from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from app.db import query, query_one, execute
from app.decorators import login_required, admin_required

bookings_bp = Blueprint('bookings', __name__)


def _users():
    return query("SELECT user_id, name FROM users ORDER BY name")

def _attractions():
    return query("SELECT attraction_id, name FROM attractions ORDER BY name")

def _status_options():
    return ['pending', 'confirmed', 'completed', 'cancelled', 'vip', 'partial']


# ── User: My Bookings ─────────────────────────────────────────────────────────
@bookings_bp.route('/my-bookings')
@login_required
def my_bookings():
    uid = session['user_id']
    bookings = query("""
        SELECT b.booking_id, b.booking_date, b.status,
               b.total_price, b.quantity, b.created_at,
               b.contact_phone,
               STRING_AGG(a.name, ', ') AS attractions
        FROM   bookings b
        LEFT JOIN booking_details bd ON bd.booking_id   = b.booking_id
        LEFT JOIN attractions      a  ON a.attraction_id = bd.attraction_id
        WHERE  b.user_id = %s
        GROUP  BY b.booking_id
        ORDER  BY b.booking_date DESC
    """, (uid,))
    return render_template('bookings/my_bookings.html', bookings=bookings)


# ── User: Add Booking ─────────────────────────────────────────────────────────
@bookings_bp.route('/book/<int:aid>', methods=['GET', 'POST'])
@login_required
def add_booking(aid):
    from datetime import date
    attraction = query_one(
        "SELECT attraction_id, name, price FROM attractions WHERE attraction_id = %s", (aid,))
    if not attraction:
        flash('Attraction not found.', 'warning')
        return redirect(url_for('attractions.list_attractions'))

    if request.method == 'POST':
        try:
            qty           = int(request.form.get('quantity', 1))
            booking_date  = request.form['booking_date']
            contact_phone = request.form.get('contact_phone', '').strip() or None
            uid           = session['user_id']
            total_price   = float(attraction['price']) * qty

            max_id = query_one("SELECT COALESCE(MAX(booking_id), 0) + 1 AS nid FROM bookings")
            bid    = max_id['nid']

            execute("""
                INSERT INTO bookings
                  (booking_id, booking_date, status, contact_name, contact_email,
                   created_at, contact_phone, user_id, total_price, quantity)
                VALUES (%s, %s, 'pending', %s, %s, NOW(), %s, %s, %s, %s)
            """, (bid, booking_date,
                  session.get('user_name', ''), session.get('user_email', ''),
                  contact_phone, uid, total_price, qty))

            execute("""
                INSERT INTO booking_details (booking_id, attraction_id, quantity)
                VALUES (%s, %s, %s)
            """, (bid, aid, qty))

            flash(f'Booking #{bid} created successfully!', 'success')
            return redirect(url_for('bookings.my_bookings'))
        except Exception as e:
            flash(f'Error creating booking: {e}', 'danger')

    return render_template('bookings/book_form.html',
                           attraction=attraction,
                           now=str(date.today()))


# ── Admin: All Bookings ───────────────────────────────────────────────────────
@bookings_bp.route('/admin/bookings')
@admin_required
def admin_list():
    bookings = query("""
        SELECT b.booking_id, b.booking_date, b.status,
               b.total_price, b.quantity, b.created_at,
               u.name AS user_name, u.email AS user_email
        FROM   bookings b
        JOIN   users    u ON u.user_id = b.user_id
        ORDER  BY b.booking_id DESC
    """)
    return render_template('admin/bookings/list.html', bookings=bookings)


@bookings_bp.route('/admin/bookings/add', methods=['GET', 'POST'])
@admin_required
def admin_add():
    if request.method == 'POST':
        try:
            max_id = query_one("SELECT COALESCE(MAX(booking_id), 0) + 1 AS nid FROM bookings")
            execute("""
                INSERT INTO bookings
                  (booking_id, booking_date, status, contact_name, contact_email,
                   created_at, contact_phone, user_id, total_price, quantity)
                VALUES (%s,%s,%s,%s,%s,NOW(),%s,%s,%s,%s)
            """, (
                max_id['nid'],
                request.form['booking_date'],
                request.form['status'],
                request.form.get('contact_name', ''),
                request.form.get('contact_email', ''),
                request.form.get('contact_phone') or None,
                request.form['user_id'],
                request.form.get('total_price') or None,
                request.form.get('quantity') or None,
            ))
            flash('Booking created.', 'success')
            return redirect(url_for('bookings.admin_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    return render_template('admin/bookings/form.html',
                           booking=None, users=_users(),
                           status_options=_status_options())


@bookings_bp.route('/admin/bookings/<int:bid>/edit', methods=['GET', 'POST'])
@admin_required
def admin_edit(bid):
    booking = query_one("SELECT * FROM bookings WHERE booking_id = %s", (bid,))
    if not booking:
        flash('Booking not found.', 'warning')
        return redirect(url_for('bookings.admin_list'))

    if request.method == 'POST':
        try:
            execute("""
                UPDATE bookings SET
                  booking_date=%s, status=%s, contact_name=%s,
                  contact_email=%s, contact_phone=%s,
                  user_id=%s, total_price=%s, quantity=%s
                WHERE booking_id = %s
            """, (
                request.form['booking_date'],
                request.form['status'],
                request.form.get('contact_name', ''),
                request.form.get('contact_email', ''),
                request.form.get('contact_phone') or None,
                request.form['user_id'],
                request.form.get('total_price') or None,
                request.form.get('quantity') or None,
                bid,
            ))
            flash('Booking updated.', 'success')
            return redirect(url_for('bookings.admin_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')

    return render_template('admin/bookings/form.html',
                           booking=booking, users=_users(),
                           status_options=_status_options())


@bookings_bp.route('/admin/bookings/<int:bid>/delete', methods=['POST'])
@admin_required
def admin_delete(bid):
    try:
        execute("DELETE FROM booking_details WHERE booking_id = %s", (bid,))
        execute("DELETE FROM payment        WHERE booking_id = %s", (bid,))
        execute("DELETE FROM bookings        WHERE booking_id = %s", (bid,))
        flash('Booking deleted.', 'success')
    except Exception as e:
        flash(f'Cannot delete: {e}', 'danger')
    return redirect(url_for('bookings.admin_list'))


# ── Admin: Booking Details (bridge table) ────────────────────────────────────
@bookings_bp.route('/admin/booking-details')
@admin_required
def bd_list():
    details = query("""
        SELECT bd.booking_id, bd.attraction_id, bd.quantity,
               b.booking_date, b.status,
               u.name AS user_name,
               a.name AS attraction_name
        FROM   booking_details bd
        JOIN   bookings    b ON b.booking_id    = bd.booking_id
        JOIN   users       u ON u.user_id       = b.user_id
        JOIN   attractions a ON a.attraction_id = bd.attraction_id
        ORDER  BY bd.booking_id, bd.attraction_id
    """)
    return render_template('admin/booking_details/list.html', details=details)


@bookings_bp.route('/admin/booking-details/add', methods=['GET', 'POST'])
@admin_required
def bd_add():
    if request.method == 'POST':
        try:
            execute("""
                INSERT INTO booking_details (booking_id, attraction_id, quantity)
                VALUES (%s, %s, %s)
            """, (request.form['booking_id'],
                  request.form['attraction_id'],
                  request.form['quantity']))
            flash('Booking detail added.', 'success')
            return redirect(url_for('bookings.bd_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    bookings = query("""
        SELECT b.booking_id, b.booking_date, b.status, u.name AS user_name
        FROM bookings b JOIN users u ON u.user_id = b.user_id
        ORDER BY b.booking_id DESC
    """)
    return render_template('admin/booking_details/form.html',
                           detail=None,
                           bookings=bookings,
                           attractions=_attractions())


@bookings_bp.route('/admin/booking-details/<int:bid>/<int:aid>/edit', methods=['GET', 'POST'])
@admin_required
def bd_edit(bid, aid):
    detail = query_one(
        "SELECT * FROM booking_details WHERE booking_id=%s AND attraction_id=%s", (bid, aid))
    if not detail:
        flash('Record not found.', 'warning')
        return redirect(url_for('bookings.bd_list'))
    if request.method == 'POST':
        try:
            execute("""
                UPDATE booking_details SET quantity=%s
                WHERE booking_id=%s AND attraction_id=%s
            """, (request.form['quantity'], bid, aid))
            flash('Updated.', 'success')
            return redirect(url_for('bookings.bd_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    bookings = query("""
        SELECT b.booking_id, b.booking_date, b.status, u.name AS user_name
        FROM bookings b JOIN users u ON u.user_id = b.user_id
        ORDER BY b.booking_id DESC
    """)
    return render_template('admin/booking_details/form.html',
                           detail=detail,
                           bookings=bookings,
                           attractions=_attractions())


@bookings_bp.route('/admin/booking-details/<int:bid>/<int:aid>/delete', methods=['POST'])
@admin_required
def bd_delete(bid, aid):
    try:
        execute("DELETE FROM booking_details WHERE booking_id=%s AND attraction_id=%s", (bid, aid))
        flash('Deleted.', 'success')
    except Exception as e:
        flash(f'Error: {e}', 'danger')
    return redirect(url_for('bookings.bd_list'))
