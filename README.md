# Step 3 – Complex Queries, VIEWs, and Integration

### 1. DSD/ERD Diagrams

**NewDSD Screen:**  
![NewDSD](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/NewDSD.png)  
**NewERD Screen:**  
![NewERD](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/NewERD.png)  
**Combined Diagram:**  
![Combined](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/Combined.png)

### 2. Integration Decisions

During the integration phase, we connected the main tables (ATTRACTIONS, BOOKINGS, USERS, CATEGORIES, etc.) using foreign keys, and created views (VIEWs) to combine and calculate important data for analytics and management needs.

**Example decisions:**
- Added the view `user_booking_stats` for summary of user activity.
- Created the view `attractions_with_category` to join each attraction with its category.
- Views are used for aggregate calculations and centralized management reporting.

### 3. Process Explanation and Commands

The process included creating the views based on existing tables (using CREATE VIEW commands), writing complex SELECT queries, and checking data with SQL queries for appropriate results.

---

### 4. Example Views – Description, Code, and Output

#### Example: View – User Booking Stats

**Description:**  
A view that summarizes booking statistics for each user – including the user's full name, number of bookings, and total spend.

**View Creation:**
```sql
CREATE VIEW user_booking_stats AS
SELECT
    u.user_id,
    u.full_name,
    COUNT(b.booking_id) AS total_bookings,
    SUM(bd.ticket_count * a.price) AS total_spent
FROM USERS u
LEFT JOIN BOOKINGS b ON u.user_id = b.user_id
LEFT JOIN BOOKING_DETAILS bd ON b.booking_id = bd.booking_id
LEFT JOIN ATTRACTIONS a ON bd.attraction_id = a.attraction_id
GROUP BY u.user_id, u.full_name;
```

**Fetching from the view (sample of 10 rows):**
```sql
SELECT * FROM user_booking_stats LIMIT 10;
```
**Sample Output:**
| user_id | full_name     | total_bookings | total_spent |
|---------|---------------|----------------|-------------|
| 1       | Yossi Cohen   | 3              | 344.00      |
| 2       | Ruth Levi     | 2              | 170.00      |
| ...     | ...           | ...            | ...         |

---

#### Example: View – Attractions With Category

**Description:**  
A view that shows attractions including the category details for each attraction.

**View Creation:**
```sql
CREATE VIEW attractions_with_category AS
SELECT
    a.attraction_id,
    a.name AS attraction_name,
    c.name AS category_name,
    a.location,
    a.price,
    a.avg_rating
FROM ATTRACTIONS a
JOIN CATEGORIES c ON a.category_id = c.category_id;
```

**Fetching from the view (sample of 10 rows):**
```sql
SELECT * FROM attractions_with_category LIMIT 10;
```
**Sample Output:**
| attraction_id | attraction_name | category_name | location     | price | avg_rating |
|---------------|----------------|--------------|-------------|-------|------------|
| 5             | Water Park     | Family       | Eilat       | 110   | 4.7        |
| 7             | Mountain Climb | Extreme      | Jerusalem   | 160   | 4.2        |
| ...           | ...            | ...          | ...         | ...   | ...        |

---

### 5. Example Queries on Views – Description, Code, and Output

#### Example: Top Users by Total Spending

**Description:**  
Find users with the highest spending according to `user_booking_stats`.

**Code:**
```sql
SELECT full_name, total_spent
FROM user_booking_stats
ORDER BY total_spent DESC
LIMIT 5;
```

**Sample Output:**
| full_name    | total_spent |
|--------------|-------------|
| Ruth Levi    | 542.00      |
| Danny Tzarfati | 483.00    |
| ...          | ...         |

---

#### Example: Most Popular Attractions by Category

**Description:**  
Retrieve a list of attractions in the 'Extreme' category from `attractions_with_category` view.

**Code:**
```sql
SELECT attraction_name, location, price
FROM attractions_with_category
WHERE category_name = 'Extreme'
LIMIT 10;
```

**Sample Output:**
| attraction_name | location        | price |
|-----------------|----------------|-------|
| Mountain Climb  | Jerusalem      | 160   |
| Omega Forest    | Upper Galilee  | 130   |
| ...             | ...            | ...   |

---

**Notes:**  
- Add links to screenshots of the view or outputs as needed.
- You can download and copy results from the system and place them in the appropriate section.

---

Good luck!
