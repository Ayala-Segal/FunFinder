
-- =========================
-- CONSTRAINT 1: Rating range
-- =========================
ALTER TABLE REVIEWS
ADD CONSTRAINT chk_rating_range
CHECK (rating BETWEEN 1 AND 5);


-- =========================
-- CONSTRAINT 2: ticket count must be positive
-- =========================
ALTER TABLE BOOKINGS
ADD CONSTRAINT chk_ticket_count_positive
CHECK (ticket_count > 0);


-- =========================
-- CONSTRAINT 3: attraction price must be valid
-- =========================
ALTER TABLE ATTRACTIONS
ADD CONSTRAINT chk_price_positive
CHECK (price >= 0);