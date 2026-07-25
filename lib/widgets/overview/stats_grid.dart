import 'package:flutter/material.dart';
import 'stat_card.dart';

class StatsGrid extends StatelessWidget {
  final double revenue;
  final int orders;
  final int pendingOrders;
  final int readyOrders;
  final int customers;
  final int walletPoints;

  final Function(int)? onTabChange;

  const StatsGrid({
    super.key,
    required this.revenue,
    required this.orders,
    required this.pendingOrders,
    required this.readyOrders,
    required this.customers,
    required this.walletPoints,
    this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.35,
        children: [
          StatCard(
            title: 'ဈေးဝယ်သူ',
            value: '$customers',
            icon: Icons.people_alt_outlined,
            color: Colors.purple,
            onTap: () => onTabChange?.call(2),
          ),

          StatCard(
            title: 'အော်ဒါ',
            value: '$orders',
            icon: Icons.receipt_long_outlined,
            color: Colors.blue,
            onTap: () => onTabChange?.call(2),
          ),

          StatCard(
            title: 'စောင့်ဆိုင်းဆဲ',
            value: '$pendingOrders',
            icon: Icons.pending_actions,
            color: Colors.orange,
            onTap: () => onTabChange?.call(2),
          ),

          StatCard(
            title: 'အဆင်သင့်ဖြစ်ပြီး',
            value: '$readyOrders',
            icon: Icons.check_circle_outline,
            color: Colors.green,
            onTap: () => onTabChange?.call(2),
          ),
        ],
      ),
    );
  }
}
