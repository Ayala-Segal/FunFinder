# FunFinder
# 🎯 FunFinder – Attractions Management System

## Table of Contents

* [Phase 1: Design and Build the Database](#phase-1-design-and-build-the-database)

  * [Introduction](#introduction)
  * [ERD (Entity-Relationship Diagram)](#erd-entity-relationship-diagram)
  * [DSD (Data Structure Diagram)](#dsd-data-structure-diagram)
  * [SQL Scripts](#sql-scripts)
  * [Data](#data)
  * [Backup](#backup)
---

## Phase 1: Design and Build the Database

### Introduction

The **FunFinder system** is designed to manage attractions, bookings, and user interactions in a structured and efficient way.
It provides a complete database solution for handling attractions, reservations, reviews, and related content.

#### Purpose of the Database

* Managing attractions with categories, pricing, and descriptions
* Handling bookings and ticket management
* Tracking users and their activity
* Managing reviews and ratings
* Storing images for each attraction

#### Potential Use Cases

* Users can browse attractions and book tickets
* Administrators manage attractions and categories
* The system analyzes popularity and ratings
* Businesses can present and manage their attractions

---
## 🚀 AI Studio Preview

📌 View the system prototype and AI design:
[Open AI Studio Project](https://ai.studio/apps/5c3de8b2-1857-4c0e-964f-efd5e41495a2)

---
## 🖼️ System Overview (Application View)

This section presents the main screens of the system and demonstrates how users interact with the application in practice.

### 🏠 Home Page
The main landing page that provides general navigation and overview of attractions.
![Home 1](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/home1.png)
![Home 2](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/home2.png)
![Home 3](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/home3.png)

---

### 🎟️ Attractions Page
Displays all available attractions with details and filtering options.
![Attractions](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/attractions.png)

---

### 🔐 Login Page
User authentication screen for system access.
![Login](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/connection.png)

---

### 🛒 Orders Page
Shows user bookings and order history.
![Orders](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/order.png)

---

### ERD (Entity-Relationship Diagram)

![ERD Diagram](https://github.com/Ayala-Segal/FunFinder/blob/main/ERDAndDSTFiles/ERD.png)

---

### DSD (Data Structure Diagram)

![DSD Diagram](https://github.com/Ayala-Segal/FunFinder/blob/main/ERDAndDSTFiles/DSD.png)

---

### SQL Scripts

* 📜 [Create Tables](https://github.com/Ayala-Segal/FunFinder/blob/main/script/create_tables.sql)
* 📜 [Insert Data](https://github.com/Ayala-Segal/FunFinder/blob/main/script/insert.sql)
* 📜 [Drop Tables](https://github.com/Ayala-Segal/FunFinder/blob/main/script/drop_tables.sql)
* 📜 [Select All Data](https://github.com/Ayala-Segal/FunFinder/blob/main/script/select_all.sql)

---

### Data

#### 🔹 CSV Files (Data Import)

📂 DataImportFiles

* 📄 [users.csv](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/7474998f733d2f590955d2af5f58084a3a5854f1/DataImportFiles/users.csv)
* 📄 [bookings.csv](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/7474998f733d2f590955d2af5f58084a3a5854f1/DataImportFiles/bookings.csv)
* 📄 [attractions.csv](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/7474998f733d2f590955d2af5f58084a3a5854f1/DataImportFiles/attractions.csv)
* 📄 [categories.csv](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/7474998f733d2f590955d2af5f58084a3a5854f1/DataImportFiles/categories.csv)
* 📄 [reviews.csv](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/7474998f733d2f590955d2af5f58084a3a5854f1/DataImportFiles/reviews.csv)
* 📄 [gallery_images.csv](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/7474998f733d2f590955d2af5f58084a3a5854f1/DataImportFiles/gallery_images.csv)
* 📄 [booking_details.csv](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/7474998f733d2f590955d2af5f58084a3a5854f1/DataImportFiles/booking_details.csv)

---

#### 🔹 Mockaroo (SQL Data)

📂 MockarooFiles

* 📄 [users.sql](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/main/MockarooFiles/users.sql)
* 📄 [bookings.sql](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/main/MockarooFiles/bookings.sql)
* 📄 [attractions.sql](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/main/MockarooFiles/attractions.sql)
* 📄 [categories.sql](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/main/MockarooFiles/categories.sql)
* 📄 [reviews.sql](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/main/MockarooFiles/reviews.sql)
* 📄 [gallery_images.sql](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/main/MockarooFiles/gallery_images.sql)
* 📄 [booking_details.sql](https://raw.githubusercontent.com/Ayala-Segal/FunFinder/main/MockarooFiles/booking_details.sql)

---

#### 🔹 Python Data Generator

📜[generate_data.py](https://github.com/Ayala-Segal/FunFinder/blob/main/Programming/generate_data.py)

Used for generating large-scale and dynamic datasets.

---

### Backup

-   backups files are kept with the date and hour of the backup:  
📂 [View Backups Folder](https://github.com/Ayala-Segal/FunFinder/tree/main/backup)
---

📄 Stage B
📊 Stage B – SQL Queries, Constraints & Database Operations

📊 SELECT Queries (4 paired queries + comparison)
🔹 Query 1 – Adventure attractions not booked by the user
📝 Description:
Retrieves attractions from the Adventure category that the user has not booked yet.

🧾 Form A – JOIN version
-- Query 1 (JOIN version):
-- Purpose: Get Adventure attractions that the user has NOT booked yet

SELECT DISTINCT
    a.name,
    a.location,
    a.price
FROM ATTRACTIONS a
JOIN CATEGORIES c
    ON a.category_id = c.category_id

LEFT JOIN BOOKING_DETAILS bd
    ON a.attraction_id = bd.attraction_id

LEFT JOIN BOOKINGS b
    ON bd.booking_id = b.booking_id
   AND b.user_id = 1

WHERE c.name = 'Adventure'
  AND b.booking_id IS NULL;

📸 Screenshot Query:
![Query 1A](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Query1A_SELECT.png)

🧾 Form B – NOT EXISTS version:
-- Query 1 (Form B - NOT EXISTS version)
-- Purpose: Get Adventure attractions that the user has NOT booked yet

SELECT
    a.name,
    a.location,
    a.price
FROM ATTRACTIONS a
WHERE a.category_id = (
    SELECT category_id
    FROM CATEGORIES
    WHERE name = 'Adventure'
)
AND NOT EXISTS (
    SELECT 1
    FROM BOOKING_DETAILS bd
    JOIN BOOKINGS b
        ON bd.booking_id = b.booking_id
    WHERE bd.attraction_id = a.attraction_id
      AND b.user_id = 1
);

📸 Screenshot Query: 
![Query 1B](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Query1B_SELECT.png)


⚖️ Difference Between Approaches:
JOIN relies on NULL filtering after table joins
NOT EXISTS directly checks absence of records
⚡ Efficiency:

✔ NOT EXISTS is generally more efficient
✔ Better optimized for “non-existence” conditions
✔ Avoids duplicate rows caused by joins

🔹 Query 2 – Past bookings without reviews
📝 Description:

Finds attractions the user visited in the past but has not reviewed yet.

📸 Query A (NOT EXISTS): 
-- Purpose: Find past booked attractions that the user has NOT reviewed yet

-- Form A: NOT EXISTS version
SELECT
a.name,
a.location,
b.booking_date
FROM BOOKINGS b
JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id
JOIN ATTRACTIONS a ON bd.attraction_id = a.attraction_id
WHERE b.user_id = 1
AND b.booking_date < CURRENT_DATE -- Only past bookings
AND NOT EXISTS (
SELECT 1
FROM REVIEWS r
WHERE r.attraction_id = a.attraction_id
AND r.user_id = 1
);

![Query 2A](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Query2A_SELECT.png)


📸 Query B (LEFT JOIN): 
-- Form B: LEFT JOIN version (anti-join pattern)
SELECT DISTINCT
    a.name,
    a.location,
    b.booking_date
FROM BOOKINGS b
JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id
JOIN ATTRACTIONS a ON bd.attraction_id = a.attraction_id
LEFT JOIN REVIEWS r
    ON r.attraction_id = a.attraction_id
   AND r.user_id = 1
WHERE b.user_id = 1
  AND b.booking_date < CURRENT_DATE
  AND r.review_id IS NULL;  -- No review exists
![Query 2B](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Query2B_SELECT.png)


⚡ Explanation:
NOT EXISTS is more accurate for exclusion logic
LEFT JOIN requires careful handling to avoid duplicates
🔹 Query 3 – Family attractions with Easy difficulty:
-- Purpose: Get family attractions with easy difficulty level

📸 Query A (JOIN): 
-- Form A: JOIN version
SELECT
a.name,
a.price,
a.avg_rating
FROM ATTRACTIONS a
JOIN CATEGORIES c ON a.category_id = c.category_id
JOIN DIFFICULTY_LEVELS d ON a.difficulty_id = d.difficulty_id
WHERE c.name = 'Family'
AND d.name = 'Easy';
![Query 3A](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Query3A_SELECT.png)

📸 Query B (Subquery): 
-- Form B: Subquery version (no joins)
SELECT
a.name,
a.price,
a.avg_rating
FROM ATTRACTIONS a
WHERE a.category_id = (
SELECT category_id FROM CATEGORIES WHERE name = 'Family'
)
AND a.difficulty_id = (
SELECT difficulty_id FROM DIFFICULTY_LEVELS WHERE name = 'Easy'
);
![Query 3B](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Query3B_SELECT.png)

⚡ Explanation:
JOIN is more readable and scalable
Subqueries are simpler but less optimized
🔹 Query 4 – Most popular attraction in a category
-- Purpose: Find most booked attraction in a category

📸 Query A (LIMIT version): 
-- Form A: LIMIT version (recommended, efficient)
SELECT
    a.name,
    COUNT(*) AS booking_count
FROM ATTRACTIONS a
JOIN BOOKING_DETAILS bd ON a.attraction_id = bd.attraction_id
WHERE a.category_id = 5
GROUP BY a.attraction_id, a.name
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM BOOKING_DETAILS bd2
        JOIN ATTRACTIONS a2 ON bd2.attraction_id = a2.attraction_id
        WHERE a2.category_id = 5
        GROUP BY bd2.attraction_id
    ) sub
);
![Query 4A](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Query4A_SELECT.png)

📸 Query B (ALL version):
-- Form B:
SELECT
    a.name,
    COUNT(*) AS booking_count
FROM ATTRACTIONS a
JOIN BOOKING_DETAILS bd ON a.attraction_id = bd.attraction_id
WHERE a.category_id = 5
GROUP BY a.attraction_id, a.name
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM BOOKING_DETAILS bd2
    JOIN ATTRACTIONS a2 ON bd2.attraction_id = a2.attraction_id
    WHERE a2.category_id = 5
    GROUP BY bd2.attraction_id
);
![Query 4B](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Query4B_SELECT.png)


⚡ Explanation:
LIMIT + ORDER BY is the most efficient approach
ALL comparison is less efficient due to full group comparison
📊 Additional SELECT Queries (4 queries)
🔹 Query 5 – Yearly spending per user:
--Query 5
-- Purpose: Show yearly spending summary per user (profile analytics)

SELECT
    EXTRACT(YEAR FROM b.booking_date) AS booking_year,  -- Extract year from date
    COUNT(b.booking_id) AS total_trips,                 -- Number of bookings
    SUM(bd.ticket_count * a.price) AS total_spent       -- Total money spent
FROM BOOKINGS b
JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id
JOIN ATTRACTIONS a ON bd.attraction_id = a.attraction_id
WHERE b.user_id = $1
GROUP BY EXTRACT(YEAR FROM b.booking_date)
ORDER BY booking_year DESC;

📸 Query: ![Query 5](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/SEL5.png)

🔹 Query 6 – Most popular categories:
-- Purpose: Show most popular categories based on bookings

SELECT
    c.name AS category_name,
    COUNT(b.booking_id) AS popularity
FROM CATEGORIES c
JOIN ATTRACTIONS a ON c.category_id = a.category_id
JOIN BOOKING_DETAILS bd ON a.attraction_id = bd.attraction_id
JOIN BOOKINGS b ON bd.booking_id = b.booking_id
GROUP BY c.name
ORDER BY popularity DESC;


📸 Query: ![Query 6](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/SEL6.png)

🔹 Query 7 – Full attraction details with images:
-- Purpose: Show full attraction details with images (UI detail page)

SELECT
    a.name,
    a.full_description,
    g.image_url
FROM ATTRACTIONS a
LEFT JOIN GALLERY_IMAGES g ON a.attraction_id = g.attraction_id  -- Allow missing images
WHERE a.attraction_id = 10;


📸 Query: ![Query 7](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/SEL7.png)


🔹 Query 8 – Attractions not visited in last 6 months:
-- Purpose: Show attractions the user has NOT visited in the last 6 months

SELECT
    a.attraction_id,
    a.name,
    a.location,
    a.price,
    a.avg_rating,
    c.name AS category_name,
    d.name AS difficulty_level
FROM ATTRACTIONS a
JOIN CATEGORIES c ON a.category_id = c.category_id
JOIN DIFFICULTY_LEVELS d ON a.difficulty_id = d.difficulty_id
WHERE NOT EXISTS (
    SELECT 1
    FROM BOOKINGS b
    JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id
    WHERE b.user_id = $1
      AND bd.attraction_id = a.attraction_id
      AND b.booking_date >= CURRENT_DATE - INTERVAL '6 months'
)
ORDER BY a.avg_rating DESC, a.price ASC;

📸 Query: ![Query 8](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/SEL8.png)


🔹 Query 9 – Attractions not visited in last 6 months
-- Purpose: Return the 4 most booked attractions in the last 2 months

SELECT
    a.attraction_id,
    a.name,
    a.location,
    a.price,
    COUNT(bd.attraction_id) AS total_bookings
FROM ATTRACTIONS a
JOIN BOOKING_DETAILS bd ON a.attraction_id = bd.attraction_id
JOIN BOOKINGS b ON bd.booking_id = b.booking_id
WHERE b.booking_date >= CURRENT_DATE - INTERVAL '2 months'  -- last 2 months only
GROUP BY
    a.attraction_id,
    a.name,
    a.location,
    a.price
ORDER BY total_bookings DESC
LIMIT 4;
📸 Query: ![Query 9](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/SEL9.png)


🗑 DELETE Queries
🔹 Delete old reviews (5+ years):
--Query 1
-- Purpose: Remove old reviews (5+ years) while considering review metadata

DELETE FROM REVIEWS r
WHERE r.review_id IN (
    SELECT r2.review_id
    FROM REVIEWS r2
    WHERE EXTRACT(YEAR FROM r2.created_at) <= EXTRACT(YEAR FROM CURRENT_DATE) - 3
    AND r2.user_id = $1
);

📸 Before: ![Query DELETE1](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/DEL1.png)

🔹 Delete inactive attractions (no bookings in last year):
--Query 2
-- Purpose: Delete attractions that had NO bookings in the last year (data cleanup / inactive attractions)

DELETE FROM ATTRACTIONS a
WHERE NOT EXISTS (
    SELECT 1
    FROM BOOKING_DETAILS bd
    JOIN BOOKINGS b ON bd.booking_id = b.booking_id
    WHERE bd.attraction_id = a.attraction_id
      AND b.booking_date >= CURRENT_DATE - INTERVAL '1 year'
);

📸 Before: ![Query DELETE2](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/DEL2.png)


🔹 Delete orphan gallery images:
--Query 3
-- Purpose: Clean up gallery images that no longer belong to existing attractions

DELETE FROM GALLERY_IMAGES g
WHERE NOT EXISTS (
    SELECT 1
    FROM ATTRACTIONS a
    WHERE a.attraction_id = g.attraction_id
);

📸 Before: ![Query DELETE3](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/DEL3.png)

🔄 UPDATE Queries
🔹 Update average rating of attractions:--Query 1
-- Purpose: Recalculate and update attraction average rating based on user reviews

UPDATE ATTRACTIONS a
SET avg_rating = sub.avg_rating
FROM (
    SELECT
        r.attraction_id,
        ROUND(AVG(r.rating)::numeric, 2) AS avg_rating  -- rounded to 2 decimal places
    FROM REVIEWS r
    WHERE r.attraction_id = $1
    GROUP BY r.attraction_id
) sub
WHERE a.attraction_id = sub.attraction_id;

📸 Before: ![Query UPDATE1A](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/upd1.png)


🔹 Update booking date (72-hour rule):
--Query 2
-- Purpose: Allow updating a booking date only if it is still at least 72 hours before the scheduled date

UPDATE BOOKINGS b
SET booking_date = $1  -- new desired date
WHERE b.booking_id = $2
  AND b.user_id = $3
  AND b.booking_date > CURRENT_DATE + INTERVAL '3 days';

📸 Before: ![Query UPDATE2A](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/upd2.png)


🔹 Mark active users based on activity:
--Query 3
-- Purpose: Mark active users based on booking activity in the last year

UPDATE USERS u
SET avatar_url = 'ACTIVE_CUSTOMER_BADGE'--???
WHERE u.user_id IN (
    SELECT b.user_id
    FROM BOOKINGS b
    WHERE b.booking_date >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY b.user_id
    HAVING COUNT(b.booking_id) > 5
);


📸 Before: ![Query UPDATE3A](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/upd3.png)


⚠️ Constraints (ALTER TABLE)
🧾 Description:

Each constraint was added using ALTER TABLE to enforce data integrity rules (e.g., FOREIGN KEY, CHECK, UNIQUE).

🧾1

📸 Invalid insert attempt: ![ALTER1](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/ALTER1.png)

🧾2

📸 Invalid insert attempt: ![ALTER2](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/ALTER2.png)

🧾3

📸 Invalid insert attempt: ![ALTER3](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/ALTER3.png)


🔄 TRANSACTIONS – COMMIT & ROLLBACK
Step 1:

Initial state
📸 DB state
![Rollback1](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Rollback1.png)

Step 2:

Rollback operation
📸 DB state
![Rollback2](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Rollback2.png)
![Rollback3](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Rollback3.png)

Step 3:

Commit operation
📸 Final DB state
![Rollback4](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Rollback4.png)
![Rollback5](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Rollback5.png)

⚡ INDEXES
Before index:
Execution time: 
📸 Screenshot
![INDEXES Before](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Before1.png)

After index:
Execution time:
📸 Screenshot
![INDEXES After](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/After1.png)

📌 Explanation:

Indexes improved performance by reducing search time and optimizing filtering on frequently queried columns.

Before index:
Execution time: 
📸 Screenshot
![INDEXES Before2](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Before2.png)

After index:
Execution time:
📸 Screenshot
![INDEXES After2](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/After2.png)

📌 Explanation:

Indexes did not improve Execution time because it is a small table.


Before index:
Execution time: 
📸 Screenshot
![INDEXES Before3](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/Before3.png)

After index:
Execution time:
📸 Screenshot
![INDEXES After3](https://github.com/Ayala-Segal/FunFinder/blob/main/images%20view/After3.png)

📌 Explanation:

Indexes did not improve Execution time because it is a small table.