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

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int selectedTab = 0;
  String searchText = '';

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
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (_) => OrderMatchedDialog(
        order: order,
        onComplete: () {
          Navigator.pop(context);

          setState(() {
            order.status = OrderStatus.completed;

            final items = order.items.split('•');

            for (final item in items) {
              final cleaned = item.trim();

              if (cleaned.contains(' x')) {
                final parts = cleaned.split(' x');

                final itemName = parts[0].trim();
                final quantity = int.tryParse(parts[1]) ?? 1;

                MenuInventory.reduceStock(itemName, quantity);
              }
            }
          });

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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),

          PageHeader(
            title: "Orders",
            subtitle: "Track customer orders",
            icon: Icons.inventory_2_outlined,
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
                    top: -50,
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

                  // SMALL ACCENT CIRCLE
                  Positioned(
                    top: 55,
                    right: 95,
                    child: Container(
                      width: 65,
                      height: 65,
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.18),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "$readyCount ready for pickup",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "Orders",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -.5,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "$activeCount active orders today",
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
                                      "Ready",
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
                                      "Completed",
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
                              "Scan Customer Pickup",
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

          const SizedBox(height: 24),

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

          const SizedBox(height: 18),

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
                hintText: "Search orders...",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

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
        ],
      ),
    );
  }
}
