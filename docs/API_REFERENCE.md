# Credit Score API Reference

## Base URL
```
http://localhost:5000/api
```

## Authentication

All protected endpoints require a JWT token in the Authorization header:
```
Authorization: Bearer <token>
```

---

## POST /api/login
Authenticate user and receive JWT token.

**Request:**
```json
{"email": "citizen@test.com", "password": "password"}
```

**Response:**
```json 
{"token": "eyJ...", "role": "citizen", "user": "John Doe"}
```

**Demo Accounts:** citizen@test.com, bank@test.com, admin@test.com (all use password: "password")

---

## POST /api/citizen/score
Calculate credit score from transaction data. Role: citizen/admin

**Request:**
```json
{
  "transactions": [
    {"date": "2024-01-01", "amount": 5000, "category": "salary", "type": "credit", "balance": 5000}
  ]
}
```

**Response:**
```json
{
  "score": 680,
  "category": "Good",
  "probability_of_default": 0.15,
  "explanations": {"positive": [...], "negative": [...]},
  "improvements": [{"action": "...", "impact": "+25 points", "priority": "medium"}],
  "recommendations": {"narrative": "...", "tips": [...], "next_steps": [...]}
}
```

---

## POST /api/bank/score
Assess credit risk for loan applicant. Role: bank/admin

**Request:**
```json
{"applicant_id": "APP-001", "transactions": [...]}
```

**Response:**
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

---

## GET /api/admin/audit
Retrieve audit logs. Role: admin

**Query Params:** limit, offset, user, role, action

**Response:**
```json
{
  "logs": [{"timestamp": "...", "user": "...", "action": "...", "score": 680}],
  "stats": {"total_requests": 150, "avg_score": 650}
}
```

---

## GET /api/admin/stats
Get system statistics. Role: admin

---

## GET /api/admin/health
Check system health. Role: admin

---

## CSV Format
```csv
date,amount,category,type,balance
2024-01-01,5000,salary,credit,5000
2024-01-05,1200,rent,debit,3800
```
