# Credit Score Flutter App

A fully offline Flutter application for credit score prediction using machine learning.

## Features

- **Offline ML Inference**: Uses ONNX Runtime for on-device credit score prediction
- **Local Database**: Isar NoSQL database for storing transactions and predictions
- **CSV Import**: Import transaction data from CSV files
- **Sample Data**: Pre-loaded sample profiles for testing
- **Score History**: Track your credit score over time

## Project Structure

```
flutter_app/
├── assets/ml/                    # ML model and data
│   ├── credit_model.onnx        # Converted XGBoost model
│   ├── scaler_params.json       # StandardScaler parameters
│   └── sample_data.json         # Sample transaction data
├── lib/
│   ├── main.dart                # App entry point
│   ├── models/                  # Isar database models
│   │   ├── transaction.dart     # Transaction model
│   │   └── prediction_result.dart # Prediction result model
│   ├── screens/                 # UI screens
│   │   ├── home_screen.dart     # Main dashboard
│   │   ├── transactions_screen.dart # Transaction management
│   │   └── history_screen.dart  # Prediction history
│   └── services/                # Business logic
│       ├── database_service.dart    # Isar database operations
│       ├── ml_service.dart          # ONNX model inference
│       ├── feature_extractor.dart   # Transaction to features
│       └── prediction_service.dart  # Credit score prediction
├── scripts/
│   └── migrate_data.dart        # Data migration script
└── convert_model_to_onnx.py     # Model conversion script
```

## Setup

### Prerequisites

- Flutter SDK 3.8+
- Python 3.8+ (for model conversion)

### Installation

1. **Install Flutter dependencies**:
   ```bash
   cd flutter_app
   flutter pub get
   ```

2. **Generate Isar schemas** (if needed):
   ```bash
   dart run build_runner build
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## Model Conversion

The XGBoost model has been converted to ONNX format. To re-convert:

```bash
cd flutter_app
pip install skl2onnx onnxmltools onnxruntime onnx
python convert_model_to_onnx.py
```

## Features Used for Prediction

The model uses 11 features extracted from transaction data:

| Feature | Description |
|---------|-------------|
| LIMIT_BAL | Estimated credit limit (based on income) |
| AGE | Account holder age (default: 35) |
| PAY_0, PAY_2, PAY_3 | Payment status (-1=on time, 0=revolving, 1+=months late) |
| BILL_AMT1-3 | Bill amounts for last 3 months |
| PAY_AMT1-3 | Payment amounts for last 3 months |

## Credit Score Categories

| Score Range | Category |
|-------------|----------|
| 800-850 | Excellent |
| 740-799 | Very Good |
| 670-739 | Good |
| 580-669 | Fair |
| 300-579 | Poor |

## CSV Format

Import transactions using CSV with these columns:

```csv
date,amount,category,type,balance
2024-01-01,5000,Salary,credit,10000
2024-01-05,-1500,Rent,debit,8500
```

## License

MIT License
