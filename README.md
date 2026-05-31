# שלב ג' – שאילתות מורכבות, מבטים (VIEWs) ואינטגרציה

### 1. תרשימי DSD/ERD

**מסך DSD:**  
![DSD](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/DSD.png)  
**מסך ERD:**  
![ERD](https://github.com/Ayala-Segal/FunFinder/blob/main/imagesView/ERD.png)

### 2. החלטות אינטגרציה

בשלב האינטגרציה חיברנו בין הטבלאות המרכזיות (ATTRACTIONS, BOOKINGS, USERS, CATEGORIES וכו') באמצעות מפתחות זרים, ויצרנו מבטים (VIEWs) שמאגדים שאילתות עיקריות לצורך דוחות וסטטיסטיקות. שמרנו על עקביות בהגדרות שמות, טיפוסי שדות ויחס תקינות, תוך הקפדה על ביצועים ואבטחת איכות הנתונים.

**דוגמאות להחלטות:**
- הוספה של מבט user_booking_stats לקבלת סיכום פעילות משתמש.
- יצירת מבט attractions_with_category לצירוף הקטגוריה לשם האטרקציה.
- טיפול במבטים שמבצעים חישובים ותצוגה מרוכזת בלבד לצרכי ניהול.

### 3. הסבר תהליך והפקודות

התהליך כלל יצירת המבטים על בסיס טבלאות קיימות (עם פקודת CREATE VIEW), שימוש בשאילתות SELECT מורכבות, ובדיקות נתונים עם SELECT * ממבטים ודוחות. הפקודות בוצעו ישירות ב-DB, וכאן מובאות דוגמאות נבחרות עם הסברים.

---

### 4. דוגמאות מבט (VIEW) - תיאור, קוד ופלט

#### דוגמה: View – User Booking Stats

**תיאור:**  
מבט המאגד סטטיסטיקת הזמנות עבור כל משתמש – כולל שם המשתמש, מספר ההזמנות וההוצאה הכוללת.

**יצירת המבט:**
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

**שליפת מידע מהמבט (10 שורות לדוגמה):**
```sql
SELECT * FROM user_booking_stats LIMIT 10;
```
**פלט לדוגמה:**
| user_id | full_name     | total_bookings | total_spent |
|---------|---------------|----------------|-------------|
| 1       | יוסי כהן      | 3              | 344.00      |
| 2       | רות לוי       | 2              | 170.00      |
| ...     | ...           | ...            | ...         |

---

#### דוגמה: View – Attractions With Category

**תיאור:**  
מבט המציג את האטרקציות כולל פרטי הקטגוריה לכל אטרקציה.

**יצירת המבט:**
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

**שליפת מידע מהמבט (10 שורות לדוגמה):**
```sql
SELECT * FROM attractions_with_category LIMIT 10;
```
**פלט לדוגמה:**
| attraction_id | attraction_name | category_name | location     | price | avg_rating |
|---------------|----------------|--------------|-------------|-------|------------|
| 5             | פארק מים       | משפחתי        | אילת        | 110   | 4.7        |
| 7             | טיפוס הרים     | אקסטרים       | ירושלים     | 160   | 4.2        |
| ...           | ...            | ...          | ...         | ...   | ...        |

---

### 5. שאילתות לדוגמה על מבט – תיאור, קוד ופלט

#### דוגמה: סך ההוצאות למשתמשים בולטים

**תיאור:**  
מציאת המשתמשים בעלי ההוצאה הגבוהה ביותר לפי user_booking_stats.

**קוד:**
```sql
SELECT full_name, total_spent
FROM user_booking_stats
ORDER BY total_spent DESC
LIMIT 5;
```

**פלט:**
| full_name    | total_spent |
|--------------|-------------|
| רות לוי      | 542.00      |
| דני צרפתי    | 483.00      |
| ...          | ...         |

---

#### דוגמה: אטרקציות הכי פופולריות לפי category

**תיאור:**  
קבלת רשימה של אטרקציות בקטגוריה "אקסטרים" מתוך המבט attractions_with_category.

**קוד:**
```sql
SELECT attraction_name, location, price
FROM attractions_with_category
WHERE category_name = 'אקסטרים'
LIMIT 10;
```

**פלט:**
| attraction_name | location        | price |
|-----------------|----------------|-------|
| טיפוס הרים      | ירושלים        | 160   |
| אומגה יער       | הגליל העליון   | 130   |
| ...             | ...            | ...   |

---

**הערות:**  
- יש להוסיף קישורים לתמונות מסך של המבט או הפלטים לפי הצורך.
- אפשר להוריד ולהעתיק פלט מהמערכת ולמקם אותו בסעיף הנכון.

---

בהצלחה!
