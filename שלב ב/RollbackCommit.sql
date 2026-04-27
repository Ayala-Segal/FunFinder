-- =========================
-- ROLLBACK DEMO
-- =========================

-- Temporary update (no status field used globally, only BOOKINGS valid column)
BEGIN;

UPDATE BOOKINGS
SET contact_phone = '8888222222'
WHERE booking_id = 1;

SELECT booking_id, contact_phone
FROM BOOKINGS
WHERE booking_id = 1;

ROLLBACK;

SELECT booking_id, contact_phone
FROM BOOKINGS
WHERE booking_id = 1;


-- =========================
-- COMMIT DEMO
-- =========================
BEGIN;

UPDATE BOOKINGS
SET contact_phone = '050-0000000'
WHERE booking_id = 2;

SELECT booking_id, contact_phone
FROM BOOKINGS
WHERE booking_id = 2;

COMMIT;

-- Verify commit
SELECT booking_id, contact_phone
FROM BOOKINGS
WHERE booking_id = 2;

