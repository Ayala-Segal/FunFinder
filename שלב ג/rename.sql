--- ========================================================
--- 1. טבלת CATEGORIES
--- ========================================================
ALTER TABLE CATEGORIES RENAME COLUMN category_id TO category_id1;
ALTER TABLE CATEGORIES RENAME COLUMN name TO name1;
ALTER TABLE CATEGORIES RENAME COLUMN icon_identifier TO icon_identifier1;

--- ========================================================
--- 2. טבלת DIFFICULTY_LEVELS
--- ========================================================
ALTER TABLE DIFFICULTY_LEVELS RENAME COLUMN difficulty_id TO difficulty_id1;
ALTER TABLE DIFFICULTY_LEVELS RENAME COLUMN name TO name1;

--- ========================================================
--- 3. טבלת ATTRACTIONS
--- ========================================================
ALTER TABLE ATTRACTIONS RENAME COLUMN attraction_id TO attraction_id1;
ALTER TABLE ATTRACTIONS RENAME COLUMN name TO name1;
ALTER TABLE ATTRACTIONS RENAME COLUMN short_description TO short_description1;
ALTER TABLE ATTRACTIONS RENAME COLUMN full_description TO full_description1;
ALTER TABLE ATTRACTIONS RENAME COLUMN location TO location1;
ALTER TABLE ATTRACTIONS RENAME COLUMN price TO price1;
ALTER TABLE ATTRACTIONS RENAME COLUMN difficulty_id TO difficulty_id1;
ALTER TABLE ATTRACTIONS RENAME COLUMN duration TO duration1;
ALTER TABLE ATTRACTIONS RENAME COLUMN target_audience TO target_audience1;
ALTER TABLE ATTRACTIONS RENAME COLUMN avg_rating TO avg_rating1;
ALTER TABLE ATTRACTIONS RENAME COLUMN review_count TO review_count1;
ALTER TABLE ATTRACTIONS RENAME COLUMN main_image_url TO main_image_url1;
ALTER TABLE ATTRACTIONS RENAME COLUMN category_id TO category_id1;

--- ========================================================
--- 4. טבלת GALLERY_IMAGES
--- ========================================================
ALTER TABLE GALLERY_IMAGES RENAME COLUMN image_id TO image_id1;
ALTER TABLE GALLERY_IMAGES RENAME COLUMN image_url TO image_url1;
ALTER TABLE GALLERY_IMAGES RENAME COLUMN attraction_id TO attraction_id1;

--- ========================================================
--- 5. טבלת USERS
--- ========================================================
ALTER TABLE USERS RENAME COLUMN user_id TO user_id1;
ALTER TABLE USERS RENAME COLUMN name TO name1;
ALTER TABLE USERS RENAME COLUMN email TO email1;
ALTER TABLE USERS RENAME COLUMN avatar_url TO avatar_url1;
ALTER TABLE USERS RENAME COLUMN created_at TO created_at1;
ALTER TABLE USERS RENAME COLUMN password_hash TO password_hash1;

--- ========================================================
--- 6. טבלת BOOKINGS
--- ========================================================
ALTER TABLE BOOKINGS RENAME COLUMN booking_id TO booking_id1;
ALTER TABLE BOOKINGS RENAME COLUMN booking_date TO booking_date1;
ALTER TABLE BOOKINGS RENAME COLUMN ticket_count TO ticket_count1;
ALTER TABLE BOOKINGS RENAME COLUMN status TO status1;
ALTER TABLE BOOKINGS RENAME COLUMN contact_name TO contact_name1;
ALTER TABLE BOOKINGS RENAME COLUMN contact_email TO contact_email1;
ALTER TABLE BOOKINGS RENAME COLUMN created_at TO created_at1;
ALTER TABLE BOOKINGS RENAME COLUMN contact_phone TO contact_phone1;
ALTER TABLE BOOKINGS RENAME COLUMN user_id TO user_id1;

--- ========================================================
--- 7. טבלת REVIEWS
--- ========================================================
ALTER TABLE REVIEWS RENAME COLUMN review_id TO review_id1;
ALTER TABLE REVIEWS RENAME COLUMN comment TO comment1;
ALTER TABLE REVIEWS RENAME COLUMN created_at TO created_at1;
ALTER TABLE REVIEWS RENAME COLUMN rating TO rating1;
ALTER TABLE REVIEWS RENAME COLUMN user_id TO user_id1;
ALTER TABLE REVIEWS RENAME COLUMN attraction_id TO attraction_id1;

--- ========================================================
--- 8. טבלת BOOKING_DETAILS (טבלת הקישור מה-ERD)
--- ========================================================
ALTER TABLE BOOKING_DETAILS RENAME COLUMN booking_id TO booking_id1;
ALTER TABLE BOOKING_DETAILS RENAME COLUMN attraction_id TO attraction_id1;
ALTER TABLE BOOKING_DETAILS RENAME COLUMN ticket_count TO ticket_count1;









-- ===========================================================================
-- להחזיר בחזרה לשמות המקוריים
-- ===========================================================================
BEGIN;

-- ===========================================================================
-- 1. טבלת CATEGORIES
-- ===========================================================================
ALTER TABLE CATEGORIES RENAME COLUMN category_id1 TO category_id;
ALTER TABLE CATEGORIES RENAME COLUMN name1 TO name;
ALTER TABLE CATEGORIES RENAME COLUMN icon_identifier1 TO icon_identifier;

-- ===========================================================================
-- 2. טבלת DIFFICULTY_LEVELS
-- ===========================================================================
ALTER TABLE DIFFICULTY_LEVELS RENAME COLUMN difficulty_id1 TO difficulty_id;
ALTER TABLE DIFFICULTY_LEVELS RENAME COLUMN name1 TO name;

-- ===========================================================================
-- 3. טבלת ATTRACTIONS
-- ===========================================================================
ALTER TABLE ATTRACTIONS RENAME COLUMN attraction_id1 TO attraction_id;
ALTER TABLE ATTRACTIONS RENAME COLUMN name1 TO name;
ALTER TABLE ATTRACTIONS RENAME COLUMN short_description1 TO short_description;
ALTER TABLE ATTRACTIONS RENAME COLUMN full_description1 TO full_description;
ALTER TABLE ATTRACTIONS RENAME COLUMN location1 TO location;
ALTER TABLE ATTRACTIONS RENAME COLUMN price1 TO price;
ALTER TABLE ATTRACTIONS RENAME COLUMN difficulty_id1 TO difficulty_id;
ALTER TABLE ATTRACTIONS RENAME COLUMN duration1 TO duration;
ALTER TABLE ATTRACTIONS RENAME COLUMN target_audience1 TO target_audience;
ALTER TABLE ATTRACTIONS RENAME COLUMN avg_rating1 TO avg_rating;
ALTER TABLE ATTRACTIONS RENAME COLUMN review_count1 TO review_count;
ALTER TABLE ATTRACTIONS RENAME COLUMN main_image_url1 TO main_image_url;
ALTER TABLE ATTRACTIONS RENAME COLUMN category_id1 TO category_id;
-- במידה ונוספה עמודת שעות בשלבים קודמים:
ALTER TABLE ATTRACTIONS RENAME COLUMN opening_hours1 TO opening_hours;

-- ===========================================================================
-- 4. טבלת GALLERY_IMAGES
-- ===========================================================================
ALTER TABLE GALLERY_IMAGES RENAME COLUMN image_id1 TO image_id;
ALTER TABLE GALLERY_IMAGES RENAME COLUMN image_url1 TO image_url;
ALTER TABLE GALLERY_IMAGES RENAME COLUMN attraction_id1 TO attraction_id;

-- ===========================================================================
-- 5. טבלת USERS
-- ===========================================================================
ALTER TABLE USERS RENAME COLUMN user_id1 TO user_id;
ALTER TABLE USERS RENAME COLUMN name1 TO name;
ALTER TABLE USERS RENAME COLUMN email1 TO email;
ALTER TABLE USERS RENAME COLUMN avatar_url1 TO avatar_url;
ALTER TABLE USERS RENAME COLUMN created_at1 TO created_at;
ALTER TABLE USERS RENAME COLUMN password_hash1 TO password_hash;
-- במידה ונוספו שדות אלו בשלבים קודמים:
ALTER TABLE USERS RENAME COLUMN phone1 TO phone;
ALTER TABLE USERS RENAME COLUMN country1 TO country;

-- ===========================================================================
-- 6. טבלת BOOKINGS
-- ===========================================================================
ALTER TABLE BOOKINGS RENAME COLUMN booking_id1 TO booking_id;
ALTER TABLE BOOKINGS RENAME COLUMN booking_date1 TO booking_date;
ALTER TABLE BOOKINGS RENAME COLUMN status1 TO status;
ALTER TABLE BOOKINGS RENAME COLUMN contact_name1 TO contact_name;
ALTER TABLE BOOKINGS RENAME COLUMN contact_email1 TO contact_email;
ALTER TABLE BOOKINGS RENAME COLUMN created_at1 TO created_at;
ALTER TABLE BOOKINGS RENAME COLUMN contact_phone1 TO contact_phone;
ALTER TABLE BOOKINGS RENAME COLUMN user_id1 TO user_id;
-- במידה ונוספו שדות אלו בשלבים קודמים:
ALTER TABLE BOOKINGS RENAME COLUMN total_price1 TO total_price;
ALTER TABLE BOOKINGS RENAME COLUMN payment_id1 TO payment_id;
ALTER TABLE BOOKINGS RENAME COLUMN quantity1 TO quantity;

-- ===========================================================================
-- 7. טבלת REVIEWS
-- ===========================================================================
ALTER TABLE REVIEWS RENAME COLUMN review_id1 TO review_id;
ALTER TABLE REVIEWS RENAME COLUMN comment1 TO comment;
ALTER TABLE REVIEWS RENAME COLUMN created_at1 TO created_at;
ALTER TABLE REVIEWS RENAME COLUMN rating1 TO rating;
ALTER TABLE REVIEWS RENAME COLUMN user_id1 TO user_id;
ALTER TABLE REVIEWS RENAME COLUMN attraction_id1 TO attraction_id;

-- ===========================================================================
-- 8. טבלת BOOKING_DETAILS
-- ===========================================================================
ALTER TABLE BOOKING_DETAILS RENAME COLUMN booking_id1 TO booking_id;
ALTER TABLE BOOKING_DETAILS RENAME COLUMN attraction_id1 TO attraction_id;
-- במידה ונוספה עמודת כמות בשלבים קודמים:
ALTER TABLE BOOKING_DETAILS RENAME COLUMN quantity1 TO quantity;

COMMIT;