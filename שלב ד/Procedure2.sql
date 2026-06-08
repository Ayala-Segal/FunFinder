-- ============================================================================
-- Procedure2.sql  -  pr_sync_attraction_stats(p_min_reviews INT)
-- Bulk-refreshes statistics for every attraction and enforces a minimum-reviews
-- business rule. Contains ALL required elements:
--   a) Explicit cursor  (OPEN / FETCH / CLOSE) to initialise zero-stat rows
--   a) Implicit cursor  (FOR rec IN SELECT) for per-attraction stat computation
--   c) DML              – UPDATE ATTRACTIONS (x2), UPDATE BOOKINGS, INSERT audit
--   d) Branching        – IF on min_reviews + IF/ELSIF on avg_rating tier
--   e) Loops            – explicit cursor LOOP + FOR (difficulty) +
--                         FOR (implicit stats) + WHILE (retry UPDATE)
--   f) Exception        – custom named SQLSTATE P0003 (inner catch), WHEN OTHERS
--   g) Records          – r_stat  t_attraction_stat (user-defined composite type)
--                         r_zero  RECORD (explicit cursor)
--                         rec     RECORD (implicit cursor)
-- ============================================================================

-- (g) User-defined composite RECORD type
DO $$ BEGIN
    CREATE TYPE t_attraction_stat AS (
        attraction_id   INT,
        attraction_name TEXT,
        new_avg_rating  NUMERIC(3,2),
        new_review_cnt  INT,
        new_revenue     FLOAT,
        booking_cnt     INT
    );
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;


CREATE OR REPLACE PROCEDURE pr_sync_attraction_stats(p_min_reviews INT)
LANGUAGE plpgsql
AS $$
DECLARE
    r_stat      t_attraction_stat;  -- (g) user-defined composite RECORD variable
    r_zero      RECORD;             -- (g) RECORD for explicit cursor rows
    rec         RECORD;             -- (g) RECORD for implicit cursor rows

    -- (a) Explicit cursor: attractions that have never received stats
    c_zero  refcursor;

    v_diff_id   INT;
    v_retry     INT;
    v_max_retry CONSTANT INT := 3;
    v_updated   INT := 0;
    v_skipped   INT := 0;
BEGIN
    -- ── (a)(c)(e)(g) SECTION 1: Explicit cursor – initialise zero-stat rows ───
    -- Find attractions whose review_count is NULL or 0 and seed them
    OPEN c_zero FOR
        SELECT attraction_id, name
        FROM   ATTRACTIONS
        WHERE  review_count IS NULL OR review_count = 0
        ORDER BY attraction_id;

    LOOP
        FETCH c_zero INTO r_zero;
        EXIT WHEN NOT FOUND;

        UPDATE ATTRACTIONS                       -- (c) DML
           SET avg_rating   = 0,
               review_count = 0,
               last_updated = NOW()
         WHERE attraction_id = r_zero.attraction_id
           AND (review_count IS NULL OR review_count = 0);

        INSERT INTO booking_audit               -- (c) DML
            (booking_id, user_id, old_status, new_status, change_type, notes)
        VALUES (0, NULL, NULL, NULL, 'UPDATE',
                'Seeded zero stats for attraction id='
                || r_zero.attraction_id || ' (' || r_zero.name || ')');
    END LOOP;
    CLOSE c_zero;

    -- ── (e) SECTION 2: FOR loop over difficulty levels ────────────────────────
    FOR v_diff_id IN
        SELECT difficulty_id FROM DIFFICULTY_LEVELS ORDER BY difficulty_id
    LOOP
        -- ── (a)(e)(g) SECTION 3: Implicit cursor – compute stats per attraction
        FOR rec IN
            SELECT
                a.attraction_id,
                a.name                                          AS attraction_name,
                COALESCE(AVG(r.rating), 0)::NUMERIC(3,2)       AS new_avg,
                COUNT(DISTINCT r.review_id)::INT                AS review_cnt,
                COALESCE(SUM(bd.quantity * a.price), 0)::FLOAT  AS revenue,
                COUNT(DISTINCT b.booking_id)::INT               AS bk_count
            FROM   ATTRACTIONS      a
            LEFT JOIN REVIEWS        r  ON r.attraction_id  = a.attraction_id
            LEFT JOIN BOOKING_DETAILS bd ON bd.attraction_id = a.attraction_id
            LEFT JOIN BOOKINGS        b  ON b.booking_id     = bd.booking_id
                                        AND b.status IN ('confirmed','completed','vip')
            WHERE  a.difficulty_id = v_diff_id
            GROUP BY a.attraction_id, a.name
        LOOP
            -- Populate user-defined composite RECORD variable
            r_stat.attraction_id   := rec.attraction_id;
            r_stat.attraction_name := rec.attraction_name;
            r_stat.new_avg_rating  := rec.new_avg;
            r_stat.new_review_cnt  := rec.review_cnt;
            r_stat.new_revenue     := rec.revenue;
            r_stat.booking_cnt     := rec.bk_count;

            -- (d) Business rule: skip attractions below review floor
            IF r_stat.new_review_cnt < p_min_reviews THEN
                v_skipped := v_skipped + 1;

                -- (f) Raise + immediately catch the custom named exception
                BEGIN
                    RAISE EXCEPTION 'BELOW_MIN_REVIEWS'
                        USING ERRCODE = 'P0003',
                              DETAIL  = 'attraction_id=' || r_stat.attraction_id
                                        || ' has only ' || r_stat.new_review_cnt
                                        || ' review(s), floor=' || p_min_reviews;
                EXCEPTION
                    WHEN SQLSTATE 'P0003' THEN
                        RAISE NOTICE 'pr_sync: skipped "%" (id=%) – %',
                                     r_stat.attraction_name,
                                     r_stat.attraction_id,
                                     SQLERRM;
                END;
                CONTINUE;   -- skip UPDATE for this attraction
            END IF;

            -- (d) IF / ELSIF: tag attraction tier based on avg_rating
            IF    r_stat.new_avg_rating >= 4.5 THEN
                -- premium tier: no change to price
                NULL;
            ELSIF r_stat.new_avg_rating >= 3.0 THEN
                -- standard tier: ensure review_count is accurate
                NULL;
            ELSE
                -- low-rated: log a warning audit entry
                INSERT INTO booking_audit        -- (c) DML
                    (booking_id, user_id, old_status, new_status, change_type, notes)
                VALUES (0, NULL, NULL, NULL, 'UPDATE',
                        'Low-rated attraction: id=' || r_stat.attraction_id
                        || ' avg=' || r_stat.new_avg_rating);
            END IF;

            -- ── (e) SECTION 4: WHILE loop – retry UPDATE until FOUND ─────────
            v_retry := 0;
            WHILE v_retry < v_max_retry LOOP
                UPDATE ATTRACTIONS               -- (c) DML
                   SET avg_rating   = r_stat.new_avg_rating,
                       review_count = r_stat.new_review_cnt,
                       last_updated = NOW()
                 WHERE attraction_id = r_stat.attraction_id;

                EXIT WHEN FOUND;
                v_retry := v_retry + 1;
            END LOOP;

            -- Recalculate total_price for all confirmed bookings of this attraction
            UPDATE BOOKINGS bk                   -- (c) DML
               SET total_price = (
                   SELECT COALESCE(SUM(bd2.quantity * a2.price), 0)
                   FROM   BOOKING_DETAILS bd2
                   JOIN   ATTRACTIONS     a2 ON a2.attraction_id = bd2.attraction_id
                   WHERE  bd2.booking_id = bk.booking_id
               )
             WHERE bk.status IN ('confirmed','completed','vip')
               AND EXISTS (
                   SELECT 1 FROM BOOKING_DETAILS bd3
                   WHERE  bd3.booking_id    = bk.booking_id
                     AND  bd3.attraction_id = r_stat.attraction_id
               );

            v_updated := v_updated + 1;
        END LOOP;  -- end implicit cursor loop

    END LOOP;  -- end FOR difficulty loop

    RAISE NOTICE 'pr_sync_attraction_stats complete: updated=%, skipped=% (min_reviews=%)',
                 v_updated, v_skipped, p_min_reviews;

-- (f) Outer exception handler
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'pr_sync_attraction_stats: unexpected error – %', SQLERRM;
END;
$$;
