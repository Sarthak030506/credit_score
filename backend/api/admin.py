"""Admin API endpoints for system administration and audit."""
from flask import Blueprint, request, jsonify

from api import require_role
from utils.audit_logger import get_audit_logger

admin_bp = Blueprint('admin', __name__)


@admin_bp.route('/audit', methods=['GET'])
@require_role('admin')
def get_audit_logs():
    """
    Retrieve audit logs with optional filtering.

    Query parameters:
        - limit: Maximum number of logs (default 100)
        - offset: Number of logs to skip (default 0)
        - user: Filter by user email
        - role: Filter by role (citizen, bank, admin)
        - action: Filter by action type

    Response:
        {
            "logs": [
                {
                    "timestamp": "2024-01-15T10:30:00",
                    "user": "citizen@test.com",
                    "role": "citizen",
                    "action": "score_request",
                    "score": 680,
                    "risk_category": "Good"
                },
                ...
            ],
            "stats": {
                "total_requests": 150,
                "avg_score": 650,
                "total_filtered": 100,
                "showing": 50
            }
        }
    """
    limit = request.args.get('limit', 100, type=int)
    offset = request.args.get('offset', 0, type=int)
    user_filter = request.args.get('user')
    role_filter = request.args.get('role')
    action_filter = request.args.get('action')

    # Validate parameters
    limit = min(max(limit, 1), 500)  # Between 1 and 500
    offset = max(offset, 0)

    logger = get_audit_logger()

    # Log this audit access
    logger.log_score_request(
        user_email=request.user.get('email', 'unknown'),
        user_role='admin',
        action='audit_view',
        additional_data={
            'filters': {
                'limit': limit,
                'offset': offset,
                'user': user_filter,
                'role': role_filter,
                'action': action_filter
            }
        }
    )

    # Get filtered logs
    result = logger.get_logs(
        limit=limit,
        offset=offset,
        user_filter=user_filter,
        role_filter=role_filter,
        action_filter=action_filter
    )

    return jsonify(result)


@admin_bp.route('/stats', methods=['GET'])
@require_role('admin')
def get_stats():
    """
    Get system statistics.

    Response:
        {
            "total_requests": 150,
            "avg_score": 650,
            "min_score": 450,
            "max_score": 820,
            "requests_by_role": {"citizen": 100, "bank": 50},
            "requests_last_24h": 25
        }
    """
    logger = get_audit_logger()
    stats = logger.get_stats()

    return jsonify(stats)


@admin_bp.route('/users', methods=['GET'])
@require_role('admin')
def get_users():
    """
    Get list of mock users for testing.

    Response:
        {
            "users": [
                {"email": "citizen@test.com", "role": "citizen", "name": "John Doe"},
                ...
            ]
        }
    """
    from config import Config

    users = [
        {
            'email': email,
            'role': user['role'],
            'name': user['name']
        }
        for email, user in Config.MOCK_USERS.items()
    ]

    return jsonify({'users': users})


@admin_bp.route('/health', methods=['GET'])
@require_role('admin')
def system_health():
    """
    Check system health and component status.

    Response:
        {
            "status": "healthy",
            "components": {
                "model": "loaded",
                "scaler": "loaded",
                "audit_log": "available"
            }
        }
    """
    import os
    from config import Config

    components = {}

    # Check model
    if os.path.exists(Config.MODEL_PATH):
        components['model'] = 'loaded'
    else:
        components['model'] = 'not_found'

    # Check scaler
    if os.path.exists(Config.SCALER_PATH):
        components['scaler'] = 'loaded'
    else:
        components['scaler'] = 'not_found'

    # Check audit log
    try:
        logger = get_audit_logger()
        logger.get_stats()
        components['audit_log'] = 'available'
    except Exception as e:
        components['audit_log'] = f'error: {str(e)}'

    # Check HuggingFace API
    if Config.HUGGINGFACE_API_KEY:
        components['huggingface_api'] = 'configured'
    else:
        components['huggingface_api'] = 'not_configured (using templates)'

    # Overall status
    critical_components = ['model', 'scaler', 'audit_log']
    all_ok = all(
        components.get(c) in ['loaded', 'available', 'configured', 'not_configured (using templates)']
        for c in critical_components
    )

    return jsonify({
        'status': 'healthy' if all_ok else 'degraded',
        'components': components
    })


@admin_bp.route('/export', methods=['GET'])
@require_role('admin')
def export_logs():
    """
    Export all audit logs as JSON.

    Response:
        Full audit log data as JSON download
    """
    from flask import Response
    import json

    logger = get_audit_logger()
    result = logger.get_logs(limit=10000)  # Get all logs

    # Create downloadable response
    response = Response(
        json.dumps(result, indent=2),
        mimetype='application/json',
        headers={
            'Content-Disposition': 'attachment; filename=audit_logs.json'
        }
    )

    return response
