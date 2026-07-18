import 'package:flutter/material.dart';
import '../../models/order_item.dart';

class OrderMatchedDialog extends StatelessWidget {
  final OrderItem order;

  final VoidCallback onComplete;

  const OrderMatchedDialog({
    super.key,
    required this.order,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SUCCESS ICON
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xffE8FAEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xff4CD778),
                size: 42,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Order matched",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              "Customer QR successfully verified",
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xffFAFAFA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(
                          0xff54C7C3,
                        ).withOpacity(.15),
                        child: Text(
                          order.customer[0],
                          style: const TextStyle(
                            color: Color(0xff54C7C3),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.customer,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              order.code,
                              style: const TextStyle(color: Color(0xff0F7B94)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _infoRow(Icons.shopping_bag_outlined, "Items", order.items),

                  const SizedBox(height: 12),

                  _infoRow(Icons.phone_outlined, "Phone", order.phone),

                  const SizedBox(height: 12),

                  _infoRow(
                    Icons.workspace_premium_outlined,
                    "Points",
                    "${order.points} pts",
                  ),

                  if (order.note != null) ...[
                    const SizedBox(height: 16),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFF7E9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xffFFD89A)),
                        ),
                        child: Text(
                          order.note!,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      onComplete();
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("Done — Hand Over"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4CD778),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 14),
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

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),

        const SizedBox(width: 10),

        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),

        Expanded(child: Text(value)),
      ],
    );
  }
}
