import 'package:flutter/material.dart';
import '../../models/wallet_transaction.dart';

class TransactionTile extends StatelessWidget {
  final WalletTransaction transaction;
  final VoidCallback? onTap;
  final bool compact;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isReceived = transaction.isReceived;

    final Color activityColor = isReceived
        ? const Color(0xff0D9488) // Teal-green accent
        : const Color(0xffE11D48); // Rose-red accent

    final Color cardBackground = isReceived
        ? const Color(0xffF0FDFA) // Soft teal tint
        : const Color(0xffFFF1F2); // Soft rose tint

    final IconData activityIcon = isReceived
        ? Icons.south_west_rounded
        : Icons.north_east_rounded;

    final String pointsText = isReceived
        ? '+${_formatPoints(transaction.points)}'
        : '-${_formatPoints(transaction.points)}';

    return Container(
      margin: EdgeInsets.only(bottom: compact ? 4 : 10),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: activityColor.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: compact ? 8 : 12,
            ),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: activityColor.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(activityIcon, color: activityColor, size: 20),
                ),

                const SizedBox(width: 12),

                // Info Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xff1E293B),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${transaction.subtitle ?? ''}  •  ${_formatDateTime(transaction.createdAt)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xff64748B),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Points Block
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      pointsText,
                      style: TextStyle(
                        color: activityColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'ပွိုင့်',
                      style: TextStyle(
                        color: Color(0xff94A3B8),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatPoints(int value) {
    final digits = value.abs().toString();
    final result = StringBuffer();

    for (int index = 0; index < digits.length; index++) {
      final remainingDigits = digits.length - index;
      result.write(digits[index]);
      if (remainingDigits > 1 && remainingDigits % 3 == 1) {
        result.write(',');
      }
    }
    return result.toString();
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDate = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

    final difference = today.difference(transactionDate).inDays;
    final formattedTime = _formatTime(dateTime);

    if (difference == 0) return formattedTime;
    if (difference == 1) return 'မနေ့က';

    return '${_monthName(dateTime.month)} ${dateTime.day}';
  }

  String _formatTime(DateTime dateTime) {
    final int hour = dateTime.hour;
    final int minute = dateTime.minute;
    final String period = hour >= 12 ? 'PM' : 'AM';
    final int displayHour = hour == 0
        ? 12
        : hour > 12
        ? hour - 12
        : hour;
    final String displayMinute = minute.toString().padLeft(2, '0');

    return '$displayHour:$displayMinute $period';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }
}
