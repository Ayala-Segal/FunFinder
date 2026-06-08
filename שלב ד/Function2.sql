-- ============================================================================
-- Function2.sql  -  fn_attraction_revenue_report(p_category_id INT)
--                   RETURNS refcursor
-- Builds and returns a REF CURSOR with per-attraction revenue statistics.
-- Contains ALL required elements:
--   a) Explicit cursor  (OPEN / FETCH / CLOSE) to restock low-stock tickets
--   a) Implicit cursor  (FOR rec IN SELECT) to refresh avg_rating per attraction
--   b) REF CURSOR       – returned to caller (named 'attraction_revenue_cur')
--   c) DML              – UPDATE TICKET (x2), UPDATE ATTRACTIONS, INSERT audit (x2)
--   d) Branching        – IF / ELSIF / ELSIF / ELSIF / ELSE on ticket_type
--   e) Loops            – explicit cursor LOOP + FOR (implicit) + WHILE
--   f) Exception        – WHEN OTHERS + RAISE NOTICE
--   g) Records          – r_ticket RECORD, rec RECORD
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_attraction_revenue_report(p_category_id INT)
RETURNS refcursor
LANGUAGE plpgsql
AS $$
DECLARE
    -- (b) Named REF CURSOR to be returned
    ref          refcursor := 'attraction_revenue_cur';

    -- (a) Explicit cursor: low-stock tickets for this category
    c_tickets    refcursor;
    r_ticket     RECORD;    -- (g) RECORD for explicit cursor rows

    -- (a) Implicit cursor RECORD variable
    rec          RECORD;    -- (g) RECORD for implicit cursor rows

    v_restock_amt INT;
    v_counter     INT := 0;
    v_max_iter    CONSTANT INT := 500;
    v_tid         INT;
BEGIN
    -- ── (a)(c)(d)(e)(g) SECTION 1: Explicit cursor – restock low tickets ──────
    -- Walk every low-stock ticket; use IF/ELSIF to choose type-based restock qty
    OPEN c_tickets FOR
        SELECT
            t.ticket_id,
            t.ticket_type,
            t.available_quantity,
            t.attraction_id
        FROM   TICKET      t
        JOIN   ATTRACTIONS a ON a.attraction_id = t.attraction_id
        WHERE  a.category_id       = p_category_id
          AND  t.available_quantity < 5
          AND  t.valid_date        >= CURRENT_DATE
        ORDER BY t.ticket_id;

    LOOP
        FETCH c_tickets INTO r_ticket;
        EXIT WHEN NOT FOUND;

        -- (d) IF / ELSIF branching: restock amount by ticket type
        IF    r_ticket.ticket_type = 'Adult'    THEN v_restock_amt := 20;
        ELSIF r_ticket.ticket_type = 'Child'    THEN v_restock_amt := 30;
        ELSIF r_ticket.ticket_type = 'Family'   THEN v_restock_amt := 15;
        ELSIF r_ticket.ticket_type = 'Senior'   THEN v_restock_amt := 10;
        ELSE                                         v_restock_amt := 10;
        END IF;

        UPDATE TICKET                              -- (c) DML
           SET available_quantity = available_quantity + v_restock_amt
         WHERE ticket_id = r_ticket.ticket_id;

        INSERT INTO booking_audit                  -- (c) DML
            (booking_id, user_id, old_status, new_status, change_type, notes)
        VALUES (0, NULL, NULL, NULL, 'UPDATE',
                'Ticket id=' || r_ticket.ticket_id
                || ' (' || r_ticket.ticket_type
                || ') low-stock restock +' || v_restock_amt);
    END LOOP;
    CLOSE c_tickets;

    -- ── (a)(c)(e)(g) SECTION 2: Implicit cursor – refresh attraction stats ────
    FOR rec IN
        SELECT
            a.attraction_id,
            COALESCE(AVG(r.rating), 0)::NUMERIC(3,2) AS new_avg,
            COUNT(r.review_id)::INT                   AS new_count
        FROM   ATTRACTIONS a
        LEFT JOIN REVIEWS   r ON r.attraction_id = a.attraction_id
        WHERE  a.category_id = p_category_id
        GROUP BY a.attraction_id
    LOOP
        UPDATE ATTRACTIONS                         -- (c) DML
           SET avg_rating   = rec.new_avg,
               review_count = rec.new_count,
               last_updated = NOW()
         WHERE attraction_id = rec.attraction_id;
    END LOOP;

    -- ── (e) SECTION 3: WHILE loop – force-restock any still-zero tickets ──────
    WHILE v_counter < v_max_iter LOOP
        SELECT t.ticket_id INTO v_tid
        FROM   TICKET      t
        JOIN   ATTRACTIONS a ON a.attraction_id = t.attraction_id
        WHERE  a.category_id        = p_category_id
          AND  t.available_quantity = 0
          AND  t.valid_date        >= CURRENT_DATE
        LIMIT 1;

        EXIT WHEN NOT FOUND;

        UPDATE TICKET                              -- (c) DML
           SET available_quantity = 10
         WHERE ticket_id = v_tid;

        INSERT INTO booking_audit                  -- (c) DML
            (booking_id, user_id, old_status, new_status, change_type, notes)
        VALUES (0, NULL, NULL, NULL, 'UPDATE',
                'Ticket id=' || v_tid
                || ' zero-stock emergency restock to qty=10 (cat=' || p_category_id || ')');

        v_counter := v_counter + 1;
    END LOOP;

    -- ── (b) Open and return the REF CURSOR with revenue summary ───────────────
    OPEN ref FOR
        SELECT
            a.attraction_id,
            a.name                                   AS attraction_name,
            a.avg_rating,
            a.review_count,
            COUNT(DISTINCT bd.booking_id)            AS total_bookings,
            COALESCE(SUM(bd.quantity * a.price), 0)  AS total_revenue,
            MIN(b.booking_date)                      AS first_booking,
            MAX(b.booking_date)                      AS last_booking
        FROM   ATTRACTIONS      a
        LEFT JOIN BOOKING_DETAILS bd ON bd.attraction_id = a.attraction_id
        LEFT JOIN BOOKINGS        b  ON b.booking_id     = bd.booking_id
        WHERE  a.category_id = p_category_id
        GROUP BY a.attraction_id, a.name, a.avg_rating, a.review_count
        ORDER BY total_revenue DESC;

    RETURN ref;

-- (f) Exception handling
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'fn_attraction_revenue_report error (category=%): %',
                     p_category_id, SQLERRM;
        RETURN ref;
END;
$$;
