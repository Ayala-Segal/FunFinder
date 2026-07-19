from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from app.config import ADMIN_EMAIL, ADMIN_PASSWORD, ADMIN_NAME
from app.db import query_one, execute

auth_bp = Blueprint('auth', __name__)


@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if 'user_id' in session:
        return redirect(url_for('home.index'))

    if request.method == 'POST':
        email    = request.form.get('email', '').strip()
        password = request.form.get('password', '').strip()

        if not email or not password:
            flash('Please enter both email and password.', 'danger')
            return render_template('auth/login.html')

        # --- Admin check ---
        if email == ADMIN_EMAIL and password == ADMIN_PASSWORD:
            session.clear()
            session['user_id']   = 0
            session['user_name'] = ADMIN_NAME
            session['user_email']= ADMIN_EMAIL
            session['is_admin']  = True
            # Give the admin a real USERS row (id 0) so booking/review FKs succeed
            # when browsing the site as a regular user. ON CONFLICT DO NOTHING (with
            # no target) skips on *any* constraint clash (id or email), not just the
            # primary key, so a stray row can never turn login into a 500.
            try:
                execute("""
                    INSERT INTO users (user_id, name, email, created_at, password_hash)
                    VALUES (0, %s, %s, NOW(), %s)
                    ON CONFLICT DO NOTHING
                """, (ADMIN_NAME, ADMIN_EMAIL, ADMIN_PASSWORD))
            except Exception:
                pass
            return redirect(url_for('auth.admin_choice'))

        # --- Regular user check (plain password_hash comparison) ---
        user = query_one(
            "SELECT user_id, name, email, password_hash FROM users WHERE email = %s",
            (email,)
        )
        if user and user['password_hash'] == password:
            session.clear()
            session['user_id']   = user['user_id']
            session['user_name'] = user['name']
            session['user_email']= user['email']
            session['is_admin']  = False
            flash(f"Welcome back, {user['name']}!", 'success')
            return redirect(url_for('home.index'))

        flash('Invalid email or password.', 'danger')

    return render_template('auth/login.html')


@auth_bp.route('/register', methods=['GET', 'POST'])
def register():
    if 'user_id' in session:
        return redirect(url_for('home.index'))

    if request.method == 'POST':
        name     = request.form.get('name', '').strip()
        email    = request.form.get('email', '').strip()
        password = request.form.get('password', '').strip()
        phone    = request.form.get('phone', '').strip() or None
        country  = request.form.get('country', '').strip() or None

        if not name or not email or not password:
            flash('Name, email and password are required.', 'danger')
            return render_template('auth/register.html', name=name, email=email,
                                    phone=phone, country=country)

        if email == ADMIN_EMAIL:
            flash('This email is reserved. Please use a different one.', 'danger')
            return render_template('auth/register.html', name=name, email=email,
                                    phone=phone, country=country)

        existing = query_one("SELECT user_id FROM users WHERE email = %s", (email,))
        if existing:
            flash('An account with this email already exists. Please sign in.', 'danger')
            return render_template('auth/register.html', name=name, email=email,
                                    phone=phone, country=country)

        max_id = query_one("SELECT COALESCE(MAX(user_id), 0) + 1 AS nid FROM users")
        execute("""
            INSERT INTO users (user_id, name, email, created_at, password_hash, phone, country)
            VALUES (%s, %s, %s, NOW(), %s, %s, %s)
        """, (max_id['nid'], name, email, password, phone, country))

        session.clear()
        session['user_id']   = max_id['nid']
        session['user_name'] = name
        session['user_email']= email
        session['is_admin']  = False
        flash(f'Welcome to ExploreEase, {name}!', 'success')
        return redirect(url_for('home.index'))

    return render_template('auth/register.html', name='', email='', phone='', country='')


@auth_bp.route('/admin-choice')
def admin_choice():
    if not session.get('is_admin'):
        return redirect(url_for('auth.login'))
    return render_template('auth/admin_choice.html')


@auth_bp.route('/logout')
def logout():
    session.clear()
    flash('You have been logged out.', 'info')
    return redirect(url_for('auth.login'))
