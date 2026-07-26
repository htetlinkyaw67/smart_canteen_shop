import 'package:flutter/material.dart';

import '../models/wallet_transaction.dart';
import '../widgets/wallet/wallet_action_button.dart';
import '../widgets/wallet/wallet_balance_card.dart';
import '../widgets/wallet/transaction_tile.dart';
import '../widgets/page_header.dart';

import 'notification_page.dart';
import 'transaction_history_page.dart';
import 'my_qr_page.dart';
import 'transfer_page.dart';

class WalletPage extends StatefulWidget {
  final VoidCallback onOpenScanner;

  const WalletPage({super.key, required this.onOpenScanner});

  @override
  State<WalletPage> createState() => WalletPageState();
}

class WalletPageState extends State<WalletPage> {
  bool _isShopOpen = true;

  int walletBalance = 1600;

  final List<WalletTransaction> transactions = [
    WalletTransaction(
      id: 'TXN-001',
      title: 'Points received',
      subtitle: 'Order #1048',
      points: 500,
      type: WalletTransactionType.received,
      createdAt: DateTime(2026, 7, 26, 18, 30),
    ),
    WalletTransaction(
      id: 'TXN-002',
      title: 'Points transferred',
      subtitle: 'Student wallet',
      points: 200,
      type: WalletTransactionType.sent,
      createdAt: DateTime(2026, 7, 26, 15, 20),
    ),
    WalletTransaction(
      id: 'TXN-003',
      title: 'Payment received',
      subtitle: 'Order #1047',
      points: 350,
      type: WalletTransactionType.received,
      createdAt: DateTime(2026, 7, 25, 13, 10),
    ),
    WalletTransaction(
      id: 'TXN-004',
      title: 'Points transferred',
      subtitle: 'Student wallet',
      points: 100,
      type: WalletTransactionType.sent,
      createdAt: DateTime(2026, 7, 24, 17, 45),
    ),
    WalletTransaction(
      id: 'TXN-005',
      title: 'Points received',
      subtitle: 'Order #1046',
      points: 250,
      type: WalletTransactionType.received,
      createdAt: DateTime(2026, 7, 24, 11, 15),
    ),
    WalletTransaction(
      id: 'TXN-006',
      title: 'Points transferred',
      subtitle: 'Student wallet',
      points: 50,
      type: WalletTransactionType.sent,
      createdAt: DateTime(2026, 7, 23, 9, 30),
    ),
    WalletTransaction(
      id: 'TXN-007',
      title: 'Payment received',
      subtitle: 'Order #1045',
      points: 400,
      type: WalletTransactionType.received,
      createdAt: DateTime(2026, 7, 22, 14, 10),
    ),
  ];

  List<WalletTransaction> get recentTransactions {
    final sortedTransactions = [...transactions];

    sortedTransactions.sort((first, second) {
      return second.createdAt.compareTo(first.createdAt);
    });

    return sortedTransactions.take(5).toList();
  }

  void _handleLogout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'ထွက်မည်',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: const Text('ထွက်မယ်ဆိုတာ သေချာပါသလား။'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('မလုပ်တော့ပါ'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();

                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Text('ထွက်မည်'),
            ),
          ],
        );
      },
    );
  }

  void showWalletScanResult() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xffD9E1E5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    color: const Color(0xff0F7B94).withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Color(0xff0F7B94),
                    size: 31,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Wallet QR Scanned',
                  style: TextStyle(
                    color: Color(0xff172B35),
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'The wallet was found. Continue to enter '
                  'the points you want to transfer.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff7E8D94),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xff0F7B94),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(sheetContext);

                      // Next step:
                      // Open your point amount + PIN transfer sheet.
                    },
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text(
                      'Continue',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openMyQr() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MyQrPage()),
    );
  }

  void _openHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionHistoryPage(transactions: transactions),
      ),
    );
  }

  void _showTransactionDetails(WalletTransaction transaction) {
    final bool isReceived = transaction.isReceived;

    final Color activityColor = isReceived
        ? const Color(0xff22C55E) // Match success color
        : const Color(0xff0F7B94); // Match primary brand color

    final IconData activityIcon = isReceived
        ? Icons.south_west_rounded
        : Icons.north_east_rounded;

    final String amountText = isReceived
        ? '+${_formatPoints(transaction.points)} pts'
        : '-${_formatPoints(transaction.points)} pts';

    // Fintech Voucher Theme Colors
    const Color voucherSheetBg = Color(0xffF1F5F9);
    const Color voucherCardBg = Color(0xffFFFFFF);
    const Color primary = Color(0xff0F7B94);
    const Color success = Color(0xff22C55E);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
          decoration: const BoxDecoration(
            color: voucherSheetBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle Bar
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xffCBD5E1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 16),

                // Main Card Container with Soft Shadows & 32px Corners
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: voucherCardBg,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Status Badge Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: success.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: success,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Success',
                                  style: TextStyle(
                                    color: success,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Minimal Title
                      Text(
                        transaction.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xff0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Large Typography for Amount
                      Text(
                        amountText,
                        style: TextStyle(
                          color: isReceived ? success : primary,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Subtle Divider
                      const Divider(color: Color(0xffF1F5F9), height: 1),
                      const SizedBox(height: 20),

                      // Key-Value Rows with Small, Muted Labels
                      if (transaction.subtitle != null &&
                          transaction.subtitle!.trim().isNotEmpty) ...[
                        _fintechRow('Details', transaction.subtitle!),
                        const SizedBox(height: 14),
                      ],
                      _fintechRow('Type', isReceived ? 'Received' : 'Sent'),
                      const SizedBox(height: 14),
                      _fintechRow('Status', '● Completed', valueColor: success),
                      const SizedBox(height: 14),
                      _fintechRow(
                        'Date',
                        _formatFullDateTime(
                          transaction.createdAt,
                        ).split('•')[0].trim(),
                      ),
                      const SizedBox(height: 14),
                      _fintechRow(
                        'Time',
                        _formatFullDateTime(
                          transaction.createdAt,
                        ).split('•')[1].trim(),
                      ),
                      const SizedBox(height: 14),
                      _fintechRow('Transaction ID', transaction.id),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Side-by-Side Action Buttons (Save to Gallery & Done)
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xff334155),
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              color: Color(0xffCBD5E1),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Saved to gallery successfully!',
                                ),
                                backgroundColor: primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.download_rounded, size: 16),
                              SizedBox(width: 6),
                              Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(sheetContext).pop();
                          },
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
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
      },
    );
  }

  Widget _fintechRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xff64748B),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: valueColor ?? const Color(0xff0F172A),
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
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

  String _formatFullDateTime(DateTime dateTime) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final int hour = dateTime.hour;

    final int displayHour = hour == 0
        ? 12
        : hour > 12
        ? hour - 12
        : hour;

    final String period = hour >= 12 ? 'PM' : 'AM';

    final String minute = dateTime.minute.toString().padLeft(2, '0');

    return '${monthNames[dateTime.month - 1]} '
        '${dateTime.day}, ${dateTime.year} • '
        '$displayHour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),

          PageHeader(
            title: "Moe's Burmese Kitchen",
            subtitle: 'Point wallet',
            icon: Icons.account_balance_wallet_rounded,
            isShopOpen: _isShopOpen,
            onStatusChanged: (isOpen) {
              setState(() {
                _isShopOpen = isOpen;
              });

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      _isShopOpen ? 'Shop is now OPEN' : 'Shop is now CLOSED',
                    ),
                    duration: const Duration(seconds: 2),
                    backgroundColor: _isShopOpen ? Colors.green : Colors.red,
                  ),
                );
            },
            notificationCount: 6,
            onNotification: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return const NotificationPage();
                  },
                ),
              );
            },
            onLogout: _handleLogout,
          ),

          WalletBalanceCard(balance: walletBalance),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0xffE2E8F0), width: 1),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff0F172A).withValues(alpha: 0.03),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: WalletActionButton(
                    icon: Icons.send_rounded,
                    title: 'Transfer',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TransferPage(currentBalance: walletBalance),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: WalletActionButton(
                    icon: Icons.qr_code_2_rounded,
                    title: 'Receive',
                    onTap: _openMyQr,
                  ),
                ),
                Expanded(
                  child: WalletActionButton(
                    icon: Icons.qr_code_scanner_rounded,
                    title: 'Scanner',
                    onTap: widget.onOpenScanner,
                  ),
                ),
                Expanded(
                  child: WalletActionButton(
                    icon: Icons.history_rounded,
                    title: 'History',
                    onTap: _openHistory,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0xffE2E8F0), width: 1),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff0F172A).withValues(alpha: 0.03),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: TextStyle(
                            color: Color(0xff0F172A),
                            fontSize: 16.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Activity logs',
                          style: TextStyle(
                            color: Color(0xff64748B),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: _openHistory,
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: Color(0xff0F7B94),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                if (recentTransactions.isEmpty)
                  _emptyTransactions()
                else
                  ...recentTransactions.map((transaction) {
                    return TransactionTile(
                      transaction: transaction,
                      onTap: () {
                        _showTransactionDetails(transaction);
                      },
                    );
                  }),
              ],
            ),
          ),

          /// BOTTOM SPACE
          const SizedBox(height: 75),
        ],
      ),
    );
  }

  Widget _emptyTransactions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 38),
      decoration: BoxDecoration(
        color: const Color(0xffF7FAFB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Icon(Icons.receipt_long_outlined, color: Color(0xff9BA8AD), size: 38),
          SizedBox(height: 12),
          Text(
            'No transactions yet',
            style: TextStyle(
              color: Color(0xff34464E),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Sent and received points will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xff8D999E), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
