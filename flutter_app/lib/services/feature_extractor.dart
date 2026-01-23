import 'dart:math';
import '../models/transaction.dart';

class FeatureExtractor {
  static Map<String, dynamic> extractFeatures(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return _getDefaultFeatures();
    }

    final sortedTxns = List<Transaction>.from(transactions)
      ..sort((a, b) => a.date.compareTo(b.date));

    final incomeTransactions =
        sortedTxns.where((t) => t.type == TransactionType.credit).toList();
    final expenseTransactions =
        sortedTxns.where((t) => t.type == TransactionType.debit).toList();

    final totalIncome =
        incomeTransactions.fold(0.0, (sum, t) => sum + t.amount.abs());
    final totalExpenses =
        expenseTransactions.fold(0.0, (sum, t) => sum + t.amount.abs());

    final features = <String, double>{};

    features['transaction_count'] = sortedTxns.length.toDouble();

    final amounts = sortedTxns.map((t) => t.amount.abs()).toList();
    features['avg_transaction'] = _mean(amounts);

    final amtMean = _mean(amounts);
    final amtStd = _standardDeviation(amounts);
    features['transaction_volatility'] =
        amtMean > 0 ? amtStd / (amtMean + 1) : 0.5;

    features['expense_ratio'] =
        totalIncome > 0 ? totalExpenses / (totalIncome + 1) : 1.0;

    double maxPaymentGap = 30.0;
    if (incomeTransactions.length > 1) {
      for (int i = 1; i < incomeTransactions.length; i++) {
        final gap = incomeTransactions[i]
            .date
            .difference(incomeTransactions[i - 1].date)
            .inDays;
        if (gap > maxPaymentGap) {
          maxPaymentGap = gap.toDouble();
        }
      }
    }
    features['payment_consistency'] = maxPaymentGap;

    final overdraftCount =
        sortedTxns.where((t) => t.balance < 0).length.toDouble();
    features['overdraft_frequency'] =
        sortedTxns.isNotEmpty ? overdraftCount / sortedTxns.length : 0;

    if (incomeTransactions.length > 1) {
      final incomeAmounts = incomeTransactions.map((t) => t.amount.abs()).toList();
      final incMean = _mean(incomeAmounts);
      final incStd = _standardDeviation(incomeAmounts);
      features['income_stability'] = incMean > 0 ? incStd / (incMean + 1) : 0.5;
    } else {
      features['income_stability'] = 0.5;
    }

    final uniqueCategories = sortedTxns.map((t) => t.category).toSet().length;
    features['category_diversity'] = min(uniqueCategories / 10, 1.0);

    double accountAge = 30.0;
    if (sortedTxns.length > 1) {
      accountAge = sortedTxns.last.date
          .difference(sortedTxns.first.date)
          .inDays
          .toDouble();
      if (accountAge < 1) accountAge = 30.0;
    }
    features['account_age'] = accountAge;

    final balances = sortedTxns.map((t) => t.balance).toList();
    features['avg_balance'] = _mean(balances);

    return _mapToModelFeatures(features, totalIncome, totalExpenses);
  }

  static Map<String, dynamic> _mapToModelFeatures(
    Map<String, double> features,
    double totalIncome,
    double totalExpenses,
  ) {
    final estimatedLimit = max(totalIncome * 5, 20000.0);

    final maxGap = features['payment_consistency'] ?? 30.0;
    int paymentStatus;
    if (maxGap <= 35) {
      paymentStatus = -1;
    } else if (maxGap <= 45) {
      paymentStatus = 0;
    } else if (maxGap <= 70) {
      paymentStatus = 1;
    } else if (maxGap <= 100) {
      paymentStatus = 2;
    } else {
      paymentStatus = min((maxGap / 30).floor(), 8);
    }

    final billAmt = totalExpenses > 0
        ? totalExpenses / 3
        : (features['avg_balance'] ?? 5000) * 0.5;
    final payAmt = totalIncome > 0 ? totalIncome / 3 : billAmt * 0.3;

    return {
      'LIMIT_BAL': estimatedLimit,
      'AGE': 35.0,
      'PAY_0': paymentStatus.toDouble(),
      'PAY_2': paymentStatus.toDouble(),
      'PAY_3': paymentStatus.toDouble(),
      'BILL_AMT1': billAmt,
      'BILL_AMT2': billAmt * 0.95,
      'BILL_AMT3': billAmt * 0.9,
      'PAY_AMT1': payAmt,
      'PAY_AMT2': payAmt * 0.95,
      'PAY_AMT3': payAmt * 0.9,
      '_raw_features': features,
    };
  }

  static List<double> getFeatureVector(Map<String, dynamic> features) {
    return [
      features['LIMIT_BAL'] as double,
      features['AGE'] as double,
      features['PAY_0'] as double,
      features['PAY_2'] as double,
      features['PAY_3'] as double,
      features['BILL_AMT1'] as double,
      features['BILL_AMT2'] as double,
      features['BILL_AMT3'] as double,
      features['PAY_AMT1'] as double,
      features['PAY_AMT2'] as double,
      features['PAY_AMT3'] as double,
    ];
  }

  static Map<String, dynamic> _getDefaultFeatures() {
    return {
      'LIMIT_BAL': 50000.0,
      'AGE': 35.0,
      'PAY_0': 0.0,
      'PAY_2': 0.0,
      'PAY_3': 0.0,
      'BILL_AMT1': 10000.0,
      'BILL_AMT2': 9500.0,
      'BILL_AMT3': 9000.0,
      'PAY_AMT1': 5000.0,
      'PAY_AMT2': 4750.0,
      'PAY_AMT3': 4500.0,
      '_raw_features': {
        'avg_transaction': 500.0,
        'transaction_volatility': 0.5,
        'expense_ratio': 0.8,
        'payment_consistency': 30.0,
        'overdraft_frequency': 0.0,
        'income_stability': 0.3,
        'category_diversity': 0.5,
        'account_age': 180.0,
        'avg_balance': 5000.0,
      },
    };
  }

  static double _mean(List<double> values) {
    if (values.isEmpty) return 0.0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  static double _standardDeviation(List<double> values) {
    if (values.length < 2) return 0.0;
    final mean = _mean(values);
    final squaredDiffs = values.map((v) => pow(v - mean, 2)).toList();
    return sqrt(squaredDiffs.reduce((a, b) => a + b) / values.length);
  }
}
