-- ============================================================================
-- Trigger2.sql  -  trg_bookings_after_update  (AFTER UPDATE on BOOKINGS)
-- Fires after every update to a BOOKINGS row. Compares OLD vs NEW:
-- (1) If status changed to 'completed', upserts a PAYMENT row and increments
--     USERS.total_bookings to maintain the running counter.
-- (2) If status changed to 'cancelled' from an active state, restores
--     available_quantity on the relevant TICKET rows.
-- (3) Always inserts a row into booking_audit capturing both old and new values
--     (change_type = 'UPDATE'). Skips when neither status nor total_price changed.
-- RAISE NOTICE on any exception so the originating UPDATE still commits.
-- ============================================================================

CREATE OR REPLACE FUNCTION trg_fn_bookings_after_update()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_next_pay_id INT;
BEGIN
    -- Nothing meaningful changed – skip all side-effects
    IF NEW.status = OLD.status
       AND NEW.total_price IS NOT DISTINCT FROM OLD.total_price
    THEN
        RETURN NEW;
    END IF;

    -- ── Transition → 'completed': settle payment + increment user counter ─────
    IF NEW.status = 'completed' AND OLD.status <> 'completed' THEN

        SELECT COALESCE(MAX(payment_id), 0) + 1
          INTO v_next_pay_id
          FROM PAYMENT;

        INSERT INTO PAYMENT (payment_id, booking_id, amount)
        VALUES (v_next_pay_id, NEW.booking_id, COALESCE(NEW.total_price, 0))
        ON CONFLICT (booking_id)
        DO UPDATE SET amount = EXCLUDED.amount;

        UPDATE USERS
           SET total_bookings = total_bookings + 1
         WHERE user_id = NEW.user_id;

    END IF;

    -- ── Transition → 'cancelled': release ticket stock ────────────────────────
    IF NEW.status = 'cancelled'
       AND OLD.status IN ('confirmed', 'vip', 'pending', 'partial')
    THEN
        UPDATE TICKET t
           SET available_quantity = available_quantity + bd.quantity
          FROM BOOKING_DETAILS bd
         WHERE bd.booking_id   = NEW.booking_id
           AND t.attraction_id = bd.attraction_id
           AND t.valid_date   >= CURRENT_DATE;
    END IF;

    -- ── Always log the change to booking_audit ────────────────────────────────
    INSERT INTO booking_audit
        (booking_id,    user_id,
         old_status,    new_status,
         old_amount,    new_amount,
         change_type,   notes)
    VALUES
        (NEW.booking_id, NEW.user_id,
         OLD.status,     NEW.status,
         OLD.total_price, NEW.total_price,
         'UPDATE',
         'Status: ' || COALESCE(OLD.status, 'NULL')
         || ' -> ' || COALESCE(NEW.status, 'NULL')
         || '  |  amount: ' || COALESCE(OLD.total_price::TEXT, 'NULL')
         || ' -> ' || COALESCE(NEW.total_price::TEXT, 'NULL'));

    RETURN NEW;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'trg_fn_bookings_after_update error on booking % – %',
                     NEW.booking_id, SQLERRM;
        RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_bookings_after_update ON BOOKINGS;

CREATE TRIGGER trg_bookings_after_update
    AFTER UPDATE ON BOOKINGS
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_bookings_after_update();
