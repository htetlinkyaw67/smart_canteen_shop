import 'package:flutter/material.dart';
import '../../models/seat_model.dart';

class SeatLayoutCard extends StatelessWidget {
  final List<SeatModel> seats;
  final ValueChanged<SeatModel> onSeatTap;
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
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xffE5EDF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Table Layout',
                      style: TextStyle(
                        color: Color(0xff172B35),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Each table has 4 seats • Tap a table to update its status',
                      style: TextStyle(color: Color(0xff839198), fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.grid_view_rounded, color: Color(0xff0F7B94)),
            ],
          ),
          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: const Color(0xffF6F9FA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.point_of_sale_outlined,
                  size: 18,
                  color: Color(0xff7D8B92),
                ),
                SizedBox(width: 7),
                Text(
                  'COUNTER',
                  style: TextStyle(
                    color: Color(0xff7D8B92),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 1),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: seats.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 9,
              mainAxisSpacing: 10,
              childAspectRatio: 0.92,
            ),
            itemBuilder: (_, index) {
              return _tableTile(seats[index]);
            },
          ),

          const SizedBox(height: 22),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 18),

          Wrap(
            alignment: WrapAlignment.start,
            spacing: 14,
            runSpacing: 12,
            children: [
              _legend(const Color(0xff25B95B), 'Available'),
              _legend(const Color(0xffF05D68), 'Occupied'),
              _legend(const Color(0xffEFB62F), 'Reserved'),
              _legend(const Color(0xff899399), 'Disabled'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tableTile(SeatModel table) {
    final color = table.statusColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSeatTap(table),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.42),
              width: 1.2,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 9,
                right: 9,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.table_restaurant_rounded,
                      size: 25,
                      color: color,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      table.id,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff172B35),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      table.statusLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: color,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legend(Color color, String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xff60717A),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
