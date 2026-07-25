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
    this.filterLabel = "ဒီနေ့",
    this.onAnalyticsTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  "ပွိုင့်စုစုပေါင်း",
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
              "ရောင်းအားသုံးသပ်ချက်",
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
