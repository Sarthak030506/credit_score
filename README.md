# Credit Score Platform

A full-stack credit scoring platform powered by machine learning that provides transparent, explainable credit assessments for citizens, lending institutions, and administrators.

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Backend Setup](#backend-setup)
  - [Frontend Setup](#frontend-setup)
  - [Flutter App Setup](#flutter-app-setup)
- [Environment Variables](#environment-variables)
- [Demo Accounts](#demo-accounts)
- [API Reference](#api-reference)
- [ML Model](#ml-model)
- [Features by Role](#features-by-role)
- [CSV Transaction Format](#csv-transaction-format)
- [Running Tests](#running-tests)
- [Docs](#docs)

---

## Overview

The Credit Score Platform analyzes a user's transaction history to generate a credit score (300–850 scale) with full explainability. It serves three distinct user roles:

- **Citizens** — upload transaction data and receive a personal credit score with improvement tips
- **Banks** — assess applicant credit risk with lending recommendations and batch processing
- **Admins** — audit system usage, view logs, and monitor system health

Scores are powered by an XGBoost classifier trained on the UCI Default of Credit Card Clients dataset (30,000 records) with SHAP-based explanations surfaced to the user.

---

## Architecture

```
┌─────────────────────────────────────────────────┐
│              Client Layer                        │
│  React Web App (Vite)  │  Flutter Mobile App    │
└────────────────┬────────────────────────────────┘
                 │ HTTP / REST
┌────────────────▼────────────────────────────────┐
│           Flask REST API (Python)                │
│  Auth  │  Citizen  │  Bank  │  Admin             │
├─────────────────────────────────────────────────┤
│              ML Pipeline                         │
│  Feature Extractor → XGBoost → SHAP Explainer   │
│              → Counterfactual Engine             │
├─────────────────────────────────────────────────┤
│              Data Layer                          │
│  model.pkl  │  scaler.pkl  │  audit_log.json    │
└─────────────────────────────────────────────────┘
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | Python 3.11+, Flask 3.0, Flask-CORS 4.0 |
| Auth | PyJWT 2.8 (JWT, 24h expiry) |
| ML | XGBoost 2.0, Scikit-learn 1.3, SHAP 0.44 |
| Data | Pandas 2.1, NumPy 1.26 |
| Frontend | React 18, Vite 5, Tailwind CSS 3, Chart.js 4, Axios 1.13 |
| Mobile | Flutter (Dart 3.8+), SQLite, Provider |
| Config | python-dotenv |

---

## Project Structure

```
Credit_Score/
├── backend/
│   ├── app.py                  # Flask app entry point, blueprints
│   ├── config.py               # Settings, mock users, JWT config
│   ├── requirements.txt        # Python dependencies
│   ├── api/
│   │   ├── __init__.py         # JWT + role decorators
│   │   ├── auth.py             # Login / token verify
│   │   ├── citizen.py          # Citizen score endpoints
│   │   ├── bank.py             # Bank risk assessment endpoints
│   │   └── admin.py            # Admin audit & stats endpoints
│   ├── ml/
│   │   ├── train_model.py      # Model training script
│   │   ├── feature_extractor.py# Transaction → feature vector
│   │   ├── predictor.py        # XGBoost prediction + score mapping
│   │   ├── explainer.py        # SHAP-based factor explanations
│   │   └── counterfactual.py   # Score improvement suggestions
│   ├── utils/
│   │   ├── audit_logger.py     # Append-only audit log writer
│   │   └── recommendations.py  # Role-specific recommendation engine
│   └── data/
│       ├── model.pkl           # Trained XGBoost model
│       ├── scaler.pkl          # StandardScaler
│       ├── feature_names.pkl   # Feature name mapping
│       ├── anomaly_detector.pkl
│       └── audit_log.json      # Audit event store
│
├── frontend/
│   ├── package.json
│   ├── vite.config.js
│   ├── tailwind.config.js
│   └── src/
│       ├── App.jsx             # Root component, routing, auth flow
│       ├── pages/
│       │   ├── LoginPage.jsx
│       │   ├── CitizenDashboard.jsx
│       │   ├── BankDashboard.jsx
│       │   └── AdminPanel.jsx
│       ├── components/
│       │   ├── common/         # Shared UI components
│       │   ├── citizen/        # Citizen-specific components
│       │   └── bank/           # Bank-specific components
│       └── services/           # Axios API client wrappers
│
├── flutter_app/
│   ├── pubspec.yaml
│   ├── lib/                    # Dart source
│   └── assets/ml/              # Bundled ML assets
│
├── docs/
│   ├── API_REFERENCE.md        # Full API docs with examples
│   └── ARCHITECTURE.md         # Component and data-flow diagrams
│
├── tests/
│   ├── test_features.py
│   ├── test_full_system.py
│   └── reproduce_bug.py
│
└── samples/                    # Sample transaction CSV files
```

---

## Getting Started

### Backend Setup

**Requirements:** Python 3.11+

```bash
# Install dependencies
pip install -r backend/requirements.txt

# (First run) Train the ML model
python -m backend.ml.train_model

# Start the API server
python backend/app.py
```

The API will be available at `http://localhost:5000`.

---

### Frontend Setup

**Requirements:** Node.js 18+

```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

The app will be available at `http://localhost:5173`.

To build for production:

```bash
npm run build
```

---

### Flutter App Setup

**Requirements:** Flutter SDK 3.8+

```bash
cd flutter_app

# Fetch dependencies
flutter pub get

# Run on connected device or emulator
flutter run

# Build release binaries
flutter build apk      # Android
flutter build ios      # iOS
flutter build windows  # Windows desktop
```

---

## Environment Variables

Create a `.env` file in the project root (or `backend/`) with the following:

```env
SECRET_KEY=your-flask-secret-key
JWT_SECRET=your-jwt-signing-secret
DEBUG=True
HUGGINGFACE_API_KEY=        # Optional – used for narrative generation
CORS_ORIGINS=*
```

| Variable | Default | Description |
|---|---|---|
| `SECRET_KEY` | `dev-secret-key-change-in-production` | Flask session signing key |
| `JWT_SECRET` | `jwt-secret-key-change-in-production` | JWT token signing secret |
| `DEBUG` | `True` | Enable Flask debug mode |
| `HUGGINGFACE_API_KEY` | _(empty)_ | Optional API key for AI-generated narratives |
| `CORS_ORIGINS` | `["*"]` | Allowed CORS origins |

> **Production note:** Always replace `SECRET_KEY` and `JWT_SECRET` with strong random values before deployment.

---

## Demo Accounts

The following accounts are available for testing:

| Role | Email | Password |
|---|---|---|
| Citizen | `citizen@test.com` | `password` |
| Bank | `bank@test.com` | `password` |
| Admin | `admin@test.com` | `password` |

---

## API Reference

Base URL: `http://localhost:5000/api`

All protected endpoints require a `Bearer` token in the `Authorization` header.

### Authentication

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/auth/login` | Authenticate and receive a JWT |
| `GET` | `/auth/verify` | Verify token validity |

**Login example:**
```json
POST /api/auth/login
{
  "email": "citizen@test.com",
  "password": "password"
}
```
```json
{
  "token": "eyJ0eXAiOiJKV1Qi...",
  "role": "citizen",
  "user": "John Doe"
}
```

---

### Citizen Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/citizen/score` | Calculate credit score from transaction data |
| `GET` | `/citizen/sample-analysis` | Run analysis on built-in demo data |

**Score request:**
```json
POST /api/citizen/score
Authorization: Bearer <token>

{
  "transactions": [
    {"date": "2024-01-01", "amount": 5000, "category": "salary",  "type": "credit", "balance": 5000},
    {"date": "2024-01-05", "amount": 1200, "category": "rent",    "type": "debit",  "balance": 3800}
  ]
}
```

**Score response:**
```json
{
  "score": 680,
  "category": "Good",
  "probability_of_default": 0.15,
  "trend": "improving",
  "reward_eligible": true,
  "explanations": {
    "positive": ["Consistent income", "Low overdraft frequency"],
    "negative": ["High spending volatility"]
  },
  "improvements": [
    {
      "action": "Reduce spending volatility",
      "detail": "Stabilize your monthly spending patterns",
      "impact": "+25 points",
      "priority": "medium",
      "timeline": "3 months"
    }
  ],
  "recommendations": {
    "narrative": "Your score of 680 reflects good financial habits...",
    "tips": [...],
    "next_steps": [...]
  }
}
```

---

### Bank Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/bank/score` | Assess credit risk for a single applicant |
| `POST` | `/bank/batch` | Batch-assess multiple applicants |
| `GET` | `/bank/thresholds` | Retrieve decision thresholds and criteria |

**Single assessment response:**
```json
{
  "applicant_id": "APP-001",
  "score": 680,
  "risk_level": "MEDIUM",
  "probability_of_default": 0.15,
  "recommendation": {
    "decision": "APPROVE_WITH_CONDITIONS",
    "suggested_limit": 25000,
    "interest_rate_tier": "B",
    "monitoring_flags": ["spending_volatility"],
    "conditions": ["Require income verification"]
  },
  "risk_factors": [...],
  "positive_factors": [...]
}
```

Possible decisions: `APPROVE`, `APPROVE_WITH_CONDITIONS`, `MANUAL_REVIEW`, `DECLINE`.

---

### Admin Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/admin/audit` | Retrieve audit logs (filterable by user, role, action) |
| `GET` | `/admin/stats` | System-wide usage statistics |
| `GET` | `/admin/health` | Service health check |

---

## ML Model

### Training Data
- **Dataset:** UCI Default of Credit Card Clients (30,000 records, 24 features)
- **Task:** Binary classification — predict probability of default

### Pipeline

```
Raw Transactions CSV
       │
       ▼
Feature Extractor  ──→  9-feature vector
       │
       ▼
StandardScaler     ──→  Normalized vector
       │
       ▼
XGBoost Classifier ──→  P(default) ∈ [0, 1]
       │
       ▼
Score Mapping      ──→  Credit Score (300–850)
       │
  ┌────┴────┐
  ▼         ▼
SHAP      Counterfactual
Explainer  Engine
```

### Extracted Features

| Feature | Description |
|---|---|
| `avg_transaction` | Mean transaction amount |
| `transaction_volatility` | Spending consistency (std / mean) |
| `expense_ratio` | Total expenses ÷ total income |
| `payment_consistency` | Max days between payment events |
| `account_age` | Days between first and last transaction |
| `overdraft_frequency` | Overdrafts ÷ total transactions |
| `income_stability` | Income regularity (std / mean of income txns) |
| `category_diversity` | Unique spending categories ÷ 10 |
| `transaction_count` | Total number of transactions |

### Credit Score Categories

| Score Range | Category |
|---|---|
| 800 – 850 | Excellent |
| 740 – 799 | Very Good |
| 670 – 739 | Good |
| 580 – 669 | Fair |
| 300 – 579 | Poor |

---

## Features by Role

### Citizen
- Upload transaction history (CSV or JSON)
- View credit score with trend indicator (improving / stable / declining)
- Read SHAP-powered explanations of positive and negative score factors
- Get prioritized, timeline-based improvement suggestions
- See reward eligibility status
- Try the platform with built-in sample data

### Bank
- Evaluate individual loan applicants
- Batch-process multiple applicants simultaneously
- Receive structured lending decisions with credit limits and interest rate tiers
- View positive and risk factors per applicant
- Access decision threshold documentation

### Admin
- Browse and filter the full audit log by user, role, or action
- View system statistics and usage metrics
- Check backend service health

---

## CSV Transaction Format

When uploading transaction history, use the following CSV column format:

| Column | Type | Required | Description |
|---|---|---|---|
| `date` | `YYYY-MM-DD` | Yes | Transaction date |
| `amount` | `float` | Yes | Transaction amount (absolute value) |
| `category` | `string` | Yes | Category (e.g., `salary`, `rent`, `groceries`) |
| `type` | `string` | Yes | `credit` or `debit` |
| `balance` | `float` | Yes | Account balance after transaction |

**Example:**
```csv
date,amount,category,type,balance
2024-01-01,5000.00,salary,credit,5000.00
2024-01-05,1200.00,rent,debit,3800.00
2024-01-10,150.00,groceries,debit,3650.00
```

Sample files are available in the `samples/` directory.

---

## Running Tests

```bash
# Run all tests from the project root
python -m pytest tests/

# Run specific test file
python -m pytest tests/test_full_system.py -v
```

---

## Docs

Detailed documentation is in the `docs/` directory:

- [`docs/API_REFERENCE.md`](docs/API_REFERENCE.md) — Complete API endpoint reference with request/response examples
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — System architecture, component interactions, and data flow diagrams

---

## License

This project is for educational and demonstration purposes.
