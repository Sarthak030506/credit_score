"""Flask application entry point for Credit Score API."""
from flask import Flask, jsonify
from flask_cors import CORS

from config import Config
from api.auth import auth_bp
from api.citizen import citizen_bp
from api.bank import bank_bp
from api.admin import admin_bp


def create_app(config_class=Config):
    """Create and configure the Flask application."""
    app = Flask(__name__)
    app.config.from_object(config_class)

    # Enable CORS
    CORS(app, origins=config_class.CORS_ORIGINS, supports_credentials=True)

    # Register blueprints
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(citizen_bp, url_prefix='/api/citizen')
    app.register_blueprint(bank_bp, url_prefix='/api/bank')
    app.register_blueprint(admin_bp, url_prefix='/api/admin')

    # Health check endpoint
    @app.route('/api/health', methods=['GET'])
    def health_check():
        return jsonify({'status': 'healthy', 'service': 'Credit Score API'})

    # Error handlers
    @app.errorhandler(400)
    def bad_request(error):
        return jsonify({'error': 'Bad request', 'message': str(error)}), 400

    @app.errorhandler(401)
    def unauthorized(error):
        return jsonify({'error': 'Unauthorized', 'message': 'Invalid or missing authentication'}), 401

    @app.errorhandler(403)
    def forbidden(error):
        return jsonify({'error': 'Forbidden', 'message': 'You do not have permission to access this resource'}), 403

    @app.errorhandler(404)
    def not_found(error):
        return jsonify({'error': 'Not found', 'message': 'Resource not found'}), 404

    @app.errorhandler(500)
    def internal_error(error):
        return jsonify({'error': 'Internal server error', 'message': 'An unexpected error occurred'}), 500

    return app


if __name__ == '__main__':
    app = create_app()
    app.run(host='0.0.0.0', port=5000, debug=Config.DEBUG)
