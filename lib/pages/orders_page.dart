import 'package:flutter/material.dart';

import '../models/order_item.dart';

import '../widgets/orders/orders_filter_tabs.dart';
import '../widgets/orders/order_card.dart';
import '../widgets/orders/qr_scan_dialog.dart';
import '../widgets/orders/order_match_dialog.dart';
import '../widgets/orders/customer_qr_dialog.dart';
import '../data/menu_inventory.dart';
import '../data/order_data.dart';
import '../data/app_badges.dart';
import '../widgets/page_header.dart';
import 'notification_page.dart';
import '../widgets/orders/order_completed_dialog.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int selectedTab = 0;
  String searchText = '';
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

    AppBadges.ordersCount.value = orders
        .where(
          (e) =>
              e.status == OrderStatus.pending ||
              e.status == OrderStatus.preparing ||
              e.status == OrderStatus.ready,
        )
        .length;
  }

  List<OrderItem> get orders => OrderData.orders;

  List<OrderItem> get readyOrders =>
      orders.where((e) => e.status == OrderStatus.ready).toList();

  void _moveOrderForward(OrderItem order) {
    setState(() {
      switch (order.status) {
        case OrderStatus.pending:
          order.status = OrderStatus.preparing;
          break;

        case OrderStatus.preparing:
          order.status = OrderStatus.ready;
          break;

        case OrderStatus.ready:
          _showQrScanner(order);
          break;

        case OrderStatus.completed:
          break;
      }
    });
  }

  void _showQrScanner(OrderItem order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => QrScanDialog(
        onScanSuccess: () {
          Navigator.pop(context);

          _showOrderMatched(order);
        },
      ),
    );
  }

  void _showOrderMatched(OrderItem order) {
    final pageContext = context;

    showDialog(
      context: pageContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return OrderMatchedDialog(
          order: order,
          onComplete: () {
            // Close OrderMatchedDialog using its own context.
            Navigator.of(dialogContext).pop();

            // Update the order and badge.
            setState(() {
              order.status = OrderStatus.completed;

              final items = order.items.split('•');

              for (final item in items) {
                final cleaned = item.trim();

                if (cleaned.contains(' x')) {
                  final parts = cleaned.split(' x');
                  final itemName = parts[0].trim();
                  final quantity = int.tryParse(parts[1].trim()) ?? 1;

                  MenuInventory.reduceStock(itemName, quantity);
                }
              }

              AppBadges.ordersCount.value = orders
                  .where(
                    (item) =>
                        item.status == OrderStatus.pending ||
                        item.status == OrderStatus.preparing ||
                        item.status == OrderStatus.ready,
                  )
                  .length;
            });

            // Wait until the first dialog has completely closed.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;

              showDialog(
                context: pageContext,
                barrierDismissible: false,
                builder: (completedDialogContext) {
                  return const OrderCompletedDialog();
                },
              );
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = orders
        .where((e) => e.status == OrderStatus.pending)
        .length;

    final preparingCount = orders
        .where((e) => e.status == OrderStatus.preparing)
        .length;

    final readyCount = orders
        .where((e) => e.status == OrderStatus.ready)
        .length;

    final completedCount = orders
        .where((e) => e.status == OrderStatus.completed)
        .length;

    final activeCount = pendingCount + preparingCount + readyCount;

    final selectedStatus = OrderStatus.values[selectedTab];

    final filteredOrders = orders.where((order) {
      bool statusMatch = order.status == selectedStatus;

      bool searchMatch =
          order.customer.toLowerCase().contains(searchText.toLowerCase()) ||
          order.code.toLowerCase().contains(searchText.toLowerCase()) ||
          order.items.toLowerCase().contains(searchText.toLowerCase());

      return statusMatch && searchMatch;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 15, 14, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),

          PageHeader(
            title: "Moe's Burmese Kitchen",
            subtitle: "ဈေးဝယ်အော်ဒါစီမံခြင်း",
            icon: Icons.inventory_2_outlined,
            isShopOpen: _isShopOpen,
            onStatusChanged: (isOpen) {
              setState(() {
                _isShopOpen = isOpen;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isShopOpen ? "ဆိုင်ဖွင့်ထားပါပြီ" : "ဆိုင်ပိတ်ထားပါပြီ",
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

          // HERO
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xff0F7B94), Color(0xff0C667C)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff0F7B94).withOpacity(.18),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  // TOP RIGHT BIG CIRCLE
                  Positioned(
                    top: -90,
                    right: -55,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.08),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "အော်ဒါများ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -.5,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "ယနေ့ လုပ်ဆောင်နေသော အော်ဒါ $activeCount ခု",
                          style: TextStyle(
                            color: Colors.white.withOpacity(.9),
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.12),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(.08),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$readyCount",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "အဆင်သင့်ဖြစ်ပြီး",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(.85),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.12),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(.08),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$completedCount",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "ပြီးဆုံးသွားပြီး",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(.85),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (readyOrders.isNotEmpty) {
                                _showQrScanner(readyOrders.first);
                              }
                            },
                            icon: const Icon(Icons.qr_code_scanner_rounded),
                            label: const Text(
                              "QR ကို စကင်ဖတ်ရန်",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xff0F7B94),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          OrdersFilterTabs(
            selectedIndex: selectedTab,
            pendingCount: pendingCount,
            preparingCount: preparingCount,
            readyCount: readyCount,
            completedCount: completedCount,
            onChanged: (index) {
              setState(() {
                selectedTab = index;
              });
            },
          ),

          const SizedBox(height: 15),

          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: "အော်ဒါများ ရှာဖွေရန်...",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 18),

          ...filteredOrders.map(
            (order) => OrderCard(
              order: order,
              onQrPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => CustomerQrDialog(orderCode: order.code),
                );
              },
              onPrimaryAction: () {
                _moveOrderForward(order);

                AppBadges.ordersCount.value = orders
                    .where(
                      (e) =>
                          e.status == OrderStatus.pending ||
                          e.status == OrderStatus.preparing ||
                          e.status == OrderStatus.ready,
                    )
                    .length;
              },
            ),
          ),

          /// BOTTOM SPACE
          const SizedBox(height: 70),
        ],
      ),
    );
  }
}
