import 'dart:math';
import '../models/prediction_result.dart';
import '../models/transaction.dart';
import 'database_service.dart';
import 'feature_extractor.dart';

class PredictionService {
  /// Run credit score prediction on current transactions
  static Future<PredictionResult> predict() async {
    final transactions = await DatabaseService.getAllTransactions();
    final features = FeatureExtractor.extractFeatures(transactions);
    final featureVector = FeatureExtractor.getFeatureVector(features);

    // Run prediction using heuristic model
    final mlResult = _predict(featureVector);

    final rawFeatures = features['_raw_features'] as Map<String, double>? ?? {};

    // Apply business logic adjustments
    int adjustedScore = mlResult['score'] as int;
    final payStatus = features['PAY_0'] as double;

    if (payStatus > 0) {
      adjustedScore = min(adjustedScore, 660);
    }
    if (payStatus >= 2) {
      adjustedScore = min(adjustedScore, 579);
    }

    final overdraftFreq = rawFeatures['overdraft_frequency'] ?? 0.0;
    if (overdraftFreq > 0.2) {
      adjustedScore = min(adjustedScore, 550);
    } else if (overdraftFreq > 0.1) {
      adjustedScore = min(adjustedScore, 620);
    } else if (overdraftFreq > 0) {
      adjustedScore = min(adjustedScore, 740);
    }

    final volatility = rawFeatures['transaction_volatility'] ?? 0.0;
    if (volatility > 1.0) {
      adjustedScore = min(adjustedScore, 720);
    }

    final expenseRatio = rawFeatures['expense_ratio'] ?? 0.0;
    if (expenseRatio > 0.95) {
      adjustedScore = min(adjustedScore, 650);
    }

    String finalCategory;
    if (adjustedScore >= 800) {
      finalCategory = 'Excellent';
    } else if (adjustedScore >= 740) {
      finalCategory = 'Very Good';
    } else if (adjustedScore >= 670) {
      finalCategory = 'Good';
    } else if (adjustedScore >= 580) {
      finalCategory = 'Fair';
    } else {
      finalCategory = 'Poor';
    }

    final result = PredictionResult(
      score: adjustedScore,
      category: finalCategory,
      probabilityOfDefault: mlResult['probability_of_default'] as double,
      predictedAt: DateTime.now(),
      limitBal: features['LIMIT_BAL'] as double,
      age: (features['AGE'] as double).round(),
      pay0: (features['PAY_0'] as double).round(),
      pay2: (features['PAY_2'] as double).round(),
      pay3: (features['PAY_3'] as double).round(),
      billAmt1: features['BILL_AMT1'] as double,
      billAmt2: features['BILL_AMT2'] as double,
      billAmt3: features['BILL_AMT3'] as double,
      payAmt1: features['PAY_AMT1'] as double,
      payAmt2: features['PAY_AMT2'] as double,
      payAmt3: features['PAY_AMT3'] as double,
      avgTransaction: rawFeatures['avg_transaction'] ?? 0.0,
      transactionVolatility: rawFeatures['transaction_volatility'] ?? 0.0,
      expenseRatio: rawFeatures['expense_ratio'] ?? 0.0,
      paymentConsistency: rawFeatures['payment_consistency'] ?? 0.0,
      overdraftFrequency: rawFeatures['overdraft_frequency'] ?? 0.0,
      incomeStability: rawFeatures['income_stability'] ?? 0.0,
      categoryDiversity: rawFeatures['category_diversity'] ?? 0.0,
      accountAge: rawFeatures['account_age'] ?? 0.0,
      avgBalance: rawFeatures['avg_balance'] ?? 0.0,
    );

    await DatabaseService.savePrediction(result);
    return result;
  }

  static Map<String, dynamic> _predict(List<double> features) {
    final limitBal = features[0];
    final payStatus = features[2];
    final billAmt = features[5];
    final payAmt = features[8];

    double payRisk = payStatus > 0 ? (payStatus / 6).clamp(0.0, 1.0) : 0.0;
    double utilization = limitBal > 0 ? (billAmt / limitBal).clamp(0.0, 1.0) : 0.5;
    double paymentRatio = billAmt > 0 ? (payAmt / billAmt).clamp(0.0, 1.0) : 0.5;

    double defaultProb = (payRisk * 0.4 + utilization * 0.3 + (1 - paymentRatio) * 0.3);
    defaultProb = defaultProb.clamp(0.05, 0.95);

    final score = (300 + (1 - defaultProb) * 550).round();

    return {
      'score': score,
      'probability_of_default': defaultProb,
    };
  }

  static Future<List<PredictionResult>> getHistory() async {
    return DatabaseService.getPredictionHistory();
  }

  static Future<PredictionResult?> getLatest() async {
    return DatabaseService.getLatestPrediction();
  }
}
