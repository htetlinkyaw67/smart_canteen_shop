import 'dart:ui';
import 'package:flutter/material.dart';

import 'overview_page.dart';
import 'menu_page.dart';
import 'orders_page.dart';
import 'seats_page.dart';
import 'wallet_page.dart';
import '../data/order_data.dart';
import '../models/order_item.dart';
import '../data/seat_data.dart';
import '../models/seat_model.dart';
import '../data/app_badges.dart';
import '../widgets/orders/qr_scan_dialog.dart';
import '../widgets/orders/order_match_dialog.dart';
import '../widgets/orders/order_completed_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    AppBadges.walletCount.value = WalletPage.requests
        .where((e) => e.status.toLowerCase() == "approved")
        .length;

    pages = [
      OverviewPage(
        onTabChange: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      const MenuPage(),
      const OrdersPage(),
      const SeatsPage(),
      const WalletPage(),
    ];
  }

  void _openGlobalScanner() {
    showDialog(
      context: context,
      builder: (_) => QrScanDialog(
        onScanSuccess: () {
          Navigator.pop(context);

          final readyOrders = OrderData.orders
              .where((e) => e.status == OrderStatus.ready)
              .toList();

          if (readyOrders.isEmpty) return;

          showDialog(
            context: context,
            builder: (_) => OrderMatchedDialog(
              order: readyOrders.first,
              onComplete: () {
                Navigator.pop(context);

                setState(() {
                  readyOrders.first.status = OrderStatus.completed;
                });

                showDialog(
                  context: context,
                  builder: (_) => const OrderCompletedDialog(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          /// PAGES
          IndexedStack(index: currentIndex, children: pages),

          /// FROSTED GLASS NAVIGATION BAR
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _buildGlassNavigationBar(),
          ),

          /// BALANCED SCANNER BUTTON POSITION
          Positioned(
            right: 20,
            bottom: 96, // Fine-tuned height for proper spacing above the bar
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xff0F7B94),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff0F7B94).withOpacity(0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: _openGlobalScanner,
                icon: const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// FROSTED GLASS NAVIGATION BAR
  Widget _buildGlassNavigationBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 66,
          decoration: BoxDecoration(
            color: const Color(0xFF0F7B94).withOpacity(0.85),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ValueListenableBuilder(
            valueListenable: AppBadges.ordersCount,
            builder: (context, ordersCount, _) {
              return ValueListenableBuilder(
                valueListenable: AppBadges.seatsCount,
                builder: (context, seatsCount, _) {
                  return ValueListenableBuilder(
                    valueListenable: AppBadges.walletCount,
                    builder: (context, walletCount, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildBottomNavItem(
                            Icons.show_chart,
                            "သုံးသပ်ချက်",
                            0,
                          ),
                          _buildBottomNavItem(Icons.restaurant, "မီနူး", 1),
                          _buildBottomNavItem(
                            Icons.inventory_2_outlined,
                            "အော်ဒါ",
                            2,
                            badgeCount: ordersCount,
                          ),
                          _buildBottomNavItem(
                            Icons.event_seat_outlined,
                            "ထိုင်ခုံ",
                            3,
                            badgeCount: seatsCount,
                          ),
                          _buildBottomNavItem(
                            Icons.account_balance_wallet_outlined,
                            "ပိုက်ဆံအိတ်",
                            4,
                            badgeCount: walletCount,
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  /// NAV ITEM BUILDER
  Widget _buildBottomNavItem(
    IconData icon,
    String label,
    int index, {
    int badgeCount = 0,
  }) {
    final isActive = currentIndex == index;
    final color = isActive ? Colors.white : Colors.white.withOpacity(0.5);

    Widget iconWidget = Icon(icon, color: color, size: 20);

    if (badgeCount > 0) {
      iconWidget = Badge(
        isLabelVisible: true,
        label: Text(badgeCount.toString()),
        child: iconWidget,
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
