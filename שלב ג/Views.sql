-- ===========================================================================
-- חלק א': אגף ניהול הזמנות ולקוחות
-- ===========================================================================

-- הסבר: מבט זה מאחד את נתוני ההזמנות עם פרטי המשתמשים שביצעו אותן על ידי חיבור (JOIN) בין טבלת BOOKINGS לטבלת USERS על בסיס שדה מזהה המשתמש (user_id).
-- המטרה: לאפשר שליפת מידע מרוכז על ההזמנות (כמו תאריך, סטטוס, כמות ומחיר) יחד עם פרטי הקשר של הלקוח (שם ואימייל) בשאילתה אחת פשוטה.
CREATE OR REPLACE VIEW vw_user_bookings AS
SELECT 
    b.booking_id,       -- מזהה ייחודי של ההזמנה
    b.booking_date,     -- תאריך ביצוע ההזמנה
    b.status AS booking_status, -- סטטוס ההזמנה (completed, active, pending וכו')
    b.total_price,      -- המחיר הכולל לתשלום עבור ההזמנה
    b.quantity AS ticket_count, -- כמות הכרטיסים שהוזמנו
    u.user_id,          -- מזהה הלקוח שביצע את ההזמנה
    u.name AS user_name, -- שם מלא של הלקוח
    u.email AS user_email, -- כתובת האימייל של הלקוח
    b.contact_phone     -- טלפון ליצירת קשר שסופק בהזמנה
FROM BOOKINGS b
JOIN USERS u ON b.user_id = u.user_id;


-- הסבר שאילתה 1: שאילתה זו שולפת מתוך המבט את כל ההזמנות שסטטוס הביצוע שלהן הוא הושלם ('completed') ושבוצעו משנת 2024 והלאה.
-- המטרה: איתור וסינון של עסקאות מוצלחות וסגורות שבוצעו לאחרונה במערכת, תוך מיון התוצאות לפי התאריך העדכני ביותר.
SELECT 
    booking_id, 
    user_name, 
    booking_status,
    total_price, 
    booking_date
FROM vw_user_bookings
WHERE booking_status = 'completed' AND booking_date >= '2024-01-01'
ORDER BY booking_date DESC;


-- הסבר שאילתה 2: שאילתה זו מבצעת קבוצת סיכום (GROUP BY) לפי מזהה ושם המשתמש ומפעילה פונקציות אגרגטיביות: COUNT לספירת שורות ו-SUM לסיכום ערכים.
-- המטרה: הפקת דוח פעילות מצטבר עבור כל לקוח, המציג כמה הזמנות הוא ביצע בסך הכל במערכת ומהו סכום הכסף הכולל שהוא שילם עד כה.
SELECT 
    user_id, 
    user_name, 
    COUNT(booking_id) AS total_orders, -- סך כל ההזמנות הייחודיות של הלקוח
    COALESCE(SUM(total_price), 0) AS total_spent -- סך כל הכסף המצטבר שהוציא הלקוח במערכת
FROM vw_user_bookings
GROUP BY user_id, user_name
ORDER BY total_orders DESC;


-- ===========================================================================
-- חלק ב': אגף ניהול אטרקציות, תוכן וקטלוג
-- ===========================================================================

-- הסבר: מבט זה מקשר בין שלוש טבלאות ליבה: טבלת האטרקציות (ATTRACTIONS), טבלת הקטגוריות (CATEGORIES) וטבלת רמות הקושי (DIFFICULTY_LEVELS).
-- המטרה: להחליף את המזהים המספריים של הקטגוריות ורמות הקושי בשמות המילוליים הברורים שלהם, כדי להציג קטלוג אטרקציות קריא, שלם ונגיש.
CREATE OR REPLACE VIEW vw_attraction_catalog AS
SELECT 
    a.attraction_id,          -- מזהה ייחודי של האטרקציה
    a.name AS attraction_name, -- שם האטרקציה
    a.location,               -- מיקום גיאוגרפי של האטרקציה
    a.price,                  -- מחיר כרטיס בסיסי
    a.duration,               -- משך הפעילות בדקות
    a.avg_rating,             -- דירוג ממוצע שקיבלה האטרקציה מהגולשים
    c.name AS category_name,  -- שם הקטגוריה המילולי (מתוך טבלת קטגוריות)
    d.name AS difficulty_level, -- תיאור רמת הקושי המילולי (מתוך טבלת רמות קושי)
    a.target_audience         -- קהל היעד של האטרקציה
FROM ATTRACTIONS a
JOIN CATEGORIES c ON a.category_id = c.category_id
JOIN DIFFICULTY_LEVELS d ON a.difficulty_id = d.difficulty_id;


-- הסבר שאילתה 1: שאילתה זו מסננת את קטלוג האטרקציות לפי שני תנאים משולבים: דירוג ממוצע גבוה או שווה ל-4.0, ומחיר כרטיס נמוך מ-250 ש"ח.
-- המטרה: הפקת רשימת המלצות אטרקטיבית של אטרקציות פופולריות שזכו לפידבק חיובי מהגולשים ובטווח מחירים הגיוני ומשתלם.
SELECT 
    attraction_name, 
    category_name, 
    price, 
    avg_rating,
    difficulty_level
FROM vw_attraction_catalog
WHERE avg_rating >= 4.0 
  AND price < 250;


-- הסבר שאילתה 2: שאילתה זו מקבצת את האטרקציות לפי שם הקטגוריה שלהן ומחשבת את כמות הפעילויות בכל קטגוריה, את המחיר הממוצע ואת הדירוג הממוצע (תוצאות מעוגלות ל-2 ספרות).
-- המטרה: ניתוח סטטיסטי של תחומי התוכן השונים במסד הנתונים כדי להבין אילו קטגוריות הן היקרות ביותר, אילו זוכות לדירוגים הגבוהים ביותר, ואיפה יש הכי הרבה היצע.
SELECT 
    category_name, 
    COUNT(attraction_id) AS number_of_attractions,              -- כמות האטרקציות הקיימות תחת קטגוריה זו
    ROUND(AVG(price)::numeric, 2) AS avg_price,                 -- ממוצע מחירי הכרטיסים בקטגוריה
    ROUND(AVG(avg_rating)::numeric, 2) AS global_category_rating -- ממוצע הדירוגים הכללי של הקטגוריה
FROM vw_attraction_catalog
GROUP BY category_name
ORDER BY avg_price DESC;