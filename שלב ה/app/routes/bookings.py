from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from app.db import query, query_one, execute, delete_booking_cascade
from app.decorators import login_required, admin_required

bookings_bp = Blueprint('bookings', __name__)


def _users():
    return query("SELECT user_id, name FROM users ORDER BY name LIMIT 500")

def _attractions():
    return query("SELECT attraction_id, name FROM attractions ORDER BY name LIMIT 500")

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

    if session.get('is_admin'):
        flash('Admins cannot make bookings. Log in as a regular user to book.', 'warning')
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

            return redirect(url_for('bookings.payment', bid=bid))
        except Exception as e:
            flash(f'Error creating booking: {e}', 'danger')

    return render_template('bookings/book_form.html',
                           attraction=attraction,
                           now=str(date.today()))


# ── User: Payment ─────────────────────────────────────────────────────────────
@bookings_bp.route('/payment/<int:bid>', methods=['GET', 'POST'])
@login_required
def payment(bid):
    booking = query_one("""
        SELECT b.booking_id, b.booking_date, b.status, b.total_price, b.quantity,
               b.user_id,
               STRING_AGG(a.name, ', ') AS attractions
        FROM   bookings b
        LEFT JOIN booking_details bd ON bd.booking_id   = b.booking_id
        LEFT JOIN attractions      a  ON a.attraction_id = bd.attraction_id
        WHERE  b.booking_id = %s
        GROUP  BY b.booking_id
    """, (bid,))

    if not booking:
        flash('Booking not found.', 'warning')
        return redirect(url_for('bookings.my_bookings'))

    # Block accessing another user's payment page
    if booking['user_id'] != session.get('user_id') and not session.get('is_admin'):
        flash('Access denied.', 'danger')
        return redirect(url_for('bookings.my_bookings'))

    # Already paid
    if booking['status'] == 'confirmed':
        flash('This booking is already confirmed.', 'info')
        return redirect(url_for('bookings.my_bookings'))

    if request.method == 'POST':
        try:
            max_pay = query_one("SELECT COALESCE(MAX(payment_id), 0) + 1 AS nid FROM payment")
            execute("""
                INSERT INTO payment (payment_id, booking_id, amount)
                VALUES (%s, %s, %s)
            """, (max_pay['nid'], bid, booking['total_price']))

            execute("UPDATE bookings SET status='confirmed' WHERE booking_id = %s", (bid,))

            flash(f'Payment successful! Booking #{bid} is confirmed.', 'success')
            return redirect(url_for('bookings.my_bookings'))
        except Exception as e:
            flash(f'Payment error: {e}', 'danger')

    return render_template('bookings/payment.html', booking=booking)


# ── Admin: All Bookings ───────────────────────────────────────────────────────
@bookings_bp.route('/admin/bookings')
@admin_required
def admin_list():
    search = request.args.get('search', '').strip()
    page   = request.args.get('page', 1, type=int)
    offset = (page - 1) * 200
    from app.db import query_one
    total = query_one("SELECT COUNT(*) AS n FROM bookings")['n']
    if len(search) >= 2:
        bookings = query("""
            SELECT b.booking_id, b.booking_date, b.status,
                   b.total_price, b.quantity, b.created_at,
                   u.name AS user_name, u.email AS user_email
            FROM   bookings b
            JOIN   users    u ON u.user_id = b.user_id
            WHERE  u.name ILIKE %s OR u.email ILIKE %s
                   OR b.status ILIKE %s
            ORDER  BY b.booking_id DESC LIMIT 200 OFFSET %s
        """, (f'%{search}%', f'%{search}%', f'%{search}%', offset))
    elif search:
        bookings = []
        from flask import flash
        flash('הקלד לפחות 2 תווים לחיפוש.', 'info')
    else:
        bookings = query("""
            SELECT b.booking_id, b.booking_date, b.status,
                   b.total_price, b.quantity, b.created_at,
                   u.name AS user_name, u.email AS user_email
            FROM   bookings b
            JOIN   users    u ON u.user_id = b.user_id
            ORDER  BY b.booking_id DESC LIMIT 200 OFFSET %s
        """, (offset,))
    return render_template('admin/bookings/list.html',
                           bookings=bookings, search=search, total=total,
                           page=page, has_next=len(bookings)==200)


@bookings_bp.route('/admin/bookings/add', methods=['GET', 'POST'])
@admin_required
def admin_add():
    from datetime import date
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
                           status_options=_status_options(),
                           today=str(date.today()))


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
        delete_booking_cascade(bid)
        flash('Booking deleted.', 'success')
    except Exception as e:
        flash(f'Cannot delete: {e}', 'danger')
    return redirect(url_for('bookings.admin_list'))


# ── Admin: Booking Details (bridge table) ────────────────────────────────────
@bookings_bp.route('/admin/booking-details')
@admin_required
def bd_list():
    search = request.args.get('search', '').strip()
    page   = request.args.get('page', 1, type=int)
    offset = (page - 1) * 200
    from app.db import query_one
    from flask import flash
    total = query_one("SELECT COUNT(*) AS n FROM booking_details")['n']
    if len(search) >= 2:
        details = query("""
            SELECT bd.booking_id, bd.attraction_id, bd.quantity,
                   b.booking_date, b.status,
                   u.name AS user_name,
                   a.name AS attraction_name
            FROM   booking_details bd
            JOIN   bookings    b ON b.booking_id    = bd.booking_id
            JOIN   users       u ON u.user_id       = b.user_id
            JOIN   attractions a ON a.attraction_id = bd.attraction_id
            WHERE  u.name ILIKE %s OR a.name ILIKE %s
            ORDER  BY bd.booking_id, bd.attraction_id LIMIT 200 OFFSET %s
        """, (f'%{search}%', f'%{search}%', offset))
    elif search:
        details = []
        flash('הקלד לפחות 2 תווים לחיפוש.', 'info')
    else:
        details = query("""
            SELECT bd.booking_id, bd.attraction_id, bd.quantity,
                   b.booking_date, b.status,
                   u.name AS user_name,
                   a.name AS attraction_name
            FROM   booking_details bd
            JOIN   bookings    b ON b.booking_id    = bd.booking_id
            JOIN   users       u ON u.user_id       = b.user_id
            JOIN   attractions a ON a.attraction_id = bd.attraction_id
            ORDER  BY bd.booking_id, bd.attraction_id LIMIT 200 OFFSET %s
        """, (offset,))
    return render_template('admin/booking_details/list.html',
                           details=details, search=search, total=total,
                           page=page, has_next=len(details)==200)


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
        ORDER BY b.booking_id DESC LIMIT 500
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
        ORDER BY b.booking_id DESC LIMIT 500
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
