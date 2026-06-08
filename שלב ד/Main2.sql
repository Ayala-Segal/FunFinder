-- ============================================================================
-- Main2.sql  -  Anonymous DO block: demonstrates Function2 + Procedure2
-- Opens the refcursor returned by fn_attraction_revenue_report for category_id=1
-- and iterates it with a LOOP / FETCH / EXIT WHEN NOT FOUND, printing each
-- revenue row with RAISE NOTICE. Then calls pr_sync_attraction_stats with a
-- minimum-reviews floor of 2 and prints the completion notice. Both calls are
-- wrapped in independent exception handlers.
-- ============================================================================

DO $$
DECLARE
    v_category_id  INT := 1;     -- target category (e.g. 'All')
    v_min_reviews  INT := 2;     -- floor for Procedure2
    ref            refcursor;
    rec            RECORD;
    v_row          INT := 0;
BEGIN
    RAISE NOTICE '======================================================';
    RAISE NOTICE '  Main2: Stage 4 – Function2 + Procedure2 demo';
    RAISE NOTICE '======================================================';

    -- ── Call Function2 and iterate the returned REF CURSOR ───────────────────
    BEGIN
        ref := fn_attraction_revenue_report(v_category_id);

        LOOP
            FETCH ref INTO rec;
            EXIT WHEN NOT FOUND;

            v_row := v_row + 1;
            RAISE NOTICE '[Function2] #%  id=% | name=% | bookings=% | revenue=% | avg_rating=%',
                         v_row,
                         rec.attraction_id,
                         rec.attraction_name,
                         rec.total_bookings,
                         ROUND(rec.total_revenue::NUMERIC, 2),
                         rec.avg_rating;
        END LOOP;

        CLOSE ref;
        RAISE NOTICE '[Function2] Total rows fetched: %', v_row;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE '[Function2] Exception: %', SQLERRM;
    END;

    -- ── Call Procedure2: pr_sync_attraction_stats ─────────────────────────────
    BEGIN
        CALL pr_sync_attraction_stats(v_min_reviews);
        RAISE NOTICE '[Procedure2] pr_sync_attraction_stats(min_reviews=%) completed',
                     v_min_reviews;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE '[Procedure2] Exception: %', SQLERRM;
    END;

    RAISE NOTICE '======================================================';
    RAISE NOTICE '  Main2: Done';
    RAISE NOTICE '======================================================';
END;
$$;
