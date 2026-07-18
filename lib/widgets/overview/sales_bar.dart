import 'package:flutter/material.dart';

class SalesBar extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;
  final Color color;
  final String? trailingText;
  final double height;

  const SalesBar({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    this.color = const Color(0xff0F7B94),
    this.trailingText,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = maxValue == 0 ? 0.0 : (value / maxValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Text(
              trailingText ?? value.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: height,
            color: Colors.grey.shade200,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                widthFactor: percentage.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(.8), color],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
