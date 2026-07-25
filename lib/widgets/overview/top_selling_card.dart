import 'package:flutter/material.dart';

import '../../models/top_menu_item.dart';
import 'sales_bar.dart';
import 'top_menu_tile.dart';

class TopSellingCard extends StatelessWidget {
  final List<TopMenuItem> items;
  final VoidCallback? onViewAll;

  const TopSellingCard({super.key, required this.items, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final sortedItems = [...items]
      ..sort((a, b) => b.soldCount.compareTo(a.soldCount));

    final totalSold = sortedItems.fold<int>(
      0,
      (sum, item) => sum + item.soldCount,
    );

    final totalRevenue = sortedItems.fold<double>(
      0,
      (sum, item) => sum + item.revenue,
    );

    final highestSold = sortedItems.isEmpty ? 1 : sortedItems.first.soldCount;

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
                  color: Colors.green.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Colors.green,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'ရောင်းအားအကောင်းဆုံး မီနူးများ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Summary
          Row(
            children: [
              Expanded(
                child: _SummaryBox(
                  title: 'ရောင်းရသော မီနူးအရေအတွက်',
                  value: totalSold.toString(),
                  color: Colors.green,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _SummaryBox(
                  title: 'ပွိုင့်များ',
                  value: '${totalRevenue.toStringAsFixed(0)} pts',
                  color: Colors.blue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Top 3 Highlight
          if (sortedItems.isNotEmpty) ...[
            TopMenuTile(item: sortedItems.first, rank: 1),

            const SizedBox(height: 16),
          ],

          // Progress bars
          ...sortedItems
              .take(5)
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SalesBar(
                    label: item.name,
                    value: item.soldCount.toDouble(),
                    maxValue: highestSold.toDouble(),
                    color: Colors.green,
                    trailingText: 'အရေအတွက် ${item.soldCount}',
                  ),
                ),
              ),

          if (sortedItems.isNotEmpty) ...[
            const Divider(height: 30),

            Text(
              '${sortedItems.first.name} သည် ရောင်းအားအကောင်းဆုံးမီနူး ဖြစ်ပါသည်။',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
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
