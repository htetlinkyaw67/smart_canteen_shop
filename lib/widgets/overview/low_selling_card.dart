import 'package:flutter/material.dart';

import '../../models/top_menu_item.dart';
import 'sales_bar.dart';

class LowSellingCard extends StatelessWidget {
  final List<TopMenuItem> items;
  final VoidCallback? onViewReport;

  const LowSellingCard({super.key, required this.items, this.onViewReport});

  @override
  Widget build(BuildContext context) {
    final lowSellingItems = [...items]
      ..sort((a, b) => a.soldCount.compareTo(b.soldCount));

    final lowestItem = lowSellingItems.isEmpty ? null : lowSellingItems.first;

    final averageSold = items.isEmpty
        ? 0
        : items.fold<int>(0, (sum, item) => sum + item.soldCount) /
              items.length;

    final maxSold = items.isEmpty
        ? 1
        : items.map((e) => e.soldCount).reduce((a, b) => a > b ? a : b);

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
          // =========================
          // HEADER
          // =========================
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.trending_down, color: Colors.red),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Low Selling Items",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              if (onViewReport != null)
                TextButton(
                  onPressed: onViewReport,
                  child: const Text("Report"),
                ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            "Products that may need promotion or review",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),

          const SizedBox(height: 18),

          // =========================
          // ANALYTICS BOXES
          // =========================
          Row(
            children: [
              Expanded(
                child: _SummaryBox(
                  title: "Worst Item",
                  value: lowestItem?.name ?? "-",
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryBox(
                  title: "Avg Sold",
                  value: averageSold.toStringAsFixed(1),
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =========================
          // ITEMS
          // =========================
          if (lowSellingItems.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: Text(
                "No menu data available",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            )
          else
            ...lowSellingItems
                .take(5)
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: SalesBar(
                      label: item.name,
                      value: item.soldCount.toDouble(),
                      maxValue: maxSold.toDouble(),
                      color: Colors.red,
                      trailingText: '${item.soldCount} sold',
                    ),
                  ),
                ),

          if (lowestItem != null) ...[
            const Divider(height: 30),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.withOpacity(.15)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.orange),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "${lowestItem.name} has one of the lowest sales counts. Consider placing it in promotions, bundles, or highlighting it on the menu.",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SummaryBox({
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
