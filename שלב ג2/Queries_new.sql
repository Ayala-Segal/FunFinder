
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
