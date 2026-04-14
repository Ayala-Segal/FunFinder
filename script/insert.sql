-- =========================
-- INSERT DATA (HIGH IDs)
-- =========================

-- USERS
INSERT INTO USERS (user_id, name, email, avatar_url, created_at, password_hash) VALUES
(10001, 'User A', 'usera@example.com', 'avatar1.png', NOW(), 'hash1'),
(10002, 'User B', 'userb@example.com', 'avatar2.png', NOW(), 'hash2'),
(10003, 'User C', 'userc@example.com', 'avatar3.png', NOW(), 'hash3'),
(10004, 'User D', 'userd@example.com', 'avatar4.png', NOW(), 'hash4'),
(10005, 'User E', 'usere@example.com', 'avatar5.png', NOW(), 'hash5');

-- CATEGORIES
INSERT INTO CATEGORIES (category_id, name, icon_identifier) VALUES
(10001, 'Extreme', 'fire'),
(10002, 'Relax', 'leaf'),
(10003, 'Water Fun', 'wave'),
(10004, 'Night Life', 'moon'),
(10005, 'Kids', 'toy');

-- ATTRACTIONS
INSERT INTO ATTRACTIONS 
(attraction_id, name, short_description, full_description, location, price, difficulty_level, duration, target_audience, avg_rating, review_count, main_image_url, category_id) 
VALUES
(10001, 'Desert Jeep Tour', 'Off-road adventure', 'Exciting jeep ride in the desert', 'Negev', 200.00, 4.0, 180, 'Adults', 4.8, 120, 'jeep.jpg', 10001),
(10002, 'Spa Day', 'Relaxing spa', 'Full spa treatment and massage', 'Dead Sea', 150.00, 1.0, 240, 'Adults', 4.9, 200, 'spa.jpg', 10002),
(10003, 'Water Park', 'Slides and pools', 'Huge water park with slides', 'Eilat', 120.00, 2.0, 300, 'Family', 4.6, 180, 'waterpark.jpg', 10003),
(10004, 'Night Club', 'Party all night', 'Music, drinks and dance', 'Tel Aviv', 90.00, 2.5, 360, 'Adults', 4.3, 90, 'club.jpg', 10004),
(10005, 'Kids Play Zone', 'Fun for kids', 'Indoor playground', 'Jerusalem', 60.00, 1.0, 120, 'Kids', 4.7, 75, 'kids.jpg', 10005);

-- BOOKINGS
INSERT INTO BOOKINGS 
(booking_id, booking_date, ticket_count, status, contact_name, contact_email, created_at, contact_phone, user_id)
VALUES
(10001, '2026-05-01', 2, 'CONFIRMED', 'User A', 'usera@example.com', NOW(), '0509000001', 10001),
(10002, '2026-05-02', 3, 'PENDING', 'User B', 'userb@example.com', NOW(), '0509000002', 10002),
(10003, '2026-05-03', 1, 'CONFIRMED', 'User C', 'userc@example.com', NOW(), '0509000003', 10003),
(10004, '2026-05-04', 5, 'CANCELLED', 'User D', 'userd@example.com', NOW(), '0509000004', 10004),
(10005, '2026-05-05', 4, 'CONFIRMED', 'User E', 'usere@example.com', NOW(), '0509000005', 10005);

-- GALLERY_IMAGES
INSERT INTO GALLERY_IMAGES (image_id, image_url, attraction_id) VALUES
(10001, 'g1.jpg', 10001),
(10002, 'g2.jpg', 10002),
(10003, 'g3.jpg', 10003),
(10004, 'g4.jpg', 10004),
(10005, 'g5.jpg', 10005);

-- REVIEWS
INSERT INTO REVIEWS (review_id, comment, created_at, rating, user_id, attraction_id) VALUES
(10001, 'Amazing!', NOW(), 5, 10001, 10001),
(10002, 'Very relaxing', NOW(), 5, 10002, 10002),
(10003, 'Super fun', NOW(), 4, 10003, 10003),
(10004, 'Good vibe', NOW(), 4, 10004, 10004),
(10005, 'Kids loved it', NOW(), 5, 10005, 10005);

-- BOOKING_DETAILS
INSERT INTO BOOKING_DETAILS (booking_id, attraction_id, ticket_count) VALUES
(10001, 10001, 2),
(10002, 10002, 3),
(10003, 10003, 1),
(10004, 10004, 5),
(10005, 10005, 4);