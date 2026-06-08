-- ============================================================================
-- Main1.sql  -  Anonymous DO block: demonstrates Function1 + Procedure1
-- Calls fn_apply_booking_discounts for user_id=1 and stores the integer
-- return value; prints how many bookings were processed (or the error code).
-- Then calls pr_complete_booking for booking_id=1 and prints the resulting
-- status and total amount from the OUT parameters. Each call is wrapped in its
-- own nested BEGIN/EXCEPTION block so one failure does not prevent the other.
-- ============================================================================

DO $$
DECLARE
    v_user_id      INT   := 1;   -- target user for Function1
    v_booking_id   INT   := 1;   -- target booking for Procedure1
    v_processed    INT;           -- return value from Function1
    v_total_amount FLOAT;         -- OUT from Procedure1
    v_status       VARCHAR;       -- OUT from Procedure1
BEGIN
    RAISE NOTICE '======================================================';
    RAISE NOTICE '  Main1: Stage 4 – Function1 + Procedure1 demo';
    RAISE NOTICE '======================================================';

    -- ── Call Function1: fn_apply_booking_discounts ────────────────────────────
    BEGIN
        v_processed := fn_apply_booking_discounts(v_user_id);

        IF v_processed >= 0 THEN
            RAISE NOTICE '[Function1] User % : % pending booking(s) processed',
                         v_user_id, v_processed;
        ELSIF v_processed = -1 THEN
            RAISE NOTICE '[Function1] User % not found', v_user_id;
        ELSE
            RAISE NOTICE '[Function1] Returned unexpected error code: %', v_processed;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE '[Function1] Exception: %', SQLERRM;
    END;

    -- ── Call Procedure1: pr_complete_booking ──────────────────────────────────
    BEGIN
        CALL pr_complete_booking(v_booking_id, v_total_amount, v_status);

        RAISE NOTICE '[Procedure1] booking_id=% -> status=%, total_price=%',
                     v_booking_id,
                     v_status,
                     ROUND(v_total_amount::NUMERIC, 2);

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE '[Procedure1] Exception: %', SQLERRM;
    END;

    RAISE NOTICE '======================================================';
    RAISE NOTICE '  Main1: Done';
    RAISE NOTICE '======================================================';
END;
$$;
