import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;
import 'package:path/path.dart';
import '../models/transaction.dart';
import '../models/prediction_result.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'credit_score.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            amount REAL NOT NULL,
            category TEXT NOT NULL,
            type TEXT NOT NULL,
            balance REAL NOT NULL,
            description TEXT,
            created_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE predictions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            score INTEGER NOT NULL,
            category TEXT NOT NULL,
            probability_of_default REAL NOT NULL,
            predicted_at TEXT NOT NULL,
            limit_bal REAL NOT NULL,
            age INTEGER NOT NULL,
            pay0 INTEGER NOT NULL,
            pay2 INTEGER NOT NULL,
            pay3 INTEGER NOT NULL,
            bill_amt1 REAL NOT NULL,
            bill_amt2 REAL NOT NULL,
            bill_amt3 REAL NOT NULL,
            pay_amt1 REAL NOT NULL,
            pay_amt2 REAL NOT NULL,
            pay_amt3 REAL NOT NULL,
            avg_transaction REAL NOT NULL,
            transaction_volatility REAL NOT NULL,
            expense_ratio REAL NOT NULL,
            payment_consistency REAL NOT NULL,
            overdraft_frequency REAL NOT NULL,
            income_stability REAL NOT NULL,
            category_diversity REAL NOT NULL,
            account_age REAL NOT NULL,
            avg_balance REAL NOT NULL
          )
        ''');
      },
    );
  }

  static Future<void> initialize() async {
    await database;
  }

  // Transaction operations
  static Future<List<Transaction>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );
    return maps.map((map) => Transaction.fromMap(map)).toList();
  }

  static Future<int> addTransaction(Transaction transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  static Future<void> addTransactions(List<Transaction> transactions) async {
    final db = await database;
    final batch = db.batch();
    for (final tx in transactions) {
      batch.insert('transactions', tx.toMap());
    }
    await batch.commit(noResult: true);
  }

  static Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> clearTransactions() async {
    final db = await database;
    await db.delete('transactions');
  }

  // Prediction operations
  static Future<List<PredictionResult>> getPredictionHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'predictions',
      orderBy: 'predicted_at DESC',
    );
    return maps.map((map) => PredictionResult.fromMap(map)).toList();
  }

  static Future<PredictionResult?> getLatestPrediction() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'predictions',
      orderBy: 'predicted_at DESC',
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return PredictionResult.fromMap(maps.first);
  }

  static Future<int> savePrediction(PredictionResult result) async {
    final db = await database;
    return await db.insert('predictions', result.toMap());
  }

  // Load sample data
  static Future<void> loadSampleData(String category) async {
    try {
      final jsonString = await rootBundle.loadString('assets/ml/sample_data.json');
      final Map<String, dynamic> allSamples = json.decode(jsonString);

      if (allSamples.containsKey(category)) {
        final List<dynamic> sampleList = allSamples[category];
        final transactions = sampleList.map((item) {
          return Transaction.fromMap(Map<String, dynamic>.from(item));
        }).toList();

        await clearTransactions();
        await addTransactions(transactions);
      }
    } catch (e) {
      print('Error loading sample data: $e');
    }
  }

  // Get transaction count
  static Future<int> getTransactionCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM transactions');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
