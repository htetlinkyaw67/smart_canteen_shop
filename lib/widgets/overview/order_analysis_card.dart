import 'package:flutter/material.dart';
import 'sales_bar.dart';

class OrderAnalysisCard extends StatelessWidget {
  final int pending;
  final int preparing;
  final int ready;
  final int completed;

  const OrderAnalysisCard({
    super.key,
    required this.pending,
    required this.preparing,
    required this.ready,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    final total = pending + preparing + ready + completed;

    final completionRate = total == 0 ? 0.0 : (completed / total) * 100;

    Color scoreColor;
    String scoreText;

    if (completionRate >= 80) {
      scoreColor = Colors.green;
      scoreText = 'Excellent';
    } else if (completionRate >= 60) {
      scoreColor = Colors.orange;
      scoreText = 'Good';
    } else {
      scoreColor = Colors.red;
      scoreText = 'Needs Attention';
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====================
          // HEADER
          // ====================
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.analytics_outlined, color: Colors.blue),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Order Analysis',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ====================
          // SUMMARY
          // ====================
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'Total Orders',
                  value: total.toString(),
                  color: Colors.blue,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _SummaryCard(
                  title: 'Completion',
                  value: '${completionRate.toStringAsFixed(0)}%',
                  color: scoreColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ====================
          // HEALTH SCORE
          // ====================
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scoreColor.withOpacity(.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.favorite, color: scoreColor),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    'Order Health: $scoreText',
                    style: TextStyle(
                      color: scoreColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ====================
          // ORDER STATUS BARS
          // ====================
          SalesBar(
            label: 'Completed',
            value: completed.toDouble(),
            maxValue: total.toDouble(),
            color: Colors.green,
            trailingText: '$completed',
          ),

          const SizedBox(height: 16),

          SalesBar(
            label: 'Ready',
            value: ready.toDouble(),
            maxValue: total.toDouble(),
            color: Colors.blue,
            trailingText: '$ready',
          ),

          const SizedBox(height: 16),

          SalesBar(
            label: 'Preparing',
            value: preparing.toDouble(),
            maxValue: total.toDouble(),
            color: Colors.orange,
            trailingText: '$preparing',
          ),

          const SizedBox(height: 16),

          SalesBar(
            label: 'Pending',
            value: pending.toDouble(),
            maxValue: total.toDouble(),
            color: Colors.red,
            trailingText: '$pending',
          ),

          const SizedBox(height: 22),

          // ====================
          // INSIGHT
          // ====================
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.withOpacity(.12)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.insights, color: Colors.indigo),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    completionRate >= 80
                        ? 'Great job! Most orders are being completed efficiently.'
                        : completionRate >= 60
                        ? 'Order flow is healthy, but there is room for improvement.'
                        : 'A large number of orders are still waiting. Consider reviewing preparation workflows.',
                    style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
