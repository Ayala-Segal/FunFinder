-- ============================================================================
-- Procedure1.sql  -  pr_complete_booking
-- Processes a booking through to fulfilment and returns the final amount/status.
-- Contains ALL required elements:
--   a) Explicit cursor  (CURSOR with parameter + OPEN / FETCH / CLOSE)
--   a) Implicit cursor  (FOR rec IN SELECT) to pre-scan attractions & refresh ratings
--   c) DML              – UPDATE ATTRACTIONS, UPDATE TICKET (x2),
--                         UPDATE BOOKING_DETAILS, DELETE BOOKING_DETAILS, UPDATE BOOKINGS
--   d) Branching        – nested IF / ELSIF / ELSE on stock availability
--   e) Loops            – explicit cursor LOOP + FOR (implicit) + WHILE (retry)
--   f) Exception        – RAISE EXCEPTION critical (P0002), WHEN OTHERS
--   g) Records          – r_line RECORD (explicit cursor), r_pre RECORD (implicit cursor)
-- ============================================================================

CREATE OR REPLACE PROCEDURE pr_complete_booking(
    IN  p_booking_id   INT,
    OUT p_total_amount FLOAT,
    OUT p_status       VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    -- (g) RECORD variable for explicit cursor rows
    r_line   RECORD;

    -- (g) RECORD variable for implicit cursor rows
    r_pre    RECORD;

    -- (a) Explicit cursor parameterised on booking_id
    c_lines CURSOR (cur_bid INT) FOR
        SELECT
            bd.attraction_id,
            bd.quantity                        AS ordered_qty,
            a.price::FLOAT                     AS unit_price,
            t.ticket_id,
            COALESCE(t.available_quantity, 0)  AS avail_qty
        FROM   BOOKING_DETAILS bd
        JOIN   ATTRACTIONS     a  ON a.attraction_id = bd.attraction_id
        LEFT JOIN TICKET       t  ON t.attraction_id = bd.attraction_id
                                 AND t.valid_date   >= CURRENT_DATE
        WHERE  bd.booking_id = cur_bid
        ORDER BY bd.attraction_id;

    v_total          FLOAT   := 0;
    v_all_ok         BOOLEAN := TRUE;
    v_expected_total FLOAT   := 0;

    -- WHILE loop helpers
    v_retry      INT := 0;
    v_max_retry  CONSTANT INT := 3;
    v_updated    BOOLEAN;
BEGIN
    -- Critical guard: booking must exist  →  named exception caught below
    IF NOT EXISTS (SELECT 1 FROM BOOKINGS WHERE booking_id = p_booking_id) THEN
        RAISE EXCEPTION 'Booking id=% does not exist', p_booking_id
            USING ERRCODE = 'P0002';
    END IF;

    -- ── (a)(c)(e)(g) SECTION 1: Implicit cursor – pre-scan & refresh stats ────
    -- Compute expected total and refresh avg_rating for all attractions in booking
    FOR r_pre IN
        SELECT
            a.attraction_id,
            a.price::FLOAT                             AS unit_price,
            bd.quantity                                AS qty,
            COALESCE(AVG(rv.rating), 0)::NUMERIC(3,2)  AS avg_r,
            COUNT(rv.review_id)::INT                    AS rev_cnt
        FROM   BOOKING_DETAILS bd
        JOIN   ATTRACTIONS     a  ON a.attraction_id  = bd.attraction_id
        LEFT JOIN REVIEWS      rv ON rv.attraction_id = a.attraction_id
        WHERE  bd.booking_id = p_booking_id
        GROUP BY a.attraction_id, a.price, bd.quantity
    LOOP
        v_expected_total := v_expected_total + (r_pre.unit_price * r_pre.qty);

        UPDATE ATTRACTIONS                   -- (c) DML
           SET avg_rating   = r_pre.avg_r,
               review_count = r_pre.rev_cnt,
               last_updated = NOW()
         WHERE attraction_id = r_pre.attraction_id;
    END LOOP;

    -- ── (a)(c)(d)(e)(g) SECTION 2: Explicit cursor – stock check per line ─────
    OPEN c_lines(p_booking_id);
    LOOP
        FETCH c_lines INTO r_line;
        EXIT WHEN NOT FOUND;

        -- (d) Nested IF / ELSIF / ELSIF / ELSE – four stock scenarios
        IF r_line.ticket_id IS NULL THEN
            -- No ticket record exists at all for this attraction
            v_all_ok := FALSE;
            DELETE FROM BOOKING_DETAILS          -- (c) DML
             WHERE booking_id    = p_booking_id
               AND attraction_id = r_line.attraction_id;

        ELSIF r_line.avail_qty = 0 THEN
            -- Completely sold out
            v_all_ok := FALSE;
            DELETE FROM BOOKING_DETAILS          -- (c) DML
             WHERE booking_id    = p_booking_id
               AND attraction_id = r_line.attraction_id;

        ELSIF r_line.avail_qty < r_line.ordered_qty THEN
            -- Partial stock – fulfil only what is available
            v_all_ok := FALSE;
            UPDATE BOOKING_DETAILS               -- (c) DML
               SET quantity = r_line.avail_qty
             WHERE booking_id    = p_booking_id
               AND attraction_id = r_line.attraction_id;

            UPDATE TICKET                        -- (c) DML
               SET available_quantity = 0
             WHERE ticket_id = r_line.ticket_id;

            v_total := v_total + (r_line.avail_qty * r_line.unit_price);

        ELSE
            -- Full stock available – deduct and accumulate
            UPDATE TICKET                        -- (c) DML
               SET available_quantity = available_quantity - r_line.ordered_qty
             WHERE ticket_id = r_line.ticket_id;

            v_total := v_total + (r_line.ordered_qty * r_line.unit_price);
        END IF;

    END LOOP;
    CLOSE c_lines;

    -- ── (e) SECTION 3: WHILE loop – retry writing the final status ────────────
    -- Retries up to v_max_retry times in case of transient lock contention
    v_retry   := 0;
    v_updated := FALSE;

    WHILE v_retry < v_max_retry AND NOT v_updated LOOP

        IF    v_total = 0  THEN p_status := 'cancelled';
        ELSIF v_all_ok     THEN p_status := 'confirmed';
        ELSE                    p_status := 'partial';
        END IF;

        p_total_amount := v_total;

        UPDATE BOOKINGS                          -- (c) DML
           SET status      = p_status,
               total_price = p_total_amount
         WHERE booking_id  = p_booking_id;

        IF FOUND THEN
            v_updated := TRUE;
        END IF;

        v_retry := v_retry + 1;
    END LOOP;

-- (f) Exception handling
EXCEPTION
    WHEN SQLSTATE 'P0002' THEN
        RAISE EXCEPTION
            'pr_complete_booking: booking id=% not found – transaction aborted',
            p_booking_id;
    WHEN OTHERS THEN
        p_status       := 'error';
        p_total_amount := -1;
        RAISE NOTICE 'pr_complete_booking: error on booking % – %',
                     p_booking_id, SQLERRM;
END;
$$;
