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
        return const Color(0xffF59E0B);
      case OrderStatus.preparing:
        return const Color(0xff0F7B94);
      case OrderStatus.ready:
        return const Color(0xff14A7A0);
      case OrderStatus.completed:
        return const Color(0xff2EAF6D);
    }
  }

  String get statusText {
    switch (order.status) {
      case OrderStatus.pending:
        return 'စောင့်ဆိုင်း';
      case OrderStatus.preparing:
        return 'ပြင်ဆင်နေ';
      case OrderStatus.ready:
        return 'အဆင်သင့်';
      case OrderStatus.completed:
        return 'ပြီးဆုံး';
    }
  }

  IconData get actionIcon {
    switch (order.status) {
      case OrderStatus.pending:
        return Icons.soup_kitchen_rounded;
      case OrderStatus.preparing:
        return Icons.notifications_active_outlined;
      case OrderStatus.ready:
        return Icons.qr_code_scanner_rounded;
      case OrderStatus.completed:
        return Icons.check_circle_rounded;
    }
  }

  String get actionText {
    switch (order.status) {
      case OrderStatus.pending:
        return 'စတင်ပြင်ဆင်မည်';
      case OrderStatus.preparing:
        return 'အသင့်ဖြစ်ကြောင်း အသိပေးမည်';
      case OrderStatus.ready:
        return 'လွှဲပြောင်းရန် စကင်ဖတ်မည်';
      case OrderStatus.completed:
        return 'လွှဲပြောင်းပြီးပါပြီ';
    }
  }

  String get customerInitial {
    final name = order.customer.trim();
    return name.isEmpty ? '?' : name.characters.first;
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = order.status == OrderStatus.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffE6ECEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xff0F7B94).withOpacity(.10),
                  child: Text(
                    customerInitial,
                    style: const TextStyle(
                      color: Color(0xff0F7B94),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.customer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.code,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(.11),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (order.isTableService) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffEAF7F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xffB8DDE6)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.table_restaurant_rounded,
                      size: 18,
                      color: Color(0xff0F7B94),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'စားပွဲဝန်ဆောင်မှု',
                      style: TextStyle(
                        color: Color(0xff52666B),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      order.tableNumber!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff0F7B94),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xffF7FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.restaurant_menu_rounded,
                    size: 18,
                    color: Color(0xff0F7B94),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.items,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${order.points} ပွိုင့်',
                    style: const TextStyle(
                      color: Color(0xff0F7B94),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (order.note != null && order.note!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 15,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      order.note!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    order.timeAgo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.phone_outlined,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    order.phone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ProgressTimeline(status: order.status),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  width: 42,
                  height: 40,
                  child: OutlinedButton(
                    onPressed: onQrPressed,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: const Color(0xff0F7B94),
                      side: BorderSide(
                        color: const Color(0xff0F7B94).withOpacity(.22),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Icon(Icons.qr_code_rounded, size: 19),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: isCompleted ? null : onPrimaryAction,
                      icon: Icon(actionIcon, size: 17),
                      label: Text(
                        actionText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: isCompleted
                            ? const Color(0xffE8FAEE)
                            : const Color(0xff0F7B94),
                        foregroundColor: isCompleted
                            ? const Color(0xff2A9A4A)
                            : Colors.white,
                        disabledBackgroundColor: const Color(0xffE8FAEE),
                        disabledForegroundColor: const Color(0xff2A9A4A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
