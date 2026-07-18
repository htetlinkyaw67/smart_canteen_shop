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
            title: 'Points Earned',
            value: '${revenue.toStringAsFixed(0)} pts',
            icon: Icons.payments_outlined,
            color: Colors.green,
            onTap: () => onTabChange?.call(4),
          ),

          StatCard(
            title: 'Orders',
            value: '$orders',
            icon: Icons.receipt_long_outlined,
            color: Colors.blue,
            onTap: () => onTabChange?.call(2),
          ),

          StatCard(
            title: 'Pending',
            value: '$pendingOrders',
            icon: Icons.pending_actions,
            color: Colors.orange,
            onTap: () => onTabChange?.call(2),
          ),

          StatCard(
            title: 'Ready',
            value: '$readyOrders',
            icon: Icons.check_circle_outline,
            color: Colors.green,
            onTap: () => onTabChange?.call(2),
          ),

          StatCard(
            title: 'Customers',
            value: '$customers',
            icon: Icons.people_alt_outlined,
            color: Colors.purple,
            onTap: () => onTabChange?.call(2),
          ),

          StatCard(
            title: 'Wallet Points',
            value: '$walletPoints',
            icon: Icons.account_balance_wallet_outlined,
            color: Colors.teal,
            onTap: () => onTabChange?.call(4),
          ),
        ],
      ),
    );
  }
}
