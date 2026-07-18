import '../models/sale_data.dart';
import '../models/top_menu_item.dart';

class DummyDashboardData {
  // =====================================================
  // HERO DATA
  // =====================================================

  static const double todayRevenue = 125000;
  static const double todayProfit = 800;
  static const double growthPercent = 15.4;

  static const int totalOrders = 42;
  static const int customers = 31;
  static const int walletPoints = 1600;

  static const int pendingOrders = 8;
  static const int preparingOrders = 12;
  static const int readyOrders = 15;
  static const int completedOrders = 65;

  // =====================================================
  // today SALES
  // =====================================================

  static const List<SaleData> todaySales = [
    SaleData(label: '7 AM', revenue: 20, orders: 1, customers: 1),
    SaleData(label: '8 AM', revenue: 50, orders: 2, customers: 2),
    SaleData(label: '9 AM', revenue: 120, orders: 4, customers: 4),
    SaleData(label: '10 AM', revenue: 180, orders: 6, customers: 5),
    SaleData(label: '11 AM', revenue: 350, orders: 10, customers: 8),
    SaleData(label: '12 PM', revenue: 40, orders: 12, customers: 10),
    SaleData(label: '1 PM', revenue: 130, orders: 5, customers: 4),
    SaleData(label: '2 PM', revenue: 90, orders: 4, customers: 3),
    SaleData(label: '3 PM', revenue: 70, orders: 3, customers: 3),
    SaleData(label: '4 PM', revenue: 110, orders: 4, customers: 4),
    SaleData(label: '5 PM', revenue: 16, orders: 6, customers: 5),
  ];

  // =====================================================
  // WEEKLY SALES
  // =====================================================

  static const List<SaleData> weeklySales = [
    SaleData(label: 'Mon', revenue: 4500, orders: 12, customers: 10),
    SaleData(label: 'Tue', revenue: 6700, orders: 18, customers: 15),
    SaleData(label: 'Wed', revenue: 5200, orders: 15, customers: 13),
    SaleData(label: 'Thu', revenue: 8800, orders: 24, customers: 19),
    SaleData(label: 'Fri', revenue: 1200, orders: 35, customers: 28),
    SaleData(label: 'Sat', revenue: 9600, orders: 28, customers: 22),
    SaleData(label: 'Sun', revenue: 7300, orders: 20, customers: 17),
  ];

  // =====================================================
  // monthly SALES
  // =====================================================

  static const List<SaleData> monthlySales = [
    SaleData(label: 'Week 1', revenue: 42000, orders: 120, customers: 98),
    SaleData(label: 'Week 2', revenue: 51000, orders: 146, customers: 121),
    SaleData(label: 'Week 3', revenue: 59000, orders: 168, customers: 140),
    SaleData(label: 'Week 4', revenue: 61000, orders: 181, customers: 152),
  ];

  // =====================================================
  // all time SALES
  // =====================================================

  static const List<SaleData> allTimeSales = [
    SaleData(label: 'Jan', revenue: 120000, orders: 450, customers: 350),
    SaleData(label: 'Feb', revenue: 180000, orders: 650, customers: 530),
    SaleData(label: 'Mar', revenue: 230000, orders: 800, customers: 670),
  ];

  // =====================================================
  // TOP SELLING ITEMS
  // =====================================================

  static const List<TopMenuItem> topSellingItems = [
    TopMenuItem(
      id: '1',
      name: 'Bubble Tea',
      soldCount: 32,
      revenue: 160000,
      percentage: 0.85,
    ),

    TopMenuItem(
      id: '2',
      name: 'Burger',
      soldCount: 21,
      revenue: 105000,
      percentage: 0.60,
    ),

    TopMenuItem(
      id: '3',
      name: 'Fried Rice',
      soldCount: 18,
      revenue: 90000,
      percentage: 0.50,
    ),

    TopMenuItem(
      id: '4',
      name: 'Milk Tea',
      soldCount: 12,
      revenue: 48000,
      percentage: 0.35,
    ),

    TopMenuItem(
      id: '5',
      name: 'Coffee',
      soldCount: 4,
      revenue: 12000,
      percentage: 0.12,
    ),

    TopMenuItem(
      id: '6',
      name: 'Cake',
      soldCount: 2,
      revenue: 6000,
      percentage: 0.05,
    ),
  ];
}
