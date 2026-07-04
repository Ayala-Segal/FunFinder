# שלב ה — GUI Application

**ExploreEase** — A full-stack web application for the FunFinder attraction booking database.

## Stack
- **Backend**: Python 3.10+ · Flask 2.3 · psycopg2
- **Frontend**: Bootstrap 5.3 · Bootstrap Icons · Jinja2 templates
- **Database**: PostgreSQL (Docker container from Stage 3)

## Setup

### 1. Prerequisites
- Python 3.10+
- Docker + Docker Compose (for the database)
- The database from Stages 1–4 must already be running

### 2. Start the database
```bash
cd ..          # root of the repo
docker-compose up -d
```

### 3. Install Python dependencies
```bash
cd "שלב ה"
pip install -r requirements.txt
```

### 4. Configure environment
The `.env` file is pre-configured:
```
DB_HOST=localhost
DB_PORT=5432
DB_NAME_SECRET=dbnew
DB_USER_SECRET=Ayelet
DB_PASSWORD_SECRET=Ayelet1!
```

### 5. Run the application
```bash
python run.py
```

Open your browser at **http://localhost:5000**

## Login Credentials

| Role           | Email                 | Password    |
|----------------|-----------------------|-------------|
| Admin          | admin@exploreease.com | Admin1234!  |
| User (Guest)   | user1@example.com     | Pwd000001   |

> There is no self-registration page. Most seeded users have bcrypt-hashed passwords (unusable for login, since login compares plain text). The Guest account above is a seeded user with a known plain-text password, kept specifically for testing the regular-user flow. Admins can create additional regular users from `Admin → Users → Add`.

## Features

### Regular Users
- Browse and search attractions (by category, difficulty, keyword)
- View attraction details with tickets and reviews
- Book an attraction
- View own bookings
- Write reviews

### Admin
- All of the above, plus:
- Full CRUD for all 11 tables
- Run Stage 2 SQL queries
- Execute Stage 4 PL/pgSQL functions and procedures with visible results

## Folder Structure
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
