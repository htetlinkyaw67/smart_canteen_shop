enum OrderStatus { pending, preparing, ready, completed }

class OrderItem {
  final String customer;
  final String code;
  final String phone;
  final String items;
  final String timeAgo;
  final int points;
  final String? note;
  final String? tableNumber;
  OrderStatus status;

  OrderItem({
    required this.customer,
    required this.code,
    required this.phone,
    required this.items,
    required this.timeAgo,
    required this.points,
    required this.status,
    this.note,
    this.tableNumber,
  });

  bool get isTableService =>
      tableNumber != null && tableNumber!.trim().isNotEmpty;
}
