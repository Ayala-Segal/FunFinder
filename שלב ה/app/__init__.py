from flask import Flask
from app.config import SECRET_KEY


def create_app():
    app = Flask(__name__, template_folder='../templates', static_folder='../static')
    app.secret_key = SECRET_KEY

    from app.routes.auth        import auth_bp
    from app.routes.home        import home_bp
    from app.routes.attractions import attractions_bp
    from app.routes.bookings    import bookings_bp
    from app.routes.reviews     import reviews_bp
    from app.routes.admin       import admin_bp
    from app.routes.reports     import reports_bp

    app.register_blueprint(auth_bp)
    app.register_blueprint(home_bp)
    app.register_blueprint(attractions_bp)
    app.register_blueprint(bookings_bp)
    app.register_blueprint(reviews_bp)
    app.register_blueprint(admin_bp)
    app.register_blueprint(reports_bp)

    return app
