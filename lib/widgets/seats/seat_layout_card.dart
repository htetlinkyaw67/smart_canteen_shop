import 'package:flutter/material.dart';

import '../../models/seat_model.dart';

class SeatLayoutCard extends StatelessWidget {
  final List<SeatModel> seats;
  final Function(SeatModel) onSeatTap;

  final int columns;

  const SeatLayoutCard({
    super.key,
    required this.seats,
    required this.onSeatTap,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const SizedBox(height: 18),

          Container(
            width: 180,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(999),
            ),
          ),

          const SizedBox(height: 14),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.point_of_sale_outlined, size: 18, color: Colors.grey),
              SizedBox(width: 6),
              Text(
                "COUNTER",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: columns * 84,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: seats.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (_, index) {
                  return _seatTile(seats[index]);
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          Divider(color: Colors.grey.shade200),

          const SizedBox(height: 18),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 18,
            runSpacing: 12,
            children: [
              _legend(Colors.white, Colors.grey.shade400, "Available"),
              _legend(const Color(0xFFFFECEC), Colors.redAccent, "Occupied"),
              _legend(const Color(0xFFFFF5DD), Colors.amber, "Reserved"),
              _legend(const Color(0xFFF2F2F2), Colors.grey, "Disabled"),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            "Tap any seat to change status",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _seatTile(SeatModel seat) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => onSeatTap(seat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: seat.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(seat.icon, size: 18, color: seat.statusColor),

            const SizedBox(height: 6),

            Text(
              seat.id,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legend(Color bg, Color border, String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: border),
          ),
        ),

        const SizedBox(width: 6),

        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
