from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from app.db import query, query_one, execute
from app.decorators import login_required, admin_required

reviews_bp = Blueprint('reviews', __name__)


def _users():
    return query("SELECT user_id, name FROM users ORDER BY name")

def _attractions():
    return query("SELECT attraction_id, name FROM attractions ORDER BY name")


# ── User: Add Review ──────────────────────────────────────────────────────────
@reviews_bp.route('/reviews/add', methods=['GET', 'POST'])
@login_required
def add_review():
    attractions = _attractions()
    if request.method == 'POST':
        try:
            aid     = int(request.form['attraction_id'])
            rating  = int(request.form['rating'])
            comment = request.form.get('comment', '').strip() or None
            uid     = session['user_id']

            if not (1 <= rating <= 5):
                flash('Rating must be between 1 and 5.', 'danger')
                return render_template('reviews/form.html',
                                       attractions=attractions, review=None, selected_aid=None)

            max_id = query_one("SELECT COALESCE(MAX(review_id), 0) + 1 AS nid FROM reviews")
            execute("""
                INSERT INTO reviews (review_id, comment, created_at, rating, user_id, attraction_id)
                VALUES (%s, %s, NOW(), %s, %s, %s)
            """, (max_id['nid'], comment, rating, uid, aid))

            flash('Review submitted successfully!', 'success')
            return redirect(url_for('attractions.detail', aid=aid))
        except Exception as e:
            flash(f'Error submitting review: {e}', 'danger')

    selected_aid = request.args.get('aid', type=int)
    return render_template('reviews/form.html',
                           attractions=attractions,
                           review=None,
                           selected_aid=selected_aid)


# ── Admin CRUD ────────────────────────────────────────────────────────────────
@reviews_bp.route('/admin/reviews')
@admin_required
def admin_list():
    reviews = query("""
        SELECT r.review_id, r.rating, r.comment, r.created_at,
               u.name AS user_name, a.name AS attraction_name,
               r.user_id, r.attraction_id
        FROM   reviews     r
        JOIN   users       u ON u.user_id       = r.user_id
        JOIN   attractions a ON a.attraction_id = r.attraction_id
        ORDER  BY r.created_at DESC
    """)
    return render_template('admin/reviews/list.html', reviews=reviews)


@reviews_bp.route('/admin/reviews/add', methods=['GET', 'POST'])
@admin_required
def admin_add():
    if request.method == 'POST':
        try:
            max_id = query_one("SELECT COALESCE(MAX(review_id), 0) + 1 AS nid FROM reviews")
            execute("""
                INSERT INTO reviews (review_id, comment, created_at, rating, user_id, attraction_id)
                VALUES (%s, %s, NOW(), %s, %s, %s)
            """, (max_id['nid'],
                  request.form.get('comment') or None,
                  request.form['rating'],
                  request.form['user_id'],
                  request.form['attraction_id']))
            flash('Review added.', 'success')
            return redirect(url_for('reviews.admin_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    return render_template('admin/reviews/form.html',
                           review=None, users=_users(), attractions=_attractions())


@reviews_bp.route('/admin/reviews/<int:rid>/edit', methods=['GET', 'POST'])
@admin_required
def admin_edit(rid):
    review = query_one("SELECT * FROM reviews WHERE review_id = %s", (rid,))
    if not review:
        flash('Review not found.', 'warning')
        return redirect(url_for('reviews.admin_list'))
    if request.method == 'POST':
        try:
            execute("""
                UPDATE reviews SET comment=%s, rating=%s, user_id=%s, attraction_id=%s
                WHERE review_id = %s
            """, (request.form.get('comment') or None,
                  request.form['rating'],
                  request.form['user_id'],
                  request.form['attraction_id'],
                  rid))
            flash('Review updated.', 'success')
            return redirect(url_for('reviews.admin_list'))
        except Exception as e:
            flash(f'Error: {e}', 'danger')
    return render_template('admin/reviews/form.html',
                           review=review, users=_users(), attractions=_attractions())


@reviews_bp.route('/admin/reviews/<int:rid>/delete', methods=['POST'])
@admin_required
def admin_delete(rid):
    try:
        execute("DELETE FROM reviews WHERE review_id = %s", (rid,))
        flash('Review deleted.', 'success')
    except Exception as e:
        flash(f'Error: {e}', 'danger')
    return redirect(url_for('reviews.admin_list'))
