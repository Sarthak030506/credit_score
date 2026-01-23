"""Audit logging utility for tracking all scoring requests."""
import json
import os
from datetime import datetime
from typing import Dict, Any, List
from threading import Lock

from config import Config


class AuditLogger:
    """Thread-safe audit logger for credit score requests."""

    def __init__(self, log_path: str = None):
        """Initialize the audit logger."""
        self.log_path = log_path or Config.AUDIT_LOG_PATH
        self._lock = Lock()
        self._ensure_log_file()

    def _ensure_log_file(self):
        """Ensure the log file exists."""
        os.makedirs(os.path.dirname(self.log_path), exist_ok=True)
        if not os.path.exists(self.log_path):
            with open(self.log_path, 'w') as f:
                json.dump({'logs': [], 'stats': {'total_requests': 0, 'total_scores': 0}}, f)

    def _read_logs(self) -> Dict[str, Any]:
        """Read current logs from file."""
        try:
            with open(self.log_path, 'r') as f:
                return json.load(f)
        except (json.JSONDecodeError, FileNotFoundError):
            return {'logs': [], 'stats': {'total_requests': 0, 'total_scores': 0}}

    def _write_logs(self, data: Dict[str, Any]):
        """Write logs to file."""
        with open(self.log_path, 'w') as f:
            json.dump(data, f, indent=2, default=str)

    def log_score_request(self, user_email: str, user_role: str,
                          action: str, score: int = None,
                          risk_category: str = None,
                          applicant_id: str = None,
                          additional_data: Dict[str, Any] = None):
        """
        Log a credit score request.

        Args:
            user_email: Email of the user making the request
            user_role: Role of the user (citizen, bank, admin)
            action: Action performed (score_request, audit_view, etc.)
            score: Calculated credit score (if applicable)
            risk_category: Risk category (if applicable)
            applicant_id: Applicant ID for bank requests
            additional_data: Any additional data to log
        """
        with self._lock:
            data = self._read_logs()

            log_entry = {
                'timestamp': datetime.utcnow().isoformat(),
                'user': user_email,
                'role': user_role,
                'action': action,
                'score': score,
                'risk_category': risk_category,
                'applicant_id': applicant_id,
            }

            if additional_data:
                log_entry['additional_data'] = additional_data

            data['logs'].append(log_entry)

            # Update stats
            data['stats']['total_requests'] += 1
            if score is not None:
                data['stats']['total_scores'] += score
                data['stats']['avg_score'] = round(
                    data['stats']['total_scores'] / data['stats']['total_requests']
                )

            # Keep only last 1000 logs
            if len(data['logs']) > 1000:
                data['logs'] = data['logs'][-1000:]

            self._write_logs(data)

    def get_logs(self, limit: int = 100, offset: int = 0,
                 user_filter: str = None,
                 role_filter: str = None,
                 action_filter: str = None) -> Dict[str, Any]:
        """
        Retrieve audit logs with optional filtering.

        Args:
            limit: Maximum number of logs to return
            offset: Number of logs to skip
            user_filter: Filter by user email
            role_filter: Filter by role
            action_filter: Filter by action type

        Returns:
            Dictionary with logs and stats
        """
        with self._lock:
            data = self._read_logs()

        logs = data['logs']

        # Apply filters
        if user_filter:
            logs = [l for l in logs if user_filter.lower() in l.get('user', '').lower()]
        if role_filter:
            logs = [l for l in logs if l.get('role') == role_filter]
        if action_filter:
            logs = [l for l in logs if l.get('action') == action_filter]

        # Sort by timestamp (newest first)
        logs = sorted(logs, key=lambda x: x.get('timestamp', ''), reverse=True)

        # Apply pagination
        total = len(logs)
        logs = logs[offset:offset + limit]

        # Calculate filtered stats
        filtered_stats = {
            'total_filtered': total,
            'showing': len(logs),
            'offset': offset
        }

        return {
            'logs': logs,
            'stats': {**data['stats'], **filtered_stats}
        }

    def get_stats(self) -> Dict[str, Any]:
        """Get overall statistics."""
        with self._lock:
            data = self._read_logs()

        stats = data['stats'].copy()

        # Calculate additional stats
        logs = data['logs']
        if logs:
            # Score distribution
            scores = [l['score'] for l in logs if l.get('score') is not None]
            if scores:
                stats['min_score'] = min(scores)
                stats['max_score'] = max(scores)
                stats['score_count'] = len(scores)

            # Role distribution
            role_counts = {}
            # Score distribution by category
            risk_distribution = {
                'Excellent': 0,
                'Very Good': 0,
                'Good': 0,
                'Fair': 0,
                'Poor': 0
            }

            for log in logs:
                role = log.get('role', 'unknown')
                role_counts[role] = role_counts.get(role, 0) + 1
                
                # Count risk categories
                category = log.get('risk_category')
                if category and category in risk_distribution:
                    risk_distribution[category] += 1

            stats['requests_by_role'] = role_counts
            stats['risk_distribution'] = risk_distribution

            # Recent activity (last 24 hours)
            now = datetime.utcnow()
            recent = [l for l in logs
                     if 'timestamp' in l and
                     (now - datetime.fromisoformat(l['timestamp'])).days < 1]
            stats['requests_last_24h'] = len(recent)

        return stats


# Singleton instance
_logger = None


def get_audit_logger() -> AuditLogger:
    """Get or create the singleton audit logger instance."""
    global _logger
    if _logger is None:
        _logger = AuditLogger()
    return _logger
