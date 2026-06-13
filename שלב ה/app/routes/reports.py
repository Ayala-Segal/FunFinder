from flask import Blueprint, render_template, request, flash
from app.db import query, call_function_refcursor, call_function_scalar, call_procedure
from app.decorators import admin_required

reports_bp = Blueprint('reports', __name__)


@reports_bp.route('/reports')
@admin_required
def index():
    return render_template('reports/index.html')


# ══════════════════════════════════════════════════════════════════════════════
# STAGE 2 QUERIES
# ══════════════════════════════════════════════════════════════════════════════

@reports_bp.route('/reports/query1', methods=['POST'])
@admin_required
def query1():
    """Top-rated attractions (avg_rating >= 4) with booking count, per category."""
    try:
        rows = query("""
            SELECT
                a.name              AS attraction_name,
                c.name              AS category_name,
                a.location,
                ROUND(AVG(r.rating)::numeric, 2)        AS avg_rating,
                COUNT(DISTINCT bd.booking_id)            AS total_bookings
            FROM   attractions      a
            JOIN   categories       c  ON c.category_id  = a.category_id
            JOIN   reviews          r  ON r.attraction_id = a.attraction_id
            LEFT JOIN booking_details bd ON bd.attraction_id = a.attraction_id
            GROUP  BY a.attraction_id, a.name, c.name, a.location
            HAVING AVG(r.rating) >= 4.0
            ORDER  BY avg_rating DESC, total_bookings DESC
        """)
        return render_template('reports/index.html',
                               q1_rows=rows,
                               q1_cols=['attraction_name','category_name','location','avg_rating','total_bookings'],
                               active='q1')
    except Exception as e:
        flash(f'Query error: {e}', 'danger')
        return render_template('reports/index.html', active='q1')


@reports_bp.route('/reports/query2', methods=['POST'])
@admin_required
def query2():
    """Customers who spent above their booking month's average."""
    try:
        rows = query("""
            SELECT
                u.name          AS full_name,
                u.email,
                EXTRACT(MONTH FROM b.booking_date)::INT AS booking_month,
                EXTRACT(YEAR  FROM b.booking_date)::INT AS booking_year,
                b.total_price,
                ROUND(ma.avg_monthly_price::numeric, 2) AS month_avg,
                b.status        AS booking_status
            FROM   users u
            JOIN   bookings b ON u.user_id = b.user_id
            JOIN   (
                SELECT
                    EXTRACT(MONTH FROM booking_date) AS bmonth,
                    EXTRACT(YEAR  FROM booking_date) AS byear,
                    AVG(total_price) AS avg_monthly_price
                FROM bookings
                GROUP BY 1, 2
            ) ma ON EXTRACT(MONTH FROM b.booking_date) = ma.bmonth
                AND EXTRACT(YEAR  FROM b.booking_date) = ma.byear
            WHERE b.total_price > ma.avg_monthly_price
            ORDER BY b.total_price DESC
        """)
        return render_template('reports/index.html',
                               q2_rows=rows,
                               q2_cols=['full_name','email','booking_month','booking_year',
                                        'total_price','month_avg','booking_status'],
                               active='q2')
    except Exception as e:
        flash(f'Query error: {e}', 'danger')
        return render_template('reports/index.html', active='q2')


# ══════════════════════════════════════════════════════════════════════════════
# STAGE 4 FUNCTIONS / PROCEDURES
# ══════════════════════════════════════════════════════════════════════════════

@reports_bp.route('/reports/fn-discounts', methods=['POST'])
@admin_required
def fn_discounts():
    """fn_apply_booking_discounts(user_id) → INT"""
    try:
        uid    = int(request.form.get('user_id', 1))
        result = call_function_scalar('fn_apply_booking_discounts', [uid])
        msg    = f'Processed {result} booking(s) for user {uid}.' if result >= 0 \
                 else f'Function returned error code {result}.'
        flash(msg, 'success' if result >= 0 else 'warning')
        # Show updated bookings for that user
        rows = query("""
            SELECT booking_id, booking_date, status, total_price
            FROM   bookings WHERE user_id = %s ORDER BY booking_id
        """, (uid,))
        return render_template('reports/index.html',
                               fn1_result=msg, fn1_rows=rows,
                               fn1_uid=uid, active='fn1')
    except Exception as e:
        flash(f'Function error: {e}', 'danger')
        return render_template('reports/index.html', active='fn1')


@reports_bp.route('/reports/fn-revenue', methods=['POST'])
@admin_required
def fn_revenue():
    """fn_attraction_revenue_report(category_id) → refcursor"""
    try:
        cid  = int(request.form.get('category_id', 1))
        rows = call_function_refcursor('fn_attraction_revenue_report', [cid])
        return render_template('reports/index.html',
                               fn2_rows=rows,
                               fn2_cols=['attraction_id','attraction_name','avg_rating',
                                         'review_count','total_bookings','total_revenue',
                                         'first_booking','last_booking'],
                               fn2_cid=cid, active='fn2')
    except Exception as e:
        flash(f'Function error: {e}', 'danger')
        return render_template('reports/index.html', active='fn2')


@reports_bp.route('/reports/proc-complete', methods=['POST'])
@admin_required
def proc_complete():
    """pr_complete_booking(booking_id, OUT amount, OUT status)"""
    try:
        bid = int(request.form.get('booking_id', 1))
        row = None
        from app.db import get_connection
        import psycopg2.extras
        conn = get_connection()
        try:
            conn.autocommit = False
            with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
                cur.execute("CALL pr_complete_booking(%s, NULL, NULL)", (bid,))
                # Fetch result from bookings table after call
            conn.commit()
        finally:
            conn.close()

        row = query(
            "SELECT booking_id, status, total_price FROM bookings WHERE booking_id = %s", (bid,))
        flash(f'pr_complete_booking({bid}) executed successfully.', 'success')
        return render_template('reports/index.html',
                               proc1_rows=row, proc1_bid=bid, active='proc1')
    except Exception as e:
        flash(f'Procedure error: {e}', 'danger')
        return render_template('reports/index.html', active='proc1')


@reports_bp.route('/reports/proc-sync', methods=['POST'])
@admin_required
def proc_sync():
    """pr_sync_attraction_stats(min_reviews)"""
    try:
        min_reviews = int(request.form.get('min_reviews', 1))
        call_procedure('pr_sync_attraction_stats', [min_reviews])
        flash(f'pr_sync_attraction_stats({min_reviews}) completed.', 'success')
        rows = query("""
            SELECT attraction_id, name, avg_rating, review_count, last_updated
            FROM   attractions ORDER BY last_updated DESC NULLS LAST LIMIT 20
        """)
        return render_template('reports/index.html',
                               proc2_rows=rows, proc2_min=min_reviews, active='proc2')
    except Exception as e:
        flash(f'Procedure error: {e}', 'danger')
        return render_template('reports/index.html', active='proc2')
