"""Bank API endpoints for credit risk assessment."""
from flask import Blueprint, request, jsonify

from api import require_role
from ml.feature_extractor import FeatureExtractor, parse_csv_transactions
from ml.predictor import get_predictor
from ml.explainer import get_explainer
from ml.counterfactual import get_counterfactual_generator
from utils.audit_logger import get_audit_logger
from utils.recommendations import get_recommendation_engine

bank_bp = Blueprint('bank', __name__)


@bank_bp.route('/score', methods=['POST'])
@require_role('bank', 'admin')
def assess_risk():
    """
    Assess credit risk for a loan applicant.

    Request body:
        {
            "applicant_id": "APP123",
            "transactions": [
                {"date": "2024-01-01", "amount": 1000, "category": "salary", "type": "credit", "balance": 5000},
                ...
            ]
        }
        OR
        {
            "applicant_id": "APP123",
            "csv_content": "date,amount,category,type,balance\\n..."
        }

    Response:
        {
            "applicant_id": "APP123",
            "score": 680,
            "risk_level": "MEDIUM",
            "probability_of_default": 0.15,
            "recommendation": {
                "decision": "APPROVE_WITH_CONDITIONS",
                "suggested_limit": 5000,
                "interest_rate_tier": "B",
                "monitoring_flags": ["spending_volatility"],
                "conditions": [...]
            },
            "risk_factors": [...],
            "positive_factors": [...]
        }
    """
    data = request.get_json()

    if not data:
        return jsonify({'error': 'No data provided'}), 400

    applicant_id = data.get('applicant_id', 'UNKNOWN')

    # Parse transactions
    if 'csv_content' in data:
        transactions = parse_csv_transactions(data['csv_content'])
    elif 'transactions' in data:
        transactions = data['transactions']
    else:
        return jsonify({'error': 'No transaction data provided'}), 400

    if not transactions:
        return jsonify({'error': 'Could not parse transaction data'}), 400

    # Extract features
    extractor = FeatureExtractor()
    features = extractor.extract_features(transactions)

    # Get prediction
    predictor = get_predictor()
    prediction = predictor.predict(features.copy())

    score = prediction['score']
    category = prediction['category']
    prob_default = prediction['probability_of_default']
    raw_features = prediction.get('raw_features', {})

    # Generate explanations
    explainer = get_explainer()
    explanations = explainer.explain(
        prediction['feature_vector'],
        prediction['feature_values'],
        raw_features
    )

    # Generate bank recommendations
    recommender = get_recommendation_engine()
    bank_recommendation = recommender.generate_bank_recommendations(
        score, category, prob_default, explanations, raw_features
    )

    # Log the request
    logger = get_audit_logger()
    logger.log_score_request(
        user_email=request.user.get('email', 'unknown'),
        user_role='bank',
        action='risk_assessment',
        score=score,
        risk_category=category,
        applicant_id=applicant_id,
        additional_data={
            'decision': bank_recommendation['decision'],
            'risk_level': bank_recommendation['risk_level']
        }
    )

    # Build response
    response = {
        'applicant_id': applicant_id,
        'score': score,
        'risk_level': bank_recommendation['risk_level'],
        'probability_of_default': prob_default,
        'recommendation': {
            'decision': bank_recommendation['decision'],
            'suggested_limit': bank_recommendation['suggested_limit'],
            'interest_rate_tier': bank_recommendation['interest_rate_tier'],
            'monitoring_flags': bank_recommendation['monitoring_flags'],
            'conditions': bank_recommendation['conditions'],
            'confidence': bank_recommendation['confidence']
        },
        'risk_factors': explanations.get('negative', []),
        'positive_factors': explanations.get('positive', []),
        'feature_importance': explanations.get('feature_importance', {})
    }

    return jsonify(response)


@bank_bp.route('/batch', methods=['POST'])
@require_role('bank', 'admin')
def batch_assess():
    """
    Assess multiple applicants in batch.

    Request body:
        {
            "applicants": [
                {"applicant_id": "APP123", "transactions": [...]},
                {"applicant_id": "APP124", "transactions": [...]}
            ]
        }

    Response:
        {
            "results": [
                {"applicant_id": "APP123", "score": 680, "decision": "APPROVE", ...},
                ...
            ],
            "summary": {
                "total": 2,
                "approved": 1,
                "conditional": 1,
                "denied": 0
            }
        }
    """
    data = request.get_json()

    if not data or 'applicants' not in data:
        return jsonify({'error': 'No applicants data provided'}), 400

    applicants = data['applicants']
    results = []
    summary = {'total': 0, 'approved': 0, 'conditional': 0, 'review': 0}

    extractor = FeatureExtractor()
    predictor = get_predictor()
    explainer = get_explainer()
    recommender = get_recommendation_engine()
    logger = get_audit_logger()

    for applicant in applicants:
        applicant_id = applicant.get('applicant_id', 'UNKNOWN')
        transactions = applicant.get('transactions', [])

        if not transactions:
            results.append({
                'applicant_id': applicant_id,
                'error': 'No transaction data'
            })
            continue

        try:
            # Process
            features = extractor.extract_features(transactions)
            prediction = predictor.predict(features.copy())

            explanations = explainer.explain(
                prediction['feature_vector'],
                prediction['feature_values'],
                prediction.get('raw_features', {})
            )

            bank_rec = recommender.generate_bank_recommendations(
                prediction['score'],
                prediction['category'],
                prediction['probability_of_default'],
                explanations,
                prediction.get('raw_features', {})
            )

            # Log
            logger.log_score_request(
                user_email=request.user.get('email', 'unknown'),
                user_role='bank',
                action='batch_assessment',
                score=prediction['score'],
                risk_category=prediction['category'],
                applicant_id=applicant_id
            )

            # Track summary
            decision = bank_rec['decision']
            if decision == 'APPROVE':
                summary['approved'] += 1
            elif decision == 'APPROVE_WITH_CONDITIONS':
                summary['conditional'] += 1
            else:
                summary['review'] += 1

            summary['total'] += 1

            results.append({
                'applicant_id': applicant_id,
                'score': prediction['score'],
                'risk_level': bank_rec['risk_level'],
                'decision': decision,
                'suggested_limit': bank_rec['suggested_limit'],
                'confidence': bank_rec['confidence']
            })

        except Exception as e:
            results.append({
                'applicant_id': applicant_id,
                'error': str(e)
            })

    return jsonify({
        'results': results,
        'summary': summary
    })


@bank_bp.route('/thresholds', methods=['GET'])
@require_role('bank', 'admin')
def get_thresholds():
    """
    Get current risk thresholds and decision criteria.

    Response:
        {
            "score_ranges": {...},
            "decision_criteria": {...},
            "rate_tiers": {...}
        }
    """
    from config import Config

    return jsonify({
        'score_ranges': Config.RISK_CATEGORIES,
        'decision_criteria': {
            'APPROVE': 'Score >= 670 (Good or Excellent)',
            'APPROVE_WITH_CONDITIONS': 'Score 580-669 (Fair)',
            'MANUAL_REVIEW': 'Score < 580 (Poor)'
        },
        'rate_tiers': {
            'A': 'Excellent credit - Best rates (Prime - 1%)',
            'B': 'Good credit - Standard rates (Prime)',
            'C': 'Fair credit - Higher rates (Prime + 2%)',
            'D': 'Poor credit - Highest rates (Prime + 5%)'
        },
        'limit_multipliers': {
            'Excellent': '3x estimated annual income',
            'Good': '2x estimated annual income',
            'Fair': '1x estimated annual income',
            'Poor': '0.5x estimated annual income'
        }
    })
