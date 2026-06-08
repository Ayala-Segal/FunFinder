import csv
from faker import Faker
import random
import os

fake = Faker()

# Target configuration
TARGET_COUNT = 20000
TARGET_BOOKING_DETAILS = 500

# Path navigation
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.normpath(os.path.join(BASE_DIR, '..', 'DataImportFiles'))

def get_path(file_name):
    return os.path.join(DATA_DIR, file_name)

def get_existing_ids(file_name, id_col_index=0):
    """Reads existing IDs from a CSV file"""
    path = get_path(file_name)
    ids = []
    if not os.path.exists(path) or os.stat(path).st_size == 0:
        return ids
    with open(path, mode='r', encoding='utf-8') as f:
        reader = csv.reader(f)
        next(reader, None)
        for row in reader:
            if row:
                try:
                    ids.append(int(row[id_col_index]))
                except (ValueError, IndexError):
                    continue
    return ids


# ✅ Fixed categories (NO CSV FILE)
CATEGORY_IDS = [1, 2, 3, 4, 5]

CATEGORY_MAP = {
    1: 'All',
    2: 'Children',
    3: 'Adults',
    4: 'Family',
    5: 'Adventure'
}


def fill_users():
    path = get_path('users.csv')
    existing_ids = get_existing_ids('users.csv')
    current_count = len(existing_ids)

    if current_count >= TARGET_COUNT:
        print(f"✅ USERS table already contains {current_count} records.")
        return existing_ids

    needed = TARGET_COUNT - current_count
    last_id = max(existing_ids) if existing_ids else 0
    print(f"🔄 Adding {needed} users to: {path}")

    file_exists = os.path.exists(path)
    with open(path, mode='a', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        if not file_exists or os.stat(path).st_size == 0:
            writer.writerow(['user_id', 'name', 'email', 'avatar_url', 'created_at', 'password_hash'])

        for i in range(last_id + 1, last_id + needed + 1):
            writer.writerow([
                i,
                fake.name(),
                fake.unique.email(),
                fake.image_url(),
                fake.date_time_this_year(),
                fake.sha256()
            ])
            existing_ids.append(i)
    return existing_ids


def fill_attractions():
    path = get_path('attractions.csv')

    existing_ids = get_existing_ids('attractions.csv')
    current_count = len(existing_ids)

    if current_count >= TARGET_COUNT:
        print(f"✅ ATTRACTIONS table already contains {current_count} records.")
        return existing_ids

    needed = TARGET_COUNT - current_count
    last_id = max(existing_ids) if existing_ids else 0
    print(f"🔄 Adding {needed} attractions to: {path}")

    file_exists = os.path.exists(path)
    with open(path, mode='a', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        if not file_exists or os.stat(path).st_size == 0:
            writer.writerow([
                'attraction_id', 'name', 'short_description', 'full_description',
                'location', 'price', 'difficulty_id', 'duration',
                'target_audience', 'avg_rating', 'review_count',
                'main_image_url', 'category_id'
            ])

        for i in range(last_id + 1, last_id + needed + 1):
            writer.writerow([
                i,
                fake.company()[:150],
                fake.sentence()[:255],
                fake.text(max_nb_chars=500),
                fake.city(),
                round(random.uniform(10, 500), 2),
                random.choice([1, 2, 3, 4]),  # difficulty
                random.randint(30, 300),
                random.choice(['Families', 'Groups', 'Individuals']),
                round(random.uniform(1, 5), 2),
                random.randint(0, 1000),
                fake.image_url(),
                random.choice(CATEGORY_IDS)  # ✅ fixed categories
            ])
            existing_ids.append(i)

    return existing_ids


def fill_booking_details():
    path = get_path('booking_details.csv')
    booking_ids = get_existing_ids('bookings.csv')
    attraction_ids = get_existing_ids('attractions.csv')

    if not booking_ids or not attraction_ids:
        print("⚠️ Error: Cannot fill BOOKING_DETAILS. Ensure 'bookings.csv' and 'attractions.csv' have data.")
        return

    existing_pairs = set()
    if os.path.exists(path) and os.stat(path).st_size > 0:
        with open(path, mode='r', encoding='utf-8') as f:
            reader = csv.reader(f)
            next(reader, None)
            for row in reader:
                if len(row) >= 2:
                    existing_pairs.add((int(row[0]), int(row[1])))

    current_count = len(existing_pairs)
    if current_count >= TARGET_BOOKING_DETAILS:
        print(f"✅ BOOKING_DETAILS table already contains {current_count} records.")
        return

    needed = TARGET_BOOKING_DETAILS - current_count
    print(f"🔄 Adding {needed} records to: {path}")

    file_exists = os.path.exists(path)
    with open(path, mode='a', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        if not file_exists or os.stat(path).st_size == 0:
            writer.writerow(['booking_id', 'attraction_id', 'ticket_count'])

        added = 0
        attempts = 0
        while added < needed and attempts < needed * 10:
            b_id = random.choice(booking_ids)
            a_id = random.choice(attraction_ids)
            if (b_id, a_id) not in existing_pairs:
                writer.writerow([b_id, a_id, random.randint(1, 8)])
                existing_pairs.add((b_id, a_id))
                added += 1
            attempts += 1

    print(f"✨ Successfully added {added} records to BOOKING_DETAILS.")


if __name__ == "__main__":
    if not os.path.exists(DATA_DIR):
        print(f"❌ Error: Target folder does not exist: {DATA_DIR}")
    else:
        fill_users()
        fill_attractions()
        fill_booking_details()
        print("\n✨ Data generation process completed successfully!")