class PredictionResult {
  int? id;
  int score;
  String category;
  double probabilityOfDefault;
  DateTime predictedAt;

  // Feature values
  double limitBal;
  int age;
  int pay0;
  int pay2;
  int pay3;
  double billAmt1;
  double billAmt2;
  double billAmt3;
  double payAmt1;
  double payAmt2;
  double payAmt3;

  // Raw features
  double avgTransaction;
  double transactionVolatility;
  double expenseRatio;
  double paymentConsistency;
  double overdraftFrequency;
  double incomeStability;
  double categoryDiversity;
  double accountAge;
  double avgBalance;

  PredictionResult({
    this.id,
    required this.score,
    required this.category,
    required this.probabilityOfDefault,
    required this.predictedAt,
    required this.limitBal,
    required this.age,
    required this.pay0,
    required this.pay2,
    required this.pay3,
    required this.billAmt1,
    required this.billAmt2,
    required this.billAmt3,
    required this.payAmt1,
    required this.payAmt2,
    required this.payAmt3,
    required this.avgTransaction,
    required this.transactionVolatility,
    required this.expenseRatio,
    required this.paymentConsistency,
    required this.overdraftFrequency,
    required this.incomeStability,
    required this.categoryDiversity,
    required this.accountAge,
    required this.avgBalance,
  });

  String get riskDescription {
    switch (category) {
      case 'Excellent':
        return 'Exceptional credit management. You demonstrate outstanding financial discipline.';
      case 'Very Good':
        return 'Above average credit profile. You show strong financial responsibility.';
      case 'Good':
        return 'Solid credit standing. You maintain healthy financial habits.';
      case 'Fair':
        return 'Average credit profile. There is room for improvement in your financial behavior.';
      case 'Poor':
        return 'Below average credit. Consider improving payment consistency and reducing debt.';
      default:
        return 'Unable to determine risk category.';
    }
  }

  List<String> get recommendations {
    final recs = <String>[];

    if (pay0 > 0) {
      recs.add('Improve payment timing - avoid late payments');
    }
    if (overdraftFrequency > 0.05) {
      recs.add('Maintain positive account balance to avoid overdrafts');
    }
    if (expenseRatio > 0.9) {
      recs.add('Reduce expense ratio - save more of your income');
    }
    if (transactionVolatility > 0.8) {
      recs.add('Work towards more stable income patterns');
    }
    if (paymentConsistency > 40) {
      recs.add('Make payments more regularly throughout the month');
    }

    if (recs.isEmpty) {
      recs.add('Continue maintaining your excellent financial habits!');
    }

    return recs;
  }

  factory PredictionResult.fromMap(Map<String, dynamic> map) {
    return PredictionResult(
      id: map['id'] as int?,
      score: map['score'] as int,
      category: map['category'] as String,
      probabilityOfDefault: (map['probability_of_default'] as num).toDouble(),
      predictedAt: DateTime.parse(map['predicted_at'] as String),
      limitBal: (map['limit_bal'] as num).toDouble(),
      age: map['age'] as int,
      pay0: map['pay0'] as int,
      pay2: map['pay2'] as int,
      pay3: map['pay3'] as int,
      billAmt1: (map['bill_amt1'] as num).toDouble(),
      billAmt2: (map['bill_amt2'] as num).toDouble(),
      billAmt3: (map['bill_amt3'] as num).toDouble(),
      payAmt1: (map['pay_amt1'] as num).toDouble(),
      payAmt2: (map['pay_amt2'] as num).toDouble(),
      payAmt3: (map['pay_amt3'] as num).toDouble(),
      avgTransaction: (map['avg_transaction'] as num).toDouble(),
      transactionVolatility: (map['transaction_volatility'] as num).toDouble(),
      expenseRatio: (map['expense_ratio'] as num).toDouble(),
      paymentConsistency: (map['payment_consistency'] as num).toDouble(),
      overdraftFrequency: (map['overdraft_frequency'] as num).toDouble(),
      incomeStability: (map['income_stability'] as num).toDouble(),
      categoryDiversity: (map['category_diversity'] as num).toDouble(),
      accountAge: (map['account_age'] as num).toDouble(),
      avgBalance: (map['avg_balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'score': score,
      'category': category,
      'probability_of_default': probabilityOfDefault,
      'predicted_at': predictedAt.toIso8601String(),
      'limit_bal': limitBal,
      'age': age,
      'pay0': pay0,
      'pay2': pay2,
      'pay3': pay3,
      'bill_amt1': billAmt1,
      'bill_amt2': billAmt2,
      'bill_amt3': billAmt3,
      'pay_amt1': payAmt1,
      'pay_amt2': payAmt2,
      'pay_amt3': payAmt3,
      'avg_transaction': avgTransaction,
      'transaction_volatility': transactionVolatility,
      'expense_ratio': expenseRatio,
      'payment_consistency': paymentConsistency,
      'overdraft_frequency': overdraftFrequency,
      'income_stability': incomeStability,
      'category_diversity': categoryDiversity,
      'account_age': accountAge,
      'avg_balance': avgBalance,
    };
  }
}
