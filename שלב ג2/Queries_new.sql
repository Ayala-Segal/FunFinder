
-- ===========================================================================
-- חלק 1: שאילתות שליפה וסינון (SELECT) מעודכנות ומותאמות
-- ===========================================================================

-- Query 1 (Form A - JOIN version)
-- Purpose: Get Adventure attractions that the user has NOT booked yet
SELECT DISTINCT
    a.name,
    a.location,
    a.price
FROM ATTRACTIONS a
JOIN CATEGORIES c 
    ON a.category_id = c.category_id
LEFT JOIN BOOKING_DETAILS bd 
    ON a.attraction_id = bd.attraction_id
LEFT JOIN BOOKINGS b 
    ON bd.booking_id = b.booking_id 
   AND b.user_id = 1
WHERE c.name = 'Adventure'
  AND b.booking_id IS NULL;


-- Query 1 (Form B - NOT EXISTS version)
-- Purpose: Get Adventure attractions that the user has NOT booked yet
SELECT
    a.name,
    a.location,
    a.price
FROM ATTRACTIONS a
WHERE a.category_id = (
    SELECT category_id 
    FROM CATEGORIES 
    WHERE name = 'Adventure'
)
AND NOT EXISTS (
    SELECT 1
    FROM BOOKING_DETAILS bd
    JOIN BOOKINGS b 
        ON bd.booking_id = b.booking_id
    WHERE bd.attraction_id = a.attraction_id
      AND b.user_id = 1
);


-- Query 2 (Form A: NOT EXISTS version)
-- Purpose: Find past booked attractions that the user has NOT reviewed yet
SELECT
    a.name,
    a.location,
    b.booking_date
FROM BOOKINGS b
JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id
JOIN ATTRACTIONS a ON bd.attraction_id = a.attraction_id
WHERE b.user_id = 1
  AND b.booking_date < CURRENT_DATE
  AND NOT EXISTS (
    SELECT 1
    FROM REVIEWS r
    WHERE r.attraction_id = a.attraction_id
      AND r.user_id = 1
  );


-- Query 2 (Form B: LEFT JOIN version - anti-join pattern)
-- Purpose: Find past booked attractions that the user has NOT reviewed yet
SELECT DISTINCT
    a.name,
    a.location,
    b.booking_date
FROM BOOKINGS b
JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id
JOIN ATTRACTIONS a ON bd.attraction_id = a.attraction_id
LEFT JOIN REVIEWS r
    ON r.attraction_id = a.attraction_id
   AND r.user_id = 1
WHERE b.user_id = 1
  AND b.booking_date < CURRENT_DATE
  AND r.review_id IS NULL;


-- Query 3 (Form A: JOIN version)
-- Purpose: Get family attractions with easy difficulty level
SELECT
    a.name,
    a.price,
    a.avg_rating
FROM ATTRACTIONS a
JOIN CATEGORIES c ON a.category_id = c.category_id
JOIN DIFFICULTY_LEVELS d ON a.difficulty_id = d.difficulty_id
WHERE c.name = 'Family'
  AND d.name = 'Easy';


-- Query 3 (Form B: Subquery version - no joins)
-- Purpose: Get family attractions with easy difficulty level
SELECT
    a.name,
    a.price,
    a.avg_rating
FROM ATTRACTIONS a
WHERE a.category_id = (
    SELECT category_id FROM CATEGORIES WHERE name = 'Family'
)
AND a.difficulty_id = (
    SELECT difficulty_id FROM DIFFICULTY_LEVELS WHERE name = 'Easy'
);


-- Query 4 (Form A)
-- Purpose: Find most booked attraction in a category
SELECT
    a.name,
    COUNT(*) AS booking_count
FROM ATTRACTIONS a
JOIN BOOKING_DETAILS bd ON a.attraction_id = bd.attraction_id
WHERE a.category_id = 5
GROUP BY a.attraction_id, a.name
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM BOOKING_DETAILS bd2
        JOIN ATTRACTIONS a2 ON bd2.attraction_id = a2.attraction_id
        WHERE a2.category_id = 5
        GROUP BY bd2.attraction_id
    ) sub
);


-- Query 4 (Form B)
-- Purpose: Find most booked attraction in a category using ALL
SELECT
    a.name,
    COUNT(*) AS booking_count
FROM ATTRACTIONS a
JOIN BOOKING_DETAILS bd ON a.attraction_id = bd.attraction_id
WHERE a.category_id = 5
GROUP BY a.attraction_id, a.name
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM BOOKING_DETAILS bd2
    JOIN ATTRACTIONS a2 ON bd2.attraction_id = a2.attraction_id
    WHERE a2.category_id = 5
    GROUP BY bd2.attraction_id
);


-- Query 5 (עודכן והותאם לטבלה החדשה משדה ticket_count לשדה quantity)
-- Purpose: Show yearly spending summary per user
SELECT
    EXTRACT(YEAR FROM b.booking_date) AS booking_year,
    COUNT(b.booking_id) AS total_trips,
    SUM(bd.quantity * a.price) AS total_spent
FROM BOOKINGS b
JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id
JOIN ATTRACTIONS a ON bd.attraction_id = a.attraction_id
WHERE b.user_id = 1
GROUP BY EXTRACT(YEAR FROM b.booking_date)
ORDER BY booking_year DESC;


-- Query 6
-- Purpose: Show most popular categories based on bookings
SELECT
    c.name AS category_name,
    COUNT(b.booking_id) AS popularity
FROM CATEGORIES c
JOIN ATTRACTIONS a ON c.category_id = a.category_id
JOIN BOOKING_DETAILS bd ON a.attraction_id = bd.attraction_id
JOIN BOOKINGS b ON bd.booking_id = b.booking_id
GROUP BY c.name
ORDER BY popularity DESC
LIMIT 1;


-- Query 7
-- Purpose: Show full attraction details with images
SELECT
    a.name,
    a.full_description,
    g.image_url
FROM ATTRACTIONS a
LEFT JOIN GALLERY_IMAGES g ON a.attraction_id = g.attraction_id
WHERE a.attraction_id = 10;


-- Query 8
-- Purpose: Show attractions the user has NOT visited in the last 6 months
SELECT
    a.attraction_id,
    a.name,
    a.location,
    a.price,
    a.avg_rating,
    c.name AS category_name,
    d.name AS difficulty_level
FROM ATTRACTIONS a
JOIN CATEGORIES c ON a.category_id = c.category_id
JOIN DIFFICULTY_LEVELS d ON a.difficulty_id = d.difficulty_id
WHERE NOT EXISTS (
    SELECT 1
    FROM BOOKINGS b
    JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id
    WHERE b.user_id = 1
      AND bd.attraction_id = a.attraction_id
      AND b.booking_date >= CURRENT_DATE - INTERVAL '6 months'
)
ORDER BY a.avg_rating DESC, a.price ASC;


-- Query 9
-- Purpose: Return the 4 most booked attractions in the last 2 months
SELECT
    a.attraction_id,
    a.name,
    a.location,
    a.price,
    COUNT(bd.attraction_id) AS total_bookings
FROM ATTRACTIONS a
JOIN BOOKING_DETAILS bd ON a.attraction_id = bd.attraction_id
JOIN BOOKINGS b ON bd.booking_id = b.booking_id
WHERE b.booking_date >= CURRENT_DATE - INTERVAL '2 months'
GROUP BY
    a.attraction_id,
    a.name,
    a.location,
    a.price
ORDER BY total_bookings DESC
LIMIT 4;


-- ===========================================================================
-- חלק 2: פקודות מחיקה (DELETE) - מדורגות למניעת שגיאות Foreign Key
-- ===========================================================================

-- Query 1
-- Purpose: Remove old reviews (3+ years)
DELETE FROM REVIEWS r
WHERE r.review_id IN (
    SELECT r2.review_id
    FROM REVIEWS r2
    WHERE EXTRACT(YEAR FROM r2.created_at) <= EXTRACT(YEAR FROM CURRENT_DATE) - 3
      AND r2.user_id = 1
);


-- Query 2 - שלב א' (חדש! מונע שגיאת מפתחות זרים בטבלת REVIEWS)
-- Purpose: Delete reviews for attractions with no bookings in the last year
DELETE FROM REVIEWS
WHERE attraction_id IN (
    SELECT a.attraction_id 
    FROM ATTRACTIONS a
    WHERE NOT EXISTS (
        SELECT 1 
        FROM BOOKING_DETAILS bd
        JOIN BOOKINGS b ON bd.booking_id = b.booking_id
        WHERE bd.attraction_id = a.attraction_id
          AND b.booking_date >= CURRENT_DATE - INTERVAL '1 year'
    )
);


-- Query 2 - שלב ב' (חדש! מונע שגיאת מפתחות זרים בטבלת GALLERY_IMAGES)
-- Purpose: Delete gallery images for attractions with no bookings in the last year
DELETE FROM GALLERY_IMAGES
WHERE attraction_id IN (
    SELECT a.attraction_id 
    FROM ATTRACTIONS a
    WHERE NOT EXISTS (
        SELECT 1 
        FROM BOOKING_DETAILS bd
        JOIN BOOKINGS b ON bd.booking_id = b.booking_id
        WHERE bd.attraction_id = a.attraction_id
          AND b.booking_date >= CURRENT_DATE - INTERVAL '1 year'
    )
);


-- Query 2 - שלב ג' (המקורית שלך - עכשיו תרוץ חלק וללא שגיאות)
-- Purpose: Delete inactive attractions (no bookings in the last year)
DELETE FROM ATTRACTIONS a
WHERE NOT EXISTS (
    SELECT 1
    FROM BOOKING_DETAILS bd
    JOIN BOOKINGS b ON bd.booking_id = b.booking_id
    WHERE bd.attraction_id = a.attraction_id
      AND b.booking_date >= CURRENT_DATE - INTERVAL '1 year'
);


-- Query 3
-- Purpose: Clean orphan images
DELETE FROM GALLERY_IMAGES g
WHERE NOT EXISTS (
    SELECT 1
    FROM ATTRACTIONS a
    WHERE a.attraction_id = g.attraction_id
);


-- ===========================================================================
-- חלק 3: פקודות עדכון (UPDATE)
-- ===========================================================================

-- Query 1
-- Purpose: Update average rating
UPDATE ATTRACTIONS a
SET avg_rating = sub.avg_rating
FROM (
    SELECT
        r.attraction_id,
        ROUND(AVG(r.rating)::numeric, 2) AS avg_rating
    FROM REVIEWS r
    WHERE r.attraction_id = 1
    GROUP BY r.attraction_id
) sub
WHERE a.attraction_id = sub.attraction_id;


-- Query 2
-- Purpose: Update booking date safely
UPDATE BOOKINGS b
SET booking_date = CURRENT_DATE + 4
WHERE b.booking_id = 2
  AND b.user_id = 1
  AND b.booking_date > CURRENT_DATE + INTERVAL '3 days';


-- Query 3
-- Purpose: Mark active users
UPDATE USERS u
SET avatar_url = 'ACTIVE_CUSTOMER_BADGE'
WHERE u.user_id IN (
    SELECT b.user_id
    FROM BOOKINGS b
    WHERE b.booking_date >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY b.user_id
    HAVING COUNT(b.booking_id) > 5
);
-- ===========================================================================



-- ===========================================================================
-- Query 1: Top-rated attractions (avg >= 4) with booking count, per category
-- ===========================================================================

-- Version A: JOINs
SELECT 
    a.name AS attraction_name,
    c.name AS category_name,
    a.location,
    ROUND(AVG(r.rating)::numeric, 2) AS avg_rating,
    COUNT(DISTINCT bd.booking_id) AS total_bookings
FROM ATTRACTIONS a
JOIN CATEGORIES c ON a.category_id = c.category_id
JOIN REVIEWS r ON a.attraction_id = r.attraction_id
LEFT JOIN BOOKING_DETAILS bd ON a.attraction_id = bd.attraction_id
GROUP BY a.attraction_id, a.name, c.name, a.location
HAVING AVG(r.rating) >= 4.0
ORDER BY avg_rating DESC, total_bookings DESC;


-- Version B: Correlated subqueries
SELECT 
    a.name AS attraction_name,
    (SELECT c.name FROM CATEGORIES c WHERE c.category_id = a.category_id) AS category_name,
    a.location,
    (SELECT ROUND(AVG(r.rating)::numeric, 2)
     FROM REVIEWS r 
     WHERE r.attraction_id = a.attraction_id) AS avg_rating,
    (SELECT COUNT(DISTINCT bd.booking_id) 
     FROM BOOKING_DETAILS bd 
     WHERE bd.attraction_id = a.attraction_id) AS total_bookings
FROM ATTRACTIONS a
WHERE (SELECT AVG(r2.rating) FROM REVIEWS r2 WHERE r2.attraction_id = a.attraction_id) >= 4.0
ORDER BY avg_rating DESC, total_bookings DESC;


-- ===========================================================================
-- Query 2: Customers who spent above their booking month's average
-- ===========================================================================

-- Version A: JOIN with derived table (monthly averages computed once)
SELECT 
    u.name AS full_name,
    u.email,
    EXTRACT(DAY FROM b.booking_date) AS booking_day,
    EXTRACT(MONTH FROM b.booking_date) AS booking_month,
    EXTRACT(YEAR FROM b.booking_date) AS booking_year,
    b.total_price,
    ROUND(ma.avg_monthly_price::numeric, 2) AS month_avg,
    b.status AS booking_status
FROM USERS u
JOIN BOOKINGS b ON u.user_id = b.user_id
JOIN (
    SELECT 
        EXTRACT(MONTH FROM booking_date) AS bmonth,
        EXTRACT(YEAR FROM booking_date) AS byear,
        AVG(total_price) AS avg_monthly_price
    FROM BOOKINGS
    GROUP BY EXTRACT(MONTH FROM booking_date), EXTRACT(YEAR FROM booking_date)
) ma ON EXTRACT(MONTH FROM b.booking_date) = ma.bmonth
    AND EXTRACT(YEAR FROM b.booking_date) = ma.byear
WHERE b.total_price > ma.avg_monthly_price
ORDER BY b.total_price DESC;


-- Version B: Correlated subquery (recalculates monthly average per row)
SELECT 
    u.name AS full_name,
    u.email,
    EXTRACT(DAY FROM b.booking_date) AS booking_day,
    EXTRACT(MONTH FROM b.booking_date) AS booking_month,
    EXTRACT(YEAR FROM b.booking_date) AS booking_year,
    b.total_price,
    (SELECT ROUND(AVG(b3.total_price)::numeric, 2)
     FROM BOOKINGS b3
     WHERE EXTRACT(MONTH FROM b3.booking_date) = EXTRACT(MONTH FROM b.booking_date)
       AND EXTRACT(YEAR FROM b3.booking_date) = EXTRACT(YEAR FROM b.booking_date)
    ) AS month_avg,
    b.status AS booking_status
FROM USERS u
JOIN BOOKINGS b ON u.user_id = b.user_id
WHERE b.total_price > (
    SELECT AVG(b2.total_price)
    FROM BOOKINGS b2
    WHERE EXTRACT(MONTH FROM b2.booking_date) = EXTRACT(MONTH FROM b.booking_date)
      AND EXTRACT(YEAR FROM b2.booking_date) = EXTRACT(YEAR FROM b.booking_date)
)
ORDER BY b.total_price DESC;


-- ===========================================================================
-- Query 3: Months with total revenue above the monthly average
-- ===========================================================================

-- Version A: HAVING with nested subquery
SELECT 
    EXTRACT(YEAR FROM b.booking_date) AS year,
    EXTRACT(MONTH FROM b.booking_date) AS month,
    COUNT(*) AS num_bookings,
    ROUND(SUM(b.total_price)::numeric, 2) AS total_revenue,
    ROUND(AVG(b.total_price)::numeric, 2) AS avg_booking_price
FROM BOOKINGS b
GROUP BY EXTRACT(YEAR FROM b.booking_date), EXTRACT(MONTH FROM b.booking_date)
HAVING SUM(b.total_price) > (
    SELECT AVG(monthly_total) FROM (
        SELECT SUM(total_price) AS monthly_total
        FROM BOOKINGS
        GROUP BY EXTRACT(YEAR FROM booking_date), EXTRACT(MONTH FROM booking_date)
    ) AS monthly_totals
)
ORDER BY year, month;


-- Version B: CTE + WHERE filter
WITH monthly_revenue AS (
    SELECT 
        EXTRACT(YEAR FROM b.booking_date) AS year,
        EXTRACT(MONTH FROM b.booking_date) AS month,
        COUNT(*) AS num_bookings,
        SUM(b.total_price) AS total_revenue,
        AVG(b.total_price) AS avg_booking_price
    FROM BOOKINGS b
    GROUP BY EXTRACT(YEAR FROM b.booking_date), EXTRACT(MONTH FROM b.booking_date)
),
avg_monthly AS (
    SELECT AVG(total_revenue) AS avg_rev FROM monthly_revenue
)
SELECT 
    mr.year,
    mr.month,
    mr.num_bookings,
    ROUND(mr.total_revenue::numeric, 2) AS total_revenue,
    ROUND(mr.avg_booking_price::numeric, 2) AS avg_booking_price
FROM monthly_revenue mr
CROSS JOIN avg_monthly am
WHERE mr.total_revenue > am.avg_rev
ORDER BY mr.year, mr.month;


-- ===========================================================================
-- Query 4: Attractions with no bookings 
-- ===========================================================================

-- Version A: LEFT JOIN + IS NULL
SELECT 
    a.attraction_id,
    a.name AS attraction_name,
    c.name AS category_name,
    a.location,
    a.price
FROM ATTRACTIONS a
JOIN CATEGORIES c ON a.category_id = c.category_id
LEFT JOIN BOOKING_DETAILS bd ON a.attraction_id = bd.attraction_id
WHERE bd.booking_id IS NULL
ORDER BY category_name, a.price DESC;


-- Version B: NOT IN with nested subqueries
SELECT 
    a.attraction_id,
    a.name AS attraction_name,
    (SELECT c.name FROM CATEGORIES c WHERE c.category_id = a.category_id) AS category_name,
    a.location,
    a.price
FROM ATTRACTIONS a
WHERE a.attraction_id NOT IN (
    SELECT DISTINCT bd.attraction_id
    FROM BOOKING_DETAILS bd
)
ORDER BY category_name, a.price DESC;


-- ===========================================================================
-- Query 5: Full customer booking history with attraction details
-- ===========================================================================
SELECT 
    u.name AS customer_name,
    u.email,
    a.name AS attraction_name,
    c.name AS category_name,
    bd.quantity,
    a.price AS attraction_price,
    (bd.quantity * a.price) AS line_total,
    EXTRACT(DAY FROM b.booking_date) AS booking_day,
    EXTRACT(MONTH FROM b.booking_date) AS booking_month,
    EXTRACT(YEAR FROM b.booking_date) AS booking_year,
    b.status AS booking_status
FROM USERS u
JOIN BOOKINGS b ON u.user_id = b.user_id
JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id
JOIN ATTRACTIONS a ON bd.attraction_id = a.attraction_id
JOIN CATEGORIES c ON a.category_id = c.category_id
ORDER BY b.booking_date DESC, u.name;


-- ===========================================================================
-- Query 6: Ticket availability/Stats by month and attraction category
-- ===========================================================================
SELECT 
    c.name AS category_name,
    EXTRACT(MONTH FROM b.booking_date) AS booking_month,
    EXTRACT(YEAR FROM b.booking_date) AS booking_year,
    COUNT(DISTINCT b.booking_id) AS num_bookings,
    SUM(bd.quantity) AS total_tickets_sold,
    ROUND(AVG(a.price)::numeric, 2) AS avg_attraction_price,
    ROUND(MIN(a.price)::numeric, 2) AS min_price,
    ROUND(MAX(a.price)::numeric, 2) AS max_price
FROM BOOKING_DETAILS bd
JOIN BOOKINGS b ON bd.booking_id = b.booking_id
JOIN ATTRACTIONS a ON bd.attraction_id = a.attraction_id
JOIN CATEGORIES c ON a.category_id = c.category_id
GROUP BY c.name, EXTRACT(MONTH FROM b.booking_date), EXTRACT(YEAR FROM b.booking_date)
ORDER BY booking_year, booking_month, category_name;


-- ===========================================================================
-- Query 7: Revenue per attraction category per quarter
-- ===========================================================================
SELECT 
    c.name AS category_name,
    EXTRACT(YEAR FROM b.booking_date) AS year,
    EXTRACT(QUARTER FROM b.booking_date) AS quarter,
    COUNT(DISTINCT b.booking_id) AS num_bookings,
    ROUND(SUM(bd.quantity * a.price)::numeric, 2) AS total_revenue,
    ROUND(AVG(bd.quantity * a.price)::numeric, 2) AS avg_revenue_per_booking
FROM ATTRACTIONS a
JOIN CATEGORIES c ON a.category_id = c.category_id
JOIN BOOKING_DETAILS bd ON a.attraction_id = bd.attraction_id
JOIN BOOKINGS b ON bd.booking_id = b.booking_id
GROUP BY c.name, EXTRACT(YEAR FROM b.booking_date), EXTRACT(QUARTER FROM b.booking_date)
ORDER BY year, quarter, total_revenue DESC;


-- ===========================================================================
-- Query 8: Customers who reviewed an attraction they booked
-- ===========================================================================
SELECT 
    u.name AS customer_name,
    u.email,
    a.name AS attraction_name,
    c.name AS category_name,
    r.rating,
    r.comment,
    EXTRACT(DAY FROM r.created_at) AS review_day,
    EXTRACT(MONTH FROM r.created_at) AS review_month,
    EXTRACT(YEAR FROM r.created_at) AS review_year,
    b.total_price,
    b.status AS booking_status
FROM USERS u
JOIN REVIEWS r ON u.user_id = r.user_id
JOIN ATTRACTIONS a ON r.attraction_id = a.attraction_id
JOIN CATEGORIES c ON a.category_id = c.category_id
JOIN BOOKINGS b ON u.user_id = b.user_id
JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id AND bd.attraction_id = a.attraction_id
ORDER BY r.rating DESC, r.created_at DESC;


-- ===========================================================================
-- פקודות מחיקה מעודכנות (DELETE)
-- ===========================================================================

-- Delete 1: Remove reviews older than 1 year
DELETE FROM REVIEWS
WHERE created_at < CURRENT_DATE - INTERVAL '1 year';


-- Delete 2: Remove cancelled bookings and their related booking details
-- שלב א': מחיקת פרטי ההזמנות המבוטלות
DELETE FROM BOOKING_DETAILS
WHERE booking_id IN (
    SELECT b.booking_id FROM BOOKINGS b WHERE b.status = 'Cancelled'
);

-- שלב ב': מחיקת ההזמנות עצמן
DELETE FROM BOOKINGS
WHERE status = 'Cancelled';


-- ===========================================================================
-- פקודות עדכון מעודכנות (UPDATE)
-- ===========================================================================

-- Update 1: Confirm 'Pending' bookings from the last 30 days
UPDATE BOOKINGS
SET status = 'Confirmed'
WHERE status = 'Pending'
  AND booking_date >= CURRENT_DATE - INTERVAL '30 days';


-- Update 2: Apply 15% discount on all attractions belonging to the 'Museum' category
UPDATE ATTRACTIONS
SET price = ROUND((price * 0.85)::numeric, 2)
WHERE category_id = (
    SELECT category_id FROM CATEGORIES WHERE name = 'Museum'
);