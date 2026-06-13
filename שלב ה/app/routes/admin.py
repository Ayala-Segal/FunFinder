from flask import Blueprint, render_template, request, redirect, url_for, flash
from app.db import query, query_one, execute
from app.decorators import admin_required

admin_bp = Blueprint('admin', __name__)


# ── Dashboard ─────────────────────────────────────────────────────────────────
@admin_bp.route('/admin')
@admin_required
def dashboard():
    counts = {
        'users':           query_one("SELECT COUNT(*) AS n FROM users")['n'],
        'attractions':     query_one("SELECT COUNT(*) AS n FROM attractions")['n'],
        'bookings':        query_one("SELECT COUNT(*) AS n FROM bookings")['n'],
        'reviews':         query_one("SELECT COUNT(*) AS n FROM reviews")['n'],
        'tickets':         query_one("SELECT COUNT(*) AS n FROM ticket")['n'],
        'payments':        query_one("SELECT COUNT(*) AS n FROM payment")['n'],
        'categories':      query_one("SELECT COUNT(*) AS n FROM categories")['n'],
        'difficulties':    query_one("SELECT COUNT(*) AS n FROM difficulty_levels")['n'],
        'gallery':         query_one("SELECT COUNT(*) AS n FROM gallery_images")['n'],
        'booking_details': query_one("SELECT COUNT(*) AS n FROM booking_details")['n'],
    }
    return render_template('admin/dashboard.html', counts=counts)


# ══════════════════════════════════════════════════════════════════════════════
# USERS
# ══════════════════════════════════════════════════════════════════════════════
@admin_bp.route('/admin/users')
@admin_required
def users_list():
    users = query("""
        SELECT user_id, name, email, phone, country, created_at, total_bookings
        FROM users ORDER BY user_id
    """)
    return render_template('admin/users/list.html', users=users)


@admin_bp.route('/admin/users/add', methods=['GET', 'POST'])
@admin_required
def users_add():
    if request.method == 'POST':
        try:
            max_id = query_one("SELECT COALESCE(MAX(user_id),0)+1 AS nid FROM users")
            execute("""
                INSERT INTO users (user_id, name, email, created_at,
                                   password_hash, phone, country)
                VALUES (%s,%s,%s,NOW(),%s,%s,%s)
            """, (max_id['nid'],
                  request.form['name'],
                  request.form['email'],
                  request.form['password'],
                  request.form.get('phone') or None,
                  request.form.get('country') or None))
            flash('User added.', 'success')
            return redirect(url_for('admin.users_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    return render_template('admin/users/form.html', user=None)


@admin_bp.route('/admin/users/<int:uid>/edit', methods=['GET', 'POST'])
@admin_required
def users_edit(uid):
    user = query_one("SELECT * FROM users WHERE user_id = %s", (uid,))
    if not user:
        flash('User not found.', 'warning')
        return redirect(url_for('admin.users_list'))
    if request.method == 'POST':
        try:
            pw = request.form.get('password', '').strip()
            if pw:
                execute("""
                    UPDATE users SET name=%s, email=%s, password_hash=%s,
                      phone=%s, country=%s WHERE user_id = %s
                """, (request.form['name'], request.form['email'], pw,
                      request.form.get('phone') or None,
                      request.form.get('country') or None, uid))
            else:
                execute("""
                    UPDATE users SET name=%s, email=%s, phone=%s, country=%s
                    WHERE user_id = %s
                """, (request.form['name'], request.form['email'],
                      request.form.get('phone') or None,
                      request.form.get('country') or None, uid))
            flash('User updated.', 'success')
            return redirect(url_for('admin.users_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    return render_template('admin/users/form.html', user=user)


@admin_bp.route('/admin/users/<int:uid>/delete', methods=['POST'])
@admin_required
def users_delete(uid):
    try:
        execute("DELETE FROM users WHERE user_id = %s", (uid,))
        flash('User deleted.', 'success')
    except Exception as e:
        flash(f'Cannot delete: {e}', 'danger')
    return redirect(url_for('admin.users_list'))


# ══════════════════════════════════════════════════════════════════════════════
# CATEGORIES
# ══════════════════════════════════════════════════════════════════════════════
@admin_bp.route('/admin/categories')
@admin_required
def categories_list():
    categories = query("SELECT * FROM categories ORDER BY category_id")
    return render_template('admin/categories/list.html', categories=categories)


@admin_bp.route('/admin/categories/add', methods=['GET', 'POST'])
@admin_required
def categories_add():
    if request.method == 'POST':
        try:
            max_id = query_one("SELECT COALESCE(MAX(category_id),0)+1 AS nid FROM categories")
            execute("INSERT INTO categories (category_id, name) VALUES (%s,%s)",
                    (max_id['nid'], request.form['name']))
            flash('Category added.', 'success')
            return redirect(url_for('admin.categories_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    return render_template('admin/categories/form.html', category=None)


@admin_bp.route('/admin/categories/<int:cid>/edit', methods=['GET', 'POST'])
@admin_required
def categories_edit(cid):
    category = query_one("SELECT * FROM categories WHERE category_id = %s", (cid,))
    if not category:
        flash('Not found.', 'warning')
        return redirect(url_for('admin.categories_list'))
    if request.method == 'POST':
        try:
            execute("UPDATE categories SET name=%s WHERE category_id=%s",
                    (request.form['name'], cid))
            flash('Category updated.', 'success')
            return redirect(url_for('admin.categories_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    return render_template('admin/categories/form.html', category=category)


@admin_bp.route('/admin/categories/<int:cid>/delete', methods=['POST'])
@admin_required
def categories_delete(cid):
    try:
        execute("DELETE FROM categories WHERE category_id = %s", (cid,))
        flash('Deleted.', 'success')
    except Exception as e:
        flash(f'Cannot delete: {e}', 'danger')
    return redirect(url_for('admin.categories_list'))


# ══════════════════════════════════════════════════════════════════════════════
# DIFFICULTY LEVELS
# ══════════════════════════════════════════════════════════════════════════════
@admin_bp.route('/admin/difficulties')
@admin_required
def difficulties_list():
    difficulties = query("SELECT * FROM difficulty_levels ORDER BY difficulty_id")
    return render_template('admin/difficulties/list.html', difficulties=difficulties)


@admin_bp.route('/admin/difficulties/add', methods=['GET', 'POST'])
@admin_required
def difficulties_add():
    if request.method == 'POST':
        try:
            max_id = query_one("SELECT COALESCE(MAX(difficulty_id),0)+1 AS nid FROM difficulty_levels")
            execute("INSERT INTO difficulty_levels (difficulty_id, name) VALUES (%s,%s)",
                    (max_id['nid'], request.form['name']))
            flash('Difficulty level added.', 'success')
            return redirect(url_for('admin.difficulties_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    return render_template('admin/difficulties/form.html', difficulty=None)


@admin_bp.route('/admin/difficulties/<int:did>/edit', methods=['GET', 'POST'])
@admin_required
def difficulties_edit(did):
    difficulty = query_one("SELECT * FROM difficulty_levels WHERE difficulty_id = %s", (did,))
    if not difficulty:
        flash('Not found.', 'warning')
        return redirect(url_for('admin.difficulties_list'))
    if request.method == 'POST':
        try:
            execute("UPDATE difficulty_levels SET name=%s WHERE difficulty_id=%s",
                    (request.form['name'], did))
            flash('Updated.', 'success')
            return redirect(url_for('admin.difficulties_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    return render_template('admin/difficulties/form.html', difficulty=difficulty)


@admin_bp.route('/admin/difficulties/<int:did>/delete', methods=['POST'])
@admin_required
def difficulties_delete(did):
    try:
        execute("DELETE FROM difficulty_levels WHERE difficulty_id = %s", (did,))
        flash('Deleted.', 'success')
    except Exception as e:
        flash(f'Cannot delete: {e}', 'danger')
    return redirect(url_for('admin.difficulties_list'))


# ══════════════════════════════════════════════════════════════════════════════
# TICKETS
# ══════════════════════════════════════════════════════════════════════════════
@admin_bp.route('/admin/tickets')
@admin_required
def tickets_list():
    tickets = query("""
        SELECT t.ticket_id, t.ticket_type, t.price, t.valid_date,
               t.available_quantity, a.name AS attraction_name
        FROM   ticket t
        JOIN   attractions a ON a.attraction_id = t.attraction_id
        ORDER  BY t.ticket_id
    """)
    return render_template('admin/tickets/list.html', tickets=tickets)


@admin_bp.route('/admin/tickets/add', methods=['GET', 'POST'])
@admin_required
def tickets_add():
    attractions = query("SELECT attraction_id, name FROM attractions ORDER BY name")
    if request.method == 'POST':
        try:
            max_id = query_one("SELECT COALESCE(MAX(ticket_id),0)+1 AS nid FROM ticket")
            execute("""
                INSERT INTO ticket (ticket_id, attraction_id, price, valid_date,
                                    ticket_type, available_quantity)
                VALUES (%s,%s,%s,%s,%s,%s)
            """, (max_id['nid'], request.form['attraction_id'],
                  request.form['price'],
                  request.form['valid_date'] or None,
                  request.form['ticket_type'],
                  request.form.get('available_quantity') or 0))
            flash('Ticket added.', 'success')
            return redirect(url_for('admin.tickets_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    return render_template('admin/tickets/form.html', ticket=None, attractions=attractions)


@admin_bp.route('/admin/tickets/<int:tid>/edit', methods=['GET', 'POST'])
@admin_required
def tickets_edit(tid):
    ticket = query_one("SELECT * FROM ticket WHERE ticket_id = %s", (tid,))
    attractions = query("SELECT attraction_id, name FROM attractions ORDER BY name")
    if not ticket:
        flash('Not found.', 'warning')
        return redirect(url_for('admin.tickets_list'))
    if request.method == 'POST':
        try:
            execute("""
                UPDATE ticket SET attraction_id=%s, price=%s, valid_date=%s,
                  ticket_type=%s, available_quantity=%s WHERE ticket_id=%s
            """, (request.form['attraction_id'], request.form['price'],
                  request.form['valid_date'] or None,
                  request.form['ticket_type'],
                  request.form.get('available_quantity') or 0, tid))
            flash('Ticket updated.', 'success')
            return redirect(url_for('admin.tickets_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    return render_template('admin/tickets/form.html', ticket=ticket, attractions=attractions)


@admin_bp.route('/admin/tickets/<int:tid>/delete', methods=['POST'])
@admin_required
def tickets_delete(tid):
    try:
        execute("DELETE FROM ticket WHERE ticket_id = %s", (tid,))
        flash('Deleted.', 'success')
    except Exception as e:
        flash(f'Cannot delete: {e}', 'danger')
    return redirect(url_for('admin.tickets_list'))


# ══════════════════════════════════════════════════════════════════════════════
# PAYMENTS
# ══════════════════════════════════════════════════════════════════════════════
@admin_bp.route('/admin/payments')
@admin_required
def payments_list():
    payments = query("""
        SELECT p.payment_id, p.booking_id, p.amount, p.payment_date,
               b.booking_date, b.status, u.name AS user_name
        FROM   payment  p
        JOIN   bookings b ON b.booking_id = p.booking_id
        JOIN   users    u ON u.user_id    = b.user_id
        ORDER  BY p.payment_id DESC
    """)
    return render_template('admin/payments/list.html', payments=payments)


@admin_bp.route('/admin/payments/add', methods=['GET', 'POST'])
@admin_required
def payments_add():
    bookings = query("""
        SELECT b.booking_id, b.booking_date, b.status, u.name AS user_name
        FROM bookings b JOIN users u ON u.user_id = b.user_id
        ORDER BY b.booking_id DESC
    """)
    if request.method == 'POST':
        try:
            max_id = query_one("SELECT COALESCE(MAX(payment_id),0)+1 AS nid FROM payment")
            execute("""
                INSERT INTO payment (payment_id, booking_id, amount, payment_date)
                VALUES (%s,%s,%s,NOW())
            """, (max_id['nid'], request.form['booking_id'], request.form['amount']))
            flash('Payment added.', 'success')
            return redirect(url_for('admin.payments_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    return render_template('admin/payments/form.html', payment=None, bookings=bookings)


@admin_bp.route('/admin/payments/<int:pid>/edit', methods=['GET', 'POST'])
@admin_required
def payments_edit(pid):
    payment = query_one("SELECT * FROM payment WHERE payment_id = %s", (pid,))
    bookings = query("""
        SELECT b.booking_id, b.booking_date, b.status, u.name AS user_name
        FROM bookings b JOIN users u ON u.user_id = b.user_id
        ORDER BY b.booking_id DESC
    """)
    if not payment:
        flash('Not found.', 'warning')
        return redirect(url_for('admin.payments_list'))
    if request.method == 'POST':
        try:
            execute("UPDATE payment SET booking_id=%s, amount=%s WHERE payment_id=%s",
                    (request.form['booking_id'], request.form['amount'], pid))
            flash('Payment updated.', 'success')
            return redirect(url_for('admin.payments_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    return render_template('admin/payments/form.html', payment=payment, bookings=bookings)


@admin_bp.route('/admin/payments/<int:pid>/delete', methods=['POST'])
@admin_required
def payments_delete(pid):
    try:
        execute("DELETE FROM payment WHERE payment_id = %s", (pid,))
        flash('Deleted.', 'success')
    except Exception as e:
        flash(f'Cannot delete: {e}', 'danger')
    return redirect(url_for('admin.payments_list'))


# ══════════════════════════════════════════════════════════════════════════════
# GALLERY IMAGES
# ══════════════════════════════════════════════════════════════════════════════
@admin_bp.route('/admin/gallery')
@admin_required
def gallery_list():
    gallery = query("""
        SELECT g.image_id, g.image_url, g.caption, g.attraction_id,
               a.name AS attraction_name
        FROM   gallery_images g
        JOIN   attractions    a ON a.attraction_id = g.attraction_id
        ORDER  BY g.image_id
    """)
    return render_template('admin/gallery/list.html', gallery=gallery)


@admin_bp.route('/admin/gallery/add', methods=['GET', 'POST'])
@admin_required
def gallery_add():
    attractions = query("SELECT attraction_id, name FROM attractions ORDER BY name")
    if request.method == 'POST':
        try:
            max_id = query_one("SELECT COALESCE(MAX(image_id),0)+1 AS nid FROM gallery_images")
            execute("""
                INSERT INTO gallery_images (image_id, image_url, caption, attraction_id)
                VALUES (%s,%s,%s,%s)
            """, (max_id['nid'], request.form['image_url'],
                  request.form.get('caption') or None,
                  request.form['attraction_id']))
            flash('Image added.', 'success')
            return redirect(url_for('admin.gallery_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    return render_template('admin/gallery/form.html', image=None, attractions=attractions)


@admin_bp.route('/admin/gallery/<int:gid>/edit', methods=['GET', 'POST'])
@admin_required
def gallery_edit(gid):
    image = query_one("SELECT * FROM gallery_images WHERE image_id = %s", (gid,))
    attractions = query("SELECT attraction_id, name FROM attractions ORDER BY name")
    if not image:
        flash('Not found.', 'warning')
        return redirect(url_for('admin.gallery_list'))
    if request.method == 'POST':
        try:
            execute("""
                UPDATE gallery_images SET image_url=%s, caption=%s, attraction_id=%s
                WHERE image_id=%s
            """, (request.form['image_url'],
                  request.form.get('caption') or None,
                  request.form['attraction_id'], gid))
            flash('Updated.', 'success')
            return redirect(url_for('admin.gallery_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    return render_template('admin/gallery/form.html', image=image, attractions=attractions)


@admin_bp.route('/admin/gallery/<int:gid>/delete', methods=['POST'])
@admin_required
def gallery_delete(gid):
    try:
        execute("DELETE FROM gallery_images WHERE image_id = %s", (gid,))
        flash('Deleted.', 'success')
    except Exception as e:
        flash(f'Cannot delete: {e}', 'danger')
    return redirect(url_for('admin.gallery_list'))


# ══════════════════════════════════════════════════════════════════════════════
# BOOKING AUDIT (read-only)
# ══════════════════════════════════════════════════════════════════════════════
@admin_bp.route('/admin/audit')
@admin_required
def audit_list():
    audit = query("""
        SELECT audit_id, booking_id, user_id, old_status, new_status,
               old_amount, new_amount, changed_by, change_type, change_time, notes
        FROM   booking_audit
        ORDER  BY change_time DESC
        LIMIT  200
    """)
    return render_template('admin/audit/list.html', audit=audit)


# ── Admin proxy routes for cross-blueprint links ──────────────────────────────
@admin_bp.route('/admin/attractions-list')
@admin_required
def attractions_list():
    return redirect(url_for('attractions.admin_list'))


@admin_bp.route('/admin/bookings-list')
@admin_required
def bookings_list():
    return redirect(url_for('bookings.admin_list'))


@admin_bp.route('/admin/reviews-list')
@admin_required
def reviews_list():
    return redirect(url_for('reviews.admin_list'))


@admin_bp.route('/admin/booking-details-list')
@admin_required
def booking_details_list():
    return redirect(url_for('bookings.bd_list'))
