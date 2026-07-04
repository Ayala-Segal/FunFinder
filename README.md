# 🎯 FunFinder – Attractions Management System

## Table of Contents

- [Phase 1: Design and Build the Database](#phase-1-design-and-build-the-database)
  - Introduction
  - Purpose of the Database
  - Potential Use Cases
  - System Overview
  - ERD (Entity-Relationship Diagram)
  - DSD (Data Structure Diagram)
  - SQL Scripts
  - Data
  - Backup
- [Phase 2: SQL Queries, Constraints & Database Operations](#phase-2-sql-queries-constraints--database-operations)

---

## Phase 1: Design and Build the Database

### Introduction

The **FunFinder system** is designed to manage attractions, bookings, and user interactions in a structured and efficient way.  
It provides a complete database solution for handling attractions, reservations, reviews, and related content.

### Purpose of the Database

- Managing attractions with categories, pricing, and descriptions  
- Handling bookings and ticket management  
- Tracking users and their activity  
- Managing reviews and ratings  
- Storing images for each attraction  

### Potential Use Cases

- Users can browse attractions and book tickets  
- Administrators manage attractions and categories  
- The system analyzes popularity and ratings  
- Businesses can present and manage their attractions  

---

## 🚀 AI Studio Preview

📌 View the system prototype and AI design:  
https://ai.studio/apps/5c3de8b2-1857-4c0e-964f-efd5e41495a2

---

## 🖼️ System Overview (Application View)

This section presents the main screens of the system and demonstrates how users interact with the application.

### 🏠 Home Page

The main landing page provides navigation and a general overview of available attractions.

![Home 1](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/home1.png)
![Home 2](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/home2.png)
![Home 3](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/home3.png)

---

### 🎟️ Attractions Page

Displays all available attractions with filtering, search options, and detailed information.

![Attractions](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/attractions.png)

---

### 🔐 Login Page

User authentication screen for secure system access.

![Login](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/connection.png)

---

### 🛒 Orders Page

Displays user booking history and order management.

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

## Phase 2: SQL Queries, Constraints & Database Operations

### Introduction

This phase focuses on advanced database operations, SQL querying, data validation, and business logic implementation.

The goal is to ensure data consistency, support analytical capabilities, and provide efficient access to information stored in the FunFinder database.

#### Purpose of this Phase

* Implementing complex SQL queries
* Enforcing business rules and data integrity
* Creating views and reports
* Managing transactions and database operations
* Supporting analytical and administrative tasks

#### Potential Use Cases

* Generating business reports
* Analyzing attraction popularity
* Tracking booking activity
* Monitoring customer reviews
* Managing database updates safely

---

### 🔍 SELECT Queries
#### Paired Queries & Comparison

##### Query 1 – Adventure Attractions Not Booked by the User

**Description**

Retrieves attractions from the Adventure category that the user has not booked yet.

###### Form A – JOIN Version

```sql
-- Query 1 (JOIN version)
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
```

📸 Screenshot Query:

![Query 1A](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query1A_SELECT.png)

###### Form B – NOT EXISTS Version

```sql
-- Query 1 (NOT EXISTS version)
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
```

📸 Screenshot Query:

![Query 1B](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query1B_SELECT.png)

###### Comparison

**Difference Between Approaches**

* JOIN relies on NULL filtering after table joins.
* NOT EXISTS directly checks for the absence of matching records.

**Efficiency**

* NOT EXISTS is generally more efficient.
* Better optimized for non-existence conditions.
* Avoids duplicate rows that may be introduced by joins.

---
##### Query 2 – Past Bookings Without Reviews

**Description**

Finds attractions that the user visited in the past but has not reviewed yet.

###### Form A – NOT EXISTS Version

```sql
-- Purpose: Find past booked attractions that the user has NOT reviewed yet

SELECT
    a.name,
    a.location,
    b.booking_date
FROM BOOKINGS b
JOIN BOOKING_DETAILS bd
    ON b.booking_id = bd.booking_id
JOIN ATTRACTIONS a
    ON bd.attraction_id = a.attraction_id
WHERE b.user_id = 1
  AND b.booking_date < CURRENT_DATE
  AND NOT EXISTS (
      SELECT 1
      FROM REVIEWS r
      WHERE r.attraction_id = a.attraction_id
        AND r.user_id = 1
  );
```

📸 Screenshot Query:

![Query 2A](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query2A_SELECT.png)

###### Form B – LEFT JOIN Version

```sql
-- Purpose: Find past booked attractions that the user has NOT reviewed yet

SELECT DISTINCT
    a.name,
    a.location,
    b.booking_date
FROM BOOKINGS b
JOIN BOOKING_DETAILS bd
    ON b.booking_id = bd.booking_id
JOIN ATTRACTIONS a
    ON bd.attraction_id = a.attraction_id
LEFT JOIN REVIEWS r
    ON r.attraction_id = a.attraction_id
   AND r.user_id = 1
WHERE b.user_id = 1
  AND b.booking_date < CURRENT_DATE
  AND r.review_id IS NULL;
```

📸 Screenshot Query:

![Query 2B](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query2B_SELECT.png)

###### Comparison

**Difference Between Approaches**

* NOT EXISTS directly checks whether a review does not exist.
* LEFT JOIN identifies missing reviews through NULL values after the join.

**Efficiency**

* NOT EXISTS is generally more accurate for exclusion logic.
* LEFT JOIN requires careful handling to avoid duplicate rows.
* NOT EXISTS is often easier for the database optimizer to process in anti-join scenarios.

---

##### Query 3 – Family Attractions with Easy Difficulty

**Description**

Retrieves attractions that belong to the Family category and have an Easy difficulty level.

###### Form A – JOIN Version

```sql
-- Purpose: Get family attractions with easy difficulty level

SELECT
    a.name,
    a.price,
    a.avg_rating
FROM ATTRACTIONS a
JOIN CATEGORIES c
    ON a.category_id = c.category_id
JOIN DIFFICULTY_LEVELS d
    ON a.difficulty_id = d.difficulty_id
WHERE c.name = 'Family'
  AND d.name = 'Easy';
```

📸 Screenshot Query:

![Query 3A](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query3A_SELECT.png)

###### Form B – Subquery Version

```sql
-- Purpose: Get family attractions with easy difficulty level

SELECT
    a.name,
    a.price,
    a.avg_rating
FROM ATTRACTIONS a
WHERE a.category_id = (
    SELECT category_id
    FROM CATEGORIES
    WHERE name = 'Family'
)
AND a.difficulty_id = (
    SELECT difficulty_id
    FROM DIFFICULTY_LEVELS
    WHERE name = 'Easy'
);
```

📸 Screenshot Query:

![Query 3B](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query3B_SELECT.png)

###### Comparison

**Difference Between Approaches**

* JOIN retrieves related data by directly connecting the relevant tables.
* Subqueries first retrieve the required identifiers and then filter the attractions table.

**Efficiency**

* JOIN is generally more readable and scalable.
* JOIN performs better when working with larger datasets and multiple related tables.
* Subqueries are simpler to write but may be less optimized in complex scenarios.

---
##### Query 4 – Most Popular Attraction in a Category

**Description**

Finds the most booked attraction within a specific category based on booking history.

###### Form A – Aggregate Function Version

```sql
-- Purpose: Find the most booked attraction in a category

SELECT
    a.name,
    COUNT(*) AS booking_count
FROM ATTRACTIONS a
JOIN BOOKING_DETAILS bd
    ON a.attraction_id = bd.attraction_id
WHERE a.category_id = 5
GROUP BY a.attraction_id, a.name
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM BOOKING_DETAILS bd2
        JOIN ATTRACTIONS a2
            ON bd2.attraction_id = a2.attraction_id
        WHERE a2.category_id = 5
        GROUP BY bd2.attraction_id
    ) sub
);
```

📸 Screenshot Query:

![Query 4A](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query4A_SELECT.png)

###### Form B – ALL Comparison Version

```sql
-- Purpose: Find the most booked attraction in a category

SELECT
    a.name,
    COUNT(*) AS booking_count
FROM ATTRACTIONS a
JOIN BOOKING_DETAILS bd
    ON a.attraction_id = bd.attraction_id
WHERE a.category_id = 5
GROUP BY a.attraction_id, a.name
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM BOOKING_DETAILS bd2
    JOIN ATTRACTIONS a2
        ON bd2.attraction_id = a2.attraction_id
    WHERE a2.category_id = 5
    GROUP BY bd2.attraction_id
);
```

📸 Screenshot Query:

![Query 4B](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Query4B_SELECT.png)

###### Comparison

**Difference Between Approaches**

* The aggregate-function approach first calculates the maximum booking count and then returns attractions that match it.
* The ALL approach compares each attraction against all booking-count results in the category.

**Efficiency**

* Aggregate functions such as MAX are generally more efficient and easier to optimize.
* The ALL comparison requires evaluating every grouped result.
* Aggregate-based solutions are usually preferred for scalability and readability.

---

#### Additional SELECT Queries

This section presents additional analytical queries used for reporting, recommendations, and user activity analysis.

#### Additional SELECT Queries

##### Query 5 – Yearly Spending per User

**Description**

Displays yearly booking statistics and total spending for a specific user, providing insights into travel activity and overall expenses.

```sql
-- Purpose: Show yearly spending summary per user (profile analytics)

SELECT
    EXTRACT(YEAR FROM b.booking_date) AS booking_year,
    COUNT(b.booking_id) AS total_trips,
    SUM(bd.ticket_count * a.price) AS total_spent
FROM BOOKINGS b
JOIN BOOKING_DETAILS bd
    ON b.booking_id = bd.booking_id
JOIN ATTRACTIONS a
    ON bd.attraction_id = a.attraction_id
WHERE b.user_id = $1
GROUP BY EXTRACT(YEAR FROM b.booking_date)
ORDER BY booking_year DESC;
```

📸 Screenshot Query:

![Query 5](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/SEL5.png)

---

##### Query 6 – Most Popular Categories

**Description**

Ranks attraction categories according to the number of bookings associated with each category.

```sql
-- Purpose: Show most popular categories based on bookings

SELECT
    c.name AS category_name,
    COUNT(b.booking_id) AS popularity
FROM CATEGORIES c
JOIN ATTRACTIONS a
    ON c.category_id = a.category_id
JOIN BOOKING_DETAILS bd
    ON a.attraction_id = bd.attraction_id
JOIN BOOKINGS b
    ON bd.booking_id = b.booking_id
GROUP BY c.name
ORDER BY popularity DESC;
```

📸 Screenshot Query:

![Query 6](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/SEL6.png)

---

##### Query 7 – Full Attraction Details with Images

**Description**

Displays detailed information about a selected attraction together with its associated gallery images.

```sql
-- Purpose: Show full attraction details with images

SELECT
    a.name,
    a.full_description,
    g.image_url
FROM ATTRACTIONS a
LEFT JOIN GALLERY_IMAGES g
    ON a.attraction_id = g.attraction_id
WHERE a.attraction_id = 10;
```

📸 Screenshot Query:

![Query 7](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/SEL7.png)

---

##### Query 8 – Attractions Not Visited in the Last Six Months

**Description**

Returns attractions that the user has not visited during the previous six months, helping generate recommendations for future trips.

```sql
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
JOIN CATEGORIES c
    ON a.category_id = c.category_id
JOIN DIFFICULTY_LEVELS d
    ON a.difficulty_id = d.difficulty_id
WHERE NOT EXISTS (
    SELECT 1
    FROM BOOKINGS b
    JOIN BOOKING_DETAILS bd
        ON b.booking_id = bd.booking_id
    WHERE b.user_id = $1
      AND bd.attraction_id = a.attraction_id
      AND b.booking_date >= CURRENT_DATE - INTERVAL '6 months'
)
ORDER BY a.avg_rating DESC, a.price ASC;
```

📸 Screenshot Query:

![Query 8](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/SEL8.png)

---

##### Query 9 – Most Booked Attractions in the Last Two Months

**Description**

Returns the four most booked attractions during the previous two months based on booking activity.

```sql
-- Purpose: Return the 4 most booked attractions in the last 2 months

SELECT
    a.attraction_id,
    a.name,
    a.location,
    a.price,
    COUNT(bd.attraction_id) AS total_bookings
FROM ATTRACTIONS a
JOIN BOOKING_DETAILS bd
    ON a.attraction_id = bd.attraction_id
JOIN BOOKINGS b
    ON bd.booking_id = b.booking_id
WHERE b.booking_date >= CURRENT_DATE - INTERVAL '2 months'
GROUP BY
    a.attraction_id,
    a.name,
    a.location,
    a.price
ORDER BY total_bookings DESC
LIMIT 4;
```

📸 Screenshot Query:

![Query 9](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/SEL9.png)

---

## 🗑 DELETE Queries

##### Query 1 – Delete Old Reviews

**Description**

Removes old reviews from the system based on creation date and user, in order to maintain relevant and up-to-date review data.

```sql
-- Query 1
-- Purpose: Remove old reviews while considering review metadata

DELETE FROM REVIEWS r
WHERE r.review_id IN (
    SELECT r2.review_id
    FROM REVIEWS r2
    WHERE EXTRACT(YEAR FROM r2.created_at) <= EXTRACT(YEAR FROM CURRENT_DATE) - 3
    AND r2.user_id = $1
);
```

📸 Before: ![Query DELETE1](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/DEL1.png)

##### Query 2 – Delete Inactive Attractions (no bookings in last year)

**Description**

Removes attractions that had no bookings in the last year, used for data cleanup and removal of inactive records.

```sql
-- Query 2
-- Purpose: Delete attractions that had NO bookings in the last year (data cleanup / inactive attractions)

DELETE FROM ATTRACTIONS a
WHERE NOT EXISTS (
    SELECT 1
    FROM BOOKING_DETAILS bd
    JOIN BOOKINGS b ON bd.booking_id = b.booking_id
    WHERE bd.attraction_id = a.attraction_id
      AND b.booking_date >= CURRENT_DATE - INTERVAL '1 year'
);
```

📸 Before: ![Query DELETE2](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/DEL2.png)

##### Query 3 – Delete orphan gallery images

**Description**

Removes gallery images that are no longer linked to existing attractions, ensuring database integrity and removing unused data.

```sql
-- Query 3
-- Purpose: Clean up gallery images that no longer belong to existing attractions

DELETE FROM GALLERY_IMAGES g
WHERE NOT EXISTS (
    SELECT 1
    FROM ATTRACTIONS a
    WHERE a.attraction_id = g.attraction_id
);
```

📸 Before: ![Query DELETE3](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/DEL3.png)

## 🔄 UPDATE Queries

##### Query 1 –Update average rating of attractions
 
```sql
-- Query 1
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
```

📸 Before: ![Query UPDATE1A](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/upd1.png)

##### Query 2 – Update booking date (72-hour rule)

```sql
--Query 2
-- Purpose: Allow updating a booking date only if it is still at least 72 hours before the scheduled date

UPDATE BOOKINGS b
SET booking_date = $1  -- new desired date
WHERE b.booking_id = $2
  AND b.user_id = $3
  AND b.booking_date > CURRENT_DATE + INTERVAL '3 days';
```

📸 Before: ![Query UPDATE2A](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/upd2.png)


##### Query 3 – Mark active users based on activity

```sql
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
```

📸 Before: ![Query UPDATE3A](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/upd3.png)


## ⚠️ Constraints (ALTER TABLE)

### Description

Each constraint was added using `ALTER TABLE` in order to enforce data integrity rules in the database, such as:

- FOREIGN KEY constraints  
- UNIQUE constraints  
- CHECK constraints  

These constraints ensure that invalid or inconsistent data cannot be inserted into the system.

## 🧾 Constraint Examples

### 1

📸 Invalid insert attempt:

![ALTER1](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/ALTER1.png)

### 2

📸 Invalid insert attempt:

![ALTER2](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/ALTER2.png)

### 3

📸 Invalid insert attempt:

![ALTER3](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/ALTER3.png)

---
## 🔄 TRANSACTIONS – COMMIT & ROLLBACK
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
