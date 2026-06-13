from flask import Blueprint, render_template, session, redirect, url_for
from app.db import query
from app.decorators import login_required

home_bp = Blueprint('home', __name__)


@home_bp.route('/')
@login_required
def index():
    # Featured attractions: top 6 by avg_rating
    featured = query("""
        SELECT a.attraction_id, a.name, a.location, a.price,
               a.avg_rating, a.main_image_url,
               c.name AS category_name
        FROM   attractions a
        JOIN   categories  c ON c.category_id = a.category_id
        WHERE  a.avg_rating IS NOT NULL
        ORDER  BY a.avg_rating DESC
        LIMIT  6
    """)

    # Category list for the Browse section
    categories = query("SELECT category_id, name, icon_identifier FROM categories ORDER BY category_id")

    return render_template('main/home.html', featured=featured, categories=categories)
