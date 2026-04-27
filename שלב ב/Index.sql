-- =========================
-- INDEX 1: BOOKINGS by user
-- =========================
CREATE INDEX idx_bookings_user_id
ON BOOKINGS(user_id);

EXPLAIN ANALYZE
SELECT booking_id, booking_date, user_id
FROM BOOKINGS
WHERE user_id = 1;


-- =========================
-- INDEX 2: BOOKINGS by date range
-- =========================
CREATE INDEX idx_bookings_date
ON BOOKINGS(booking_date);

EXPLAIN ANALYZE
SELECT booking_id, booking_date
FROM BOOKINGS
WHERE booking_date >= CURRENT_DATE - INTERVAL '6 months';


-- =========================
-- INDEX 3: BOOKING_DETAILS attraction lookup
-- =========================
CREATE INDEX idx_booking_details_attraction
ON BOOKING_DETAILS(attraction_id);

EXPLAIN ANALYZE
SELECT *
FROM BOOKING_DETAILS
WHERE attraction_id = 5;