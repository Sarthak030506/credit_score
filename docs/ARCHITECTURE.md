# Credit Score MVP - Architecture Documentation

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              FRONTEND (React)                                │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │  Login Page │  │  Citizen    │  │    Bank     │  │   Admin     │        │
│  │             │  │  Dashboard  │  │  Dashboard  │  │   Panel     │        │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘        │
│         │                │                │                │                │
│         └────────────────┴────────────────┴────────────────┘                │
│                                   │                                          │
│                          [REST API Calls]                                    │
└───────────────────────────────────┼──────────────────────────────────────────┘
                                    │
┌───────────────────────────────────┼──────────────────────────────────────────┐
│                           BACKEND (Flask)                                    │
│                                   │                                          │
│  ┌────────────────────────────────┴────────────────────────────────────┐    │
│  │                         API Gateway Layer                            │    │
│  │  /api/login  │  /api/citizen/*  │  /api/bank/*  │  /api/admin/*     │    │
│  └──────────────┴──────────────────┴───────────────┴───────────────────┘    │
│                                   │                                          │
│  ┌────────────────────────────────┴────────────────────────────────────┐    │
│  │                      Authentication Middleware                       │    │
│  │                   (JWT Token + Role-Based Access)                    │    │
│  └──────────────────────────────────────────────────────────────────────┘    │
│                                   │                                          │
│  ┌─────────────┬─────────────┬────┴──────┬─────────────┬─────────────┐      │
│  │  Scoring    │  Feature    │ Explain-  │ Recommen-   │   Audit     │      │
│  │  Service    │  Extractor  │ ability   │ dation      │   Logger    │      │
│  └──────┬──────┴──────┬──────┴─────┬─────┴──────┬──────┴──────┬──────┘      │
│         │             │            │            │             │              │
│  ┌──────┴─────────────┴────────────┴────────────┴─────────────┴──────┐      │
│  │                         ML Engine                                  │      │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐    │      │
│  │  │ Trained Model│  │    Scaler    │  │ Counterfactual Engine│    │      │
│  │  │ (XGBoost)    │  │ (StandardSc) │  │                      │    │      │
│  │  └──────────────┘  └──────────────┘  └──────────────────────┘    │      │
│  └───────────────────────────────────────────────────────────────────┘      │
│                                   │                                          │
│  ┌────────────────────────────────┴────────────────────────────────────┐    │
│  │                    Optional: GenAI Integration                       │    │
│  │                  (OpenAI/Anthropic for Narratives)                   │    │
│  └──────────────────────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────────┐
│                              DATA LAYER                                       │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────┐      │
│  │ Training Data   │  │  Sample CSVs    │  │    Audit Logs (JSON)    │      │
│  │ (UCI/Kaggle)    │  │  (Generated)    │  │                         │      │
│  └─────────────────┘  └─────────────────┘  └─────────────────────────┘      │
└──────────────────────────────────────────────────────────────────────────────┘
```

## Component Breakdown

### 1. Frontend Components

```
src/
├── components/
│   ├── common/
│   │   ├── Header.jsx           # Navigation header with role indicator
│   │   ├── FileUpload.jsx       # CSV file upload component
│   │   ├── ScoreGauge.jsx       # Visual credit score display
│   │   └── LoadingSpinner.jsx   # Loading state indicator
│   ├── citizen/
│   │   ├── ScoreCard.jsx        # Main score display card
│   │   ├── ExplanationPanel.jsx # Why this score explanation
│   │   ├── ImprovementTips.jsx  # How to improve score
│   │   └── TransactionSummary.jsx
│   ├── bank/
│   │   ├── RiskAssessment.jsx   # Risk evaluation display
│   │   ├── LenderRecommendations.jsx
│   │   └── MonitoringAlerts.jsx
│   └── admin/
│       ├── AuditLogTable.jsx    # Audit log viewer
│       └── SystemStats.jsx      # Basic metrics
├── pages/
│   ├── LoginPage.jsx
│   ├── CitizenDashboard.jsx
│   ├── BankDashboard.jsx
│   └── AdminPanel.jsx
├── services/
│   └── api.js                   # API client wrapper
└── utils/
    └── formatters.js            # Data formatting utilities
```

### 2. Backend Structure

```
backend/
├── app.py                       # Flask application entry point
├── config.py                    # Configuration settings
├── requirements.txt
├── api/
│   ├── __init__.py
│   ├── auth.py                  # Authentication endpoints
│   ├── citizen.py               # Citizen-specific endpoints
│   ├── bank.py                  # Bank/lender endpoints
│   └── admin.py                 # Admin endpoints
├── ml/
│   ├── __init__.py
│   ├── train_model.py           # Model training script
│   ├── feature_extractor.py     # Transaction → features
│   ├── predictor.py             # Score prediction
│   ├── explainer.py             # SHAP/LIME explanations
│   └── counterfactual.py        # Improvement suggestions
├── utils/
│   ├── __init__.py
│   ├── audit_logger.py          # Audit logging utility
│   └── recommendations.py       # Role-based recommendations
└── data/
    ├── model.pkl                # Trained model (generated)
    ├── scaler.pkl               # Feature scaler (generated)
    └── audit_logs.json          # Audit log storage
```

## Data Flow

### Citizen Score Request Flow
```
1. User uploads CSV → Frontend
2. Frontend POST /api/citizen/score with CSV data
3. Backend validates JWT token + role
4. Feature Extractor processes CSV → feature vector
5. ML Model predicts probability of default
6. Explainer generates SHAP values
7. Counterfactual engine finds improvement paths
8. Recommendation service generates citizen tips
9. (Optional) GenAI generates narrative
10. Response returned with score + explanations + tips
11. Audit logger records the request
```

### Bank Score Request Flow
```
1. Bank uploads applicant CSV → Frontend
2. Frontend POST /api/bank/score with CSV data
3. Backend validates JWT token + role (must be 'bank')
4. Same feature extraction + prediction
5. Explainer generates risk factors
6. Recommendation service generates lender advice
7. Response includes: risk level, suggested limits, monitoring flags
8. Audit logger records the request
```

## Security Model

### Authentication
- JWT-based stateless authentication
- Tokens expire after 24 hours
- Role encoded in token payload

### Authorization Matrix
| Endpoint              | Citizen | Bank | Admin |
|-----------------------|---------|------|-------|
| POST /api/login       | ✓       | ✓    | ✓     |
| POST /api/citizen/score| ✓      | ✗    | ✗     |
| POST /api/bank/score  | ✗       | ✓    | ✗     |
| GET /api/admin/audit  | ✗       | ✗    | ✓     |
| GET /api/admin/stats  | ✗       | ✗    | ✓     |

## ML Model Details

### Training Data
- **Primary**: UCI Default of Credit Card Clients Dataset
  - 30,000 records, 24 features
  - Binary classification (default: yes/no)

### Feature Engineering (from transaction CSV)
| Feature               | Description                          | Calculation |
|-----------------------|--------------------------------------|-------------|
| avg_transaction       | Average transaction amount           | mean(amounts) |
| transaction_volatility| Spending consistency                 | std(amounts) |
| expense_ratio         | Spending vs income                   | expenses/income |
| payment_consistency   | Bill payment regularity              | on_time/total |
| account_age_months    | Account maturity                     | from dates |
| overdraft_frequency   | Overdraft count                      | count(balance<0) |
| income_stability      | Income variation                     | std(income)/mean |
| category_diversity    | Spending diversity                   | unique_categories |

### Model Architecture
- **Algorithm**: XGBoost Classifier (CPU-friendly)
- **Output**: Probability of default (0-1)
- **Score Mapping**: probability → 300-850 credit score scale

### Explainability
- **SHAP values**: Feature importance for each prediction
- **Counterfactuals**: DiCE library for actionable changes
