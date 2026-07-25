import 'package:flutter/material.dart';

enum SalesFilter { today, week, month, allTime }

class SalesFilterChips extends StatelessWidget {
  final SalesFilter selectedFilter;
  final ValueChanged<SalesFilter> onChanged;

  const SalesFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _chip(label: 'ယနေ့', filter: SalesFilter.today),
          const SizedBox(width: 10),

          _chip(label: '၇ ရက်', filter: SalesFilter.week),
          const SizedBox(width: 10),

          _chip(label: '၃၀ ရက်', filter: SalesFilter.month),
          const SizedBox(width: 10),

          _chip(label: 'အားလုံး', filter: SalesFilter.allTime),
        ],
      ),
    );
  }

  Widget _chip({required String label, required SalesFilter filter}) {
    final isSelected = selectedFilter == filter;

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => onChanged(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff0F7B94) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? const Color(0xff0F7B94) : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
