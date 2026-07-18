import 'package:flutter/material.dart';

class SalesHeroCard extends StatelessWidget {
  final double revenue;
  final double profit;
  final double growthPercent;
  final int orders;
  final int customers;
  final String filterLabel;
  final VoidCallback? onAnalyticsTap;

  const SalesHeroCard({
    super.key,
    required this.revenue,
    required this.profit,
    required this.growthPercent,
    required this.orders,
    required this.customers,
    this.filterLabel = "Today",
    this.onAnalyticsTap,
  });

  @override
  Widget build(BuildContext context) {
    final avgOrderValue = orders == 0 ? 0 : (revenue / orders);

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff0F7B94), Color(0xff19A7CE)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(.06),
              ),
            ),
          ),

          Positioned(
            bottom: -40,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(.05),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                const SizedBox(height: 24),

                Text(
                  "Total Points Earned",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "${revenue.toStringAsFixed(0)} pts",
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: growthPercent >= 0 ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${growthPercent >= 0 ? '+' : ''}${growthPercent.toStringAsFixed(1)}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      "vs previous period",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.receipt_long_outlined,
                        title: "Orders",
                        value: orders.toString(),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: _InfoCard(
                        icon: Icons.people_alt_outlined,
                        title: "Customers",
                        value: customers.toString(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.savings_outlined,
                        title: "Profit",
                        value: "${profit.toStringAsFixed(0)} pts",
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: _InfoCard(
                        icon: Icons.analytics_outlined,
                        title: "Avg Order",
                        value: "${avgOrderValue.toStringAsFixed(0)} pts",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.trending_up, color: Colors.white, size: 20),
        ),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sales Overview",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            Text(
              filterLabel,
              style: TextStyle(
                color: Colors.white.withOpacity(.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.75),
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
