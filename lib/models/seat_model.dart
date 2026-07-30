import 'package:flutter/material.dart';

enum SeatStatus { available, occupied, reserved, disabled }

class SeatModel {
  String id;

  int row;
  int column;

  SeatStatus status;

  SeatModel({
    required this.id,
    required this.row,
    required this.column,
    this.status = SeatStatus.available,
  });

  String get statusLabel {
    switch (status) {
      case SeatStatus.available:
        return 'အားလပ်';

      case SeatStatus.occupied:
        return 'အသုံးပြုနေ';

      case SeatStatus.reserved:
        return 'ကြိုတင်မှာထား';

      case SeatStatus.disabled:
        return 'အသုံးမပြုနိုင်';
    }
  }

  Color get statusColor {
    switch (status) {
      case SeatStatus.available:
        return const Color(0xff4CD778);

      case SeatStatus.occupied:
        return Colors.redAccent;

      case SeatStatus.reserved:
        return Colors.amber;

      case SeatStatus.disabled:
        return Colors.grey;
    }
  }

  Color get backgroundColor {
    switch (status) {
      case SeatStatus.available:
        return Colors.white;

      case SeatStatus.occupied:
        return const Color(0xFFFFECEC);

      case SeatStatus.reserved:
        return const Color(0xFFFFF5DD);

      case SeatStatus.disabled:
        return const Color(0xFFF2F2F2);
    }
  }

  IconData get icon {
    switch (status) {
      case SeatStatus.available:
        return Icons.event_seat_outlined;

      case SeatStatus.occupied:
        return Icons.people_alt_outlined;

      case SeatStatus.reserved:
        return Icons.schedule_outlined;

      case SeatStatus.disabled:
        return Icons.block_outlined;
    }
  }
}
