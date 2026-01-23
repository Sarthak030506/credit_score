import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../models/transaction.dart';
import '../services/database_service.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Transaction> _transactions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final txns = await DatabaseService.getAllTransactions();
      setState(() => _transactions = txns);
    } catch (e) {
      _showError('Failed to load transactions: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _importCsv() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final csvString = await file.readAsString();
        final rows = const CsvToListConverter().convert(csvString);

        if (rows.isEmpty) {
          _showError('CSV file is empty');
          return;
        }

        // Get headers
        final headers =
            rows.first.map((e) => e.toString().toLowerCase().trim()).toList();

        // Find column indices
        final dateIdx = _findColumnIndex(headers, ['date', 'transaction_date', 'trans_date']);
        final amountIdx = _findColumnIndex(headers, ['amount', 'transaction_amount', 'trans_amount']);
        final categoryIdx = _findColumnIndex(headers, ['category', 'transaction_category', 'trans_category']);
        final typeIdx = _findColumnIndex(headers, ['type', 'transaction_type', 'trans_type']);
        final balanceIdx = _findColumnIndex(headers, ['balance', 'account_balance', 'running_balance']);

        if (dateIdx == -1 || amountIdx == -1) {
          _showError('CSV must have date and amount columns');
          return;
        }

        // Parse transactions
        final transactions = <Transaction>[];
        for (int i = 1; i < rows.length; i++) {
          final row = rows[i];
          if (row.length <= amountIdx) continue;

          double amount = 0;
          try {
            amount = double.parse(row[amountIdx].toString().replaceAll(RegExp(r'[^0-9.-]'), ''));
          } catch (_) {}

          final type = typeIdx >= 0 && row.length > typeIdx
              ? row[typeIdx].toString().toLowerCase()
              : (amount >= 0 ? 'credit' : 'debit');

          double balance = 0;
          if (balanceIdx >= 0 && row.length > balanceIdx) {
             try {
                balance = double.parse(row[balanceIdx].toString().replaceAll(RegExp(r'[^0-9.-]'), ''));
             } catch (_) {}
          }

          transactions.add(Transaction(
            date: DateTime.tryParse(row[dateIdx].toString()) ?? DateTime.now(),
            amount: amount.abs(),
            category: categoryIdx >= 0 && row.length > categoryIdx
                ? row[categoryIdx].toString()
                : 'Other',
            type:
                type == 'credit' ? TransactionType.credit : TransactionType.debit,
            balance: balance,
            createdAt: DateTime.now(),
          ));
        }

        if (transactions.isEmpty) {
          _showError('No valid transactions found in CSV');
          return;
        }

        // Show confirmation dialog
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Import Transactions'),
            content: Text(
              'Found ${transactions.length} transactions. Do you want to replace existing data or add to it?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await DatabaseService.clearTransactions();
                  Navigator.pop(ctx, true);
                },
                child: const Text('Replace'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Add'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await DatabaseService.addTransactions(transactions);
          _showSuccess('Imported ${transactions.length} transactions');
          _loadTransactions();
        }
      }
    } catch (e) {
      _showError('Failed to import CSV: $e');
    }
  }

  int _findColumnIndex(List<String> headers, List<String> possibleNames) {
    for (final name in possibleNames) {
      final idx = headers.indexOf(name);
      if (idx >= 0) return idx;
    }
    return -1;
  }

  Future<void> _loadSampleData() async {
    final category = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Load Sample Data'),
        content: const Text('Choose a credit profile to load:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'excellent'),
            child: const Text('Excellent'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'very_good'),
            child: const Text('Very Good'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'good'),
            child: const Text('Good'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'fair'),
            child: const Text('Fair'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'poor'),
            child: const Text('Poor'),
          ),
        ],
      ),
    );

    if (category != null) {
      await DatabaseService.loadSampleData(category);
      _showSuccess('Loaded $category sample data');
      _loadTransactions();
    }
  }

  Future<void> _addTransaction() async {
    final result = await showDialog<Transaction>(
      context: context,
      builder: (ctx) => const AddTransactionDialog(),
    );

    if (result != null) {
      await DatabaseService.addTransaction(result);
      _loadTransactions();
    }
  }

  Future<void> _deleteTransaction(Transaction txn) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: Text('Delete ${txn.category} transaction of ${txn.amount}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (txn.id != null) {
        await DatabaseService.deleteTransaction(txn.id!);
        _loadTransactions();
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'import') _importCsv();
              if (value == 'sample') _loadSampleData();
              if (value == 'clear') _confirmClear();
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'import', child: Text('Import CSV')),
              const PopupMenuItem(value: 'sample', child: Text('Load Sample Data')),
              const PopupMenuItem(value: 'clear', child: Text('Clear All')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
              ? _buildEmptyState()
              : _buildTransactionList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTransaction,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No transactions yet',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadSampleData,
            icon: const Icon(Icons.download),
            label: const Text('Load Sample Data'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _importCsv,
            icon: const Icon(Icons.upload_file),
            label: const Text('Import CSV'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _transactions.length,
      itemBuilder: (ctx, idx) {
        final txn = _transactions[idx];
        final isCredit = txn.type == TransactionType.credit;

        return Dismissible(
          key: Key(txn.id.toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => _deleteTransaction(txn),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  isCredit ? Colors.green.shade100 : Colors.red.shade100,
              child: Icon(
                isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                color: isCredit ? Colors.green : Colors.red,
              ),
            ),
            title: Text(txn.category),
            subtitle: Text(_formatDate(txn.date)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : '-'}\$${txn.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCredit ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  'Bal: \$${txn.balance.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmClear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Transactions'),
        content: const Text('This will delete all transaction data. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseService.clearTransactions();
      _loadTransactions();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({super.key});

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  double _amount = 0;
  String _category = 'Other';
  TransactionType _type = TransactionType.debit;
  double _balance = 0;

  final _categories = [
    'Salary',
    'Freelance',
    'Rent',
    'Utilities',
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Healthcare',
    'Investments',
    'CreditCardBill',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Transaction'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(_formatDate(_date)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
              ),

              // Amount
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Enter valid amount' : null,
                onSaved: (v) => _amount = double.tryParse(v ?? '') ?? 0,
              ),

              // Type
              DropdownButtonFormField<TransactionType>(
                decoration: const InputDecoration(labelText: 'Type'),
                value: _type,
                items: TransactionType.values.map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text(t == TransactionType.credit ? 'Credit (Income)' : 'Debit (Expense)'),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _type = v!),
              ),

              // Category
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),
                value: _category,
                items: _categories.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c));
                }).toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),

              // Balance
              TextFormField(
                decoration: const InputDecoration(labelText: 'Balance After'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _balance = double.tryParse(v ?? '') ?? 0,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final txn = Transaction(
                date: _date,
                amount: _amount,
                category: _category,
                type: _type,
                balance: _balance,
                createdAt: DateTime.now(),
              );
              Navigator.pop(context, txn);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
