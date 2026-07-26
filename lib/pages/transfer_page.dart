import 'package:flutter/material.dart';

class TransferPage extends StatefulWidget {
  final int currentBalance;

  const TransferPage({super.key, required this.currentBalance});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool _isLoading = false;
  final List<int> _suggestedAmounts = [50, 100, 250, 500, 1000];

  // Theme Colors
  static const Color primary = Color(0xff0F7B94);
  static const Color success = Color(0xff22C55E);
  static const Color background = Color(0xffF8FAFC);
  static const Color cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _handleTransfer() {
    final String recipient = _recipientController.text.trim();
    final String amountText = _amountController.text.trim();
    final String note = _noteController.text.trim();

    if (recipient.isEmpty) {
      _showError('Please enter a recipient wallet ID or phone number.');
      return;
    }

    if (amountText.isEmpty) {
      _showError('Please enter the point amount to transfer.');
      return;
    }

    final int? amount = int.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid point amount.');
      return;
    }

    if (amount > widget.currentBalance) {
      _showError('Insufficient balance for this transfer.');
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showFintechReceiptModal(recipient, amount, note);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // =========================================================================
  // RECOLORED VOUCHER MODAL WITH SIDE-BY-SIDE BUTTONS
  // =========================================================================
  void _showFintechReceiptModal(String recipient, int amount, String note) {
    final String txnId =
        'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final String dateStr =
        '${_formatMonth(DateTime.now().month)} ${DateTime.now().day}, ${DateTime.now().year}';
    final String timeStr = _formatTime(DateTime.now());

    // 🎨 Changed outer voucher background to a soft slate tone (Color(0xffF1F5F9))
    const Color voucherSheetBg = Color(0xffF1F5F9);
    const Color voucherCardBg = Color(0xffFFFFFF);

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
                      const Text(
                        'Transfer Completed Successfully',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Large Typography for Amount
                      Text(
                        '-$amount pts',
                        style: const TextStyle(
                          color: primary,
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
                      _fintechRow('Recipient', recipient),
                      const SizedBox(height: 14),
                      _fintechRow('Status', '● Completed', valueColor: success),
                      const SizedBox(height: 14),
                      _fintechRow('Date', dateStr),
                      const SizedBox(height: 14),
                      _fintechRow('Time', timeStr),
                      const SizedBox(height: 14),
                      _fintechRow('Transaction', txnId),
                      if (note.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _fintechRow('Note', note),
                      ],
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
                            Navigator.of(context).pop(true);
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

  String _formatMonth(int month) {
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
    return months[month - 1];
  }

  String _formatTime(DateTime dt) {
    final int hour = dt.hour;
    final int displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final String period = hour >= 12 ? 'PM' : 'AM';
    final String minute = dt.minute.toString().padLeft(2, '0');
    return '$displayHour:$minute $period';
  }

  // =========================================================================
  // MAIN BUILD SCREEN
  // =========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Material(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(12),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          'Transfer Points',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AVAILABLE BALANCE',
                        style: TextStyle(
                          color: Color(0xff99F6E4),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.currentBalance} pts',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                decoration: const BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Send Details',
                        style: TextStyle(
                          color: Color(0xff0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xffE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'RECIPIENT',
                              style: TextStyle(
                                color: Color(0xff64748B),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _recipientController,
                              style: const TextStyle(
                                color: Color(0xff0F172A),
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Username, ID or phone number',
                                hintStyle: TextStyle(
                                  color: Color(0xff94A3B8),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xffE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TRANSFER AMOUNT',
                              style: TextStyle(
                                color: Color(0xff64748B),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Color(0xff0F172A),
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                              decoration: const InputDecoration(
                                hintText: '0',
                                suffixText: 'pts',
                                suffixStyle: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w900,
                                ),
                                hintStyle: TextStyle(
                                  color: Color(0xff94A3B8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _suggestedAmounts.map((val) {
                                  final bool isSelected =
                                      _amountController.text == val.toString();
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: InkWell(
                                      onTap: () => setState(
                                        () => _amountController.text = val
                                            .toString(),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? primary
                                              : const Color(0xffE2E8F0),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Text(
                                          '+$val pts',
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xff475569),
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xffE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'REMARK NOTE (OPTIONAL)',
                              style: TextStyle(
                                color: Color(0xff64748B),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _noteController,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Color(0xff0F172A),
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Add a friendly note...',
                                hintStyle: TextStyle(
                                  color: Color(0xff94A3B8),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: _isLoading ? null : _handleTransfer,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Confirm Transfer',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
