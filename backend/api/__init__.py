"""API module for Credit Score application."""
from functools import wraps
from flask import request, jsonify, current_app
import jwt

from config import Config


def get_token_from_header():
    """Extract JWT token from Authorization header."""
    auth_header = request.headers.get('Authorization', '')
    if auth_header.startswith('Bearer '):
        return auth_header[7:]
    return None


def decode_token(token):
    """Decode and validate JWT token."""
    try:
        payload = jwt.decode(
            token,
            Config.JWT_SECRET,
            algorithms=[Config.JWT_ALGORITHM]
        )
        return payload
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None


def require_auth(f):
    """Decorator to require valid JWT authentication."""
    @wraps(f)
    def decorated(*args, **kwargs):
        token = get_token_from_header()
        if not token:
            return jsonify({'error': 'Missing authentication token'}), 401

        payload = decode_token(token)
        if not payload:
            return jsonify({'error': 'Invalid or expired token'}), 401

        request.user = payload
        return f(*args, **kwargs)
    return decorated


def require_role(*roles):
    """Decorator to require specific user role(s)."""
    def decorator(f):
        @wraps(f)
        def decorated(*args, **kwargs):
            token = get_token_from_header()
            if not token:
                return jsonify({'error': 'Missing authentication token'}), 401

            payload = decode_token(token)
            if not payload:
                return jsonify({'error': 'Invalid or expired token'}), 401

            if payload.get('role') not in roles:
                return jsonify({'error': 'Insufficient permissions'}), 403

            request.user = payload
            return f(*args, **kwargs)
        return decorated
    return decorator
