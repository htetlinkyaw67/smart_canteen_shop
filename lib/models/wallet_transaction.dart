enum WalletTransactionType { sent, received }

class WalletTransaction {
  final String id;
  final String title;
  final String? subtitle;
  final int points;
  final WalletTransactionType type;
  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.title,
    this.subtitle,
    required this.points,
    required this.type,
    required this.createdAt,
  });

  bool get isReceived {
    return type == WalletTransactionType.received;
  }
}
