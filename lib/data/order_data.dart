import '../models/order_item.dart';

class OrderData {
  static final List<OrderItem> orders = [
    OrderItem(
      customer: "Aung Aung",
      code: "MBK-1001",
      phone: "+95 9 123 456",
      items: "Mohinga x1 • Tea Leaf Salad x1",
      timeAgo: "1h ago",
      points: 8500,
      status: OrderStatus.ready,
      note: "Less spicy",
    ),

    OrderItem(
      customer: "Su Su",
      code: "MBK-1002",
      phone: "+95 9 552 881",
      items: "Ohn No Khao Swè x2",
      timeAgo: "48m ago",
      points: 7200,
      status: OrderStatus.ready,
    ),

    OrderItem(
      customer: "Myo Set",
      code: "MBK-1003",
      phone: "+95 9 444 333",
      items: "Shan Noodles x1",
      timeAgo: "16m ago",
      points: 2800,
      status: OrderStatus.pending,
    ),

    OrderItem(
      customer: "Ei Ei Phyo",
      code: "MBK-1004",
      phone: "+95 9 111 222",
      items: "Tea Leaf Salad x2",
      timeAgo: "22m ago",
      points: 3000,
      status: OrderStatus.preparing,
    ),

    OrderItem(
      customer: "Ko Min",
      code: "MBK-1005",
      phone: "+95 9 888 999",
      items: "Mohinga x2",
      timeAgo: "2h ago",
      points: 6000,
      status: OrderStatus.completed,
    ),
  ];
}
