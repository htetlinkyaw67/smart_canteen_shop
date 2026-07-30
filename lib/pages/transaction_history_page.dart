import 'package:flutter/material.dart';

import '../models/wallet_transaction.dart';
import '../widgets/wallet/transaction_tile.dart';

enum TransactionFilter { all, received, sent }

class TransactionHistoryPage extends StatefulWidget {
  final List<WalletTransaction> transactions;

  const TransactionHistoryPage({super.key, required this.transactions});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final TextEditingController _searchController = TextEditingController();

  TransactionFilter _selectedFilter = TransactionFilter.all;
  DateTime? _selectedDate;

  List<WalletTransaction> get _filteredTransactions {
    final String searchQuery = _searchController.text.trim().toLowerCase();

    final List<WalletTransaction> result = widget.transactions.where((
      transaction,
    ) {
      final bool matchesType;

      switch (_selectedFilter) {
        case TransactionFilter.received:
          matchesType = transaction.type == WalletTransactionType.received;
          break;
        case TransactionFilter.sent:
          matchesType = transaction.type == WalletTransactionType.sent;
          break;
        case TransactionFilter.all:
          matchesType = true;
          break;
      }

      final bool matchesDate =
          _selectedDate == null ||
          _isSameDate(transaction.createdAt, _selectedDate!);

      final String transactionTitle = transaction.title.toLowerCase();
      final String transactionSubtitle =
          transaction.subtitle?.toLowerCase() ?? '';
      final String transactionId = transaction.id.toLowerCase();

      final bool matchesSearch =
          searchQuery.isEmpty ||
          transactionTitle.contains(searchQuery) ||
          transactionSubtitle.contains(searchQuery) ||
          transactionId.contains(searchQuery) ||
          transaction.points.toString().contains(searchQuery);

      return matchesType && matchesDate && matchesSearch;
    }).toList();

    result.sort((first, second) => second.createdAt.compareTo(first.createdAt));
    return result;
  }

  int get _receivedPoints => widget.transactions
      .where((t) => t.type == WalletTransactionType.received)
      .fold(0, (total, t) => total + t.points);

  int get _sentPoints => widget.transactions
      .where((t) => t.type == WalletTransactionType.sent)
      .fold(0, (total, t) => total + t.points);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff0F7B94),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xff0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null || !mounted) return;
    setState(() => _selectedDate = selectedDate);
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _selectedFilter = TransactionFilter.all;
      _selectedDate = null;
    });
  }

  bool _isSameDate(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  void _showTransactionDetails(WalletTransaction transaction) {
    final bool isReceived = transaction.isReceived;

    final Color activityColor = isReceived
        ? const Color(0xff22C55E) // Match success color
        : const Color(0xff0F7B94); // Match primary brand color

    final IconData activityIcon = isReceived
        ? Icons.south_west_rounded
        : Icons.north_east_rounded;

    final String amountText = isReceived
        ? '+${_formatPoints(transaction.points)} ပွိုင့်'
        : '-${_formatPoints(transaction.points)} ပွိုင့်';

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
                                  'အောင်မြင်သည်',
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
                        _fintechRow('အသေးစိတ်', transaction.subtitle!),
                        const SizedBox(height: 14),
                      ],
                      _fintechRow(
                        'အမျိုးအစား',
                        isReceived ? 'လက်ခံရရှိ' : 'ပို့ပြီး',
                      ),
                      const SizedBox(height: 14),
                      _fintechRow('အခြေအနေ', 'ပြီးဆုံး'),
                      const SizedBox(height: 14),
                      _fintechRow(
                        'ရက်စွဲ',
                        _formatFullDateTime(
                          transaction.createdAt,
                        ).split('•')[0].trim(),
                      ),
                      const SizedBox(height: 14),
                      _fintechRow(
                        'အချိန်',
                        _formatFullDateTime(
                          transaction.createdAt,
                        ).split('•')[1].trim(),
                      ),
                      const SizedBox(height: 14),
                      _fintechRow('ငွေလွှဲကုဒ်', transaction.id),
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
                                  'အောင်မြင်စွာ သိမ်းပြီးပါပြီ။',
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
                                'သိမ်းမည်',
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

  @override
  Widget build(BuildContext context) {
    final List<WalletTransaction> visibleTransactions = _filteredTransactions;
    final bool hasActiveFilters =
        _selectedFilter != TransactionFilter.all ||
        _selectedDate != null ||
        _searchController.text.trim().isNotEmpty;

    const Color brandPrimary = Color(0xff0F7B94);
    const Color brandDark = Color(0xff0B5364);
    const Color textDark = Color(0xff0F172A);
    const Color textMuted = Color(0xff64748B);
    const Color successGreen = Color(0xff10B981);
    const Color errorRed = Color(0xffF43F5E);

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          // Balanced Medium-Height Header App Bar with Modernized Leading Back Button
          SliverAppBar(
            pinned: true,
            expandedHeight: 60,
            collapsedHeight: 65,
            centerTitle: true,
            backgroundColor: brandPrimary,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leadingWidth: 64,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Material(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(14),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            title: const Text(
              'ငွေလွှဲမှတ်တမ်း',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Filters & Analytics Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // KPI Analytics Overview Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: successGreen.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.south_west_rounded,
                                  size: 16,
                                  color: successGreen,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'အဝင် ပွိုင့်',
                                      style: TextStyle(
                                        color: textMuted,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '+${_formatPoints(_receivedPoints)}',
                                      style: const TextStyle(
                                        color: textDark,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: const Color(0xffE2E8F0),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: errorRed.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.north_east_rounded,
                                  size: 16,
                                  color: errorRed,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'အထွက် ပွိုင့်',
                                      style: TextStyle(
                                        color: textMuted,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '-${_formatPoints(_sentPoints)}',
                                      style: const TextStyle(
                                        color: textDark,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: textDark,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ID သို့မဟုတ် ပွိုင့်ဖြင့် ရှာပါ...',
                      hintStyle: const TextStyle(
                        color: Color(0xff94A3B8),
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: textMuted,
                        size: 18,
                      ),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: textMuted,
                              ),
                            ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xffE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xffE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: brandPrimary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Modern Filter Segments
                  Container(
                    height: 42,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xffE2E8F0).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSegmentTab(
                            'အားလုံး',
                            TransactionFilter.all,
                          ),
                        ),
                        Expanded(
                          child: _buildSegmentTab(
                            'လက်ခံရရှိ',
                            TransactionFilter.received,
                          ),
                        ),
                        Expanded(
                          child: _buildSegmentTab(
                            'ပေးပို့',
                            TransactionFilter.sent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Date Filter and Reset Row
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: _selectDate,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xffE2E8F0),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 15,
                                  color: brandPrimary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedDate == null
                                      ? 'ရက်စွဲဖြင့် စစ်ထုတ်ရန်'
                                      : _formatShortDate(_selectedDate!),
                                  style: const TextStyle(
                                    color: textDark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (hasActiveFilters) ...[
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 40,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: errorRed,
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xffFECDD3)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                            onPressed: _clearFilters,
                            icon: const Icon(Icons.refresh_rounded, size: 14),
                            label: const Text(
                              'ပြန်သတ်မှတ်ရန်',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Section Counter Header
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'လုပ်ဆောင်မှုမှတ်တမ်း',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${visibleTransactions.length} ခု',
                    style: const TextStyle(
                      color: textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Transactions List or Empty Container
          if (visibleTransactions.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 30),
              sliver: SliverToBoxAdapter(child: _emptyState()),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
              sliver: SliverList.separated(
                itemCount: visibleTransactions.length,
                itemBuilder: (context, index) {
                  final WalletTransaction transaction =
                      visibleTransactions[index];
                  return TransactionTile(
                    transaction: transaction,
                    compact: true,
                    onTap: () => _showTransactionDetails(transaction),
                  );
                },
                // Reduced spacing between transaction cards
                separatorBuilder: (_, __) => const SizedBox(height: 6),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSegmentTab(String label, TransactionFilter filter) {
    final bool isSelected = _selectedFilter == filter;

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(0xff0F7B94)
                : const Color(0xff64748B),
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xffF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Color(0xff64748B),
              size: 24,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'မှတ်တမ်း မတွေ့ပါ',
            style: TextStyle(
              color: Color(0xff0F172A),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'ရှာဖွေမှုစာသား သို့မဟုတ် Filter များကို ပြင်ဆင်ကြည့်ပါ။',
            style: TextStyle(color: Color(0xff64748B), fontSize: 11.5),
          ),
          const SizedBox(height: 16),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xff0F7B94),
              backgroundColor: const Color(0xffE0F2FE),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _clearFilters,
            child: const Text(
              'Filter များ ဖယ်ရှားရန်',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPoints(int value) {
    final String digits = value.abs().toString();
    final StringBuffer result = StringBuffer();
    for (int index = 0; index < digits.length; index++) {
      final int remainingDigits = digits.length - index;
      result.write(digits[index]);
      if (remainingDigits > 1 && remainingDigits % 3 == 1) {
        result.write(',');
      }
    }
    return result.toString();
  }

  String _formatShortDate(DateTime dateTime) {
    const List<String> months = [
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
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  String _formatFullDateTime(DateTime dateTime) {
    const monthNames = [
      'ဇန်နဝါရီ',
      'ဖေဖော်ဝါရီ',
      'မတ်',
      'ဧပြီ',
      'မေ',
      'ဇွန်',
      'ဇူလိုင်',
      'ဩဂုတ်',
      'စက်တင်ဘာ',
      'အောက်တိုဘာ',
      'နိုဝင်ဘာ',
      'ဒီဇင်ဘာ',
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
}
