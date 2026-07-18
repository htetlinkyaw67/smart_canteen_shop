import 'package:flutter/material.dart';

class ReadyPickupCard extends StatelessWidget {
  final String customer;
  final String code;
  final String items;
  final String timeAgo;
  final VoidCallback onTap;

  const ReadyPickupCard({
    super.key,
    required this.customer,
    required this.code,
    required this.items,
    required this.timeAgo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xffF3FBFA),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xffBEEDEA)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.notifications_active_outlined,
                        size: 12,
                        color: Color(0xff0F7B94),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "READY",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff0F7B94),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  timeAgo,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              customer,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(
              code,
              style: const TextStyle(color: Color(0xff0F7B94), fontSize: 13),
            ),

            const Spacer(),

            Text(
              items,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
