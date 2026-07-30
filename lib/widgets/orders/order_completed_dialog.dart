import 'package:flutter/material.dart';

class OrderCompletedDialog extends StatelessWidget {
  final String? tableNumber;

  const OrderCompletedDialog({super.key, this.tableNumber});

  bool get isTableService =>
      tableNumber != null && tableNumber!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xffE8FAEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xff2EAF6D),
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'အော်ဒါပြီးဆုံးပါပြီ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff1F2D31),
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              isTableService
                  ? 'အော်ဒါကို ${tableNumber!} သို့ ပို့ဆောင်ပြီးပါပြီ'
                  : 'အော်ဒါကို အောင်မြင်စွာ လွှဲပြောင်းပြီးပါပြီ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            if (isTableService) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffF2F8F9),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.table_restaurant_rounded,
                      color: Color(0xff0F7B94),
                      size: 19,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        tableNumber!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xff0F7B94),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xff0F7B94),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'ပြီးပါပြီ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
