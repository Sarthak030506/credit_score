import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';
import 'package:path_provider/path_provider.dart';

class MLService {
  static OrtSession? _session;
  static Map<String, dynamic>? _scalerParams;
  static bool _isInitialized = false;

  static List<String> get featureNames => [
        'LIMIT_BAL',
        'AGE',
        'PAY_0',
        'PAY_2',
        'PAY_3',
        'BILL_AMT1',
        'BILL_AMT2',
        'BILL_AMT3',
        'PAY_AMT1',
        'PAY_AMT2',
        'PAY_AMT3',
      ];

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize ONNX Runtime
      OrtEnv.instance.init();

      // Load model from assets
      final modelBytes = await rootBundle.load('assets/ml/credit_model.onnx');
      final modelData = modelBytes.buffer.asUint8List();

      // Write to temporary file (required by onnxruntime)
      final tempDir = await getTemporaryDirectory();
      final modelFile = File('${tempDir.path}/credit_model.onnx');
      await modelFile.writeAsBytes(modelData);

      // Create session options
      final sessionOptions = OrtSessionOptions();

      // Create session
      _session = OrtSession.fromFile(modelFile, sessionOptions);

      // Load scaler parameters
      final scalerJson =
          await rootBundle.loadString('assets/ml/scaler_params.json');
      _scalerParams = json.decode(scalerJson);

      _isInitialized = true;
      print('ML Service initialized successfully');
    } catch (e) {
      print('Error initializing ML Service: $e');
      // Don't rethrow - allow app to run with fallback predictions
      _isInitialized = false;
    }
  }

  static List<double> scaleFeatures(List<double> features) {
    if (_scalerParams == null) {
      throw Exception('Scaler parameters not loaded');
    }

    final mean = List<double>.from(
        (_scalerParams!['mean'] as List).map((e) => (e as num).toDouble()));
    final scale = List<double>.from(
        (_scalerParams!['scale'] as List).map((e) => (e as num).toDouble()));

    final scaled = <double>[];
    for (int i = 0; i < features.length; i++) {
      scaled.add((features[i] - mean[i]) / scale[i]);
    }

    return scaled;
  }

  static Future<Map<String, dynamic>> predict(List<double> features) async {
    // Try ONNX inference first
    if (_isInitialized && _session != null) {
      try {
        return await _runOnnxInference(features);
      } catch (e) {
        print('ONNX inference failed, using fallback: $e');
      }
    }

    // Fallback to heuristic-based prediction
    return _fallbackPredict(features);
  }

  static Future<Map<String, dynamic>> _runOnnxInference(
      List<double> features) async {
    // Scale features
    final scaledFeatures = scaleFeatures(features);

    // Create input tensor
    final inputData =
        Float32List.fromList(scaledFeatures.map((e) => e.toDouble()).toList());
    final inputOrt = OrtValueTensor.createTensorWithDataList(
      inputData,
      [1, features.length],
    );

    // Run inference
    final inputs = {'float_input': inputOrt};
    final runOptions = OrtRunOptions();
    final outputs = _session!.run(runOptions, inputs);

    // Parse outputs - XGBoost classifier outputs: [labels, probabilities]
    double defaultProb = 0.5;
    int predictedClass = 0;

    try {
      // First output: predicted labels
      final labelOutput = outputs[0]?.value;
      if (labelOutput is List && labelOutput.isNotEmpty) {
        predictedClass = labelOutput[0] is int
            ? labelOutput[0]
            : (labelOutput[0] as num).toInt();
      }

      // Second output: probabilities (as list of maps or list of lists)
      final probOutput = outputs[1]?.value;
      if (probOutput is List && probOutput.isNotEmpty) {
        final firstProb = probOutput[0];
        if (firstProb is Map) {
          // Format: [{0: prob0, 1: prob1}]
          defaultProb = (firstProb[1] ?? firstProb['1'] ?? 0.5) as double;
        } else if (firstProb is List && firstProb.length > 1) {
          // Format: [[prob0, prob1]]
          defaultProb = (firstProb[1] as num).toDouble();
        }
      }
    } catch (e) {
      print('Error parsing ONNX output: $e');
    }

    // Clean up
    inputOrt.release();
    runOptions.release();
    for (var output in outputs) {
      output?.release();
    }

    // Calculate credit score (300-850)
    final score = (300 + (1 - defaultProb) * 550).round();

    return {
      'score': score,
      'category': _getCategory(score),
      'probability_of_default': defaultProb,
      'predicted_class': predictedClass,
    };
  }

  static Map<String, dynamic> _fallbackPredict(List<double> features) {
    // Heuristic-based prediction when ONNX is unavailable
    // Features: LIMIT_BAL, AGE, PAY_0, PAY_2, PAY_3, BILL_AMT1-3, PAY_AMT1-3

    final limitBal = features[0];
    final payStatus = features[2]; // PAY_0
    final billAmt = features[5]; // BILL_AMT1
    final payAmt = features[8]; // PAY_AMT1

    // Calculate risk factors
    double payRisk = payStatus > 0 ? (payStatus / 6).clamp(0.0, 1.0) : 0.0;
    double utilization = limitBal > 0 ? (billAmt / limitBal).clamp(0.0, 1.0) : 0.5;
    double paymentRatio =
        billAmt > 0 ? (payAmt / billAmt).clamp(0.0, 1.0) : 0.5;

    // Combine factors for default probability
    double defaultProb =
        (payRisk * 0.4 + utilization * 0.3 + (1 - paymentRatio) * 0.3);
    defaultProb = defaultProb.clamp(0.05, 0.95);

    final score = (300 + (1 - defaultProb) * 550).round();

    return {
      'score': score,
      'category': _getCategory(score),
      'probability_of_default': defaultProb,
      'predicted_class': defaultProb > 0.5 ? 1 : 0,
    };
  }

  static String _getCategory(int score) {
    if (score >= 800) return 'Excellent';
    if (score >= 740) return 'Very Good';
    if (score >= 670) return 'Good';
    if (score >= 580) return 'Fair';
    return 'Poor';
  }

  static void dispose() {
    _session?.release();
    _session = null;
    _isInitialized = false;
  }
}
