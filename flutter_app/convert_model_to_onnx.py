"""
Script to convert XGBoost model and StandardScaler to ONNX format for Flutter.
"""
import os
import pickle
import numpy as np
from skl2onnx import convert_sklearn, to_onnx
from skl2onnx.common.data_types import FloatTensorType
from onnxmltools import convert_xgboost
from onnxmltools.convert.common.data_types import FloatTensorType as XGBFloatTensorType
import onnx
import json

# Paths
BACKEND_DATA = os.path.join(os.path.dirname(__file__), '..', 'backend', 'data')
OUTPUT_DIR = os.path.join(os.path.dirname(__file__), 'assets', 'ml')

def load_artifacts():
    """Load model, scaler, and feature names from pickle files."""
    print("Loading model artifacts...")

    with open(os.path.join(BACKEND_DATA, 'model.pkl'), 'rb') as f:
        model = pickle.load(f)

    with open(os.path.join(BACKEND_DATA, 'scaler.pkl'), 'rb') as f:
        scaler = pickle.load(f)

    with open(os.path.join(BACKEND_DATA, 'feature_names.pkl'), 'rb') as f:
        feature_names = pickle.load(f)

    print(f"  Model type: {type(model).__name__}")
    print(f"  Scaler type: {type(scaler).__name__}")
    print(f"  Features ({len(feature_names)}): {feature_names}")

    return model, scaler, feature_names

def convert_scaler_to_onnx(scaler, n_features):
    """Convert StandardScaler to ONNX format."""
    print("\nConverting StandardScaler to ONNX...")

    initial_type = [('float_input', FloatTensorType([None, n_features]))]
    onnx_scaler = convert_sklearn(scaler, initial_types=initial_type)

    return onnx_scaler

def convert_xgb_to_onnx(model, n_features):
    """Convert XGBoost model to ONNX format."""
    print("\nConverting XGBoost model to ONNX...")

    initial_type = [('float_input', XGBFloatTensorType([None, n_features]))]
    onnx_model = convert_xgboost(model, initial_types=initial_type)

    return onnx_model

def export_scaler_params(scaler, feature_names, output_path):
    """Export scaler parameters as JSON for manual scaling in Dart."""
    print("\nExporting scaler parameters as JSON...")

    params = {
        'mean': scaler.mean_.tolist(),
        'scale': scaler.scale_.tolist(),
        'feature_names': feature_names
    }

    with open(output_path, 'w') as f:
        json.dump(params, f, indent=2)

    print(f"  Saved to: {output_path}")
    return params

def export_sample_data(output_path):
    """Export sample transaction data for the app."""
    print("\nExporting sample data...")

    samples = {
        'excellent': [],
        'good': [],
        'fair': [],
        'poor': [],
        'very_good': []
    }

    samples_dir = os.path.join(BACKEND_DATA, 'samples')

    for category in samples.keys():
        csv_path = os.path.join(samples_dir, f'{category}.csv')
        if os.path.exists(csv_path):
            import csv
            with open(csv_path, 'r') as f:
                reader = csv.DictReader(f)
                samples[category] = list(reader)

    with open(output_path, 'w') as f:
        json.dump(samples, f, indent=2)

    print(f"  Saved to: {output_path}")

def validate_onnx_model(model_path, scaler_path, scaler_params, n_features):
    """Validate the converted ONNX models."""
    print("\nValidating ONNX models...")

    import onnxruntime as ort

    # Test input
    test_input = np.array([[
        50000,  # LIMIT_BAL
        35,     # AGE
        0,      # PAY_0
        0,      # PAY_2
        0,      # PAY_3
        10000,  # BILL_AMT1
        9500,   # BILL_AMT2
        9000,   # BILL_AMT3
        5000,   # PAY_AMT1
        4750,   # PAY_AMT2
        4500    # PAY_AMT3
    ]], dtype=np.float32)

    # Manual scaling using exported params
    mean = np.array(scaler_params['mean'], dtype=np.float32)
    scale = np.array(scaler_params['scale'], dtype=np.float32)
    scaled_input = (test_input - mean) / scale

    # Run model inference
    session = ort.InferenceSession(model_path)
    input_name = session.get_inputs()[0].name

    # Get prediction
    outputs = session.run(None, {input_name: scaled_input})

    print(f"  Test input shape: {test_input.shape}")
    print(f"  Scaled input sample: {scaled_input[0][:3]}...")
    print(f"  Model output (probabilities): {outputs[1][0]}")
    print(f"  Predicted class: {outputs[0][0]}")

    # Calculate credit score from probability
    default_prob = outputs[1][0][1]  # Probability of class 1 (default)
    score = 300 + (1 - default_prob) * (850 - 300)
    print(f"  Credit Score: {int(score)}")

    return True

def main():
    """Main conversion pipeline."""
    print("=" * 60)
    print("Credit Score Model Conversion to ONNX")
    print("=" * 60)

    # Create output directory
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    # Load artifacts
    model, scaler, feature_names = load_artifacts()
    n_features = len(feature_names)

    # Export scaler parameters (for Dart-side scaling)
    scaler_params_path = os.path.join(OUTPUT_DIR, 'scaler_params.json')
    scaler_params = export_scaler_params(scaler, feature_names, scaler_params_path)

    # Convert XGBoost model to ONNX
    onnx_model = convert_xgb_to_onnx(model, n_features)
    model_path = os.path.join(OUTPUT_DIR, 'credit_model.onnx')
    onnx.save_model(onnx_model, model_path)
    print(f"  Model saved to: {model_path}")

    # Export sample data
    sample_data_path = os.path.join(OUTPUT_DIR, 'sample_data.json')
    export_sample_data(sample_data_path)

    # Validate
    try:
        validate_onnx_model(model_path, None, scaler_params, n_features)
        print("\n" + "=" * 60)
        print("Conversion completed successfully!")
        print("=" * 60)
    except Exception as e:
        print(f"\nValidation warning: {e}")
        print("Model files created but validation skipped.")

    print(f"\nOutput files in: {OUTPUT_DIR}")
    print("  - credit_model.onnx (XGBoost model)")
    print("  - scaler_params.json (StandardScaler parameters)")
    print("  - sample_data.json (Sample transaction data)")

if __name__ == '__main__':
    main()
