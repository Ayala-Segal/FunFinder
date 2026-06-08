-- ============================================================================
-- Trigger1.sql  -  trg_bookings_before_insert  (BEFORE INSERT on BOOKINGS)
-- Fires before every new booking is written. Uses NEW (and implicitly OLD is
-- NULL for an INSERT). Checks NEW.status: blocks direct inserts with status
-- 'cancelled'. If total_price is NULL, computes it from BOOKING_DETAILS.
-- Applies a 15% welcome discount for accounts registered within the last
-- 30 days (branching on user registration date). Inserts an audit record into
-- booking_audit as a side-effect. RAISE NOTICE on non-critical errors so the
-- insert is not silently swallowed.
-- ============================================================================

CREATE OR REPLACE FUNCTION trg_fn_bookings_before_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_computed_price FLOAT;
    v_user_created   TIMESTAMP;
BEGIN
    -- Hard block: inserting a cancelled booking directly is disallowed
    IF NEW.status = 'cancelled' THEN
        RAISE EXCEPTION
            'Direct INSERT with status=''cancelled'' is not allowed (booking_id=%)',
            NEW.booking_id;
    END IF;

    -- Fetch the registering user's account creation timestamp
    SELECT created_at
      INTO v_user_created
      FROM USERS
     WHERE user_id = NEW.user_id;

    -- Compute total_price when caller left it NULL
    IF NEW.total_price IS NULL OR NEW.total_price = 0 THEN
        SELECT COALESCE(SUM(bd.quantity * a.price), 0)::FLOAT
          INTO v_computed_price
          FROM BOOKING_DETAILS bd
          JOIN ATTRACTIONS     a ON a.attraction_id = bd.attraction_id
         WHERE bd.booking_id = NEW.booking_id;

        NEW.total_price := v_computed_price;
    END IF;

    -- Welcome discount: 15% off for users who joined in the last 30 days
    IF v_user_created IS NOT NULL
       AND v_user_created > NOW() - INTERVAL '30 days'
       AND NEW.total_price > 0
    THEN
        NEW.total_price := ROUND((NEW.total_price * 0.85)::NUMERIC, 2);
        -- Ensure status reflects a valid bookable state
        IF NEW.status IS NULL THEN
            NEW.status := 'pending';
        END IF;
    END IF;

    -- Audit trail: log every new booking
    INSERT INTO booking_audit
        (booking_id, user_id, old_status, new_status,
         old_amount,  new_amount, change_type, notes)
    VALUES
        (NEW.booking_id,  NEW.user_id,
         NULL,            NEW.status,
         NULL,            NEW.total_price,
         'INSERT',
         'New booking inserted (trigger: before insert)');

    RETURN NEW;     -- pass the (possibly modified) row through to the table

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'trg_fn_bookings_before_insert error on booking % – %',
                     NEW.booking_id, SQLERRM;
        RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_bookings_before_insert ON BOOKINGS;

CREATE TRIGGER trg_bookings_before_insert
    BEFORE INSERT ON BOOKINGS
    FOR EACH ROW
    EXECUTE FUNCTION trg_fn_bookings_before_insert();
