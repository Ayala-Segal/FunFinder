import os
from dotenv import load_dotenv

# Load .env from the שלב ה folder
load_dotenv(os.path.join(os.path.dirname(__file__), '..', '.env'))

DB_HOST     = os.getenv('DB_HOST',         'db')
DB_PORT     = int(os.getenv('DB_PORT',     '5432'))
DB_NAME     = os.getenv('DB_NAME_SECRET',  'dbnew')
DB_USER     = os.getenv('DB_USER_SECRET',  'Ayelet')
DB_PASSWORD = os.getenv('DB_PASSWORD_SECRET', 'Ayelet1!')

SECRET_KEY     = os.getenv('SECRET_KEY', 'exploreease-stage5-secret-2024')
ADMIN_EMAIL    = os.getenv('ADMIN_EMAIL',    'admin@exploreease.com')
ADMIN_PASSWORD = os.getenv('ADMIN_PASSWORD', 'Admin1234!')
ADMIN_NAME     = 'Administrator'
