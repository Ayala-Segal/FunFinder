
--- ===========================================================================
--- FILE NAME: Views.sql
--- PURPOSE: יצירת מבטים (Views) ושאילתות מורכבות על בסיס המודל הממוזג החדש
--- ===========================================================================

-- ---------------------------------------------------------------------------
-- חלק א': יצירת מבטים (CREATE VIEW)
-- ---------------------------------------------------------------------------

/*
===============================================================================
                     תיאור מילולי של המבט: view_booking_summary
===============================================================================
מבט זה נועד לספק דוח ניהולי וריכוזי של כל ההזמנות במערכת.
הוא משלב מידע מטבלת ההזמנות המקורית (BOOKINGS) ומחבר אליו בצורה ישירה את שם הלקוח
ואת מדינת המגורים שלו (country) - עמודה חדשה שהגיעה כחלק מתהליך המיזוג עם הדאטאבייס של חברתך.
המבט מאפשר למנהלי המערכת לנתח הרגלי רכישה לפי חלוקה גאוגרפית בקלות ובמהירות.

הנחיות להגשה: יש להריץ את פקודת ה-CREATE למטה, ולאחר מכן לבצע שליפה מלאה:
--> פקודת השליטה להצגה: SELECT * FROM view_booking_summary LIMIT 10;
*/

CREATE OR REPLACE VIEW view_booking_summary AS
SELECT
    b.booking_id,
    u.name AS customer_name,
    u.country AS customer_country, -- שדה חדש מהאינטגרציה
    b.booking_date,
    b.total_price,                  -- שדה חדש מהאינטגרציה
    b.status
FROM BOOKINGS b
JOIN USERS u ON b.user_id = u.user_id;


-- ---------------------------------------------------------------------------
-- חלק ב': שאילתות מורכבות על בסיס הטבלאות והשדות המעודכנים
-- ---------------------------------------------------------------------------

/*
===============================================================================
שאילתא 1 (JOIN Version) & (NOT EXISTS Version)
תיאור מילולי: שליפת אטרקציות מסוג 'Adventure' שהמשתמש הנוכחי (user_id = 1) טרם הזמין.
===============================================================================
*/
-- גרסה א': שימוש ב-LEFT JOIN וסינון ערכי NULL
SELECT DISTINCT
    a.name,
    a.location,
    a.price
FROM ATTRACTIONS a
JOIN CATEGORIES c ON a.category_id = c.category_id
LEFT JOIN BOOKING_DETAILS bd ON a.attraction_id = bd.attraction_id
LEFT JOIN BOOKINGS b ON bd.booking_id = b.booking_id AND b.user_id = 1
WHERE c.name = 'Adventure'
  AND b.booking_id IS NULL;

-- גרסה ב': שימוש ב-NOT EXISTS לביצועים אופטימליים
SELECT
    a.name,
    a.location,
    a.price
FROM ATTRACTIONS a
WHERE a.category_id = (
    SELECT category_id FROM CATEGORIES WHERE name = 'Adventure'
)
AND NOT EXISTS (
    SELECT 1
    FROM BOOKING_DETAILS bd
    JOIN BOOKINGS b ON bd.booking_id = b.booking_id
    WHERE bd.attraction_id = a.attraction_id
      AND b.user_id = 1
);


/*
===============================================================================
שאילתא 2 (NOT EXISTS Version) & (LEFT JOIN Version)
תיאור מילולי: מציאת אטרקציות בעבר שהמשתמש ביקר בהן בפועל, אך טרם השאיר עליהן ביקורת.
===============================================================================
*/
-- גרסה א': סינון באמצעות תת-שאילתה מסוג NOT EXISTS
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

-- גרסה ב': סינון אנטאי-ג'וין באמצעות LEFT JOIN
SELECT DISTINCT
    a.name,
    a.location,
    b.booking_date
FROM BOOKINGS b
JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id
JOIN ATTRACTIONS a ON bd.attraction_id = a.attraction_id
LEFT JOIN REVIEWS r ON r.attraction_id = a.attraction_id AND r.user_id = 1
WHERE b.user_id = 1
  AND b.booking_date < CURRENT_DATE
  AND r.review_id IS NULL;


/*
===============================================================================
שאילתא 3 (משתמשת בשדות האינטגרציה!)
תיאור מילולי: שליפת אטרקציות משפחתיות ברמת קושי קלה, תוך הצגת שעות הפתיחה הממוזגות.
===============================================================================
*/
SELECT
    a.name,
    a.price,
    a.avg_rating,
    a.opening_hours -- שדה חדש לחלוטין שנוסף מהמיזוג
FROM ATTRACTIONS a
JOIN CATEGORIES c ON a.category_id = c.category_id
JOIN DIFFICULTY_LEVELS d ON a.difficulty_id = d.difficulty_id
WHERE c.name = 'Family'
  AND d.name = 'Easy';


/*
===============================================================================
שאילתא 4 (פופולריות)
תיאור מילולי: מציאת האטרקציה המוזמנת ביותר (בעלת כמות הרכישות המקסימלית) בקטגוריה 5.
===============================================================================
*/
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


/*
===============================================================================
שאילתא 5 (פרופיל משתמש משודרגת!)
תיאור מילולי: סיכום פיננסי וכמותי שנתי של טיולים והוצאות עבור משתמש ספציפי.
הערה: השאילתה שודרגה להשתמש בעמודה הממוזגת total_price לביצועים מהירים.
===============================================================================
*/
SELECT
    EXTRACT(YEAR FROM b.booking_date) AS booking_year,
    COUNT(b.booking_id) AS total_trips,
    SUM(b.total_price) AS total_spent -- ניצול עמודת המחיר החדשה מהאינטגרציה
FROM BOOKINGS b
WHERE b.user_id = 1
GROUP BY EXTRACT(YEAR FROM b.booking_date)
ORDER BY booking_year DESC;


/*
===============================================================================
שאילתא 6
תיאור מילולי: הצגת שם הקטגוריה המובילה והפופולרית ביותר במערכת על בסיס נפח הזמנות.
===============================================================================
*/
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


/*
===============================================================================
שאילתא 7
תיאור מילולי: שליפת פרטים מלאים עבור ממשק משתמש (UI Detail Page) כולל גלריית תמונות ושעות פעילות.
===============================================================================
*/
SELECT
    a.name,
    a.full_description,
    a.opening_hours, -- מוצג כעת בפירוט המלא של ה-UI
    g.image_url
FROM ATTRACTIONS a
LEFT JOIN GALLERY_IMAGES g ON a.attraction_id = g.attraction_id
WHERE a.attraction_id = 10;


/*
===============================================================================
שאילתא 8 (ניצול שדות המדינה החדשים!)
תיאור מילולי: שליפת אטרקציות שהמשתמש לא ביקר בהן בחצי השנה האחרונה, ממוקד לפי מדינתו.
===============================================================================
*/
SELECT
    a.attraction_id,
    a.name,
    a.location,
    a.price,
    a.avg_rating,
    c.name AS category_name
FROM ATTRACTIONS a
JOIN CATEGORIES c ON a.category_id = c.category_id
WHERE NOT EXISTS (
    SELECT 1
    FROM BOOKINGS b
    JOIN USERS u ON b.user_id = u.user_id
    JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id
    WHERE b.user_id = 1
      AND u.country = 'Israel' -- דוגמה לסינון דינמי לפי עמודת המדינה החדשה מהאינטגרציה
      AND bd.attraction_id = a.attraction_id
      AND b.booking_date >= CURRENT_DATE - INTERVAL '6 months'
)
ORDER BY a.avg_rating DESC, a.price ASC;


/*
===============================================================================
שאילתא 9
תיאור מילולי: הצגת 4 האטרקציות הכי מבוקשות (בעלות נפח ההזמנות הגבוה ביותר) בחודשיים האחרונים.
===============================================================================
*/
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
GROUP BY a.attraction_id, a.name, a.location, a.price
ORDER BY total_bookings DESC
LIMIT 4;