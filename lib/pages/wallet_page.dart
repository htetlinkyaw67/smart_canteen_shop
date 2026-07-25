import 'package:flutter/material.dart';

import '../models/exchange_request.dart';
import '../widgets/wallet/exchange_request_tile.dart';
import '../widgets/wallet/wallet_balance_card.dart';
import '../models/shop_user.dart';
import '../data/app_badges.dart';
import '../widgets/page_header.dart';
import 'notification_page.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  static final List<ExchangeRequest> requests = [
    ExchangeRequest(
      points: 100,
      amount: 800,
      status: "Pending",
      date: "2026-06-18 13:23",
    ),
    ExchangeRequest(
      points: 100,
      amount: 800,
      status: "Approved",
      date: "2026-06-18 08:00",
    ),
    ExchangeRequest(
      points: 200,
      amount: 1600,
      status: "Paid",
      date: "2026-06-17 15:23",
    ),
  ];

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String selectedFilter = "All";
  DateTime? selectedDate;

  bool _isShopOpen = true; // SHOP STATUS STATE

  void _handleLogout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("ထွက်မည်"),
          content: const Text("ထွက်မယ်ဆိုတာ သေချာပါသလား။"),
          actions: [
            // Cancel logout
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("မလုပ်တော့ပါ"),
            ),

            // Confirm logout
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                // Close confirmation dialog first
                Navigator.of(dialogContext).pop();

                // Go to LoginPage
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Text(
                "ထွက်မည်",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    AppBadges.walletCount.value = WalletPage.requests
        .where((e) => e.status.toLowerCase() == "approved")
        .length;
  }

  int get pendingRequestCount {
    return WalletPage.requests
        .where((request) => request.status.toLowerCase() == "pending")
        .length;
  }

  int get pendingPoints {
    return WalletPage.requests
        .where((request) => request.status.toLowerCase() == "pending")
        .fold(0, (sum, request) => sum + request.points);
  }

  List<ExchangeRequest> get filteredRequests {
    var result = WalletPage.requests;

    if (selectedFilter != "All") {
      result = result
          .where(
            (request) =>
                request.status.toLowerCase() == selectedFilter.toLowerCase(),
          )
          .toList();
    }

    if (selectedDate != null) {
      final dateString = selectedDate!.toString().substring(0, 10);

      result = result
          .where((request) => request.date.startsWith(dateString))
          .toList();
    }

    return result;
  }

  void _showExchangeSheet(BuildContext context) {
    final pointsController = TextEditingController(text: "100");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// HEADER
                    Row(
                      children: [
                        const Text(
                          "Exchange points for cash",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const Spacer(),

                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// AVAILABLE CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xffF8F8F8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Available",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "1,600 pts",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Rate",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "1 pt = 8 Ks",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// POINTS
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Points to exchange",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: pointsController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) {
                        setModalState(() {});
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.currency_exchange,
                          color: Color(0xff0F7B94),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// RECEIVE AMOUNT
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xffEAF7FA),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xffB8DDE6)),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "You will receive",
                            style: TextStyle(
                              color: Color(0xff0F7B94),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const Spacer(),

                          Text(
                            "${(int.tryParse(pointsController.text) ?? 0) * 8} Ks",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// NOTE
                    TextField(
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Optional note...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// INFO
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xffEAF7FA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xffB8DDE6)),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: Color(0xff0F7B94)),

                          SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Cash can be collected after approval. Verify your PIN in the next step.",
                              style: TextStyle(height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// CONTINUE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0F7B94),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          final points =
                              int.tryParse(pointsController.text) ?? 0;

                          final amount = points * 8;

                          Navigator.pop(context);

                          Future.delayed(const Duration(milliseconds: 200), () {
                            _showPinDialog(context, points, amount);
                          });
                        },
                        icon: const Icon(Icons.lock_outline),
                        label: const Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
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
  }

  void _showPinDialog(BuildContext context, int points, int amount) {
    final pinController = TextEditingController();
    final focusNode = FocusNode();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!focusNode.hasFocus) {
                focusNode.requestFocus();
              }
            });

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              contentPadding: const EdgeInsets.all(24),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Verify PIN",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Enter your 6-digit PIN to confirm this exchange.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, height: 1.4),
                  ),

                  const SizedBox(height: 24),

                  /// PIN BOXES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 40,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xffF8F8F8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: index < pinController.text.length
                                ? const Color(0xff0F7B94)
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            index < pinController.text.length ? "•" : "",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  /// HIDDEN INPUT
                  Opacity(
                    opacity: 0,
                    child: SizedBox(
                      width: 1,
                      height: 1,
                      child: TextField(
                        focusNode: focusNode,
                        controller: pinController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        autofocus: true,
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0F7B94),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),

                          onPressed: () {
                            if (pinController.text.length != 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter your 6-digit PIN",
                                  ),
                                ),
                              );
                              return;
                            }
                            if (pinController.text != ShopUser.pin) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Incorrect PIN")),
                              );
                              return;
                            }

                            setState(() {
                              WalletPage.requests.insert(
                                0,
                                ExchangeRequest(
                                  points: points,
                                  amount: amount,
                                  status: "Pending",
                                  date: DateTime.now().toString().substring(
                                    0,
                                    16,
                                  ),
                                ),
                              );

                              AppBadges.walletCount.value = WalletPage.requests
                                  .where(
                                    (e) => e.status.toLowerCase() == "approved",
                                  )
                                  .length;
                            });

                            Navigator.of(context, rootNavigator: true).pop();

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _showSuccessDialog(
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).context,
                              );
                            });
                          },

                          child: const Text(
                            "Continue",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xffEAF8EF),
                  child: Icon(Icons.check, color: Colors.green, size: 35),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Exchange Request Created",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Your cash exchange request has been submitted successfully.",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0F7B94),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Done"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 40),
      child: Column(
        children: [
          const SizedBox(height: 18),

          PageHeader(
            title: "Moe's Burmese Kitchen",
            subtitle: "Point transactions",
            icon: Icons.account_balance_wallet,
            isShopOpen: _isShopOpen,
            onStatusChanged: (isOpen) {
              setState(() {
                _isShopOpen = isOpen;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isShopOpen ? "Shop is now OPEN" : "Shop is now CLOSED",
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
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              );
            },

            onLogout: _handleLogout,
          ),

          /// HERO CARD
          WalletBalanceCard(
            onExchange: () {
              _showExchangeSheet(context);
            },
          ),

          const SizedBox(height: 20),

          /// SUMMARY CARD
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Exchange Overview",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: _miniSummaryCard(
                        title: "Pending Requests",
                        value: "$pendingRequestCount",
                        icon: Icons.receipt_long,
                        color: const Color(0xff4CD778),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _miniSummaryCard(
                        title: "Pending",
                        value: "$pendingPoints pts",
                        icon: Icons.schedule,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// REQUESTS CARD
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Exchange History",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const Spacer(),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffF2F7F8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${filteredRequests.length}",
                              style: const TextStyle(
                                color: Color(0xff0F7B94),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Track your exchange requests",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _filterChip("All"),
                            _filterChip("Pending"),
                            _filterChip("Approved"),
                            _filterChip("Paid"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          foregroundColor: const Color(0xff0F7B94),
                          side: const BorderSide(color: Color(0xff0F7B94)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2025),
                            lastDate: DateTime(2030),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xff0F7B94),
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_month_rounded),
                        label: Text(
                          selectedDate == null
                              ? "Filter by Date"
                              : selectedDate!.toString().substring(0, 10),
                        ),
                      ),

                      if (selectedDate != null)
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              selectedDate = null;
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 18,
                            color: Color(0xff0F7B94),
                          ),
                          label: const Text(
                            "Clear Date Filter",
                            style: TextStyle(
                              color: Color(0xff0F7B94),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                ...filteredRequests.map(
                  (request) => ExchangeRequestTile(request: request),
                ),
              ],
            ),
          ),

          /// BOTTOM SPACE
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final selected = selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          setState(() {
            selectedFilter = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xff0F7B94) : const Color(0xffF4F6F7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),

          const SizedBox(height: 14),

          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
