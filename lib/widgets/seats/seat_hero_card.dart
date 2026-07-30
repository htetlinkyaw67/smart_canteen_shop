import 'package:flutter/material.dart';

class SeatHeroCard extends StatelessWidget {
  final int availableTables;
  final int totalTables;
  final double occupancyPercent;

  const SeatHeroCard({
    super.key,
    required this.availableTables,
    required this.totalTables,
    required this.occupancyPercent,
  });

  @override
  Widget build(BuildContext context) {
    final occupiedPercent = (occupancyPercent * 100).clamp(0, 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff0F7B94), Color(0xff18A3C3)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff0F7B94).withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.table_restaurant_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'စားပွဲစီမံခန့်ခွဲမှု',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  'စားပွဲ $totalTables လုံးအနက်',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.90),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$availableTables',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 33,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  'လုံး အားလပ်',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.90),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'ကြိုတင်မှာယူမှုနှင့် စားပွဲအားလပ်မှုကို စောင့်ကြည့်ပါ',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: occupancyPercent.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withValues(alpha: 0.24),
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'စားပွဲအသုံးပြုမှု $occupiedPercent%',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
