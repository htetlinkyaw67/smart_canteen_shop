import 'package:flutter/material.dart';

class CustomerQrDialog extends StatelessWidget {
  final String orderCode;

  const CustomerQrDialog({super.key, required this.orderCode});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xffF2EEFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.qr_code, color: Color(0xffB39DDB)),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Text(
                    "Customer's pickup QR",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const Divider(),

            const SizedBox(height: 10),

            Container(
              width: 270,
              height: 270,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const FittedBox(
                child: Icon(Icons.qr_code_2, color: Colors.black),
              ),
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xffF2EEFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                orderCode,
                style: const TextStyle(
                  color: Color(0xff6B58D3),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
