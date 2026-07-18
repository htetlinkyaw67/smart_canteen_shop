class SaleData {
  final String label;
  final double revenue;
  final int orders;
  final int customers;

  const SaleData({
    required this.label,
    required this.revenue,
    required this.orders,
    required this.customers,
  });

  SaleData copyWith({
    String? label,
    double? revenue,
    int? orders,
    int? customers,
  }) {
    return SaleData(
      label: label ?? this.label,
      revenue: revenue ?? this.revenue,
      orders: orders ?? this.orders,
      customers: customers ?? this.customers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'revenue': revenue,
      'orders': orders,
      'customers': customers,
    };
  }

  factory SaleData.fromMap(Map<String, dynamic> map) {
    return SaleData(
      label: map['label'] ?? '',
      revenue: (map['revenue'] ?? 0).toDouble(),
      orders: map['orders'] ?? 0,
      customers: map['customers'] ?? 0,
    );
  }
}
