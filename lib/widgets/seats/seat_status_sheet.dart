import 'package:flutter/material.dart';

import '../../models/seat_model.dart';

class SeatStatusSheet extends StatelessWidget {
  final SeatModel seat;
  final ValueChanged<SeatStatus> onStatusChanged;

  final VoidCallback onRename;
  final VoidCallback onDelete;

  const SeatStatusSheet({
    super.key,
    required this.seat,
    required this.onStatusChanged,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: seat.statusColor.withValues(alpha: 0.15),
                child: Icon(seat.icon, size: 30, color: seat.statusColor),
              ),

              const SizedBox(height: 14),

              Text(
                seat.id,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Current status: ${seat.statusLabel}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),

              const SizedBox(height: 24),

              _statusTile(
                context,
                SeatStatus.available,
                "Available",
                const Color(0xff4CD778),
                Icons.check_circle_outline,
              ),

              _statusTile(
                context,
                SeatStatus.occupied,
                "Occupied",
                Colors.redAccent,
                Icons.people_outline,
              ),

              _statusTile(
                context,
                SeatStatus.reserved,
                "Reserved",
                Colors.amber,
                Icons.schedule_outlined,
              ),

              _statusTile(
                context,
                SeatStatus.disabled,
                "Disabled",
                Colors.grey,
                Icons.block_outlined,
              ),

              const SizedBox(height: 20),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.edit, color: Color(0xff0F7B94)),
                title: const Text("Rename Seat"),
                onTap: () {
                  Navigator.pop(context);
                  onRename();
                },
              ),

              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  "Delete Seat",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusTile(
    BuildContext context,
    SeatStatus status,
    String title,
    Color color,
    IconData icon,
  ) {
    final bool selected = seat.status == status;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: selected
          ? const Icon(Icons.check_circle, color: Color(0xff0F7B94))
          : null,
      onTap: () {
        Navigator.pop(context);
        onStatusChanged(status);
      },
    );
  }
}
