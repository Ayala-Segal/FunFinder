import psycopg2
from psycopg2 import extras
from faker import Faker
import csv
import os

from dotenv import load_dotenv
load_dotenv("../.env")# --- הגדרות חיבור ---
print(f"DEBUG: Connecting as user: {os.getenv('DB_USER_SECRET')}")
DB_PARAMS = {
    "host": "127.0.0.1",
    "database": os.getenv("DB_NAME_SECRET"),
    "user": os.getenv("DB_USER_SECRET"), 
    "password": os.getenv("DB_PASSWORD_SECRET"), 
    "port": "5432"
}


fake = Faker()

def get_db_connection():
    return psycopg2.connect(**DB_PARAMS)

# --- פונקציה גנרית להרצה מהירה של אלפי שורות ---
def execute_bulk_insert(query, data_list):
    conn = get_db_connection()
    cur = conn.cursor()
    try:
        # שימוש ב-execute_batch להרצה מהירה מאוד (חשוב ל-20,000 שורות)
        extras.execute_batch(cur, query, data_list, page_size=1000)
        conn.commit()
        print(f"✓ הוכנסו {len(data_list)} רשומות בהצלחה.")
    except Exception as e:
        print(f"✘ שגיאה: {e}")
        conn.rollback()
    finally:
        cur.close()
        conn.close()

# --- פונקציה לביטול/החזרת אילוצים (Constraints) ---
def toggle_constraints(enable=True):
    action = "ENABLE" if enable else "DISABLE"
    tables = ["USERS", "CATEGORIES", "ATTRACTIONS", "REVIEWS", "BOOKINGS"]
    conn = get_db_connection()
    cur = conn.cursor()
    for table in tables:
        cur.execute(f"ALTER TABLE {table} {action} TRIGGER ALL;")
    conn.commit()
    cur.close()
    conn.close()
    print(f"--- כל הטריגרים הועברו למצב: {action} ---")

# --- פונקציה לקריאת CSV (מ-Mockaroo) ---
def load_csv_data(file_path):
    data = []
    if not os.path.exists(file_path):
        print(f"קובץ {file_path} לא נמצא, מדלג...")
        return []
    with open(file_path, mode='r', encoding='utf-8') as f:
        reader = csv.reader(f)
        next(reader) # מדלג על הכותרות
        for row in reader:
            data.append(tuple(row))
    return data

# --- הרצה מרכזית ---
if __name__ == "__main__":
    # 1. ביטול בדיקות קשרים כדי ששום דבר לא ייתקע
    toggle_constraints(enable=False)

    # 2. אכלוס קטגוריות (500 רשומות - דוגמה ליצירה אוטומטית)
    print("מכניס קטגוריות...")
    cat_query = "INSERT INTO CATEGORIES (category_id, name, icon_identifier) VALUES (%s, %s, %s) ON CONFLICT DO NOTHING"
    cat_data = [(i, fake.word(), fake.slug()) for i in range(1002, 1502)]
    execute_bulk_insert(cat_query, cat_data)

    # 3. אכלוס משתמשים (1,000 רשומות)
    print("מכניס 1,000 משתמשים...")
    user_query = "INSERT INTO USERS (user_id, name, email, avatar_url, created_at, password_hash) VALUES (%s, %s, %s, %s, %s, %s) ON CONFLICT DO NOTHING"
    user_data = [(i, fake.name(), fake.unique.email(), fake.image_url(), fake.date_this_year(), fake.sha256()) for i in range(2000, 3000)]
    execute_bulk_insert(user_query, user_data)

    # 4. אכלוס אטרקציות (קריאה מקובץ CSV של Mockaroo)
    print("מכניס אטרקציות מתוך CSV...")
    attr_query = """INSERT INTO ATTRACTIONS (
    attraction_id, name, short_description, full_description,
    location, price, difficulty_level, duration,
    target_audience, avg_rating, review_count,
    main_image_url, category_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s) ON CONFLICT DO NOTHING"""
    # ודאי שהקובץ נמצא באותה תיקייה של הסקריפט
    attr_csv_data = load_csv_data('attractions.csv') 
    if attr_csv_data:
        execute_bulk_insert(attr_query, attr_csv_data)

    # 5. החזרת בדיקות קשרים
    toggle_constraints(enable=True)
    print("--- הסקריפט הסתיים בהצלחה! ---")
