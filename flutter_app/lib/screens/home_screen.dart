import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/prediction_result.dart';
import '../services/database_service.dart';
import '../services/prediction_service.dart';
import 'transactions_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  PredictionResult? _latestPrediction;
  int _transactionCount = 0;
  bool _isLoading = false;
  bool _isPredicting = false;
  late AnimationController _scoreAnimationController;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scoreAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scoreAnimationController, curve: Curves.easeOutCubic),
    );
    _loadData();
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final prediction = await PredictionService.getLatest();
      final count = await DatabaseService.getTransactionCount();
      setState(() {
        _latestPrediction = prediction;
        _transactionCount = count;
      });
      if (prediction != null) {
        _scoreAnimationController.forward(from: 0);
      }
    } catch (e) {
      _showError('Failed to load data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _runPrediction() async {
    if (_transactionCount == 0) {
      _showError('Please add transactions first');
      return;
    }

    setState(() => _isPredicting = true);
    try {
      final result = await PredictionService.predict();
      setState(() => _latestPrediction = result);
      _scoreAnimationController.forward(from: 0);
      _showSuccess('Credit score calculated: ${result.score}');
    } catch (e) {
      _showError('Prediction failed: $e');
    } finally {
      setState(() => _isPredicting = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 800) return const Color(0xFF1B5E20);
    if (score >= 740) return const Color(0xFF2E7D32);
    if (score >= 670) return const Color(0xFF1565C0);
    if (score >= 580) return const Color(0xFFEF6C00);
    return const Color(0xFFC62828);
  }

  Color _getScoreLightColor(int score) {
    if (score >= 800) return const Color(0xFFE8F5E9);
    if (score >= 740) return const Color(0xFFE8F5E9);
    if (score >= 670) return const Color(0xFFE3F2FD);
    if (score >= 580) return const Color(0xFFFFF3E0);
    return const Color(0xFFFFEBEE);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  backgroundColor: theme.colorScheme.primary,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text(
                      'Credit Score',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primaryContainer,
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.history, color: Colors.white),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HistoryScreen()),
                      ),
                    ),
                  ],
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildScoreCard(),
                        const SizedBox(height: 20),
                        _buildQuickStats(),
                        const SizedBox(height: 20),
                        _buildActionButtons(),
                        const SizedBox(height: 20),
                        if (_latestPrediction != null) _buildScoreBreakdown(),
                        const SizedBox(height: 20),
                        if (_latestPrediction != null) _buildRecommendations(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildScoreCard() {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        final score = _latestPrediction?.score ?? 0;
        final animatedScore = (score * _scoreAnimation.value).round();

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: _latestPrediction != null
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getScoreLightColor(score),
                      Colors.white,
                    ],
                  )
                : null,
            color: _latestPrediction == null ? Colors.grey.shade100 : null,
            boxShadow: [
              BoxShadow(
                color: _latestPrediction != null
                    ? _getScoreColor(score).withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  'YOUR CREDIT SCORE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                if (_latestPrediction != null) ...[
                  // Circular Score Indicator
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background circle
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: 1,
                            strokeWidth: 12,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation(Colors.grey.shade200),
                          ),
                        ),
                        // Score arc
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Transform.rotate(
                            angle: -math.pi / 2,
                            child: CircularProgressIndicator(
                              value: ((score - 300) / 550) * _scoreAnimation.value,
                              strokeWidth: 12,
                              strokeCap: StrokeCap.round,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation(_getScoreColor(score)),
                            ),
                          ),
                        ),
                        // Score text
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$animatedScore',
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: _getScoreColor(score),
                              ),
                            ),
                            Text(
                              'out of 850',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: _getScoreColor(score).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: _getScoreColor(score).withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      _latestPrediction!.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: _getScoreColor(score),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _latestPrediction!.riskDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ] else ...[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: Icon(
                      Icons.analytics_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Score Yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add transactions and calculate your score',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loadSampleData,
                    icon: const Icon(Icons.bolt, color: Colors.indigo),
                    label: const Text('Load Sample Data (MVP)'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.indigo,
                      backgroundColor: Colors.indigo.shade50,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
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
      await _runPrediction(); // Auto-calculate score
      _loadData(); // Refresh UI
    }
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.receipt_long,
            label: 'Transactions',
            value: '$_transactionCount',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.warning_amber_rounded,
            label: 'Risk Level',
            value: _latestPrediction != null
                ? '${(_latestPrediction!.probabilityOfDefault * 100).toStringAsFixed(1)}%'
                : '--',
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.trending_up,
            label: 'Category',
            value: _latestPrediction?.category.split(' ').first ?? '--',
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isPredicting ? null : _runPrediction,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isPredicting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_graph, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        'Calculate Score',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TransactionsScreen()),
            );
            _loadData();
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_balance_wallet, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                'Manage Transactions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScoreBreakdown() {
    final result = _latestPrediction!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.pie_chart, color: Colors.indigo.shade700),
              ),
              const SizedBox(width: 12),
              const Text(
                'Score Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildBreakdownItem('Payment History', _getPaymentScore(result.pay0), Colors.green),
          _buildBreakdownItem('Credit Utilization', _getUtilizationScore(result), Colors.blue),
          _buildBreakdownItem('Account Stability', _getStabilityScore(result), Colors.purple),
          _buildBreakdownItem('Income Pattern', _getIncomeScore(result), Colors.orange),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: Colors.grey.shade700)),
              Text(
                '${(value * 100).round()}%',
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  double _getPaymentScore(int payStatus) {
    if (payStatus <= -1) return 1.0;
    if (payStatus == 0) return 0.8;
    if (payStatus == 1) return 0.5;
    return 0.2;
  }

  double _getUtilizationScore(PredictionResult result) {
    final ratio = result.billAmt1 / (result.limitBal + 1);
    return (1 - ratio).clamp(0.0, 1.0);
  }

  double _getStabilityScore(PredictionResult result) {
    return (1 - result.overdraftFrequency).clamp(0.0, 1.0);
  }

  double _getIncomeScore(PredictionResult result) {
    return (1 - result.incomeStability).clamp(0.0, 1.0);
  }

  Widget _buildRecommendations() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.lightbulb, color: Colors.amber.shade800),
              ),
              const SizedBox(width: 12),
              const Text(
                'Recommendations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._latestPrediction!.recommendations.map((rec) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.arrow_right,
                        color: Colors.amber.shade800,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rec,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
