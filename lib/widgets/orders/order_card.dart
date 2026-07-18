import 'package:flutter/material.dart';
import '../../models/order_item.dart';
import 'progress_timeline.dart';

class OrderCard extends StatelessWidget {
  final OrderItem order;

  final VoidCallback onPrimaryAction;
  final VoidCallback onQrPressed;

  const OrderCard({
    super.key,
    required this.order,
    required this.onPrimaryAction,
    required this.onQrPressed,
  });

  Color get statusColor {
    switch (order.status) {
      case OrderStatus.pending:
        return const Color(0xffFF9800);

      case OrderStatus.preparing:
        return const Color(0xff0F7B94);

      case OrderStatus.ready:
        return const Color(0xff0F7B94);

      case OrderStatus.completed:
        return const Color(0xff2EAF6D);
    }
  }

  String get statusText {
    switch (order.status) {
      case OrderStatus.pending:
        return "PENDING";

      case OrderStatus.preparing:
        return "PREPARING";

      case OrderStatus.ready:
        return "READY";

      case OrderStatus.completed:
        return "COMPLETED";
    }
  }

  Widget _buildPrimaryButton() {
    switch (order.status) {
      case OrderStatus.pending:
        return Expanded(
          child: ElevatedButton.icon(
            onPressed: onPrimaryAction,
            icon: const Icon(Icons.soup_kitchen, size: 18),
            label: const Text("Start preparing"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0F7B94),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
            ),
          ),
        );

      case OrderStatus.preparing:
        return Expanded(
          child: ElevatedButton.icon(
            onPressed: onPrimaryAction,
            icon: const Icon(Icons.notifications_active_outlined, size: 18),
            label: const Text("Mark ready & notify"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0F7B94),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
            ),
          ),
        );

      case OrderStatus.ready:
        return Expanded(
          child: ElevatedButton.icon(
            onPressed: onPrimaryAction,
            icon: const Icon(Icons.qr_code_scanner, size: 18),
            label: const Text("Scan to hand over"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0F7B94),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
            ),
          ),
        );

      case OrderStatus.completed:
        return Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xffE8FAEE),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xffB6EBC6)),
            ),
            child: const Center(
              child: Text(
                "✓ Handed over",
                style: TextStyle(
                  color: Color(0xff2A9A4A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xff0F7B94).withOpacity(.08)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff0F7B94).withOpacity(.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // STATUS + POINTS
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(.12),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const Spacer(),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff0F7B94).withOpacity(.08),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: const Color(0xff0F7B94).withOpacity(.12),
                        ),
                      ),
                      child: Text(
                        "${order.points} pts",
                        style: const TextStyle(
                          color: Color(0xff0F7B94),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // CUSTOMER
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xff0F7B94).withOpacity(.10),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          order.customer[0],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0F7B94),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customer,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            order.code,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ORDER ITEMS
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xffF7FAFC),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.restaurant_menu_rounded,
                        color: Color(0xff0F7B94),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          order.items,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),

                if (order.note != null) ...[
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF6EA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order.note!,
                            style: const TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // INFO ROW
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      order.timeAgo,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),

                    const SizedBox(width: 18),

                    Icon(
                      Icons.phone_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        order.phone,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                ProgressTimeline(status: order.status),

                const SizedBox(height: 18),

                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: onQrPressed,
                      icon: const Icon(Icons.qr_code, size: 18),
                      label: const Text("QR"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xff0F7B94),
                        side: BorderSide(
                          color: const Color(0xff0F7B94).withOpacity(.20),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    _buildPrimaryButton(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
