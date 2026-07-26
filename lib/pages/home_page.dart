import 'dart:ui';

import 'package:flutter/material.dart';

import 'overview_page.dart';
import 'menu_page.dart';
import 'orders_page.dart';
import 'seats_page.dart';
import 'wallet_page.dart';

import '../data/order_data.dart';
import '../models/order_item.dart';
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

  final GlobalKey<WalletPageState> _walletPageKey =
      GlobalKey<WalletPageState>();

  @override
  void initState() {
    super.initState();
    AppBadges.walletCount.value = 0;

    pages = [
      OverviewPage(onTabChange: _changeTab),
      const MenuPage(),
      const OrdersPage(),
      const SeatsPage(),
      WalletPage(key: _walletPageKey, onOpenScanner: _openWalletScanner),
    ];
  }

  void _changeTab(int index) {
    if (index < 0 || index >= pages.length) {
      return;
    }

    setState(() {
      currentIndex = index;
    });
  }

  void _openWalletScanner() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return QrScanDialog(
          onScanSuccess: () {
            Navigator.of(dialogContext).pop();

            if (!mounted) {
              return;
            }

            // Simple alternative directly in HomePage
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Wallet QR Scanned Successfully!')),
            );
          },
        );
      },
    );
  }

  void _openGlobalScanner() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return QrScanDialog(
          onScanSuccess: () {
            Navigator.of(dialogContext).pop();

            final readyOrders = OrderData.orders
                .where((order) => order.status == OrderStatus.ready)
                .toList();

            if (readyOrders.isEmpty) {
              _showNoReadyOrderMessage();
              return;
            }

            final matchedOrder = readyOrders.first;

            showDialog(
              context: context,
              builder: (matchDialogContext) {
                return OrderMatchedDialog(
                  order: matchedOrder,
                  onComplete: () {
                    Navigator.of(matchDialogContext).pop();

                    setState(() {
                      matchedOrder.status = OrderStatus.completed;
                    });

                    showDialog(
                      context: context,
                      builder: (_) {
                        return const OrderCompletedDialog();
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void _showNoReadyOrderMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xff172B35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('No ready order was found.')),
            ],
          ),
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
          Positioned.fill(
            child: IndexedStack(index: currentIndex, children: pages),
          ),

          /// FROSTED-GLASS NAVIGATION BAR
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(top: false, child: _buildGlassNavigationBar()),
          ),

          /// GLOBAL ORDER SCANNER
          Positioned(
            right: 20,
            bottom: 96,
            child: SafeArea(top: false, child: _buildScannerButton()),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerButton() {
    return Tooltip(
      message: 'Scan order QR',
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xff0F7B94),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff0F7B94).withValues(alpha: 0.40),
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
    );
  }

  Widget _buildGlassNavigationBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 66,
          decoration: BoxDecoration(
            color: const Color(0xff0F7B94).withValues(alpha: 0.90),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.20),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ValueListenableBuilder<int>(
            valueListenable: AppBadges.ordersCount,
            builder: (context, ordersCount, _) {
              return ValueListenableBuilder<int>(
                valueListenable: AppBadges.seatsCount,
                builder: (context, tableCount, _) {
                  return ValueListenableBuilder<int>(
                    valueListenable: AppBadges.walletCount,
                    builder: (context, walletCount, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: _buildBottomNavItem(
                              icon: Icons.dashboard_rounded,
                              label: 'သုံးသပ်ချက်',
                              index: 0,
                            ),
                          ),
                          Expanded(
                            child: _buildBottomNavItem(
                              icon: Icons.restaurant_menu_rounded,
                              label: 'မီနူး',
                              index: 1,
                            ),
                          ),
                          Expanded(
                            child: _buildBottomNavItem(
                              icon: Icons.inventory_2_outlined,
                              label: 'အော်ဒါ',
                              index: 2,
                              badgeCount: ordersCount,
                            ),
                          ),
                          Expanded(
                            child: _buildBottomNavItem(
                              icon: Icons.table_restaurant_rounded,
                              label: 'စားပွဲ',
                              index: 3,
                              badgeCount: tableCount,
                            ),
                          ),
                          Expanded(
                            child: _buildBottomNavItem(
                              icon: Icons.account_balance_wallet_outlined,
                              label: 'ပိုက်ဆံအိတ်',
                              index: 4,
                              badgeCount: walletCount,
                            ),
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

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required int index,
    int badgeCount = 0,
  }) {
    final bool isActive = currentIndex == index;

    final Color itemColor = isActive
        ? Colors.white
        : Colors.white.withValues(alpha: 0.58);

    Widget iconWidget = Icon(icon, color: itemColor, size: 20);

    if (badgeCount > 0) {
      iconWidget = Badge(
        isLabelVisible: true,
        backgroundColor: const Color(0xffEF5D68),
        textColor: Colors.white,
        smallSize: 8,
        largeSize: 17,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        label: Text(
          badgeCount > 99 ? '99+' : badgeCount.toString(),
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
        ),
        child: iconWidget,
      );
    }

    return Semantics(
      button: true,
      selected: isActive,
      label: label,
      child: InkWell(
        onTap: () {
          _changeTab(index);
        },
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 220),
                scale: isActive ? 1.08 : 1,
                child: iconWidget,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: itemColor,
                  fontSize: 9,
                  height: 1,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
