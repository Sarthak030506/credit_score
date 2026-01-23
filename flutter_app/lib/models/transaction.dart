class Transaction {
  int? id;
  DateTime date;
  double amount;
  String category;
  TransactionType type;
  double balance;
  String? description;
  DateTime createdAt;

  Transaction({
    this.id,
    required this.date,
    required this.amount,
    required this.category,
    required this.type,
    required this.balance,
    this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int?,
      date: DateTime.tryParse(map['date']?.toString() ?? '') ?? DateTime.now(),
      amount: double.tryParse(map['amount']?.toString() ?? '') ?? 0,
      category: map['category']?.toString() ?? 'Other',
      type: (map['type']?.toString().toLowerCase() == 'credit')
          ? TransactionType.credit
          : TransactionType.debit,
      balance: double.tryParse(map['balance']?.toString() ?? '') ?? 0,
      description: map['description']?.toString(),
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String().split('T')[0],
      'amount': amount,
      'category': category,
      'type': type == TransactionType.credit ? 'credit' : 'debit',
      'balance': balance,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

enum TransactionType {
  credit,
  debit,
}
