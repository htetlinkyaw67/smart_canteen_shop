import 'package:flutter/material.dart';
import '../widgets/page_header.dart';

import '../widgets/overview/low_selling_card.dart';
import '../widgets/overview/order_analysis_card.dart';
import '../widgets/overview/quick_action_grid.dart';
import '../widgets/overview/sales_filter_chips.dart';
import '../widgets/overview/sales_hero_card.dart';
import '../widgets/overview/sales_trend_card.dart';
import '../widgets/overview/stats_grid.dart';
import '../widgets/overview/top_selling_card.dart';
import '../models/sale_data.dart';

import '../data/dummy_dashboard_data.dart';

class OverviewPage extends StatefulWidget {
  final Function(int) onTabChange;

  const OverviewPage({super.key, required this.onTabChange});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  SalesFilter _selectedFilter = SalesFilter.today;
  bool _isShopOpen = true; // SHOP STATUS STATE

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              // TODO: Add your auth clear / navigation routing logic here
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
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

  String get _trendTitle {
    switch (_selectedFilter) {
      case SalesFilter.today:
        return 'Today Sales Trend';

      case SalesFilter.week:
        return 'Weekly Sales Trend';

      case SalesFilter.month:
        return 'Monthly Sales Trend';

      case SalesFilter.allTime:
        return 'Revenue History';
    }
  }

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
            subtitle: "Owner Dashboard",
            icon: Icons.storefront,
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

          const SizedBox(height: 28),

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

          const SizedBox(height: 10),

          // =====================================
          // SALES TREND
          // =====================================
          SalesTrendCard(title: _trendTitle, salesData: _salesData),

          const SizedBox(height: 18),

          // =====================================
          // TOP SELLING ITEMS
          // =====================================
          TopSellingCard(items: DummyDashboardData.topSellingItems),

          const SizedBox(height: 18),

          // =====================================
          // LOW SELLING ITEMS
          // =====================================
          LowSellingCard(items: DummyDashboardData.topSellingItems),

          const SizedBox(height: 18),

          // =====================================
          // ORDER ANALYSIS
          // =====================================
          OrderAnalysisCard(
            pending: DummyDashboardData.pendingOrders,
            preparing: DummyDashboardData.preparingOrders,
            ready: DummyDashboardData.readyOrders,
            completed: DummyDashboardData.completedOrders,
          ),

          const SizedBox(height: 20),

          // =====================================
          // QUICK ACTIONS
          // =====================================
          QuickActionGrid(onTabChange: widget.onTabChange),
        ],
      ),
    );
  }

  String get _filterLabel {
    switch (_selectedFilter) {
      case SalesFilter.today:
        return "Today";

      case SalesFilter.week:
        return "Last 7 Days";

      case SalesFilter.month:
        return "Last 30 Days";

      case SalesFilter.allTime:
        return "All Time";
    }
  }
}
