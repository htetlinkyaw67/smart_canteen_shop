import 'package:flutter/material.dart';

class QuickActionGrid extends StatelessWidget {
  final Function(int) onTabChange;

  const QuickActionGrid({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 18),

        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.12,
            children: [
              _ActionCard(
                title: 'Orders',
                subtitle: 'Manage customer orders',
                icon: Icons.receipt_long_outlined,
                color: Colors.orange,
                onTap: () => onTabChange(2),
              ),

              _ActionCard(
                title: 'Menu',
                subtitle: 'Edit menu items',
                icon: Icons.restaurant_menu,
                color: Colors.teal,
                onTap: () => onTabChange(1),
              ),

              _ActionCard(
                title: 'Seats',
                subtitle: 'Manage seat layout',
                icon: Icons.event_seat_outlined,
                color: Colors.blue,
                onTap: () => onTabChange(3),
              ),

              _ActionCard(
                title: 'Wallet',
                subtitle: 'Points & exchange',
                icon: Icons.account_balance_wallet_outlined,
                color: Colors.purple,
                onTap: () => onTabChange(4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
            ),

            const Spacer(),

            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Text(
                  'Open',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(width: 4),

                Icon(Icons.arrow_forward_rounded, color: color, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
