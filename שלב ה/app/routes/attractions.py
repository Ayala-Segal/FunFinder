from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from app.db import query, query_one, execute, delete_attraction_cascade
from app.decorators import login_required, admin_required

attractions_bp = Blueprint('attractions', __name__)


# ── Helper lookups ────────────────────────────────────────────────────────────
def _opening_hours(form):
    frm = form.get('opening_from', '').strip()
    to  = form.get('opening_to',   '').strip()
    if frm and to:
        return f"{frm} - {to}"
    return frm or to or None

def _categories():
    return query("SELECT category_id, name FROM categories ORDER BY name")

def _difficulties():
    return query("SELECT difficulty_id, name FROM difficulty_levels ORDER BY difficulty_id")


# ── User-facing browse ────────────────────────────────────────────────────────
@attractions_bp.route('/attractions')
@login_required
def list_attractions():
    cat_id   = request.args.get('category_id',   type=int)
    diff_id  = request.args.get('difficulty_id', type=int)
    search   = request.args.get('search', '').strip()

    sql = """
        SELECT a.attraction_id, a.name, a.location, a.price,
               a.avg_rating, a.duration, a.main_image_url,
               c.name AS category_name,
               d.name AS difficulty_name
        FROM   attractions a
        JOIN   categories       c ON c.category_id  = a.category_id
        JOIN   difficulty_levels d ON d.difficulty_id = a.difficulty_id
        WHERE  1=1
    """
    params = []
    if cat_id:
        sql += " AND a.category_id = %s"; params.append(cat_id)
    if diff_id:
        sql += " AND a.difficulty_id = %s"; params.append(diff_id)
    if search:
        sql += " AND (a.name ILIKE %s OR a.location ILIKE %s)"
        params.extend([f'%{search}%', f'%{search}%'])
    sql += " ORDER BY a.avg_rating DESC NULLS LAST, a.name"

    attractions = query(sql, params or None)
    return render_template('attractions/list.html',
                           attractions=attractions,
                           categories=_categories(),
                           difficulties=_difficulties(),
                           selected_cat=cat_id,
                           selected_diff=diff_id,
                           search=search)


@attractions_bp.route('/attractions/<int:aid>')
@login_required
def detail(aid):
    attraction = query_one("""
        SELECT a.*, c.name AS category_name, d.name AS difficulty_name
        FROM   attractions a
        JOIN   categories       c ON c.category_id  = a.category_id
        JOIN   difficulty_levels d ON d.difficulty_id = a.difficulty_id
        WHERE  a.attraction_id = %s
    """, (aid,))
    if not attraction:
        flash('Attraction not found.', 'warning')
        return redirect(url_for('attractions.list_attractions'))

    gallery = query("SELECT image_url FROM gallery_images WHERE attraction_id = %s", (aid,))
    reviews = query("""
        SELECT r.rating, r.comment, r.created_at, u.name AS user_name
        FROM   reviews r JOIN users u ON u.user_id = r.user_id
        WHERE  r.attraction_id = %s ORDER BY r.created_at DESC LIMIT 10
    """, (aid,))
    tickets = query("""
        SELECT ticket_type, price, valid_date, available_quantity
        FROM   ticket WHERE attraction_id = %s AND valid_date >= CURRENT_DATE
        ORDER  BY valid_date
    """, (aid,))

    return render_template('attractions/detail.html',
                           a=attraction, gallery=gallery,
                           reviews=reviews, tickets=tickets)


# ── Admin CRUD ────────────────────────────────────────────────────────────────
@attractions_bp.route('/admin/attractions')
@admin_required
def admin_list():
    search = request.args.get('search', '').strip()
    page   = request.args.get('page', 1, type=int)
    offset = (page - 1) * 200
    total  = query_one("SELECT COUNT(*) AS n FROM attractions")['n']
    if len(search) >= 2:
        rows = query("""
            SELECT a.attraction_id, a.name, a.location,
                   a.price, a.avg_rating, a.review_count,
                   c.name AS category_name, d.name AS difficulty_name
            FROM   attractions a
            JOIN   categories       c ON c.category_id  = a.category_id
            JOIN   difficulty_levels d ON d.difficulty_id = a.difficulty_id
            WHERE  a.name ILIKE %s OR a.location ILIKE %s OR c.name ILIKE %s
            ORDER  BY a.attraction_id LIMIT 200 OFFSET %s
        """, (f'%{search}%', f'%{search}%', f'%{search}%', offset))
    elif search:
        rows = []
        flash('הקלד לפחות 2 תווים לחיפוש.', 'info')
    else:
        rows = query("""
            SELECT a.attraction_id, a.name, a.location,
                   a.price, a.avg_rating, a.review_count,
                   c.name AS category_name, d.name AS difficulty_name
            FROM   attractions a
            JOIN   categories       c ON c.category_id  = a.category_id
            JOIN   difficulty_levels d ON d.difficulty_id = a.difficulty_id
            ORDER  BY a.attraction_id LIMIT 200 OFFSET %s
        """, (offset,))
    return render_template('admin/attractions/list.html',
                           attractions=rows, search=search, total=total,
                           page=page, has_next=len(rows)==200)


@attractions_bp.route('/admin/attractions/add', methods=['GET', 'POST'])
@admin_required
def admin_add():
    if request.method == 'POST':
        try:
            max_id = query_one("SELECT COALESCE(MAX(attraction_id),0)+1 AS nid FROM attractions")
            execute("""
                INSERT INTO attractions
                  (attraction_id, name, short_description, full_description,
                   location, price, difficulty_id, duration, target_audience,
                   avg_rating, review_count, main_image_url, category_id, opening_hours)
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """, (
                max_id['nid'],
                request.form['name'],
                request.form.get('short_description') or None,
                request.form.get('full_description') or None,
                request.form['location'],
                request.form['price'],
                request.form['difficulty_id'],
                request.form.get('duration') or None,
                request.form.get('target_audience') or None,
                None, 0,
                request.form.get('main_image_url') or None,
                request.form['category_id'],
                _opening_hours(request.form),
            ))
            flash('Attraction added successfully.', 'success')
            return redirect(url_for('attractions.admin_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')

    return render_template('admin/attractions/form.html',
                           attraction=None,
                           categories=_categories(),
                           difficulties=_difficulties())


@attractions_bp.route('/admin/attractions/<int:aid>/edit', methods=['GET', 'POST'])
@admin_required
def admin_edit(aid):
    row = query_one("SELECT * FROM attractions WHERE attraction_id = %s", (aid,))
    if not row:
        flash('Attraction not found.', 'warning')
        return redirect(url_for('attractions.admin_list'))

    if request.method == 'POST':
        try:
            execute("""
                UPDATE attractions SET
                  name=%s, short_description=%s, full_description=%s,
                  location=%s, price=%s, difficulty_id=%s, duration=%s,
                  target_audience=%s, avg_rating=%s, review_count=%s,
                  main_image_url=%s, category_id=%s, opening_hours=%s
                WHERE attraction_id = %s
            """, (
                request.form['name'],
                request.form['short_description'],
                request.form.get('full_description') or None,
                request.form['location'],
                request.form['price'],
                request.form['difficulty_id'],
                request.form['duration'],
                request.form['target_audience'],
                request.form.get('avg_rating') or None,
                request.form.get('review_count') or 0,
                request.form.get('main_image_url') or None,
                request.form['category_id'],
                _opening_hours(request.form),
                aid,
            ))
            flash('Attraction updated successfully.', 'success')
            return redirect(url_for('attractions.admin_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')

    return render_template('admin/attractions/form.html',
                           attraction=row,
                           categories=_categories(),
                           difficulties=_difficulties())


@attractions_bp.route('/admin/attractions/<int:aid>/delete', methods=['POST'])
@admin_required
def admin_delete(aid):
    try:
        delete_attraction_cascade(aid)
        flash('Attraction deleted.', 'success')
    except Exception as e:
        flash(f'Cannot delete: {e}', 'danger')
    return redirect(url_for('attractions.admin_list'))
