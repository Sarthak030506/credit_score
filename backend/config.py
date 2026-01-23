"""Configuration settings for the Credit Score API."""
import os
from dotenv import load_dotenv

load_dotenv()


class Config:
    """Application configuration."""

    # Flask settings
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')
    DEBUG = os.getenv('DEBUG', 'True').lower() == 'true'

    # JWT settings
    JWT_SECRET = os.getenv('JWT_SECRET', 'jwt-secret-key-change-in-production')
    JWT_ALGORITHM = 'HS256'
    JWT_EXPIRATION_HOURS = 24

    # CORS settings
    CORS_ORIGINS = ["*"]

    # ML Model paths
    MODEL_PATH = os.path.join(os.path.dirname(__file__), 'data', 'model.pkl')
    SCALER_PATH = os.path.join(os.path.dirname(__file__), 'data', 'scaler.pkl')

    # Audit log path
    AUDIT_LOG_PATH = os.path.join(os.path.dirname(__file__), 'data', 'audit_log.json')

    # HuggingFace API (optional, for narrative generation)
    HUGGINGFACE_API_KEY = os.getenv('HUGGINGFACE_API_KEY', '')
    HUGGINGFACE_MODEL = 'mistralai/Mistral-7B-Instruct-v0.2'

    # Mock users for authentication
    MOCK_USERS = {
        'citizen@test.com': {
            'password': 'password',
            'role': 'citizen',
            'name': 'John Doe'
        },
        'bank@test.com': {
            'password': 'password',
            'role': 'bank',
            'name': 'Bank Officer'
        },
        'admin@test.com': {
            'password': 'password',
            'role': 'admin',
            'name': 'System Admin'
        }
    }

    # Credit score range
    SCORE_MIN = 300
    SCORE_MAX = 850

    # Risk categories
    # Risk categories
    RISK_CATEGORIES = {
        'Excellent': (800, 850),
        'Very Good': (740, 799),
        'Good': (670, 739),
        'Fair': (580, 669),
        'Poor': (300, 579)
    }
