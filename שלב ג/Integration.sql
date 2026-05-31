
--- ===========================================================================
--- FILE NAME: Integrate.sql
--- PURPOSE: פקודות שינוי ויצירה של טבלאות, מיזוג נתונים וניקוי המודל הישן
--- ===========================================================================

/*
===============================================================================
                       הסבר מילולי על תהליך האינטגרציה וההחלטות
===============================================================================
1. החלטה על מבנה המשתמשים (USERS):
   בטבלה של חברתך היו שדות נפרדים לשם פרטי ושם משפחה (first_name, last_name).
   הוחלט לשמור על השדה המקורי המאוחד אצלך (name) המכיל את השם המלא, שכן הוא עונה
   על הצורך הלוגי בצורה מלאה ומונע פיצול מידע מיותר. השדה המבדיל היחיד שהיה חסר
   הוא מדינת המגורים (country), והוא התווסף בהצלחה לטבלת המשתמשים שלך.

2. החלטה על הוספת ישויות חדשות (TICKET ו-PAYMENT):
   במערכת שלך לא היה ניהול ישיר של כרטיסים ספציפיים או מעקב תשלומים פרטני.
   כדי לאבד אפס מידע מהאינטגרציה, הוחלט להקים שתי טבלאות חדשות לחלוטין:
   טבלת TICKET לעדכון מלאי וסוגי כרטיסים, וטבלת PAYMENT למעקב כספי של הזמנות.

3. החלטה על שדרוג טבלאות קיימות (BOOKINGS ו-ATTRACTIONS):
   לטבלת ההזמנות נוספה עמודת 'total_price' (מחיר סופי מחושב) המאפשרת שליפת נתונים
   מהירה ללא צורך בחישובים מורכבים בזמן אמת. לטבלת האטרקציות נוספה עמודת
   'opening_hours' (שעות פתיחה) כדי להעשיר את המידע המוצג למשתמש.

4. שלבי ביצוע פקודות ה-SQL (אסטרטגיית המיזוג):
   - שלב א': מחיקת שאריות ישנות של טבלאות המקור כדי לאפשר הרצה נקייה.
   - שלב ב': יצירת טבלאות הלוויין החדשות (PAYMENT ו-TICKET) ללא הגדרת אילוצי מפתחות
            זרים בשלב הראשוני כדי למנוע חסימות (Deadlocks) בזמן העברת המידע.
   - שלב ג': הוספת העמודות החדשות לטבלאות הקיימות תוך שימוש ב-IF NOT EXISTS להגנה.
   - שלב ד': הזרקת המידע וביצוע עדכונים מוצלבים (UPDATE) בין טבלאות המקור לטבלאות היעד.
   - שלב ה': שימוש בבלוקים חסיני שגיאות (DO PL/pgSQL) להסרת הספרה 1 משמות השדות שלך
            והחזרתם למצבם המקורי והתקני.
   - שלב ו': החלת אילוצי שלמות (Constraints) ומפתחות זרים סופיים על המבנה המאוחד.
*/

-- ---------------------------------------------------------------------------
-- שלב א': ניקוי מראש של טבלאות המקור הזמניות (אם הן קיימות ונוצרו בעבר)
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS public.BOOKINGTICKET CASCADE;
DROP TABLE IF EXISTS public.REVIEW CASCADE;
DROP TABLE IF EXISTS public.BOOKING CASCADE;
DROP TABLE IF EXISTS public.PAYMENT CASCADE;
DROP TABLE IF EXISTS public.TICKET CASCADE;
DROP TABLE IF EXISTS public.ATTRACTION CASCADE;
DROP TABLE IF EXISTS public.CUSTOMER CASCADE;


-- ---------------------------------------------------------------------------
-- שלב ב': יצירת הטבלאות החדשות לחלוטין שמגיעות מהמודל המשולב
-- ---------------------------------------------------------------------------

-- 1. יצירת טבלת תשלומים סופית
CREATE TABLE IF NOT EXISTS PAYMENT
(
  payment_id INT NOT NULL,
  booking_id INT NOT NULL,
  amount FLOAT NOT NULL CHECK (amount > 0),
  PRIMARY KEY (payment_id),
  UNIQUE (booking_id)
);

-- 2. יצירת טבלת כרטיסים סופית
CREATE TABLE IF NOT EXISTS TICKET
(
  ticket_id INT NOT NULL,
  attraction_id INT NOT NULL,
  price FLOAT NOT NULL CHECK (price >= 0),
  valid_date DATE NOT NULL,
  ticket_type VARCHAR(20) NOT NULL,
  available_quantity INT CHECK (available_quantity >= 0),
  PRIMARY KEY (ticket_id)
);


-- ---------------------------------------------------------------------------
-- שלב ג': הרחבת הטבלאות הקיימות שלך והוספת העמודות החדשות מהאינטגרציה
-- ---------------------------------------------------------------------------
ALTER TABLE USERS ADD COLUMN IF NOT EXISTS country VARCHAR(20);
ALTER TABLE BOOKINGS ADD COLUMN IF NOT EXISTS total_price FLOAT;
ALTER TABLE ATTRACTIONS ADD COLUMN IF NOT EXISTS opening_hours TIME;


-- ---------------------------------------------------------------------------
-- שלב ד': העברת הנתונים המשולבת (INSERT & UPDATE) מוגנת בבלוק חכם
-- ---------------------------------------------------------------------------
DO $$
BEGIN
    -- עדכון נתוני מדינה לטבלת USERS (תומך בשני מצבי השמות האפשריים)
    BEGIN
        UPDATE USERS u SET country = c.country FROM CUSTOMER c WHERE u.user_id1 = c.customer_id;
    EXCEPTION WHEN undefined_column THEN
        UPDATE USERS u SET country = c.country FROM CUSTOMER c WHERE u.user_id = c.customer_id;
    EXCEPTION WHEN undefined_table THEN
        RAISE NOTICE 'טבלת המקור CUSTOMER אינה קיימת, מדלג על עדכון המדינה';
    END;

    -- עדכון שעות פתיחה לטבלת ATTRACTIONS
    BEGIN
        UPDATE ATTRACTIONS a SET opening_hours = att.opening_hours FROM ATTRACTION att WHERE a.attraction_id1 = att.attraction_id;
    EXCEPTION WHEN undefined_column THEN
        UPDATE ATTRACTIONS a SET opening_hours = att.opening_hours FROM ATTRACTION att WHERE a.attraction_id = att.attraction_id;
    EXCEPTION WHEN undefined_table THEN
        RAISE NOTICE 'טבלת המקור ATTRACTION אינה קיימת, מדלג על עדכון שעות פתיחה';
    END;

    -- עדכון מחיר כולל לטבלת BOOKINGS
    BEGIN
        UPDATE BOOKINGS b SET total_price = bk.total_price FROM BOOKING bk WHERE b.booking_id1 = bk.booking_id;
    EXCEPTION WHEN undefined_column THEN
        UPDATE BOOKINGS b SET total_price = bk.total_price FROM BOOKING bk WHERE b.booking_id = bk.booking_id;
    EXCEPTION WHEN undefined_table THEN
        RAISE NOTICE 'טבלת המקור BOOKING אינה קיימת, מדלג על עדכון מחיר כולל';
    END;
END $$;


-- ---------------------------------------------------------------------------
-- שלב ה': החזרת שמות השדות (העמודות) שלך לשמות המקוריים (הסרת הספרה 1)
-- ---------------------------------------------------------------------------
DO $$
BEGIN
    -- טבלת USERS
    BEGIN ALTER TABLE USERS RENAME COLUMN user_id1 TO user_id; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE USERS RENAME COLUMN name1 TO name; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE USERS RENAME COLUMN email1 TO email; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE USERS RENAME COLUMN avatar_url1 TO avatar_url; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE USERS RENAME COLUMN created_at1 TO created_at; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE USERS RENAME COLUMN password_hash1 TO password_hash; EXCEPTION WHEN undefined_column THEN END;

    -- טבלת BOOKINGS
    BEGIN ALTER TABLE BOOKINGS RENAME COLUMN booking_id1 TO booking_id; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE BOOKINGS RENAME COLUMN booking_date1 TO booking_date; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE BOOKINGS RENAME COLUMN ticket_count1 TO ticket_count; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE BOOKINGS RENAME COLUMN status1 TO status; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE BOOKINGS RENAME COLUMN contact_name1 TO contact_name; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE BOOKINGS RENAME COLUMN contact_email1 TO contact_email; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE BOOKINGS RENAME COLUMN created_at1 TO created_at; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE BOOKINGS RENAME COLUMN contact_phone1 TO contact_phone; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE BOOKINGS RENAME COLUMN user_id1 TO user_id; EXCEPTION WHEN undefined_column THEN END;

    -- טבלת ATTRACTIONS
    BEGIN ALTER TABLE ATTRACTIONS RENAME COLUMN attraction_id1 TO attraction_id; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE ATTRACTIONS RENAME COLUMN name1 TO name; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE ATTRACTIONS RENAME COLUMN short_description1 TO short_description; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE ATTRACTIONS RENAME COLUMN full_description1 TO full_description; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE ATTRACTIONS RENAME COLUMN location1 TO location; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE ATTRACTIONS RENAME COLUMN price1 TO price; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE ATTRACTIONS RENAME COLUMN difficulty_id1 TO difficulty_id; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE ATTRACTIONS RENAME COLUMN duration1 TO duration; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE ATTRACTIONS RENAME COLUMN target_audience1 TO target_audience; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE ATTRACTIONS RENAME COLUMN avg_rating1 TO avg_rating; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE ATTRACTIONS RENAME COLUMN review_count1 TO review_count; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE ATTRACTIONS RENAME COLUMN main_image_url1 TO main_image_url; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE ATTRACTIONS RENAME COLUMN category_id1 TO category_id; EXCEPTION WHEN undefined_column THEN END;

    -- טבלת CATEGORIES
    BEGIN ALTER TABLE CATEGORIES RENAME COLUMN category_id1 TO category_id; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE CATEGORIES RENAME COLUMN name1 TO name; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE CATEGORIES RENAME COLUMN icon_identifier1 TO icon_identifier; EXCEPTION WHEN undefined_column THEN END;

    -- טבלת DIFFICULTY_LEVELS
    BEGIN ALTER TABLE DIFFICULTY_LEVELS RENAME COLUMN difficulty_id1 TO difficulty_id; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE DIFFICULTY_LEVELS RENAME COLUMN name1 TO name; EXCEPTION WHEN undefined_column THEN END;

    -- טבלת GALLERY_IMAGES
    BEGIN ALTER TABLE GALLERY_IMAGES RENAME COLUMN image_id1 TO image_id; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE GALLERY_IMAGES RENAME COLUMN image_url1 TO image_url; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE GALLERY_IMAGES RENAME COLUMN attraction_id1 TO attraction_id; EXCEPTION WHEN undefined_column THEN END;

    -- טבלת REVIEWS
    BEGIN ALTER TABLE REVIEWS RENAME COLUMN review_id1 TO review_id; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE REVIEWS RENAME COLUMN comment1 TO comment; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE REVIEWS RENAME COLUMN created_at1 TO created_at; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE REVIEWS RENAME COLUMN rating1 TO rating; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE REVIEWS RENAME COLUMN user_id1 TO user_id; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE REVIEWS RENAME COLUMN attraction_id1 TO attraction_id; EXCEPTION WHEN undefined_column THEN END;

    -- טבלת BOOKING_DETAILS
    BEGIN ALTER TABLE BOOKING_DETAILS RENAME COLUMN booking_id1 TO booking_id; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE BOOKING_DETAILS RENAME COLUMN attraction_id1 TO attraction_id; EXCEPTION WHEN undefined_column THEN END;
    BEGIN ALTER TABLE BOOKING_DETAILS RENAME COLUMN ticket_count1 TO ticket_count; EXCEPTION WHEN undefined_column THEN END;
END $$;


-- ---------------------------------------------------------------------------
-- שלב ו': יצירת קשרי מפתחות זרים (Constraints) סופיים בין הטבלאות המאוחדות
-- ---------------------------------------------------------------------------
ALTER TABLE PAYMENT DROP CONSTRAINT IF EXISTS fk_payment_booking;
ALTER TABLE PAYMENT ADD CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES BOOKINGS(booking_id);

ALTER TABLE TICKET DROP CONSTRAINT IF EXISTS fk_ticket_attraction;
ALTER TABLE TICKET ADD CONSTRAINT fk_ticket_attraction FOREIGN KEY (attraction_id) REFERENCES ATTRACTIONS(attraction_id);