import 'package:flutter/material.dart';
import '../widgets/page_header.dart';

import '../widgets/overview/low_selling_card.dart';
import '../widgets/overview/quick_action_grid.dart';
import '../widgets/overview/sales_filter_chips.dart';
import '../widgets/overview/sales_hero_card.dart';
import '../widgets/overview/stats_grid.dart';
import '../widgets/overview/top_selling_card.dart';
import '../models/sale_data.dart';
import 'notification_page.dart';

import '../data/dummy_dashboard_data.dart';

class OverviewPage extends StatefulWidget {
  final Function(int) onTabChange;

  const OverviewPage({super.key, required this.onTabChange});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  SalesFilter _selectedFilter = SalesFilter.today;

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

  List<SaleData> get _salesData {
    switch (_selectedFilter) {
      case SalesFilter.today:
        return DummyDashboardData.todaySales;

      case SalesFilter.week:
        return DummyDashboardData.weeklySales;

      case SalesFilter.month:
        return DummyDashboardData.monthlySales;

      case SalesFilter.allTime:
        return DummyDashboardData.allTimeSales;
    }
  }

  double get _revenue => _salesData.fold(0, (sum, item) => sum + item.revenue);

  int get _orders => _salesData.fold(0, (sum, item) => sum + item.orders);

  int get _customers => _salesData.fold(0, (sum, item) => sum + item.customers);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 30),
      child: Column(
        children: [
          const SizedBox(height: 30),

          // UPDATED PAGE HEADER WITH OPEN/CLOSE TOGGLE AND LOGOUT BUTTON
          PageHeader(
            title: "Moe's Burmese Kitchen",
            subtitle: "ဆိုင်ပိုင်ရှင် ဒက်ရှ်ဘုတ်",
            icon: Icons.storefront,
            onStatusChanged: (isOpen) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      isOpen ? 'ဆိုင်ဖွင့်ထားပါပြီ' : 'ဆိုင်ပိတ်ထားပါပြီ',
                    ),
                    duration: const Duration(seconds: 2),
                    backgroundColor: isOpen ? Colors.green : Colors.red,
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

          // =====================================
          // SALES HERO
          // =====================================
          SalesHeroCard(
            revenue: _revenue,
            profit: DummyDashboardData.todayProfit,
            growthPercent: DummyDashboardData.growthPercent,
            orders: _orders,
            customers: _customers,
            filterLabel: _filterLabel,
            onAnalyticsTap: () {},
          ),

          const SizedBox(height: 20),

          // =====================================
          // FILTER CHIPS
          // =====================================
          SalesFilterChips(
            selectedFilter: _selectedFilter,
            onChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),

          const SizedBox(height: 18),

          // =====================================
          // STATS GRID
          // =====================================
          StatsGrid(
            revenue: _revenue,
            orders: _orders,
            pendingOrders: DummyDashboardData.pendingOrders,
            readyOrders: DummyDashboardData.readyOrders,
            customers: _customers,
            walletPoints: DummyDashboardData.walletPoints,
            onTabChange: widget.onTabChange,
          ),

          // =====================================
          // TOP SELLING ITEMS
          // =====================================
          TopSellingCard(items: DummyDashboardData.topSellingItems),

          const SizedBox(height: 18),

          // =====================================
          // LOW SELLING ITEMS
          // =====================================
          LowSellingCard(items: DummyDashboardData.topSellingItems),

          const SizedBox(height: 20),

          // =====================================
          // QUICK ACTIONS
          // =====================================
          QuickActionGrid(onTabChange: widget.onTabChange),

          /// BOTTOM SPACE
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  String get _filterLabel {
    switch (_selectedFilter) {
      case SalesFilter.today:
        return "ယနေ့";

      case SalesFilter.week:
        return "လွန်ခဲ့သော ၇ ရက်က";

      case SalesFilter.month:
        return "လွန်ခဲ့သော ရက် ၃၀ က";

      case SalesFilter.allTime:
        return "အားလုံး";
    }
  }
}
