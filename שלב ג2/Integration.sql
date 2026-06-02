-- ============================================================================
-- STAGE G2 - Integration.sql
-- PURPOSE:
--   מיזוג חכם בין הדאטה הקיים (USERS / ATTRACTIONS / BOOKINGS / REVIEWS / BOOKING_DETAILS)
--   לבין טבלאות מקור אפשריות של צוות נוסף (CUSTOMER / ATTRACTION / BOOKING / REVIEW / BOOKINGTICKET).
--
-- עקרונות המיזוג:
-- 1) זיהוי כפילויות לפי מפתח עסקי (לדוגמה: USERS לפי email).
-- 2) עדכון רשומה קיימת רק כשיש ערך חסר (COALESCE) כדי לא לדרוס מידע איכותי.
-- 3) הכנסת רשומות חדשות עם מזהים חדשים בלבד: MAX(id) + ROW_NUMBER() (מונע התנגשות מספר רץ).
-- 4) שמירת מיפויי מזהים בטבלאות זמניות לצורך מיזוג טבלאות תלויות (BOOKINGS, REVIEWS, BOOKING_DETAILS).
-- 5) בסוף כל שלב - סנכרון sequence (אם קיים) כדי שהכנסות עתידיות לא יתנגשו.
--
-- הערה:
--   הסקריפט Idempotent ברמת מבנה/לוגיקה: אפשר להריץ כמה פעמים, והוא ימזג רק מה שחסר.
-- ============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- שלב 0: יצירת טבלאות משלימות במידת הצורך (לפי שלב ג')
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS PAYMENT
(
  payment_id INT NOT NULL,
  booking_id INT NOT NULL,
  amount FLOAT NOT NULL CHECK (amount > 0),
  PRIMARY KEY (payment_id),
  UNIQUE (booking_id)
);

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

ALTER TABLE USERS       ADD COLUMN IF NOT EXISTS country VARCHAR(20);
ALTER TABLE BOOKINGS    ADD COLUMN IF NOT EXISTS total_price FLOAT;
ALTER TABLE ATTRACTIONS ADD COLUMN IF NOT EXISTS opening_hours TIME;

ALTER TABLE PAYMENT DROP CONSTRAINT IF EXISTS fk_payment_booking;
ALTER TABLE PAYMENT ADD CONSTRAINT fk_payment_booking
  FOREIGN KEY (booking_id) REFERENCES BOOKINGS(booking_id);

ALTER TABLE TICKET DROP CONSTRAINT IF EXISTS fk_ticket_attraction;
ALTER TABLE TICKET ADD CONSTRAINT fk_ticket_attraction
  FOREIGN KEY (attraction_id) REFERENCES ATTRACTIONS(attraction_id);

-- ---------------------------------------------------------------------------
-- שלב 1: טבלאות מיפוי זמניות (מקור -> יעד)
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS tmp_user_map;
DROP TABLE IF EXISTS tmp_attraction_map;
DROP TABLE IF EXISTS tmp_booking_map;

CREATE TEMP TABLE tmp_user_map
(
  source_customer_id INT PRIMARY KEY,
  target_user_id INT NOT NULL
) ON COMMIT DROP;

CREATE TEMP TABLE tmp_attraction_map
(
  source_attraction_id INT PRIMARY KEY,
  target_attraction_id INT NOT NULL
) ON COMMIT DROP;

CREATE TEMP TABLE tmp_booking_map
(
  source_booking_id INT PRIMARY KEY,
  target_booking_id INT NOT NULL
) ON COMMIT DROP;

-- ---------------------------------------------------------------------------
-- שלב 2: מיזוג USERS מ-CUSTOMER (דדופליקציה לפי email)
-- ---------------------------------------------------------------------------
DO $$
DECLARE
  v_user_max_id INT;
  v_seq_name TEXT;
BEGIN
  IF to_regclass('public.customer') IS NULL THEN
    RAISE NOTICE 'CUSTOMER לא קיימת - דילוג על מיזוג USERS.';
    RETURN;
  END IF;

  DROP TABLE IF EXISTS tmp_customer_norm;
  CREATE TEMP TABLE tmp_customer_norm AS
  SELECT
    c.customer_id,
    lower(trim(c.email)) AS email_key,
    nullif(trim(COALESCE(c.first_name, '') || ' ' || COALESCE(c.last_name, '')), '') AS full_name,
    c.email,
    c.country,
    COALESCE(c.password, 'imported') AS password_hash,
    COALESCE(c.created_at, NOW()) AS created_at
  FROM CUSTOMER c
  WHERE c.email IS NOT NULL
    AND trim(c.email) <> '';

  UPDATE USERS u
  SET
    name = COALESCE(u.name, s.full_name),
    country = COALESCE(u.country, s.country),
    password_hash = COALESCE(u.password_hash, s.password_hash),
    created_at = COALESCE(u.created_at, s.created_at)
  FROM tmp_customer_norm s
  WHERE lower(trim(u.email)) = s.email_key;

  INSERT INTO tmp_user_map(source_customer_id, target_user_id)
  SELECT s.customer_id, u.user_id
  FROM tmp_customer_norm s
  JOIN USERS u
    ON lower(trim(u.email)) = s.email_key
  ON CONFLICT (source_customer_id) DO NOTHING;

  SELECT COALESCE(MAX(user_id), 0) INTO v_user_max_id FROM USERS;

  WITH new_customers AS (
    SELECT
      s.customer_id,
      s.full_name,
      s.email,
      s.password_hash,
      s.created_at,
      s.country,
      ROW_NUMBER() OVER (ORDER BY s.customer_id) AS rn
    FROM tmp_customer_norm s
    LEFT JOIN tmp_user_map m
      ON m.source_customer_id = s.customer_id
    WHERE m.source_customer_id IS NULL
  ),
  ins AS (
    INSERT INTO USERS (user_id, name, email, avatar_url, created_at, password_hash, country)
    SELECT
      v_user_max_id + rn,
      COALESCE(full_name, 'Imported User'),
      email,
      NULL,
      created_at,
      password_hash,
      country
    FROM new_customers
    RETURNING user_id, lower(trim(email)) AS email_key
  )
  INSERT INTO tmp_user_map(source_customer_id, target_user_id)
  SELECT n.customer_id, i.user_id
  FROM new_customers n
  JOIN ins i
    ON i.email_key = lower(trim(n.email))
  ON CONFLICT (source_customer_id) DO NOTHING;

  SELECT pg_get_serial_sequence('public.users', 'user_id') INTO v_seq_name;
  IF v_seq_name IS NOT NULL THEN
    EXECUTE format('SELECT setval(%L, COALESCE((SELECT MAX(user_id) FROM USERS), 0), true)', v_seq_name);
  END IF;

  RAISE NOTICE 'USERS merged from CUSTOMER successfully.';
END $$;

-- ---------------------------------------------------------------------------
-- שלב 3: מיזוג ATTRACTIONS מ-ATTRACTION (דדופליקציה לפי name+location)
-- ---------------------------------------------------------------------------
DO $$
DECLARE
  v_attr_max_id INT;
  v_seq_name TEXT;
BEGIN
  IF to_regclass('public.attraction') IS NULL THEN
    RAISE NOTICE 'ATTRACTION לא קיימת - דילוג על מיזוג ATTRACTIONS.';
    RETURN;
  END IF;

  DROP TABLE IF EXISTS tmp_attr_norm;
  CREATE TEMP TABLE tmp_attr_norm AS
  SELECT
    a.attraction_id,
    lower(trim(a.name)) AS name_key,
    lower(trim(a.location)) AS location_key,
    a.name,
    a.location,
    a.price,
    a.opening_hours
  FROM ATTRACTION a
  WHERE a.name IS NOT NULL
    AND a.location IS NOT NULL;

  UPDATE ATTRACTIONS t
  SET
    price = COALESCE(t.price, s.price),
    opening_hours = COALESCE(t.opening_hours, s.opening_hours)
  FROM tmp_attr_norm s
  WHERE lower(trim(t.name)) = s.name_key
    AND lower(trim(t.location)) = s.location_key;

  INSERT INTO tmp_attraction_map(source_attraction_id, target_attraction_id)
  SELECT s.attraction_id, t.attraction_id
  FROM tmp_attr_norm s
  JOIN ATTRACTIONS t
    ON lower(trim(t.name)) = s.name_key
   AND lower(trim(t.location)) = s.location_key
  ON CONFLICT (source_attraction_id) DO NOTHING;

  SELECT COALESCE(MAX(attraction_id), 0) INTO v_attr_max_id FROM ATTRACTIONS;

  WITH new_attr AS (
    SELECT
      s.*,
      ROW_NUMBER() OVER (ORDER BY s.attraction_id) AS rn
    FROM tmp_attr_norm s
    LEFT JOIN tmp_attraction_map m
      ON m.source_attraction_id = s.attraction_id
    WHERE m.source_attraction_id IS NULL
  ),
  ins AS (
    INSERT INTO ATTRACTIONS
    (
      attraction_id, name, short_description, full_description, location, price,
      difficulty_id, duration, target_audience, avg_rating, review_count,
      main_image_url, category_id, opening_hours
    )
    SELECT
      v_attr_max_id + rn,
      name,
      COALESCE(name, 'Imported attraction'),
      NULL,
      location,
      COALESCE(price, 0),
      1,
      60,
      'All',
      NULL,
      0,
      NULL,
      1,
      opening_hours
    FROM new_attr
    RETURNING attraction_id, lower(trim(name)) AS name_key, lower(trim(location)) AS location_key
  )
  INSERT INTO tmp_attraction_map(source_attraction_id, target_attraction_id)
  SELECT n.attraction_id, i.attraction_id
  FROM new_attr n
  JOIN ins i
    ON i.name_key = n.name_key
   AND i.location_key = n.location_key
  ON CONFLICT (source_attraction_id) DO NOTHING;

  SELECT pg_get_serial_sequence('public.attractions', 'attraction_id') INTO v_seq_name;
  IF v_seq_name IS NOT NULL THEN
    EXECUTE format('SELECT setval(%L, COALESCE((SELECT MAX(attraction_id) FROM ATTRACTIONS), 0), true)', v_seq_name);
  END IF;

  RAISE NOTICE 'ATTRACTIONS merged from ATTRACTION successfully.';
END $$;

-- ---------------------------------------------------------------------------
-- שלב 4: מיזוג BOOKINGS מ-BOOKING
-- זיהוי כפילות: user_id + booking_date + total_price
-- ---------------------------------------------------------------------------
DO $$
DECLARE
  v_booking_max_id INT;
  v_seq_name TEXT;
BEGIN
  IF to_regclass('public.booking') IS NULL THEN
    RAISE NOTICE 'BOOKING לא קיימת - דילוג על מיזוג BOOKINGS.';
    RETURN;
  END IF;

  DROP TABLE IF EXISTS tmp_booking_norm;
  CREATE TEMP TABLE tmp_booking_norm AS
  SELECT
    b.booking_id AS source_booking_id,
    COALESCE(um.target_user_id, b.customer_id) AS target_user_id,
    b.booking_date,
    b.total_price,
    COALESCE(NULLIF(trim(b.status), ''), 'Confirmed') AS status,
    NOW()::timestamp AS created_at
  FROM BOOKING b
  LEFT JOIN tmp_user_map um
    ON um.source_customer_id = b.customer_id
  WHERE b.booking_date IS NOT NULL;

  INSERT INTO tmp_booking_map(source_booking_id, target_booking_id)
  SELECT s.source_booking_id, t.booking_id
  FROM tmp_booking_norm s
  JOIN BOOKINGS t
    ON t.user_id = s.target_user_id
   AND t.booking_date = s.booking_date
   AND COALESCE(t.total_price, -1) = COALESCE(s.total_price, -1)
  ON CONFLICT (source_booking_id) DO NOTHING;

  UPDATE BOOKINGS t
  SET
    total_price = COALESCE(t.total_price, s.total_price),
    status = COALESCE(NULLIF(t.status, ''), s.status)
  FROM tmp_booking_norm s
  JOIN tmp_booking_map m
    ON m.source_booking_id = s.source_booking_id
  WHERE t.booking_id = m.target_booking_id;

  SELECT COALESCE(MAX(booking_id), 0) INTO v_booking_max_id FROM BOOKINGS;

  WITH new_bookings AS (
    SELECT
      s.*,
      u.name AS contact_name,
      u.email AS contact_email,
      ROW_NUMBER() OVER (ORDER BY s.source_booking_id) AS rn
    FROM tmp_booking_norm s
    JOIN USERS u
      ON u.user_id = s.target_user_id
    LEFT JOIN tmp_booking_map m
      ON m.source_booking_id = s.source_booking_id
    WHERE m.source_booking_id IS NULL
  ),
  ins AS (
    INSERT INTO BOOKINGS
    (
      booking_id, booking_date, ticket_count, status,
      contact_name, contact_email, created_at, contact_phone,
      user_id, total_price
    )
    SELECT
      v_booking_max_id + rn,
      booking_date,
      1,
      status,
      COALESCE(contact_name, 'Imported User'),
      COALESCE(contact_email, 'imported@example.com'),
      created_at,
      NULL,
      target_user_id,
      total_price
    FROM new_bookings
    RETURNING booking_id
  )
  INSERT INTO tmp_booking_map(source_booking_id, target_booking_id)
  SELECT n.source_booking_id, i.booking_id
  FROM new_bookings n
  JOIN ins i
    ON i.booking_id = v_booking_max_id + n.rn
  ON CONFLICT (source_booking_id) DO NOTHING;

  SELECT pg_get_serial_sequence('public.bookings', 'booking_id') INTO v_seq_name;
  IF v_seq_name IS NOT NULL THEN
    EXECUTE format('SELECT setval(%L, COALESCE((SELECT MAX(booking_id) FROM BOOKINGS), 0), true)', v_seq_name);
  END IF;

  RAISE NOTICE 'BOOKINGS merged from BOOKING successfully.';
END $$;

-- ---------------------------------------------------------------------------
-- שלב 5: מיזוג REVIEWS מ-REVIEW
-- ---------------------------------------------------------------------------
DO $$
DECLARE
  v_review_max_id INT;
  v_seq_name TEXT;
BEGIN
  IF to_regclass('public.review') IS NULL THEN
    RAISE NOTICE 'REVIEW לא קיימת - דילוג על מיזוג REVIEWS.';
    RETURN;
  END IF;

  DROP TABLE IF EXISTS tmp_review_norm;
  CREATE TEMP TABLE tmp_review_norm AS
  SELECT
    r.review_id AS source_review_id,
    COALESCE(um.target_user_id, r.customer_id) AS target_user_id,
    COALESCE(am.target_attraction_id, r.attraction_id) AS target_attraction_id,
    COALESCE(r.comment, '') AS comment,
    COALESCE(r.created_at, NOW()) AS created_at,
    CASE
      WHEN r.rating < 1 THEN 1
      WHEN r.rating > 5 THEN 5
      ELSE r.rating
    END AS rating
  FROM REVIEW r
  LEFT JOIN tmp_user_map um
    ON um.source_customer_id = r.customer_id
  LEFT JOIN tmp_attraction_map am
    ON am.source_attraction_id = r.attraction_id;

  SELECT COALESCE(MAX(review_id), 0) INTO v_review_max_id FROM REVIEWS;

  WITH candidate AS (
    SELECT
      s.*,
      ROW_NUMBER() OVER (ORDER BY s.source_review_id) AS rn
    FROM tmp_review_norm s
    JOIN USERS u
      ON u.user_id = s.target_user_id
    JOIN ATTRACTIONS a
      ON a.attraction_id = s.target_attraction_id
    LEFT JOIN REVIEWS t
      ON t.user_id = s.target_user_id
     AND t.attraction_id = s.target_attraction_id
     AND t.rating = s.rating
     AND COALESCE(t.comment, '') = s.comment
     AND t.created_at::date = s.created_at::date
    WHERE t.review_id IS NULL
  )
  INSERT INTO REVIEWS(review_id, comment, created_at, rating, user_id, attraction_id)
  SELECT
    v_review_max_id + rn,
    comment,
    created_at,
    rating,
    target_user_id,
    target_attraction_id
  FROM candidate;

  SELECT pg_get_serial_sequence('public.reviews', 'review_id') INTO v_seq_name;
  IF v_seq_name IS NOT NULL THEN
    EXECUTE format('SELECT setval(%L, COALESCE((SELECT MAX(review_id) FROM REVIEWS), 0), true)', v_seq_name);
  END IF;

  RAISE NOTICE 'REVIEWS merged from REVIEW successfully.';
END $$;

-- ---------------------------------------------------------------------------
-- שלב 6: מיזוג BOOKING_DETAILS מ-BOOKINGTICKET
-- תמיכה בשני מבנים אפשריים:
--   א) bookingticket(booking_id, attraction_id, ticket_count)
--   ב) bookingticket(booking_id, ticket_id, quantity)
-- ---------------------------------------------------------------------------
DO $$
DECLARE
  has_booking_id BOOLEAN;
  has_attraction_id BOOLEAN;
  has_ticket_count BOOLEAN;
  has_ticket_id BOOLEAN;
  has_quantity BOOLEAN;
BEGIN
  IF to_regclass('public.bookingticket') IS NULL THEN
    RAISE NOTICE 'BOOKINGTICKET לא קיימת - דילוג על מיזוג BOOKING_DETAILS.';
    RETURN;
  END IF;

  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'bookingticket' AND column_name = 'booking_id'
  ) INTO has_booking_id;

  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'bookingticket' AND column_name = 'attraction_id'
  ) INTO has_attraction_id;

  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'bookingticket' AND column_name = 'ticket_count'
  ) INTO has_ticket_count;

  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'bookingticket' AND column_name = 'ticket_id'
  ) INTO has_ticket_id;

  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'bookingticket' AND column_name = 'quantity'
  ) INTO has_quantity;

  IF has_booking_id AND has_attraction_id THEN
    INSERT INTO BOOKING_DETAILS (booking_id, attraction_id, ticket_count)
    SELECT
      COALESCE(bm.target_booking_id, bt.booking_id) AS booking_id,
      COALESCE(am.target_attraction_id, bt.attraction_id) AS attraction_id,
      CASE
        WHEN has_ticket_count THEN COALESCE(bt.ticket_count, 1)
        ELSE 1
      END AS ticket_count
    FROM BOOKINGTICKET bt
    LEFT JOIN tmp_booking_map bm
      ON bm.source_booking_id = bt.booking_id
    LEFT JOIN tmp_attraction_map am
      ON am.source_attraction_id = bt.attraction_id
    JOIN BOOKINGS b
      ON b.booking_id = COALESCE(bm.target_booking_id, bt.booking_id)
    JOIN ATTRACTIONS a
      ON a.attraction_id = COALESCE(am.target_attraction_id, bt.attraction_id)
    ON CONFLICT (booking_id, attraction_id) DO UPDATE
      SET ticket_count = GREATEST(BOOKING_DETAILS.ticket_count, EXCLUDED.ticket_count);

    RAISE NOTICE 'BOOKING_DETAILS merged using booking_id + attraction_id model.';

  ELSIF has_booking_id AND has_ticket_id THEN
    INSERT INTO BOOKING_DETAILS (booking_id, attraction_id, ticket_count)
    SELECT
      COALESCE(bm.target_booking_id, bt.booking_id) AS booking_id,
      COALESCE(am.target_attraction_id, t.attraction_id) AS attraction_id,
      CASE
        WHEN has_quantity THEN COALESCE(bt.quantity, 1)
        ELSE 1
      END AS ticket_count
    FROM BOOKINGTICKET bt
    JOIN TICKET t
      ON t.ticket_id = bt.ticket_id
    LEFT JOIN tmp_booking_map bm
      ON bm.source_booking_id = bt.booking_id
    LEFT JOIN tmp_attraction_map am
      ON am.source_attraction_id = t.attraction_id
    JOIN BOOKINGS b
      ON b.booking_id = COALESCE(bm.target_booking_id, bt.booking_id)
    JOIN ATTRACTIONS a
      ON a.attraction_id = COALESCE(am.target_attraction_id, t.attraction_id)
    ON CONFLICT (booking_id, attraction_id) DO UPDATE
      SET ticket_count = GREATEST(BOOKING_DETAILS.ticket_count, EXCLUDED.ticket_count);

    RAISE NOTICE 'BOOKING_DETAILS merged using booking_id + ticket_id model.';
  ELSE
    RAISE NOTICE 'BOOKINGTICKET קיים אך ללא עמודות צפויות - אין מיזוג BOOKING_DETAILS.';
  END IF;
END $$;

-- ---------------------------------------------------------------------------
-- שלב 7: דוחות בקרה אחרי מיזוג
-- ---------------------------------------------------------------------------
-- בדיקת כפילויות אימייל ב-USERS
-- צריך להחזיר 0 שורות
SELECT lower(trim(email)) AS email_key, COUNT(*)
FROM USERS
GROUP BY lower(trim(email))
HAVING COUNT(*) > 1;

-- ספירות בסיסיות אחרי מיזוג
SELECT 'USERS' AS table_name, COUNT(*) AS row_count FROM USERS
UNION ALL
SELECT 'ATTRACTIONS', COUNT(*) FROM ATTRACTIONS
UNION ALL
SELECT 'BOOKINGS', COUNT(*) FROM BOOKINGS
UNION ALL
SELECT 'REVIEWS', COUNT(*) FROM REVIEWS
UNION ALL
SELECT 'BOOKING_DETAILS', COUNT(*) FROM BOOKING_DETAILS;

COMMIT;
