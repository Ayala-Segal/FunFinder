-- ============================================================================
-- Function1.sql  -  fn_apply_booking_discounts(p_user_id INT)  RETURNS INT
-- Processes all pending bookings for a user and applies tiered discount logic.
-- Contains ALL required elements:
--   a) Explicit cursor  (OPEN / FETCH / CLOSE) over pending bookings
--   a) Implicit cursor  (FOR rec IN SELECT) to refresh attraction stats
--   b) REF CURSOR       – not the return type here; see Function2
--   c) DML              – UPDATE BOOKINGS, UPDATE ATTRACTIONS,
--                         INSERT booking_audit, DELETE BOOKING_DETAILS + BOOKINGS
--   d) Branching        – IF / ELSIF / ELSIF / ELSE (4-tier price logic)
--   e) Loops            – cursor LOOP + FOR (implicit) + WHILE (purge loop)
--   f) Exception        – named SQLSTATE P0001, WHEN OTHERS
--   g) Records          – r_booking RECORD, r_attr RECORD
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_apply_booking_discounts(p_user_id INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    -- (a) Explicit cursor: pending bookings for this user with cost breakdown
    c_pending   refcursor;
    r_booking   RECORD;     -- (g) RECORD for explicit cursor rows

    -- (a) Implicit cursor RECORD variable
    r_attr      RECORD;     -- (g) RECORD for implicit cursor rows

    v_count     INT   := 0;
    v_new_total FLOAT;

    -- WHILE loop helpers
    v_while_cnt INT := 0;
    v_max_while CONSTANT INT := 200;
    v_cancel_id INT;
BEGIN
    -- Guard: user must exist  →  named exception caught below
    IF NOT EXISTS (SELECT 1 FROM USERS WHERE user_id = p_user_id) THEN
        RAISE EXCEPTION 'User % not found', p_user_id
            USING ERRCODE = 'P0001';
    END IF;

    -- ── (a)(e)(g) SECTION 1: Implicit cursor – refresh attraction stats ───────
    -- FOR loop over every attraction this user has ever booked
    FOR r_attr IN
        SELECT
            a.attraction_id,
            COALESCE(AVG(rv.rating), 0)::NUMERIC(3,2) AS new_avg,
            COUNT(rv.review_id)::INT                   AS new_cnt
        FROM   ATTRACTIONS      a
        JOIN   BOOKING_DETAILS  bd ON bd.attraction_id = a.attraction_id
        JOIN   BOOKINGS         b  ON b.booking_id     = bd.booking_id
        LEFT JOIN REVIEWS       rv ON rv.attraction_id = a.attraction_id
        WHERE  b.user_id = p_user_id
        GROUP BY a.attraction_id
    LOOP
        -- (c) DML inside implicit cursor loop
        UPDATE ATTRACTIONS
           SET avg_rating   = r_attr.new_avg,
               review_count = r_attr.new_cnt,
               last_updated = NOW()
         WHERE attraction_id = r_attr.attraction_id;
    END LOOP;

    -- ── (a)(d)(e)(g) SECTION 2: Explicit cursor – tiered discount logic ───────
    OPEN c_pending FOR
        SELECT
            b.booking_id,
            b.status,
            COALESCE(b.total_price, 0)::FLOAT   AS total_price,
            COALESCE(b.quantity,    1)           AS qty,
            a.price::FLOAT                      AS unit_price,
            bd.attraction_id
        FROM   BOOKINGS        b
        JOIN   BOOKING_DETAILS bd ON bd.booking_id   = b.booking_id
        JOIN   ATTRACTIONS     a  ON a.attraction_id = bd.attraction_id
        LEFT JOIN PAYMENT      p  ON p.booking_id    = b.booking_id
        WHERE  b.user_id = p_user_id
          AND  b.status  IN ('pending', 'Pending')
        ORDER BY b.booking_id;

    LOOP
        FETCH c_pending INTO r_booking;
        EXIT WHEN NOT FOUND;

        -- (d) IF / ELSIF / ELSIF / ELSE  – four price tiers
        IF r_booking.total_price = 0 THEN
            -- Tier 1: total missing – recompute from unit price × quantity
            v_new_total := r_booking.unit_price * r_booking.qty;
            UPDATE BOOKINGS                       -- (c) DML
               SET total_price = v_new_total
             WHERE booking_id  = r_booking.booking_id;

        ELSIF r_booking.total_price < 50 THEN
            -- Tier 2: micro-booking – cancel automatically
            UPDATE BOOKINGS                       -- (c) DML
               SET status = 'cancelled'
             WHERE booking_id = r_booking.booking_id;

            INSERT INTO booking_audit             -- (c) DML
                (booking_id, user_id, old_status, new_status,
                 old_amount, new_amount, change_type, notes)
            VALUES (r_booking.booking_id, p_user_id,
                    r_booking.status, 'cancelled',
                    r_booking.total_price, r_booking.total_price,
                    'UPDATE', 'Auto-cancelled: total below 50 minimum');

        ELSIF r_booking.total_price < 300 THEN
            -- Tier 3: standard – confirm
            UPDATE BOOKINGS                       -- (c) DML
               SET status = 'confirmed'
             WHERE booking_id = r_booking.booking_id;

        ELSE
            -- Tier 4: high-value – VIP + 10% loyalty discount
            v_new_total := r_booking.total_price * 0.90;
            UPDATE BOOKINGS                       -- (c) DML
               SET status      = 'vip',
                   total_price = v_new_total
             WHERE booking_id = r_booking.booking_id;

            INSERT INTO booking_audit             -- (c) DML
                (booking_id, user_id, old_status, new_status,
                 old_amount, new_amount, change_type, notes)
            VALUES (r_booking.booking_id, p_user_id,
                    r_booking.status, 'vip',
                    r_booking.total_price, v_new_total,
                    'UPDATE', 'VIP: 10% loyalty discount applied');
        END IF;

        v_count := v_count + 1;
    END LOOP;
    CLOSE c_pending;

    -- ── (e) SECTION 3: WHILE loop – purge stale cancelled bookings ────────────
    -- Remove cancelled bookings older than 90 days with no associated payment
    WHILE v_while_cnt < v_max_while LOOP
        SELECT b.booking_id INTO v_cancel_id
        FROM   BOOKINGS b
        WHERE  b.user_id      = p_user_id
          AND  b.status       = 'cancelled'
          AND  b.booking_date < CURRENT_DATE - INTERVAL '90 days'
          AND  NOT EXISTS (
                   SELECT 1 FROM PAYMENT p WHERE p.booking_id = b.booking_id)
        ORDER BY b.booking_id
        LIMIT 1;

        EXIT WHEN NOT FOUND;

        INSERT INTO booking_audit                 -- (c) DML
            (booking_id, user_id, old_status, new_status, change_type, notes)
        VALUES (v_cancel_id, p_user_id,
                'cancelled', 'purged', 'DELETE',
                'Purged: stale cancelled booking with no payment record');

        DELETE FROM BOOKING_DETAILS               -- (c) DML
         WHERE booking_id = v_cancel_id;
        DELETE FROM BOOKINGS                      -- (c) DML
         WHERE booking_id = v_cancel_id;

        v_while_cnt := v_while_cnt + 1;
    END LOOP;

    RETURN v_count;

-- (f) Exception handling
EXCEPTION
    WHEN SQLSTATE 'P0001' THEN          -- named user-not-found exception
        RAISE NOTICE 'fn_apply_booking_discounts: user % does not exist', p_user_id;
        RETURN -1;
    WHEN OTHERS THEN
        RAISE NOTICE 'fn_apply_booking_discounts: unexpected error – %', SQLERRM;
        RETURN -2;
END;
$$;
