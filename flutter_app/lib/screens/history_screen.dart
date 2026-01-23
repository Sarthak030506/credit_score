import 'package:flutter/material.dart';
import '../models/prediction_result.dart';
import '../services/prediction_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<PredictionResult> _history = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final history = await PredictionService.getHistory();
      setState(() => _history = history);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading history: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 800) return Colors.green.shade700;
    if (score >= 740) return Colors.green;
    if (score >= 670) return Colors.blue;
    if (score >= 580) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score History'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? _buildEmptyState()
              : _buildHistoryList(),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No prediction history',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Run a prediction to see your history',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _history.length,
      itemBuilder: (ctx, idx) {
        final result = _history[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => _showDetails(result),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Score circle
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getScoreColor(result.score).withOpacity(0.1),
                      border: Border.all(
                        color: _getScoreColor(result.score),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${result.score}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(result.score),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.category,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Default Risk: ${(result.probabilityOfDefault * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          _formatDateTime(result.predictedAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Arrow
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDetails(PredictionResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (ctx, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Score
              Center(
                child: Column(
                  children: [
                    Text(
                      '${result.score}',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(result.score),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _getScoreColor(result.score).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        result.category,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _getScoreColor(result.score),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Date
              Text(
                'Predicted on ${_formatDateTime(result.predictedAt)}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Feature Details
              const Text(
                'Feature Analysis',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildFeatureRow('Credit Limit', '\$${result.limitBal.toStringAsFixed(0)}'),
              _buildFeatureRow('Payment Status', _getPaymentStatusText(result.pay0)),
              _buildFeatureRow('Average Transaction', '\$${result.avgTransaction.toStringAsFixed(0)}'),
              _buildFeatureRow('Expense Ratio', '${(result.expenseRatio * 100).toStringAsFixed(1)}%'),
              _buildFeatureRow('Overdraft Frequency', '${(result.overdraftFrequency * 100).toStringAsFixed(1)}%'),
              _buildFeatureRow('Income Stability', '${(result.incomeStability * 100).toStringAsFixed(1)}%'),
              _buildFeatureRow('Account Age', '${result.accountAge.toStringAsFixed(0)} days'),
              _buildFeatureRow('Average Balance', '\$${result.avgBalance.toStringAsFixed(0)}'),

              const SizedBox(height: 24),

              // Recommendations
              const Text(
                'Recommendations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...result.recommendations.map((rec) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline,
                            size: 20, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(child: Text(rec)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String _getPaymentStatusText(int status) {
    if (status <= -1) return 'On Time';
    if (status == 0) return 'Revolving';
    return '$status Month(s) Late';
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
