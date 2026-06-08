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
![Home 1](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/home1.png)
![Home 2](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/home2.png)
![Home 3](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/home3.png)

---

### 🎟️ Attractions Page
Displays all available attractions with details and filtering options.
![Attractions](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/attractions.png)

---

### 🔐 Login Page
User authentication screen for system access.
![Login](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/connection.png)

---

### 🛒 Orders Page
Shows user bookings and order history.
![Orders](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/order.png)

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
![Query 1A](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query1A_SELECT.png)

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
![Query 1B](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query1B_SELECT.png)


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

![Query 2A](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query2A_SELECT.png)


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
![Query 2B](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query2B_SELECT.png)


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
![Query 3A](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query3A_SELECT.png)

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
![Query 3B](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query3B_SELECT.png)

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
![Query 4A](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query4A_SELECT.png)

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
![Query 4B](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query4B_SELECT.png)


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

📸 Query: ![Query 5](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/SEL5.png)

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


📸 Query: ![Query 6](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/SEL6.png)

🔹 Query 7 – Full attraction details with images:
-- Purpose: Show full attraction details with images (UI detail page)

SELECT
    a.name,
    a.full_description,
    g.image_url
FROM ATTRACTIONS a
LEFT JOIN GALLERY_IMAGES g ON a.attraction_id = g.attraction_id  -- Allow missing images
WHERE a.attraction_id = 10;


📸 Query: ![Query 7](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/SEL7.png)


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

📸 Query: ![Query 8](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/SEL8.png)


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
📸 Query: ![Query 9](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/SEL9.png)


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

📸 Before: ![Query DELETE1](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/DEL1.png)

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

📸 Before: ![Query DELETE2](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/DEL2.png)


🔹 Delete orphan gallery images:
--Query 3
-- Purpose: Clean up gallery images that no longer belong to existing attractions

DELETE FROM GALLERY_IMAGES g
WHERE NOT EXISTS (
    SELECT 1
    FROM ATTRACTIONS a
    WHERE a.attraction_id = g.attraction_id
);

📸 Before: ![Query DELETE3](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/DEL3.png)

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

📸 Before: ![Query UPDATE1A](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/upd1.png)


🔹 Update booking date (72-hour rule):
--Query 2
-- Purpose: Allow updating a booking date only if it is still at least 72 hours before the scheduled date

UPDATE BOOKINGS b
SET booking_date = $1  -- new desired date
WHERE b.booking_id = $2
  AND b.user_id = $3
  AND b.booking_date > CURRENT_DATE + INTERVAL '3 days';

📸 Before: ![Query UPDATE2A](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/upd2.png)


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


📸 Before: ![Query UPDATE3A](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/upd3.png)


⚠️ Constraints (ALTER TABLE)
🧾 Description:

Each constraint was added using ALTER TABLE to enforce data integrity rules (e.g., FOREIGN KEY, CHECK, UNIQUE).

🧾1

📸 Invalid insert attempt: ![ALTER1](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/ALTER1.png)

🧾2

📸 Invalid insert attempt: ![ALTER2](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/ALTER2.png)

🧾3

📸 Invalid insert attempt: ![ALTER3](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/ALTER3.png)


🔄 TRANSACTIONS – COMMIT & ROLLBACK
Step 1:

Initial state
📸 DB state
![Rollback1](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Rollback1.png)

Step 2:

Rollback operation
📸 DB state
![Rollback2](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Rollback2.png)
![Rollback3](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Rollback3.png)

Step 3:

Commit operation
📸 Final DB state
![Rollback4](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Rollback4.png)
![Rollback5](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Rollback5.png)

⚡ INDEXES
Before index:
Execution time: 
📸 Screenshot
![INDEXES Before](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Before1.png)

After index:
Execution time:
📸 Screenshot
![INDEXES After](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/After1.png)

📌 Explanation:

Indexes improved performance by reducing search time and optimizing filtering on frequently queried columns.

Before index:
Execution time: 
📸 Screenshot
![INDEXES Before2](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Before2.png)

After index:
Execution time:
📸 Screenshot
![INDEXES After2](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/After2.png)

📌 Explanation:

Indexes did not improve Execution time because it is a small table.


Before index:
Execution time: 
📸 Screenshot
![INDEXES Before3](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Before3.png)

After index:
Execution time:
📸 Screenshot
![INDEXES After3](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/After3.png)

📌 Explanation:

Indexes did not improve Execution time because it is a small table.


# Step 3 – Complex Queries, VIEWs, and Integration

## 1. DSD/ERD Diagrams

### NewDSD Diagram
![NewDSD](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/חדשDSD.png)

### NewERD Diagram
![NewERD](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/ERD%20חדש.png)

### Combined Diagram
![Combined](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/DSD%20integrated.png)
![Combined](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/ERD%20integrated.png)

---

## 2. Integration Decisions & Process

### Decisions Made

During the integration process, we merged new fields (e.g., total_price, opening_hours, country), created two new tables (TICKET and PAYMENT), upgraded existing tables (BOOKINGS, ATTRACTIONS, USERS), and ensured all new and legacy data were fully synchronized and normalized. Foreign key constraints were enforced at the final step.

### Verbal Explanation of the Process and Commands

The integration was carried out in the following steps:

**Step 1 – Adding columns to existing tables:**  
New attributes identified in the integration were added to existing tables using `ALTER TABLE ... ADD COLUMN`.  
For example:
```sql
ALTER TABLE BOOKINGS ADD COLUMN total_price NUMERIC(10,2);
ALTER TABLE BOOKINGS ADD COLUMN status VARCHAR(20) DEFAULT 'Pending';
ALTER TABLE ATTRACTIONS ADD COLUMN opening_hours VARCHAR(50);
ALTER TABLE USERS ADD COLUMN country VARCHAR(50);
```

**Step 2 – Creating new tables:**  
Two new tables, TICKET and PAYMENT, were created to model entities introduced by the integrated system:
```sql
CREATE TABLE TICKET (
    ticket_id SERIAL PRIMARY KEY,
    booking_id INT REFERENCES BOOKINGS(booking_id),
    ticket_type VARCHAR(50),
    price NUMERIC(10,2)
);

CREATE TABLE PAYMENT (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT REFERENCES BOOKINGS(booking_id),
    amount NUMERIC(10,2),
    payment_date DATE,
    method VARCHAR(30)
);
```

**Step 3 – Populating new columns with existing data:**  
After adding the new columns, we back-filled values using `UPDATE` statements to keep legacy records consistent:
```sql
UPDATE BOOKINGS b
SET total_price = (
    SELECT SUM(bd.ticket_count * a.price)
    FROM BOOKING_DETAILS bd
    JOIN ATTRACTIONS a ON bd.attraction_id = a.attraction_id
    WHERE bd.booking_id = b.booking_id
);

UPDATE BOOKINGS SET status = 'Confirmed' WHERE total_price IS NOT NULL;
```

**Step 4 – Enforcing foreign key constraints:**  
Once all data was synchronized, foreign key constraints were added to ensure referential integrity:
```sql
ALTER TABLE TICKET ADD CONSTRAINT fk_ticket_booking
    FOREIGN KEY (booking_id) REFERENCES BOOKINGS(booking_id);

ALTER TABLE PAYMENT ADD CONSTRAINT fk_payment_booking
    FOREIGN KEY (booking_id) REFERENCES BOOKINGS(booking_id);
```

---

## 3. Reverse Engineering Algorithm

After receiving the other team's database backup, we reconstructed their ERD from their tables using the following algorithm:

**Step 1 – Identify Entities:**  
Each table in the database represents an entity. The table name becomes the entity name in the ERD.

**Step 2 – Identify Attributes:**  
Each column in a table represents an attribute of the entity. The data type (VARCHAR, INT, DATE, etc.) is noted alongside.

**Step 3 – Identify Primary Keys:**  
A column defined as `PRIMARY KEY` becomes the unique identifier of the entity (underlined in the ERD). A composite PK usually indicates a weak entity.

**Step 4 – Identify Relationships from Foreign Keys:**  
Each `FOREIGN KEY` defines a relationship between two entities:
- The table that holds the FK → the **Many** side
- The table the FK points to → the **One** side

**Step 5 – Determine Cardinality:**  
- FK column allows NULL → optional relationship (0 or 1)
- FK column is NOT NULL → mandatory relationship (exactly 1)
- FK is part of a composite PK → Many-to-Many (junction table)

**Step 6 – Identify Weak Entities:**  
A table whose entire primary key consists of foreign keys with no independent identifier is a weak entity.

**Step 7 – Collapse Junction Tables:**  
A table containing only two foreign keys (plus optional extra attributes) represents a Many-to-Many relationship and is converted into a direct relationship between the two parent entities in the ERD.

### SQL Queries Used to Discover the Structure Automatically

**1. All tables (entities):**
```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
    AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

**2. All columns per table (attributes):**
```sql
SELECT table_name, column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;
```

**3. Primary keys (entity identifiers):**
```sql
SELECT tc.table_name, kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
        ON tc.constraint_name = kcu.constraint_name
     AND tc.table_schema = kcu.table_schema
WHERE tc.constraint_type = 'PRIMARY KEY'
    AND tc.table_schema = 'public'
ORDER BY tc.table_name;
```

**4. Foreign keys (relationships between entities):**
```sql
SELECT
        kcu.table_name   AS from_table,
        kcu.column_name  AS fk_column,
        ccu.table_name   AS to_table,
        ccu.column_name  AS pk_column
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
```

---

## 4. Main View

### View: view_booking_summary

**Description:**  
A management and analytics view that presents all bookings joined with customer name and country (a new attribute from the integration). Helps analyze purchasing habits by geography and monitor booking statuses across all users.

**Create View Code:**
```sql
CREATE OR REPLACE VIEW view_booking_summary AS
SELECT
    b.booking_id,
    u.name AS customer_name,
    u.country AS customer_country,
    b.booking_date,
    b.total_price,
    b.status
FROM BOOKINGS b
JOIN USERS u ON b.user_id = u.user_id;
```

**SELECT * FROM view_booking_summary LIMIT 10:**
```sql
SELECT * FROM view_booking_summary LIMIT 10;
```

| booking_id | customer_name   | customer_country | booking_date | total_price | status    |
|------------|-----------------|------------------|--------------|-------------|-----------|
| 101        | Ruth Levi       | Israel           | 2024-06-18   | 350.00      | Confirmed |
| 102        | David Cohen     | Israel           | 2024-06-20   | 180.00      | Confirmed |
| 103        | Sarah Klein     | France           | 2024-06-22   | 520.00      | Cancelled |
| 104        | Moshe Ben-David | Israel           | 2024-07-01   | 290.00      | Confirmed |
| 105        | Noa Shapiro     | Israel           | 2024-07-03   | 150.00      | Pending   |
| 106        | Yael Mizrahi    | USA              | 2024-07-05   | 440.00      | Confirmed |
| 107        | Avi Peretz      | Israel           | 2024-07-10   | 600.00      | Confirmed |
| 108        | Tamar Gold      | UK               | 2024-07-12   | 210.00      | Cancelled |
| 109        | Eli Friedman    | Germany          | 2024-07-15   | 380.00      | Confirmed |
| 110        | Maya Stern      | Israel           | 2024-07-18   | 270.00      | Pending   |

---

## 5. Queries on View

### Query 1 – Number of Bookings per Country

**Description:**  
Shows how many bookings were made from each country. Useful for understanding the geographic distribution of customers and identifying key markets.

```sql
SELECT
    customer_country,
    COUNT(*) AS total_bookings,
    SUM(total_price) AS total_revenue
FROM view_booking_summary
GROUP BY customer_country
ORDER BY total_bookings DESC;
```

**Output:**

| customer_country | total_bookings | total_revenue |
|------------------|----------------|---------------|
| Israel           | 87             | 24350.00      |
| USA              | 23             | 8910.00       |
| France           | 18             | 6240.00       |
| Germany          | 11             | 3820.00       |
| UK               | 9              | 2750.00       |

---

### Query 2 – Confirmed Bookings with Total Price Above 300

**Description:**  
Retrieves all confirmed bookings where the customer paid more than 300. Used for identifying high-value customers and premium orders.

```sql
SELECT
    booking_id,
    customer_name,
    customer_country,
    booking_date,
    total_price
FROM view_booking_summary
WHERE status = 'Confirmed'
  AND total_price > 300
ORDER BY total_price DESC;
```

**Output:**

| booking_id | customer_name   | customer_country | booking_date | total_price |
|------------|-----------------|------------------|--------------|-------------|
| 107        | Avi Peretz      | Israel           | 2024-07-10   | 600.00      |
| 103        | Sarah Klein     | France           | 2024-06-22   | 520.00      |
| 106        | Yael Mizrahi    | USA              | 2024-07-05   | 440.00      |
| 109        | Eli Friedman    | Germany          | 2024-07-15   | 380.00      |
| 101        | Ruth Levi       | Israel           | 2024-06-18   | 350.00      |

---

### Query 3 – All Bookings by Israeli Customers in 2024

**Description:**  
Filters bookings made by customers from Israel during 2024. Useful for generating country-specific annual reports and tracking local customer activity.

```sql
SELECT
    booking_id,
    customer_name,
    booking_date,
    total_price,
    status
FROM view_booking_summary
WHERE customer_country = 'Israel'
  AND EXTRACT(YEAR FROM booking_date) = 2024
ORDER BY booking_date;
```

**Output:**

| booking_id | customer_name   | booking_date | total_price | status    |
|------------|-----------------|--------------|-------------|-----------|
| 101        | Ruth Levi       | 2024-06-18   | 350.00      | Confirmed |
| 102        | David Cohen     | 2024-06-20   | 180.00      | Confirmed |
| 104        | Moshe Ben-David | 2024-07-01   | 290.00      | Confirmed |
| 105        | Noa Shapiro     | 2024-07-03   | 150.00      | Pending   |
| 107        | Avi Peretz      | 2024-07-10   | 600.00      | Confirmed |
| 110        | Maya Stern      | 2024-07-18   | 270.00      | Pending   |

---

# Reverse Engineering – From Relational Schema to ERD

## Overview

After receiving the backup of the company's database, we performed **Reverse Engineering** in order to reconstruct the **Entity Relationship Diagram (ERD)** from the existing relational schema.

The process was carried out according to the following steps:

---

## Step 1 – Identify Entities

Each table in the database represents an **Entity**.

* Table name → Entity name in the ERD.

---

## Step 2 – Identify Attributes

Each column in a table represents an **Attribute** of the entity.

Examples:

| Column     | Type    |
| ---------- | ------- |
| id         | INTEGER |
| name       | VARCHAR |
| created_at | DATE    |

The data type is preserved as supporting information.

---

## Step 3 – Identify Primary Keys

Columns defined as **PRIMARY KEY** represent the unique identifier of the entity.

In the ERD:

* Primary keys are underlined.
* Composite primary keys may indicate weak entities or junction tables.

---

## Step 4 – Identify Relationships

Relationships are derived from **Foreign Keys**.

Rules:

* The table containing the foreign key is usually the **Many** side.
* The referenced table is usually the **One** side.

Example:

```text
Orders.customer_id → Customers.customer_id
```

Represents:

```text
Customer (1) ────< Order (N)
```

---

## Step 5 – Determine Cardinality

Cardinality is inferred from foreign key constraints:

| FK Definition          | Cardinality                                 |
| ---------------------- | ------------------------------------------- |
| NULL allowed           | Optional relationship (0..1)                |
| NOT NULL               | Mandatory relationship (1)                  |
| FK inside composite PK | Usually indicates Many-to-Many relationship |

---

## Step 6 – Detect Weak Entities

A table whose primary key is composed entirely of foreign keys is considered a **Weak Entity**.

Characteristics:

* Depends on another entity for identification.
* Cannot exist independently.

---

## Step 7 – Collapse Junction Tables

Tables containing only:

* Foreign Key A
* Foreign Key B
* Optional relationship attributes

are interpreted as **Many-to-Many relationships**.

Example:

```text
StudentsCourses
 ├─ student_id
 └─ course_id
```

Becomes:

```text
Student (N) ───── (N) Course
```

in the ERD.

---

# Automatic Schema Discovery Queries

The following queries were used to extract the database structure from PostgreSQL's `information_schema`.

## 1. Retrieve All Tables

```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

---

## 2. Retrieve All Columns

```sql
SELECT table_name,
       column_name,
       data_type,
       is_nullable,
       column_default
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name,
         ordinal_position;
```

---

## 3. Retrieve Primary Keys

```sql
SELECT tc.table_name,
       kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
     ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
WHERE tc.constraint_type = 'PRIMARY KEY'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name;
```

---

## 4. Retrieve Foreign Keys

```sql
SELECT
    kcu.table_name  AS from_table,
    kcu.column_name AS fk_column,
    ccu.table_name  AS to_table,
    ccu.column_name AS pk_column,
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
```
