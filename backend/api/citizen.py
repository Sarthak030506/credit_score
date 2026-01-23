"""Citizen API endpoints for credit score assessment."""
from flask import Blueprint, request, jsonify

from api import require_role
from ml.feature_extractor import FeatureExtractor, parse_csv_transactions
from ml.predictor import get_predictor
from ml.explainer import get_explainer
from ml.counterfactual import get_counterfactual_generator
from utils.audit_logger import get_audit_logger
from utils.recommendations import get_recommendation_engine

citizen_bp = Blueprint('citizen', __name__)


@citizen_bp.route('/score', methods=['POST'])
@require_role('citizen', 'admin')
def calculate_score():
    """
    Calculate credit score from transaction data.

    Request body:
        {
            "transactions": [
                {"date": "2024-01-01", "amount": 1000, "category": "salary", "type": "credit", "balance": 5000},
                ...
            ]
        }
        OR
        {
            "csv_content": "date,amount,category,type,balance\\n2024-01-01,1000,salary,credit,5000\\n..."
        }

    Response:
        {
            "score": 680,
            "category": "Good",
            "probability_of_default": 0.15,
            "explanations": {
                "positive": ["Consistent income", "Low overdrafts"],
                "negative": ["High spending volatility"]
            },
            "improvements": [
                {"action": "Reduce spending volatility", "impact": "+25 points", ...}
            ],
            "recommendations": {
                "narrative": "Your score of 680 reflects...",
                "tips": [...],
                "next_steps": [...]
            }
        }
    """
    data = request.get_json()

    if not data:
        return jsonify({'error': 'No data provided'}), 400

    # Parse transactions
    if 'csv_content' in data:
        transactions = parse_csv_transactions(data['csv_content'])
    elif 'transactions' in data:
        transactions = data['transactions']
    else:
        return jsonify({'error': 'No transaction data provided. Include "transactions" array or "csv_content" string.'}), 400

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

    # Generate improvement suggestions
    counterfactual = get_counterfactual_generator()
    improvements = counterfactual.generate_improvements(
        prediction['feature_values'],
        raw_features,
        score
    )

    # Generate recommendations
    recommender = get_recommendation_engine()
    recommendations = recommender.generate_citizen_recommendations(
        score, category, explanations, improvements
    )

    # Log the request
    logger = get_audit_logger()
    logger.log_score_request(
        user_email=request.user.get('email', 'unknown'),
        user_role='citizen',
        action='score_request',
        score=score,
        risk_category=category
    )

    # Calculate trend if possible
    trend = 'stable'
    if features.get('payment_consistency', 30) < 20 and features.get('overdraft_frequency', 0) == 0:
         trend = 'improving'
    elif features.get('payment_consistency', 30) > 40:
         trend = 'declining'

    # Build response
    response = {
        'score': score,
        'category': category,
        'probability_of_default': prob_default,
        'trend': trend,
        'reward_eligible': category in ['Excellent', 'Good'] and trend != 'declining',
        'explanations': {
            'positive': explanations.get('positive', []),
            'negative': explanations.get('negative', [])
        },
        'improvements': [
            {
                'action': imp['action'],
                'detail': imp['detail'],
                'impact': imp['impact'],
                'priority': imp['priority'],
                'timeline': imp['timeline']
            }
            for imp in improvements[:5]
        ],
        'recommendations': recommendations
    }

    return jsonify(response)


@citizen_bp.route('/sample-analysis', methods=['GET'])
@require_role('citizen', 'admin')
def sample_analysis():
    """
    Get a sample analysis with demo data.

    Useful for testing the UI without uploading data.
    """
    # Sample transactions for demo
    sample_transactions = [
        {'date': '2024-01-01', 'amount': 5000, 'category': 'salary', 'type': 'credit', 'balance': 5000},
        {'date': '2024-01-05', 'amount': 1200, 'category': 'rent', 'type': 'debit', 'balance': 3800},
        {'date': '2024-01-10', 'amount': 200, 'category': 'utilities', 'type': 'debit', 'balance': 3600},
        {'date': '2024-01-15', 'amount': 500, 'category': 'groceries', 'type': 'debit', 'balance': 3100},
        {'date': '2024-02-01', 'amount': 5000, 'category': 'salary', 'type': 'credit', 'balance': 8100},
        {'date': '2024-02-05', 'amount': 1200, 'category': 'rent', 'type': 'debit', 'balance': 6900},
        {'date': '2024-02-10', 'amount': 200, 'category': 'utilities', 'type': 'debit', 'balance': 6700},
        {'date': '2024-02-15', 'amount': 450, 'category': 'groceries', 'type': 'debit', 'balance': 6250},
    ]

    # Process same as score endpoint
    extractor = FeatureExtractor()
    features = extractor.extract_features(sample_transactions)

    predictor = get_predictor()
    prediction = predictor.predict(features.copy())

    explainer = get_explainer()
    explanations = explainer.explain(
        prediction['feature_vector'],
        prediction['feature_values'],
        prediction.get('raw_features', {})
    )

    counterfactual = get_counterfactual_generator()
    improvements = counterfactual.generate_improvements(
        prediction['feature_values'],
        prediction.get('raw_features', {}),
        prediction['score']
    )

    recommender = get_recommendation_engine()
    recommendations = recommender.generate_citizen_recommendations(
        prediction['score'],
        prediction['category'],
        explanations,
        improvements
    )

    # Calculate mock trend for sample data
    # In a real scenario, we would compare with previous month's score
    # Here we infer from recent behavior metrics
    trend = 'stable'
    volatility = features.get('transaction_volatility', 0.5)
    consistency = features.get('payment_consistency', 30)
    utilization = features.get('_raw_features', {}).get('expense_ratio', 0.8)

    if consistency < 10 and volatility < 0.8 and utilization < 0.9:
         trend = 'improving'
    elif consistency > 40 or volatility > 2.0 or utilization > 1.1:
         trend = 'declining'

    return jsonify({
        'score': prediction['score'],
        'category': prediction['category'],
        'probability_of_default': prediction['probability_of_default'],
        'trend': trend,
        'reward_eligible': prediction['category'] in ['Excellent', 'Good', 'Very Good'] and trend != 'declining',
        'explanations': {
            'positive': explanations.get('positive', []),
            'negative': explanations.get('negative', [])
        },
        'improvements': improvements[:5],
        'recommendations': recommendations,
        'sample_data': True
    })
