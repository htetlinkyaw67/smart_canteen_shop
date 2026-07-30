import 'package:flutter/material.dart';

class OrdersFilterTabs extends StatelessWidget {
  final int selectedIndex;

  final int pendingCount;
  final int preparingCount;
  final int readyCount;
  final int completedCount;

  final ValueChanged<int> onChanged;

  const OrdersFilterTabs({
    super.key,
    required this.selectedIndex,
    required this.pendingCount,
    required this.preparingCount,
    required this.readyCount,
    required this.completedCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(28),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _tab(0, "စောင့်ဆိုင်း", pendingCount, Colors.orange),

          _tab(1, "ပြင်ဆင်နေ", preparingCount, const Color(0xffB39DDB)),

          _tab(2, "အဆင်သင့်", readyCount, const Color(0xff54C7C3)),

          _tab(3, "ပြီးဆုံး", completedCount, const Color(0xff4CD778)),
        ],
      ),
    );
  }

  Widget _tab(int index, String title, int count, Color color) {
    final selected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onChanged(index),
      child: Container(
        margin: const EdgeInsets.only(right: 8),

        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,

          borderRadius: BorderRadius.circular(24),
        ),

        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),

            const SizedBox(width: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "$count",
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
