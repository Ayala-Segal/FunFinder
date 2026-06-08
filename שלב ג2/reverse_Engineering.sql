-- ---------------------------------------------------------------------------
-- הינדוס לאחור (Reverse Engineering) – מסכמה לוגית לERD
-- ---------------------------------------------------------------------------
/*
===============================================================================
              אלגוריתם הינדוס לאחור: כיצד מקבלים ERD מתוך בסיס נתונים קיים
===============================================================================

לאחר שקיבלנו את הגיבוי של מערכת ה-Database של חברתנו,
ביצענו הינדוס לאחור לפי הצעדים הבאים:

שלב 1: זיהוי ישויות (Entities)
   כל טבלה בבסיס הנתונים מייצגת ישות.
   שם הטבלה הופך לשם הישות בתרשים ה-ERD.

שלב 2: זיהוי תכונות (Attributes)
   כל עמודה (Column) בטבלה מייצגת תכונה של הישות.
   סוג הנתון (VARCHAR, INT, DATE וכו') נשמר כמידע נלווה.

שלב 3: זיהוי מפתח ראשי (Primary Key)
   עמודה המוגדרת כ-PRIMARY KEY היא המזהה הייחודי של הישות (מסומן בקו תחתי ב-ERD).
   מפתח מורכב (Composite PK) מצביע לרוב על ישות חלשה.

שלב 4: זיהוי קשרים ממפתחות זרים (Foreign Keys → Relationships)
   כל FOREIGN KEY מגדיר קשר בין שתי ישויות:
   - הטבלה שמכילה את ה-FK היא הצד ה"רבים" (Many)
   - הטבלה שאליה ה-FK מצביע היא הצד ה"אחד" (One)

שלב 5: קביעת חיוביות (Cardinality)
   - אם עמודת ה-FK מאפשרת NULL → הקשר אופציונלי (0 or 1)
   - אם עמודת ה-FK היא NOT NULL → הקשר מחויב (exactly 1)
   - אם ה-FK הוא חלק ממפתח ראשי מורכב → קשר Many-to-Many (טבלת ביניים)

שלב 6: זיהוי ישויות חלשות (Weak Entities)
   טבלה שהמפתח הראשי שלה מורכב לחלוטין ממפתחות זרים היא ישות חלשה.

שלב 7: קיפול טבלאות ביניים
   טבלה המכילה רק שני מפתחות זרים (+ תכונות נוספות אופציונליות)
   מייצגת קשר Many-to-Many ומומרת לקשר ישיר בין שתי הישויות ב-ERD.
*/

-- שאילתות לחשיפת המבנה אוטומטית מתוך ה-information_schema:

-- 1. הצגת כל הטבלאות (הישויות)
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 2. הצגת כל העמודות לכל טבלה (התכונות)
SELECT table_name, column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- 3. זיהוי מפתחות ראשיים (מזהי הישויות)
SELECT tc.table_name, kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
   AND tc.table_schema = kcu.table_schema
WHERE tc.constraint_type = 'PRIMARY KEY'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name;

-- 4. זיהוי מפתחות זרים (הקשרים בין הישויות)
SELECT
    kcu.table_name        AS from_table,
    kcu.column_name       AS fk_column,
    ccu.table_name        AS to_table,
    ccu.column_name       AS pk_column,
    tc.constraint_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
   AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage ccu
    ON tc.constraint_name = ccu.constraint_name
   AND tc.table_schema = ccu.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
ORDER BY kcu.table_name;