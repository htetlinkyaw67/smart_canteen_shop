import 'package:flutter/material.dart';
import '../../models/sale_data.dart';

class SalesTrendCard extends StatelessWidget {
  final List<SaleData> salesData;
  final String title;

  const SalesTrendCard({
    super.key,
    required this.salesData,
    this.title = 'ရောင်းအား',
  });

  @override
  Widget build(BuildContext context) {
    final maxRevenue = salesData.isEmpty
        ? 1.0
        : salesData.map((e) => e.revenue).reduce((a, b) => a > b ? a : b);

    final totalRevenue = salesData.fold<double>(
      0,
      (sum, item) => sum + item.revenue,
    );

    final totalOrders = salesData.fold<int>(
      0,
      (sum, item) => sum + item.orders,
    );

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
          // Header
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xff0F7B94).withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.show_chart, color: Color(0xff0F7B94)),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Summary
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  title: 'ပွိုင့်စုစုပေါင်း',
                  value: '${totalRevenue.toStringAsFixed(0)} pts',
                  color: Colors.green,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _SummaryTile(
                  title: 'အော်ဒါ',
                  value: '$totalOrders',
                  color: Colors.blue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Chart
          SizedBox(
            height: 220,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: salesData.map((sale) {
                  final double barHeight = maxRevenue <= 0
                      ? 0
                      : (sale.revenue / maxRevenue) * 140;

                  return Container(
                    width: 38,
                    margin: const EdgeInsets.symmetric(horizontal: 9),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          sale.orders.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 45,
                          height: barHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xff19A7CE), Color(0xff0F7B94)],
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          sale.label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${sale.revenue.toInt()}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Divider(color: Colors.grey.shade200),

          const SizedBox(height: 8),

          Text(
            'Highest sales: ${salesData.isEmpty ? '-' : salesData.reduce((a, b) => a.revenue > b.revenue ? a : b).label}',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SummaryTile({
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
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
