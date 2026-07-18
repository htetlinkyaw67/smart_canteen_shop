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

  int get ordersBadgeCount => OrderData.orders
      .where(
        (e) =>
            e.status == OrderStatus.pending ||
            e.status == OrderStatus.preparing ||
            e.status == OrderStatus.ready,
      )
      .length;

  int get walletBadgeCount {
    return WalletPage.requests
        .where((request) => request.status.toLowerCase() == "approved")
        .length;
  }

  int get reservedSeatsCount {
    return SeatData.seats
        .where((seat) => seat.status == SeatStatus.reserved)
        .length;
  }

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
      backgroundColor: const Color(0xffF4F6F8),

      body: pages[currentIndex],

      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xff0F7B94),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xff0F7B94).withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: IconButton(
          onPressed: _openGlobalScanner,
          icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: const Color(0xffF7FAFB),

          selectedIndex: currentIndex,

          indicatorColor: const Color(0xff0F7B94).withOpacity(0.15),

          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },

          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.show_chart),
              label: 'Overview',
            ),

            const NavigationDestination(
              icon: Icon(Icons.restaurant),
              label: 'Menu',
            ),

            NavigationDestination(
              icon: Badge(
                isLabelVisible: AppBadges.ordersCount.value > 0,
                label: Text(AppBadges.ordersCount.value.toString()),
                child: const Icon(Icons.inventory_2_outlined),
              ),
              label: 'Orders',
            ),

            NavigationDestination(
              icon: Badge(
                isLabelVisible: AppBadges.seatsCount.value > 0,
                label: Text(AppBadges.seatsCount.value.toString()),
                child: const Icon(Icons.event_seat_outlined),
              ),
              label: 'Seats',
            ),

            NavigationDestination(
              icon: Badge(
                isLabelVisible: AppBadges.walletCount.value > 0,
                label: Text(AppBadges.walletCount.value.toString()),
                child: const Icon(Icons.account_balance_wallet_outlined),
              ),
              label: 'Wallet',
            ),
          ],
        ),
      ),
    );
  }
}
