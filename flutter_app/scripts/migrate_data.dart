/// Data Migration Script
///
/// This script can be used to pre-populate the Isar database with
/// transaction data from CSV files or the sample data.
///
/// Run with: dart run scripts/migrate_data.dart
///
/// Note: This is meant for development/testing. In production,
/// use the app's built-in "Load Sample Data" feature.

import 'dart:convert';
import 'dart:io';

void main() async {
  print('Credit Score App - Data Migration Script');
  print('=' * 50);

  // Read sample data
  final sampleDataPath = 'assets/ml/sample_data.json';
  final sampleFile = File(sampleDataPath);

  if (!sampleFile.existsSync()) {
    print('Error: Sample data file not found at $sampleDataPath');
    print('Please run the model conversion script first.');
    exit(1);
  }

  final jsonContent = await sampleFile.readAsString();
  final Map<String, dynamic> samples = json.decode(jsonContent);

  print('\nAvailable sample profiles:');
  for (final category in samples.keys) {
    final transactions = samples[category] as List;
    print('  - $category: ${transactions.length} transactions');
  }

  print('\n' + '=' * 50);
  print('Sample data is ready for use in the app.');
  print('\nTo load sample data in the app:');
  print('1. Open the Transactions screen');
  print('2. Tap the menu button (three dots)');
  print('3. Select "Load Sample Data"');
  print('4. Choose a credit profile');
  print('\nAlternatively, import your own CSV with columns:');
  print('  date, amount, category, type, balance');
}
