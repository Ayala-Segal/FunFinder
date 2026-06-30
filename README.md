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
- [Phase 3: Complex Queries, Views, and Integration](#phase-3--complex-queries-views-and-integration)
- [Phase 4: PL/pgSQL – Functions, Procedures & Triggers](#phase-4--plpgsql-functions-procedures--triggers)
- [Phase 5: Web Application – ExploreEase](#phase-5--web-application-exploreease)

---

## 🚀 How to Run the Website (Phase 5)

### Prerequisites
- Python 3.10+
- Docker Desktop — must be **running**

### Step 1 — Start the database
Open a terminal in the **root** of the project and run:
```bash
docker-compose up -d
```
This starts PostgreSQL on port 5432. You only need to do this once (or after a restart).

### Step 2 — Install Python dependencies
```bash
cd "שלב ה"
pip install -r requirements.txt
```

### Step 3 — Run the application
```bash
python run.py
```

### Step 4 — Open in browser
Go to: **http://localhost:5000**

---

### Login Credentials

| Role | Email | Password |
|------|-------|----------|
| Admin | `admin@exploreease.com` | `Admin1234!` |
| Regular User | any email from the database | the value in the `password_hash` column |

> **Admin** has access to the full management panel (CRUD for all tables, reports, and Phase 4 functions).  
> **Regular User** can browse attractions, make bookings, and write reviews.

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


## Phase 3 – Complex Queries, VIEWs, and Integration

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

---

# Phase 4 – PL/pgSQL: Functions, Procedures & Triggers

## Overview

Phase 4 extends the FunFinder database by embedding complex business logic directly inside PostgreSQL using PL/pgSQL. The implementation includes 2 functions, 2 procedures, 2 triggers, and 2 anonymous main programs (DO blocks). Every object contains all required PL/pgSQL elements: explicit cursor, implicit cursor, REF cursor, DML statements, branching (IF/ELSIF/ELSE), loops (cursor loop, FOR, WHILE), exception handling, and record variables.

---

## Schema Changes – AlterTable.sql

Run this file first, before any other Stage 4 file.

### `booking_audit` table

A central audit/log table consumed by both triggers and both functions.

| Column | Type | Description |
|--------|------|-------------|
| audit_id | SERIAL PK | Auto-generated identifier |
| booking_id | INT | The booking that was changed |
| user_id | INT | The user involved |
| old_status / new_status | VARCHAR | Status before and after the change |
| old_amount / new_amount | DOUBLE PRECISION | Price before and after |
| change_type | VARCHAR | `INSERT` / `UPDATE` / `DELETE` |
| change_time | TIMESTAMP | Timestamp of the change (default: NOW()) |
| notes | TEXT | Free-text explanation |

### Additional columns added

- `total_bookings INT` added to **USERS** – a running counter of confirmed bookings per user, maintained automatically by Trigger 2.
- `last_updated TIMESTAMP` added to **ATTRACTIONS** – timestamp of the last statistics refresh.

---

## Function 1 – `fn_apply_booking_discounts(p_user_id INT) → INT`

### Purpose

Receives a user ID, processes all pending bookings for that user, applies a four-tier discount/action policy, and purges stale cancelled bookings. Returns the number of bookings processed.

### Business Logic

**Section 1 – Implicit Cursor:** For every attraction the user has ever booked, recalculates `avg_rating` and `review_count` and updates the ATTRACTIONS table.

**Section 2 – Explicit Cursor (four price tiers):**

| Condition | Action |
|-----------|--------|
| `total_price = 0` | Recompute price from unit_price × quantity |
| `total_price < 50` | Auto-cancel + write audit record |
| `50 ≤ total_price < 300` | Confirm (`status = 'confirmed'`) |
| `total_price ≥ 300` | Upgrade to VIP + apply 10% loyalty discount + write audit record |

**Section 3 – WHILE Loop:** Purges cancelled bookings older than 90 days with no associated payment (deletes from BOOKING_DETAILS and BOOKINGS after logging to audit).

### PL/pgSQL Elements

| Element | Implementation |
|---------|---------------|
| Explicit Cursor | `c_pending refcursor` – OPEN / FETCH / CLOSE |
| Implicit Cursor | `FOR r_attr IN SELECT ... LOOP` |
| DML | UPDATE BOOKINGS, UPDATE ATTRACTIONS, INSERT booking_audit, DELETE BOOKING_DETAILS |
| Branching | IF / ELSIF / ELSIF / ELSE (4 tiers) |
| Loops | Cursor LOOP + FOR implicit + WHILE |
| Exception | Named SQLSTATE P0001 (user not found) + WHEN OTHERS |
| Records | `r_booking RECORD`, `r_attr RECORD` |

---

## Function 2 – `fn_attraction_revenue_report(p_category_id INT) → refcursor`

### Purpose

Receives a category ID. Restocks low-inventory tickets, refreshes attraction statistics, and returns a **named REF CURSOR** containing a revenue report for every attraction in the category.

### Business Logic

**Section 1 – Explicit Cursor:** Iterates over tickets with `available_quantity < 5`. Restock amount is determined by ticket type:

| Ticket Type | Restock Qty |
|-------------|-------------|
| Adult | +20 |
| Child | +30 |
| Family | +15 |
| Senior | +10 |

**Section 2 – Implicit Cursor:** Refreshes `avg_rating` and `review_count` for every attraction in the category.

**Section 3 – WHILE Loop:** Emergency restock to qty = 10 for any tickets still at zero.

**Section 4 – REF CURSOR:** Opens a named cursor (`'attraction_revenue_cur'`) with a revenue summary (total_bookings, total_revenue, avg_rating, first/last booking dates) and returns it to the caller.

### Key Design Point

Because the function **returns a refcursor**, the caller (Main 2 / the web application) iterates the rows itself. This allows processing large result sets without loading everything into memory at once.

---

## Procedure 1 – `pr_complete_booking(IN booking_id, OUT total_amount, OUT status)`

### Purpose

Processes a booking end-to-end: checks ticket inventory for each attraction in the booking, deducts stock, and returns a final status and total price via OUT parameters.

### Business Logic

**Section 1 – Implicit Cursor:** Computes the expected total and refreshes attraction statistics.

**Section 2 – Parameterised Explicit Cursor:** Iterates over every BOOKING_DETAILS row. Four stock scenarios:

| Scenario | Action |
|----------|--------|
| No ticket record exists | Delete the line from BOOKING_DETAILS |
| Stock = 0 (sold out) | Delete the line from BOOKING_DETAILS |
| Partial stock | Fulfil only available quantity; deduct all remaining stock |
| Full stock | Deduct ordered quantity; accumulate into total |

**Section 3 – WHILE retry loop:** Writes the final status up to 3 times in case of transient contention.

**Returned status:**
- `total = 0` → `'cancelled'`
- All lines fully fulfilled → `'confirmed'`
- At least one partial/missing line → `'partial'`

---

## Procedure 2 – `pr_sync_attraction_stats(p_min_reviews INT)`

### Purpose

Bulk-refreshes statistics (avg_rating, review_count, revenue) for every attraction. Skips attractions that have fewer reviews than the given minimum floor.

### Notable Design Elements

**User-defined composite type** `t_attraction_stat` is declared explicitly:
```sql
CREATE TYPE t_attraction_stat AS (
    attraction_id INT, attraction_name TEXT,
    new_avg_rating NUMERIC(3,2), new_review_cnt INT,
    new_revenue FLOAT, booking_cnt INT
);
```

**Explicit Cursor:** Seeds zero-stat attractions (review_count IS NULL or 0).

**Outer FOR loop** over difficulty levels drives the main processing.

**Implicit Cursor (inner):** Computes statistics per attraction within each difficulty level.

**Inner exception block:** If an attraction is below the review floor, raises SQLSTATE P0003, immediately catches it, logs a NOTICE, and uses `CONTINUE` to skip to the next attraction — without aborting the entire procedure.

**WHILE retry:** Attempts the UPDATE up to 3 times.

---

## Trigger 1 – `trg_bookings_before_insert`

**Type:** BEFORE INSERT ON BOOKINGS — fires before every new row enters the table.

| Step | Logic |
|------|-------|
| 1 | Hard block: if `NEW.status = 'cancelled'` → RAISE EXCEPTION (direct insertion of a cancelled booking is forbidden) |
| 2 | If `NEW.total_price` is NULL → compute it automatically from BOOKING_DETAILS × ATTRACTIONS.price and set `NEW.total_price` |
| 3 | If the user registered within the last 30 days → apply a 15% welcome discount to `NEW.total_price` |
| 4 | Insert a row into booking_audit |
| 5 | `RETURN NEW` — passes the (possibly modified) row through to the table |

---

## Trigger 2 – `trg_bookings_after_update`

**Type:** AFTER UPDATE ON BOOKINGS — fires after every update.

| Condition | Action |
|-----------|--------|
| Status and price both unchanged | `RETURN NEW` immediately (no side-effects needed) |
| Status transitions to `'completed'` | Insert (or upsert) a PAYMENT row; increment `USERS.total_bookings` by 1 |
| Status transitions to `'cancelled'` from an active state | Restore `available_quantity` on all relevant TICKET rows |
| Always | Insert a row into booking_audit capturing OLD and NEW values |

---

## Main Programs

### Main1.sql

Anonymous DO block demonstrating Function 1 and Procedure 1:

- Calls `fn_apply_booking_discounts(1)` and prints how many bookings were processed (or the error code).
- Calls `CALL pr_complete_booking(1, ...)` and prints the resulting status and total price.
- Each call is wrapped in its own `BEGIN/EXCEPTION` block so a failure in one does not prevent the other.

### Main2.sql

Anonymous DO block demonstrating Function 2 and Procedure 2:

- Calls `fn_attraction_revenue_report(1)`, fetches the returned refcursor in a LOOP, and prints each revenue row with RAISE NOTICE.
- Calls `CALL pr_sync_attraction_stats(2)` and prints the completion notice.

---

---

# Phase 5 – Web Application: ExploreEase

## Overview

Phase 5 builds a complete full-stack web application on top of the database created in previous phases. Regular users can browse attractions and make bookings; administrators manage all data and execute the Phase 4 PL/pgSQL objects directly from the interface.

**Technology stack:**
- **Backend:** Python 3.10+ · Flask · psycopg2
- **Frontend:** Bootstrap 5.3 · Bootstrap Icons · Jinja2
- **Database:** PostgreSQL (Docker container from Phase 3)

---

## Project Structure

```
שלב ה/
├── run.py                  ← Entry point
├── app/
│   ├── __init__.py         ← Flask factory, blueprint registration
│   ├── config.py           ← Reads .env configuration
│   ├── db.py               ← Database layer (query, execute, refcursor helpers)
│   ├── decorators.py       ← @login_required, @admin_required
│   └── routes/
│       ├── auth.py         ← Login / logout
│       ├── home.py         ← Home page
│       ├── attractions.py  ← Browse + Admin CRUD
│       ├── bookings.py     ← Booking flow + payment + Admin CRUD
│       ├── reviews.py      ← User reviews
│       ├── reports.py      ← Phase 2 queries + Phase 4 functions/procedures
│       └── admin.py        ← CRUD for all remaining tables
├── templates/              ← HTML templates (Jinja2)
└── static/                 ← CSS, JavaScript
```

---

## Database Layer – db.py

A custom abstraction layer over psycopg2, providing six helper functions:

| Function | Purpose |
|----------|---------|
| `query(sql, params)` | SELECT — returns a list of dicts |
| `query_one(sql, params)` | SELECT — returns a single row dict or None |
| `execute(sql, params)` | INSERT / UPDATE / DELETE |
| `call_procedure(name, params)` | Call a stored procedure (no result set) |
| `call_function_scalar(name, params)` | Call a function returning a scalar value |
| `call_function_refcursor(name, params)` | Call a function returning a refcursor — opens a transaction, fetches all rows |

**SQL Injection prevention:** All parameters are passed as `%s` placeholders and never interpolated into the query string.

**Connection management:** A `get_cursor()` context manager handles commit on success, rollback on exception, and always closes the connection.

---

## Authentication – auth.py

Supports two user types:

- **Admin:** Credentials stored in config; on success sets `session['is_admin'] = True`.
- **Regular user:** Queries the USERS table and compares `password_hash`; on success stores `user_id`, `user_name`, `user_email` in the session.

**Logout** clears the entire session.

---

## Access Control – decorators.py

```python
@login_required   # Checks session['user_id'] — redirects to /login if missing
@admin_required   # Checks session['is_admin'] — returns 403 if False
```

Every route that requires authentication uses one of these decorators, preventing direct URL access by unauthorised users.

---

## Attractions Module – attractions.py

### User-facing browse (`/attractions`)

- **Filtering** by category, difficulty level, and free-text keyword search (`ILIKE` on name and location)
- **Sorting** by `avg_rating` descending (highest-rated first)
- Image fallback handled in the template when `main_image_url` is missing

### Attraction detail page (`/attractions/<id>`)

Displays: full attraction details, image gallery, last 10 reviews, available tickets with validity dates.

### Admin CRUD (`/admin/attractions`)

Full create / read / update / delete with search and pagination.

---

## Bookings Module – bookings.py

### User booking flow

| Step | Route | What happens |
|------|-------|-------------|
| 1 | `GET /book/<aid>` | Show form to choose quantity and date |
| 2 | `POST /book/<aid>` | Insert into BOOKINGS (status='pending') + BOOKING_DETAILS → **`trg_bookings_before_insert` fires automatically** and calculates/adjusts the price |
| 3 | `GET /payment/<bid>` | Show booking summary with final price |
| 4 | `POST /payment/<bid>` | Insert into PAYMENT, set status='confirmed' → **`trg_bookings_after_update` fires automatically** and increments `USERS.total_bookings` |
| 5 | `GET /my-bookings` | List all bookings for the logged-in user |

**Security:** A user cannot access another user's payment page; already-confirmed bookings cannot be paid again.

---

## Reports Module – reports.py

Accessible to admins only. Combines Phase 2 SQL queries with live execution of Phase 4 database objects:

| Button | Call | Output displayed |
|--------|------|-----------------|
| Top-rated attractions | Inline SQL | Table of attractions with avg_rating ≥ 4 |
| Above-average spenders | Inline SQL with subquery | Customers who spent above their month's average |
| Apply Discounts | `call_function_scalar('fn_apply_booking_discounts', [uid])` | Bookings processed + updated booking list |
| Revenue Report | `call_function_refcursor('fn_attraction_revenue_report', [cid])` | Revenue table fetched from the refcursor |
| Complete Booking | `CALL pr_complete_booking(bid, NULL, NULL)` | Updated status and total price |
| Sync Stats | `call_procedure('pr_sync_attraction_stats', [min])` | 20 most recently updated attractions |

---

## Pagination

All admin list pages support pagination:

```python
page   = request.args.get('page', 1, type=int)
offset = (page - 1) * 200
# SQL: LIMIT 200 OFFSET %s
has_next = len(rows) == 200   # if exactly 200 rows returned, a next page likely exists
```

---

## Connection Between Phase 4 and Phase 5

The key strength of the project is that the two phases are not isolated — the PL/pgSQL objects are active whenever data changes, whether through the UI or directly in SQL:

| Action in the UI | What happens in the database |
|-----------------|------------------------------|
| User books an attraction | `trg_bookings_before_insert` fires — computes price, applies welcome discount |
| User completes payment | `trg_bookings_after_update` fires — creates PAYMENT row, increments total_bookings |
| Admin clicks Apply Discounts | `fn_apply_booking_discounts` runs — updates bookings, purges stale ones |
| Admin clicks Revenue Report | `fn_attraction_revenue_report` runs — returns refcursor; app iterates and displays it |
| Admin clicks Sync Stats | `pr_sync_attraction_stats` runs — refreshes all attraction statistics |

This architecture ensures that the `booking_audit` table always reflects the true history of every booking, regardless of how the data was changed.

---

## ExploreEase — Setup & Features

**ExploreEase** is the full-stack web application built on top of the FunFinder database.

### Stack
- **Backend**: Python 3.10+ · Flask 2.3 · psycopg2
- **Frontend**: Bootstrap 5.3 · Bootstrap Icons · Jinja2 templates
- **Database**: PostgreSQL (Docker container from Stage 3)

### Setup

#### 1. Prerequisites
- Python 3.10+
- Docker + Docker Compose (for the database)
- The database from Stages 1–4 must already be running

#### 2. Start the database
```bash
cd ..          # root of the repo
docker-compose up -d
```

#### 3. Install Python dependencies
```bash
cd "שלב ה"
pip install -r requirements.txt
```

#### 4. Configure environment
The `.env` file is pre-configured:
```
DB_HOST=localhost
DB_PORT=5432
DB_NAME_SECRET=dbnew
DB_USER_SECRET=Ayelet
DB_PASSWORD_SECRET=Ayelet1!
```

#### 5. Run the application
```bash
python run.py
```

Open your browser at **http://localhost:5000**

### Login Credentials

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@exploreease.com | Admin1234! |
| User | (any user from DB) | (password_hash value) |

### Features

**Regular Users**
- Browse and search attractions (by category, difficulty, keyword)
- View attraction details with tickets and reviews
- Book an attraction
- View own bookings
- Write reviews

**Admin**
- All of the above, plus:
- Full CRUD for all 11 tables
- Run Stage 2 SQL queries
- Execute Stage 4 PL/pgSQL functions and procedures with visible results

### Folder Structure
```
שלב ה/
├── run.py
├── requirements.txt
├── .env
├── app/
│   ├── __init__.py       # Flask factory + blueprint registration
│   ├── config.py         # Env-based configuration
│   ├── db.py             # Database helpers
│   ├── decorators.py     # login_required, admin_required
│   └── routes/
│       ├── auth.py
│       ├── home.py
│       ├── attractions.py
│       ├── bookings.py
│       ├── reviews.py
│       ├── admin.py
│       └── reports.py
├── templates/
│   ├── base.html
│   ├── auth/
│   ├── main/
│   ├── attractions/
│   ├── bookings/
│   ├── reviews/
│   ├── admin/
│   └── reports/
└── static/
    ├── css/style.css
    └── js/main.js
```
