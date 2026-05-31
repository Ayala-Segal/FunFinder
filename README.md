# Step 3 – Complex Queries, VIEWs, and Integration

## 1. DSD/ERD Diagrams

### NewDSD Diagram
![NewDSD](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/NewDSD.png)

### NewERD Diagram
![NewERD](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/NewERD.png)

### Combined Diagram
![Combined](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Combined.png)

---

## 2. Integration Decisions

During the integration process, we merged new fields (e.g., total_price, opening_hours, country), created two new tables (TICKET and PAYMENT), upgraded existing tables (BOOKINGS, ATTRACTIONS, USERS), and ensured all new and legacy data were fully synchronized and normalized. Foreign key constraints were enforced at the final step.

---

## 3. Main View

### View: view_booking_summary

**Description:**  
A management and analytics view that presents all bookings joined with customer name and country (a new attribute from the integration). Helps analyze purchasing habits by geography.

**Code:**
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

**Example Output:**
| booking_id | customer_name | customer_country | booking_date | total_price | status     |
|------------|---------------|------------------|--------------|-------------|------------|
|   101      | Ruth Levi     | Israel           | 2024-06-18   | 350         | Confirmed  |
|   113      | Guy Cohen     | France           | 2024-07-02   | 480         | Cancelled  |
|    ...     | ...           | ...              | ...          | ...         | ...        |

**Screenshot:**  
![booking_summary_view](imagesView/view_booking_summary.png)

---

## 4. Complex Query Examples

Each query is based on the new unified data model. For each query, there is code, use-case description, sample output, and a screenshot placeholder.

---

### 1. Attractions of 'Adventure' Type not yet ordered by the current user

**(A) Version with LEFT JOIN**
```sql
SELECT DISTINCT
    a.name,
    a.location,
    a.price
FROM ATTRACTIONS a
JOIN CATEGORIES c ON a.category_id = c.category_id
LEFT JOIN BOOKING_DETAILS bd ON a.attraction_id = bd.attraction_id
LEFT JOIN BOOKINGS b ON bd.booking_id = b.booking_id AND b.user_id = 1
WHERE c.name = 'Adventure'
  AND b.booking_id IS NULL;
```

**(B) Version with NOT EXISTS**
```sql
SELECT
    a.name,
    a.location,
    a.price
FROM ATTRACTIONS a
WHERE a.category_id = (
    SELECT category_id FROM CATEGORIES WHERE name = 'Adventure'
)
AND NOT EXISTS (
    SELECT 1
    FROM BOOKING_DETAILS bd
    JOIN BOOKINGS b ON bd.booking_id = b.booking_id
    WHERE bd.attraction_id = a.attraction_id
      AND b.user_id = 1
);
```

**Sample Output:**
| name             | location      | price |
|------------------|--------------|-------|
| River Rafting    | Galilee      | 180   |
| Desert ATV Tour  | Negev        | 200   |
| ...              | ...          | ...   |
**Screenshot:**  
![unused_adventure_attractions](imagesView/query1.png)

---

### 2. Past Attractions Visited but Not Yet Reviewed

**(A) Version with NOT EXISTS**
```sql
SELECT
    a.name,
    a.location,
    b.booking_date
FROM BOOKINGS b
JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id
JOIN ATTRACTIONS a ON bd.attraction_id = a.attraction_id
WHERE b.user_id = 1
  AND b.booking_date < CURRENT_DATE
  AND NOT EXISTS (
    SELECT 1
    FROM REVIEWS r
    WHERE r.attraction_id = a.attraction_id
      AND r.user_id = 1
  );
```

**(B) Version with LEFT JOIN**
```sql
SELECT DISTINCT
    a.name,
    a.location,
    b.booking_date
FROM BOOKINGS b
JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id
JOIN ATTRACTIONS a ON bd.attraction_id = a.attraction_id
LEFT JOIN REVIEWS r ON r.attraction_id = a.attraction_id AND r.user_id = 1
WHERE b.user_id = 1
  AND b.booking_date < CURRENT_DATE
  AND r.review_id IS NULL;
```

**Sample Output:**
| name             | location     | booking_date |
|------------------|-------------|--------------|
| Cave Hiking      | Carmel       | 2024-04-17   |
| Surf School      | Tel Aviv     | 2024-05-21   |
| ...              | ...          | ...          |
**Screenshot:**  
![not_reviewed_attractions](imagesView/query2.png)

---

### 3. Family Attractions with Easy Difficulty Showing Merged Opening Hours

```sql
SELECT
    a.name,
    a.price,
    a.avg_rating,
    a.opening_hours
FROM ATTRACTIONS a
JOIN CATEGORIES c ON a.category_id = c.category_id
JOIN DIFFICULTY_LEVELS d ON a.difficulty_id = d.difficulty_id
WHERE c.name = 'Family'
  AND d.name = 'Easy';
```

**Sample Output:**
| name              | price | avg_rating | opening_hours |
|-------------------|-------|------------|--------------|
| Kids Playground   | 50    | 4.8        | 09:00-18:00  |
| Mini Golf Resort  | 70    | 4.5        | 10:00-20:00  |
| ...               | ...   | ...        | ...          |
**Screenshot:**  
![family_easy_opening](imagesView/query3.png)

---

### 4. Most Booked Attraction in Category 5

```sql
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
```

**Sample Output:**
| name                | booking_count |
|---------------------|--------------|
| Paintball Park      | 45           |
**Screenshot:**  
![most_booked_cat5](imagesView/query4.png)

---

### 5. Yearly Financial & Trip Summary for a Specific User

```sql
SELECT
    EXTRACT(YEAR FROM b.booking_date) AS booking_year,
    COUNT(b.booking_id) AS total_trips,
    SUM(b.total_price) AS total_spent
FROM BOOKINGS b
WHERE b.user_id = 1
GROUP BY EXTRACT(YEAR FROM b.booking_date)
ORDER BY booking_year DESC;
```

**Sample Output:**
| booking_year | total_trips | total_spent |
|--------------|-------------|-------------|
| 2024         | 6           | 1800        |
| 2023         | 10          | 3020        |
**Screenshot:**  
![yearly_user_summary](imagesView/query5.png)

---

### 6. Most Popular Category Based on Total Bookings

```sql
SELECT
    c.name AS category_name,
    COUNT(b.booking_id) AS popularity
FROM CATEGORIES c
JOIN ATTRACTIONS a ON c.category_id = a.category_id
JOIN BOOKING_DETAILS bd ON a.attraction_id = bd.attraction_id
JOIN BOOKINGS b ON bd.booking_id = b.booking_id
GROUP BY c.name
ORDER BY popularity DESC
LIMIT 1;
```

**Sample Output:**
| category_name  | popularity |
|----------------|------------|
| Adventure      | 128        |
**Screenshot:**  
![most_popular_category](imagesView/query6.png)

---

### 7. Full Details for Attraction UI Detail Page, Gallery and Opening Hours

```sql
SELECT
    a.name,
    a.full_description,
    a.opening_hours,
    g.image_url
FROM ATTRACTIONS a
LEFT JOIN GALLERY_IMAGES g ON a.attraction_id = g.attraction_id
WHERE a.attraction_id = 10;
```

**Sample Output:**
| name                | full_description      | opening_hours | image_url                     |
|---------------------|----------------------|---------------|-------------------------------|
| Water Wonderland    | Huge water park...   | 09:00-18:00   | img/attractions/water_1.jpg   |
| Water Wonderland    | Huge water park...   | 09:00-18:00   | img/attractions/water_2.jpg   |
| ...                 | ...                  | ...           | ...                           |
**Screenshot:**  
![ui_detail_page](imagesView/query7.png)

---

### 8. Attractions NOT Visited by the User in the Last 6 Months (by User Country)

```sql
SELECT
    a.attraction_id,
    a.name,
    a.location,
    a.price,
    a.avg_rating,
    c.name AS category_name
FROM ATTRACTIONS a
JOIN CATEGORIES c ON a.category_id = c.category_id
WHERE NOT EXISTS (
    SELECT 1
    FROM BOOKINGS b
    JOIN USERS u ON b.user_id = u.user_id
    JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id
    WHERE b.user_id = 1
      AND u.country = 'Israel'
      AND bd.attraction_id = a.attraction_id
      AND b.booking_date >= CURRENT_DATE - INTERVAL '6 months'
)
ORDER BY a.avg_rating DESC, a.price ASC;
```

**Sample Output:**
| attraction_id | name           | location    | price | avg_rating | category_name |
|---------------|---------------|-------------|-------|------------|--------------|
| 131           | Snow Dome     | Hermon      | 120   | 4.9        | Winter Fun   |
| 104           | Escape Room   | Netanya     | 80    | 4.7        | Adventure    |
| ...           | ...           | ...         | ...   | ...        | ...          |
**Screenshot:**  
![not_visited_6_months](imagesView/query8.png)

---

### 9. Top 4 Most Booked Attractions in the Last 2 Months

```sql
SELECT
    a.attraction_id,
    a.name,
    a.location,
    a.price,
    COUNT(bd.attraction_id) AS total_bookings
FROM ATTRACTIONS a
JOIN BOOKING_DETAILS bd ON a.attraction_id = bd.attraction_id
JOIN BOOKINGS b ON bd.booking_id = b.booking_id
WHERE b.booking_date >= CURRENT_DATE - INTERVAL '2 months'
GROUP BY a.attraction_id, a.name, a.location, a.price
ORDER BY total_bookings DESC
LIMIT 4;
```

**Sample Output:**
| attraction_id | name          | location  | price | total_bookings |
|---------------|--------------|-----------|-------|----------------|
| 90            | Mega Karting | Petah Tikva| 150  | 25             |
| 74            | SkyJump      | Haifa      | 90   | 17             |
| ...           | ...          | ...       | ...   | ...            |
**Screenshot:**  
![top4_attractions_2months](imagesView/query9.png)

---
