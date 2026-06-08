BEGIN;

-- ===========================================================================
-- PHASE 0: PREPARE TARGET SCHEMA & UNIFY FIELDS
-- ===========================================================================

CREATE TABLE IF NOT EXISTS PAYMENT
(
  payment_id INT NOT NULL,
  booking_id INT NOT NULL,
  amount DOUBLE PRECISION NOT NULL CHECK (amount > 0),
  PRIMARY KEY (payment_id),
  UNIQUE (booking_id)
);

CREATE TABLE IF NOT EXISTS TICKET
(
  ticket_id INT NOT NULL,
  attraction_id INT NOT NULL,
  price DOUBLE PRECISION NOT NULL CHECK (price >= 0),
  valid_date DATE NOT NULL,
  ticket_type CHARACTER VARYING(20) NOT NULL,
  available_quantity INT CHECK (available_quantity >= 0),
  PRIMARY KEY (ticket_id)
);

-- וידוא קיום עמודות יעד מתאימות (מותאם למבנה החדש עם הסיומת 1)
ALTER TABLE USERS ADD COLUMN IF NOT EXISTS phone1 VARCHAR(20);
ALTER TABLE USERS ADD COLUMN IF NOT EXISTS country1 VARCHAR(50);

ALTER TABLE ATTRACTIONS ADD COLUMN IF NOT EXISTS opening_hours1 TIME;

ALTER TABLE BOOKINGS ADD COLUMN IF NOT EXISTS total_price1 FLOAT;
ALTER TABLE BOOKINGS ADD COLUMN IF NOT EXISTS payment_id1 INT;
ALTER TABLE BOOKINGS ADD COLUMN IF NOT EXISTS quantity1 INT;

ALTER TABLE BOOKING_DETAILS ADD COLUMN IF NOT EXISTS quantity1 INT;

-- יצירת מונים (Sequences) במידה ואינם קיימים
CREATE SEQUENCE IF NOT EXISTS users_user_id_seq;
CREATE SEQUENCE IF NOT EXISTS attractions_attraction_id_seq;
CREATE SEQUENCE IF NOT EXISTS bookings_booking_id_seq;
CREATE SEQUENCE IF NOT EXISTS reviews_review_id_seq;
CREATE SEQUENCE IF NOT EXISTS payment_payment_id_seq;
CREATE SEQUENCE IF NOT EXISTS ticket_ticket_id_seq;

-- פלט סטטוס תקין ב-SQL רגיל במקום RAISE NOTICE
SELECT '✓ PHASE 0: Schema fusion completed. All target tables prepared.' AS migration_status;

-- יצירת טבלת לוג זמנית שתשרוד לאורך הטרנזקציה
DROP TABLE IF EXISTS tmp_integration_log;
CREATE TEMP TABLE tmp_integration_log
(
  log_id SERIAL PRIMARY KEY,
  phase VARCHAR(50),
  table_name VARCHAR(50),
  operation VARCHAR(20),
  rows_affected INT,
  status VARCHAR(50),
  message TEXT,
  created_at TIMESTAMP DEFAULT NOW()
) ON COMMIT PRESERVE ROWS;

-- הגירה פנימית של שדות ישנים בטבלת היעד (ticket_count1 -> quantity1)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'bookings' AND column_name = 'ticket_count1') THEN
    UPDATE BOOKINGS SET quantity1 = COALESCE(quantity1, ticket_count1);
    ALTER TABLE BOOKINGS DROP COLUMN ticket_count1;
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'booking_details' AND column_name = 'ticket_count1') THEN
    UPDATE BOOKING_DETAILS SET quantity1 = COALESCE(quantity1, ticket_count1);
    ALTER TABLE BOOKING_DETAILS DROP COLUMN ticket_count1;
  END IF;

  INSERT INTO tmp_integration_log(phase, table_name, operation, rows_affected, status, message)
  VALUES ('PHASE 0', 'BOOKINGS/BOOKING_DETAILS', 'MIGRATE', 0, 'SUCCESS', 'Internal target schema unified to quantity1 field');
END $$;

-- ===========================================================================
-- PHASE 1: CREATE TEMPORARY MAPPING TABLES
-- ===========================================================================
DROP TABLE IF EXISTS tmp_user_map;
DROP TABLE IF EXISTS tmp_attraction_map;
DROP TABLE IF EXISTS tmp_booking_map;

CREATE TEMP TABLE tmp_user_map (
  source_user_id INT PRIMARY KEY,
  target_user_id INT NOT NULL,
  match_type VARCHAR(20)
) ON COMMIT DROP;

CREATE TEMP TABLE tmp_attraction_map (
  source_attraction_id INT PRIMARY KEY,
  target_attraction_id INT NOT NULL,
  match_type VARCHAR(20)
) ON COMMIT DROP;

CREATE TEMP TABLE tmp_booking_map (
  source_booking_id INT PRIMARY KEY,
  target_booking_id INT NOT NULL,
  match_type VARCHAR(20)
) ON COMMIT DROP;

SELECT '✓ PHASE 1: ID Mapping tables initialized.' AS migration_status;

-- ===========================================================================
-- PHASE 2: MERGE CORE TABLES USING UNIQUE NATURAL KEYS
-- ===========================================================================

-- 2A: מיזוג משתמשים על בסיס מפתח ייחודי: EMAIL
DO $$
DECLARE
  v_user_max_id INT;
  v_updated_count INT := 0;
BEGIN
  IF to_regclass('public.customer') IS NULL THEN RETURN; END IF;

  -- נרמול נתוני מקור (ממסד המקור הישן, השדות ללא 1)
  DROP TABLE IF EXISTS tmp_customer_norm;
  CREATE TEMP TABLE tmp_customer_norm AS
  SELECT
    c.customer_id,
    lower(trim(c.email)) AS email_key,
    NULLIF(trim(COALESCE(c.first_name, '') || ' ' || COALESCE(c.last_name, '')), '') AS full_name,
    c.email, c.country, COALESCE(c.phone, NULL) AS phone,
    COALESCE(c.password, 'imported_' || md5(random()::text)) AS password_hash
  FROM CUSTOMER c WHERE c.email IS NOT NULL AND trim(c.email) <> '';

  -- עדכון משתמשים קיימים ביעד לפי אימייל (השדות ביעד עודכנו ל-1)
  UPDATE USERS u
  SET
    name1 = COALESCE(u.name1, s.full_name),
    country1 = COALESCE(u.country1, s.country),
    phone1 = COALESCE(u.phone1, s.phone),
    password_hash1 = COALESCE(u.password_hash1, s.password_hash)
  FROM tmp_customer_norm s
  WHERE lower(trim(u.email1)) = s.email_key;
  
  GET DIAGNOSTICS v_updated_count = ROW_COUNT;

  -- מיפוי משתמשים קיימים (עודכן ל-user_id1 ו-email1)
  INSERT INTO tmp_user_map(source_user_id, target_user_id, match_type)
  SELECT s.customer_id, u.user_id1, 'existing'
  FROM tmp_customer_norm s
  JOIN USERS u ON lower(trim(u.email1)) = s.email_key;

  -- יצירת מזהים חדשים רצים עבור אלו שלא נמצאו לפי אימייל
  SELECT COALESCE(MAX(user_id1), 0) INTO v_user_max_id FROM USERS;

  WITH new_customers AS (
    SELECT s.*, ROW_NUMBER() OVER (ORDER BY s.customer_id) AS rn
    FROM tmp_customer_norm s
    LEFT JOIN tmp_user_map m ON m.source_user_id = s.customer_id
    WHERE m.source_user_id IS NULL
  ),
  ins AS (
    INSERT INTO USERS (user_id1, name1, email1, created_at1, password_hash1, country1, phone1)
    SELECT v_user_max_id + rn, COALESCE(full_name, 'Imported User'), email, NOW(), password_hash, country, phone
    FROM new_customers
    RETURNING user_id1, lower(trim(email1)) AS email_key
  )
  INSERT INTO tmp_user_map(source_user_id, target_user_id, match_type)
  SELECT n.customer_id, i.user_id1, 'new'
  FROM new_customers n
  JOIN ins i ON i.email_key = n.email_key;
END $$;

-- 2B: מיזוג אטרקציות על בסיס מפתח משולב ייחודי: NAME + LOCATION
DO $$
DECLARE
  v_attr_max_id INT;
BEGIN
  IF to_regclass('public.attraction') IS NULL THEN RETURN; END IF;

  DROP TABLE IF EXISTS tmp_attr_norm;
  CREATE TEMP TABLE tmp_attr_norm AS
  SELECT
    a.attraction_id,
    lower(trim(a.name)) AS name_key,
    lower(trim(a.location)) AS location_key,
    a.name, a.location, COALESCE(a.price, 0) AS price,
    COALESCE(a.opening_hours, NULL) AS opening_hours, COALESCE(a.description, NULL) AS description
  FROM ATTRACTION a WHERE a.name IS NOT NULL AND a.location IS NOT NULL;

  -- עדכון נתונים חסרים באטרקציות קיימות ביעד (עודכן ל-1)
  UPDATE ATTRACTIONS t
  SET price1 = COALESCE(t.price1, s.price), 
      opening_hours1 = COALESCE(t.opening_hours1, s.opening_hours), 
      full_description1 = COALESCE(t.full_description1, s.description)
  FROM tmp_attr_norm s WHERE lower(trim(t.name1)) = s.name_key AND lower(trim(t.location1)) = s.location_key;

  -- בניית מפת מזהים לאטרקציות קיימות
  INSERT INTO tmp_attraction_map(source_attraction_id, target_attraction_id, match_type)
  SELECT s.attraction_id, t.attraction_id1, 'existing'
  FROM tmp_attr_norm s
  JOIN ATTRACTIONS t ON lower(trim(t.name1)) = s.name_key AND lower(trim(t.location1)) = s.location_key;

  -- הכנסת אטרקציות חדשות לחלוטין (עודכן ל-1)
  SELECT COALESCE(MAX(attraction_id1), 0) INTO v_attr_max_id FROM ATTRACTIONS;

  WITH new_attr AS (
    SELECT s.*, ROW_NUMBER() OVER (ORDER BY s.attraction_id) AS rn
    FROM tmp_attr_norm s
    LEFT JOIN tmp_attraction_map m ON m.source_attraction_id = s.attraction_id
    WHERE m.source_attraction_id IS NULL
  ),
  ins AS (
    INSERT INTO ATTRACTIONS (attraction_id1, name1, short_description1, full_description1, location1, price1, difficulty_id1, duration1, target_audience1, avg_rating1, review_count1, category_id1, opening_hours1)
    SELECT v_attr_max_id + rn, name, name, description, location, price, 1, 60, 'All', NULL, 0, 1, opening_hours
    FROM new_attr
    RETURNING attraction_id1, lower(trim(name1)) AS name_key, lower(trim(location1)) AS location_key
  )
  INSERT INTO tmp_attraction_map(source_attraction_id, target_attraction_id, match_type)
  SELECT n.attraction_id, i.attraction_id1, 'new'
  FROM new_attr n
  JOIN ins i ON i.name_key = n.name_key AND i.location_key = n.location_key;
END $$;

-- ===========================================================================
-- PHASE 3: MERGE DEPENDENT TABLES WITH COMPOSITE NATURAL KEYS
-- ===========================================================================

-- 3A: מיזוג הזמנות לפי מפתח משולב: USER_ID (ממוזג) + BOOKING_DATE + TOTAL_PRICE
DO $$
DECLARE
  v_booking_max_id INT;
  has_quantity_col BOOLEAN;
BEGIN
  IF to_regclass('public.booking') IS NULL THEN RETURN; END IF;

  DROP TABLE IF EXISTS tmp_booking_norm;
  CREATE TEMP TABLE tmp_booking_norm AS
  SELECT
    b.booking_id AS source_booking_id,
    um.target_user_id,
    b.booking_date,
    COALESCE(b.total_price, 0) AS total_price,
    1 AS quantity, 
    COALESCE(NULLIF(trim(b.booking_status), ''), 'Confirmed') AS status
  FROM BOOKING b
  JOIN tmp_user_map um ON um.source_user_id = b.customer_id
  WHERE b.booking_date IS NOT NULL;

  -- בדיקה מראש איזו עמודה קיימת בטבלת המקור כדי למנוע קריסת טרנזקציה
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' AND table_name = 'booking' AND column_name = 'quantity'
  ) INTO has_quantity_col;

  -- עדכון הכמות בהתאם לעמודה שנמצאה במקור
  IF has_quantity_col THEN
    UPDATE tmp_booking_norm bn SET quantity = b.quantity FROM BOOKING b WHERE bn.source_booking_id = b.booking_id;
  ELSE
    -- אם הגעת לכאן, נבדוק אם ticket_count קיימת, אם לא - נשאיר 1 כברירת מחדל
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'booking' AND column_name = 'ticket_count') THEN
      UPDATE tmp_booking_norm bn SET quantity = b.ticket_count FROM BOOKING b WHERE bn.source_booking_id = b.booking_id;
    END IF;
  END IF;

  -- מיפוי הזמנות קיימות לפי המפתח המשולב (עודכן ל-1 ביעד)
  INSERT INTO tmp_booking_map(source_booking_id, target_booking_id, match_type)
  SELECT s.source_booking_id, t.booking_id1, 'existing'
  FROM tmp_booking_norm s
  JOIN BOOKINGS t ON t.user_id1 = s.target_user_id AND t.booking_date1 = s.booking_date AND COALESCE(t.total_price1, 0) = s.total_price;

  -- הוספת הזמנות ייחודיות חדשות (עודכן ל-1 ביעד)
  SELECT COALESCE(MAX(booking_id1), 0) INTO v_booking_max_id FROM BOOKINGS;

  WITH new_bookings AS (
    SELECT s.*, u.name1 AS contact_name, u.email1 AS contact_email, ROW_NUMBER() OVER (ORDER BY s.source_booking_id) AS rn
    FROM tmp_booking_norm s
    JOIN USERS u ON u.user_id1 = s.target_user_id
    LEFT JOIN tmp_booking_map m ON m.source_booking_id = s.source_booking_id
    WHERE m.source_booking_id IS NULL
  ),
  ins AS (
    INSERT INTO BOOKINGS (booking_id1, booking_date1, quantity1, status1, contact_name1, contact_email1, created_at1, user_id1, total_price1)
    SELECT v_booking_max_id + rn, booking_date, quantity, status, contact_name, contact_email, NOW(), target_user_id, total_price
    FROM new_bookings
    RETURNING booking_id1, user_id1, booking_date1, total_price1
  )
  INSERT INTO tmp_booking_map(source_booking_id, target_booking_id, match_type)
  SELECT n.source_booking_id, i.booking_id1, 'new'
  FROM new_bookings n
  JOIN ins i ON i.user_id1 = n.target_user_id AND i.booking_date1 = n.booking_date AND i.total_price1 = n.total_price;
END $$;
-- 3B: מיזוג חוות דעת לפי מפתח משולב: USER_ID + ATTRACTION_ID + COMMENT (טקסט)
DO $$
DECLARE v_review_max_id INT;
BEGIN
  IF to_regclass('public.review') IS NULL THEN RETURN; END IF;
  SELECT COALESCE(MAX(review_id1), 0) INTO v_review_max_id FROM REVIEWS;

  WITH candidate AS (
    SELECT r.comment, COALESCE(r.review_date, NOW()) AS created_at, COALESCE(r.rating, 3) AS rating, um.target_user_id, am.target_attraction_id, ROW_NUMBER() OVER (ORDER BY r.review_id) AS rn
    FROM REVIEW r
    JOIN tmp_user_map um ON um.source_user_id = r.customer_id
    JOIN tmp_attraction_map am ON am.source_attraction_id = r.attraction_id
    LEFT JOIN REVIEWS t ON t.user_id1 = um.target_user_id AND t.attraction_id1 = am.target_attraction_id AND lower(trim(t.comment1)) = lower(trim(r.comment))
    WHERE t.review_id1 IS NULL 
  )
  INSERT INTO REVIEWS(review_id1, comment1, created_at1, rating1, user_id1, attraction_id1)
  SELECT v_review_max_id + rn, comment, created_at, rating, target_user_id, target_attraction_id
  FROM candidate;
END $$;

-- 3C: מיזוג פרטי הזמנה לפי מפתח משולב: BOOKING_ID + ATTRACTION_ID (מעודכן ל-SQL דינמי)
DO $$
DECLARE
  has_booking_id BOOLEAN; has_attraction_id BOOLEAN;
  has_ticket_count BOOLEAN; has_ticket_id BOOLEAN; has_quantity BOOLEAN;
  v_col_expr TEXT;
BEGIN
  IF to_regclass('public.bookingticket') IS NULL THEN RETURN; END IF;

  SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'bookingticket' AND column_name = 'booking_id') INTO has_booking_id;
  SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'bookingticket' AND column_name = 'attraction_id') INTO has_attraction_id;
  SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'bookingticket' AND column_name = 'ticket_count') INTO has_ticket_count;
  SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'bookingticket' AND column_name = 'ticket_id') INTO has_ticket_id;
  SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'bookingticket' AND column_name = 'quantity') INTO has_quantity;

  -- קביעת הביטוי הדינמי עבור עמודת הכמות בהתאם למה שקיים במקור
  IF has_quantity THEN v_col_expr := 'COALESCE(bt.quantity, 1)';
  ELSIF has_ticket_count THEN v_col_expr := 'COALESCE(bt.ticket_count, 1)';
  ELSE v_col_expr := '1';
  END IF;

  -- מבנה א': מבוסס קישור ישיר לאטרקציה
  IF has_booking_id AND has_attraction_id THEN
    EXECUTE format('
      INSERT INTO BOOKING_DETAILS (booking_id1, attraction_id1, quantity1)
      SELECT bm.target_booking_id, am.target_attraction_id, %s
      FROM BOOKINGTICKET bt
      JOIN tmp_booking_map bm ON bm.source_booking_id = bt.booking_id
      JOIN tmp_attraction_map am ON am.source_attraction_id = bt.attraction_id
      ON CONFLICT (booking_id1, attraction_id1) DO UPDATE
        SET quantity1 = GREATEST(COALESCE(BOOKING_DETAILS.quantity1, 0), COALESCE(EXCLUDED.quantity1, 0))', 
      v_col_expr);

  -- מבנה ב': מבוסס מפתח כרטיס
  ELSIF has_booking_id AND has_ticket_id THEN
    EXECUTE format('
      INSERT INTO BOOKING_DETAILS (booking_id1, attraction_id1, quantity1)
      SELECT bm.target_booking_id, am.target_attraction_id, %s
      FROM BOOKINGTICKET bt
      JOIN TICKET t ON t.ticket_id = bt.ticket_id
      JOIN tmp_booking_map bm ON bm.source_booking_id = bt.booking_id
      JOIN tmp_attraction_map am ON am.source_attraction_id = t.attraction_id
      ON CONFLICT (booking_id1, attraction_id1) DO UPDATE
        SET quantity1 = GREATEST(COALESCE(BOOKING_DETAILS.quantity1, 0), COALESCE(EXCLUDED.quantity1, 0))', 
      v_col_expr);
  END IF;
END $$;
-- ===========================================================================
-- PHASE 4: SUPPLEMENTARY TABLES (PAYMENTS & TICKETS)
-- ===========================================================================

-- 4A: מיזוג כרטיסים לפי מפתח משולב
DO $$
DECLARE v_ticket_max_id INT;
BEGIN
  IF to_regclass('public.ticket_source') IS NULL THEN RETURN; END IF;
  SELECT COALESCE(MAX(ticket_id), 0) INTO v_ticket_max_id FROM TICKET;

  WITH src_tickets AS (
    SELECT t.price, t.valid_date, t.ticket_type, COALESCE(t.available_quantity, 0) AS available_quantity, am.target_attraction_id, ROW_NUMBER() OVER (ORDER BY t.ticket_id) AS rn
    FROM TICKET_SOURCE t
    JOIN tmp_attraction_map am ON am.source_attraction_id = t.attraction_id
  ),
  new_tickets AS (
    SELECT s.* FROM src_tickets s
    LEFT JOIN TICKET tgt ON tgt.attraction_id = s.target_attraction_id AND tgt.ticket_type = s.ticket_type AND tgt.valid_date = s.valid_date
    WHERE tgt.ticket_id IS NULL 
  )
  INSERT INTO TICKET (ticket_id, attraction_id, price, valid_date, ticket_type, available_quantity)
  SELECT v_ticket_max_id + rn, target_attraction_id, price, valid_date, ticket_type, available_quantity
  FROM new_tickets;
END $$;

-- 4B: מיזוג תשלומים לפי מפתח משולב
DO $$
DECLARE v_payment_max_id INT;
BEGIN
  IF to_regclass('public.payment_source') IS NULL THEN RETURN; END IF;
  SELECT COALESCE(MAX(payment_id), 0) INTO v_payment_max_id FROM PAYMENT;

  INSERT INTO PAYMENT (payment_id, booking_id, amount)
  SELECT v_payment_max_id + ROW_NUMBER() OVER (ORDER BY p.payment_id), bm.target_booking_id, p.amount
  FROM PAYMENT_SOURCE p
  JOIN tmp_booking_map bm ON bm.source_booking_id = p.booking_id
  ON CONFLICT (booking_id) DO UPDATE 
    SET amount = EXCLUDED.amount;
END $$;

-- עדכון שדה הקישור החוזר בטבלת הזמנות (עודכן ל-payment_id1 ו-booking_id1)
DO $$
BEGIN
  UPDATE BOOKINGS b
  SET payment_id1 = p.payment_id
  FROM PAYMENT p WHERE b.booking_id1 = p.booking_id;
END $$;

-- ===========================================================================
-- PHASE 5: SEQUENCE SYNCHRONIZATION
-- ===========================================================================
DO $$
DECLARE
  v_seq_names TEXT[] := ARRAY['users_user_id_seq', 'attractions_attraction_id_seq', 'bookings_booking_id_seq', 'reviews_review_id_seq', 'payment_payment_id_seq', 'ticket_ticket_id_seq'];
  v_seq_name TEXT; v_max_id BIGINT;
BEGIN
  FOREACH v_seq_name IN ARRAY v_seq_names LOOP
    IF EXISTS (SELECT 1 FROM pg_sequences WHERE sequencename = v_seq_name) THEN
      CASE v_seq_name
        WHEN 'users_user_id_seq' THEN SELECT COALESCE(MAX(user_id1), 0) INTO v_max_id FROM USERS;
        WHEN 'attractions_attraction_id_seq' THEN SELECT COALESCE(MAX(attraction_id1), 0) INTO v_max_id FROM ATTRACTIONS;
        WHEN 'bookings_booking_id_seq' THEN SELECT COALESCE(MAX(booking_id1), 0) INTO v_max_id FROM BOOKINGS;
        WHEN 'reviews_review_id_seq' THEN SELECT COALESCE(MAX(review_id1), 0) INTO v_max_id FROM REVIEWS;
        WHEN 'payment_payment_id_seq' THEN SELECT COALESCE(MAX(payment_id), 0) INTO v_max_id FROM PAYMENT;
        WHEN 'ticket_ticket_id_seq' THEN SELECT COALESCE(MAX(ticket_id), 0) INTO v_max_id FROM TICKET;
      END CASE;
      EXECUTE format('SELECT setval(%L, %L, true)', v_seq_name, v_max_id);
    END IF;
  END LOOP;
END $$;

DROP TABLE IF EXISTS BOOKINGTICKET CASCADE;
DROP TABLE IF EXISTS REVIEW CASCADE;
DROP TABLE IF EXISTS BOOKING CASCADE;
DROP TABLE IF EXISTS ATTRACTION CASCADE;
DROP TABLE IF EXISTS CUSTOMER CASCADE;

-- אם קיימות טבלאות גיבוי זמניות של המקור, אפשר למחוק גם אותן:
DROP TABLE IF EXISTS TICKET_SOURCE CASCADE;
DROP TABLE IF EXISTS PAYMENT_SOURCE CASCADE;

COMMIT;

BEGIN;

UPDATE BOOKINGS b
SET total_price = (
    SELECT SUM(bd.quantity * a.price)
    FROM BOOKING_DETAILS bd
    JOIN ATTRACTIONS a ON bd.attraction_id = a.attraction_id
    WHERE bd.booking_id = b.booking_id
)
WHERE b.total_price IS NULL;

COMMIT;
