import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final TextEditingController _pinController = TextEditingController();

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
    _pinController.dispose();
    super.dispose();
  }

  void _handleTransfer() {
    final String recipient = _recipientController.text.trim();
    final String amountText = _amountController.text.trim();
    final String note = _noteController.text.trim();

    if (recipient.isEmpty) {
      _showError('လက်ခံမည့် Wallet ID သို့မဟုတ် ဖုန်းနံပါတ် ထည့်ပါ။');
      return;
    }

    if (amountText.isEmpty) {
      _showError('လွှဲပြောင်းမည့် ပွိုင့်ပမာဏ ထည့်ပါ။');
      return;
    }

    final int? amount = int.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showError('မှန်ကန်သော ပွိုင့်ပမာဏ ထည့်ပါ။');
      return;
    }

    if (amount > widget.currentBalance) {
      _showError('လွှဲပြောင်းမည့် ပွိုင့်ပမာဏ အလက်မရနိင်ပါ။');
      return;
    }

    _showPinVerificationSheet(recipient, amount, note);
  }

  Future<void> _showPinVerificationSheet(
    String recipient,
    int amount,
    String note,
  ) async {
    _pinController.clear();
    final FocusNode pinFocusNode = FocusNode();

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.58),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final int enteredDigits = _pinController.text.length;
            final bool isComplete = enteredDigits == 6;

            return Dialog(
              alignment: Alignment.center,
              insetPadding: const EdgeInsets.symmetric(horizontal: 22),
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 370),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.lock_rounded,
                            color: primary,
                            size: 27,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'PIN ဖြင့် အတည်ပြုပါ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff0F172A),
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'လွှဲပြောင်းမှုကို ဆက်လုပ်ရန် PIN နံပါတ် ၆ လုံး ထည့်ပါ။',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff64748B),
                            fontSize: 12.5,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: 1,
                          height: 1,
                          child: TextField(
                            controller: _pinController,
                            focusNode: pinFocusNode,
                            autofocus: true,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                            ),
                            onChanged: (_) => setDialogState(() {}),
                            onSubmitted: (_) {
                              if (isComplete) {
                                Navigator.pop(dialogContext, true);
                              }
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () => pinFocusNode.requestFocus(),
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (index) {
                              final bool filled = index < enteredDigits;
                              final bool active =
                                  index == enteredDigits && enteredDigits < 6;

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 160),
                                width: 42,
                                height: 50,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: filled
                                      ? primary.withValues(alpha: 0.08)
                                      : const Color(0xffF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: filled || active
                                        ? primary
                                        : const Color(0xffCBD5E1),
                                    width: active ? 2 : 1.2,
                                  ),
                                  boxShadow: active
                                      ? [
                                          BoxShadow(
                                            color: primary.withValues(
                                              alpha: 0.12,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: filled
                                    ? const Text(
                                        '•',
                                        style: TextStyle(
                                          color: primary,
                                          fontSize: 25,
                                          height: 1,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      )
                                    : null,
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$enteredDigits / 6',
                          style: TextStyle(
                            color: isComplete
                                ? primary
                                : const Color(0xff94A3B8),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isComplete
                                ? () => Navigator.pop(dialogContext, true)
                                : null,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: primary,
                              disabledBackgroundColor: const Color(0xffE2E8F0),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'အတည်ပြု၍ လွှဲမည်',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Material(
                        color: const Color(0xffF1F5F9),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => Navigator.pop(dialogContext, false),
                          child: const SizedBox(
                            width: 36,
                            height: 36,
                            child: Icon(
                              Icons.close_rounded,
                              size: 19,
                              color: Color(0xff64748B),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    pinFocusNode.dispose();

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);

      // Replace this delay with your Laravel API PIN verification request.
      await Future.delayed(const Duration(milliseconds: 850));

      if (!mounted) return;
      setState(() => _isLoading = false);
      _showFintechReceiptModal(recipient, amount, note);
    }
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
                                  'အောင်မြင်ပါသည်',
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
                        'လွှဲပြောင်းမှု အောင်မြင်ပါသည်',
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
                        '-$amount ပွိုင့်',
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
                      _fintechRow('လက်ခံသူ', recipient),
                      const SizedBox(height: 14),
                      _fintechRow('အခြေအနေ', 'ပြီးစီးပြီး'),
                      const SizedBox(height: 14),
                      _fintechRow('ရက်စွဲ', dateStr),
                      const SizedBox(height: 14),
                      _fintechRow('အချိန်', timeStr),
                      const SizedBox(height: 14),
                      _fintechRow('ငွေလွှဲအမှတ်', txnId),
                      if (note.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _fintechRow('မှတ်ချက်', note),
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
                                  'Gallery ထဲသို့ အောင်မြင်စွာ သိမ်းဆည်းပြီးပါပြီ။',
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
                                'သိမ်းဆည်းရန်',
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
                            'ပြီးပါပြီ',
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
          'ပွိုင့်လွှဲပြောင်းရန်',
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
                        'လက်ကျန်ပွိုင့်',
                        style: TextStyle(
                          color: Color(0xff99F6E4),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.currentBalance} ပွိုင့်',
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
                        'လွှဲပြောင်းမှုအချက်အလက်',
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
                              'လက်ခံမည့်သူ',
                              style: TextStyle(
                                color: Color(0xff64748B),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
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
                                hintText:
                                    'အသုံးပြုသူအမည်၊ ID သို့မဟုတ် ဖုန်းနံပါတ်',
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
                              'လွှဲပြောင်းမည့် ပွိုင့်ပမာဏ',
                              style: TextStyle(
                                color: Color(0xff64748B),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
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
                                suffixText: 'ပွိုင့်',
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
                                          '+$val ပွိုင့်',
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
                              'မှတ်ချက် (မဖြည့်လည်းရသည်)',
                              style: TextStyle(
                                color: Color(0xff64748B),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
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
                                hintText: 'မှတ်ချက်ရေးထည့်ပါ...',
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
                                  'လွှဲပြောင်းမှု အတည်ပြုရန်',
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
