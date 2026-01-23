"""Authentication API endpoints."""
from datetime import datetime, timedelta
from flask import Blueprint, request, jsonify
import jwt

from config import Config

auth_bp = Blueprint('auth', __name__)


@auth_bp.route('/login', methods=['POST'])
def login():
    """
    Authenticate user and return JWT token.

    Request body:
        {
            "email": "citizen@test.com",
            "password": "password"
        }

    Response:
        {
            "token": "jwt...",
            "role": "citizen",
            "user": "John Doe"
        }
    """
    data = request.get_json()

    if not data:
        return jsonify({'error': 'No data provided'}), 400

    email = data.get('email', '').lower().strip()
    password = data.get('password', '')

    if not email or not password:
        return jsonify({'error': 'Email and password are required'}), 400

    # Check mock users
    user = Config.MOCK_USERS.get(email)

    if not user or user['password'] != password:
        return jsonify({'error': 'Invalid email or password'}), 401

    # Generate JWT token
    expiration = datetime.utcnow() + timedelta(hours=Config.JWT_EXPIRATION_HOURS)
    payload = {
        'email': email,
        'role': user['role'],
        'name': user['name'],
        'exp': expiration
    }

    token = jwt.encode(payload, Config.JWT_SECRET, algorithm=Config.JWT_ALGORITHM)

    return jsonify({
        'token': token,
        'role': user['role'],
        'user': user['name']
    })


@auth_bp.route('/verify', methods=['GET'])
def verify_token():
    """
    Verify if a JWT token is valid.

    Headers:
        Authorization: Bearer <token>

    Response:
        {
            "valid": true,
            "user": { "email": "...", "role": "...", "name": "..." }
        }
    """
    auth_header = request.headers.get('Authorization', '')

    if not auth_header.startswith('Bearer '):
        return jsonify({'valid': False, 'error': 'No token provided'}), 401

    token = auth_header[7:]

    try:
        payload = jwt.decode(token, Config.JWT_SECRET, algorithms=[Config.JWT_ALGORITHM])
        return jsonify({
            'valid': True,
            'user': {
                'email': payload.get('email'),
                'role': payload.get('role'),
                'name': payload.get('name')
            }
        })
    except jwt.ExpiredSignatureError:
        return jsonify({'valid': False, 'error': 'Token has expired'}), 401
    except jwt.InvalidTokenError:
        return jsonify({'valid': False, 'error': 'Invalid token'}), 401
