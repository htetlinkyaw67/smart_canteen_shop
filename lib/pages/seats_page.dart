import 'package:flutter/material.dart';

import '../models/seat_model.dart';

import '../widgets/seats/seat_hero_card.dart';
import '../widgets/seats/seat_kpi_card.dart';
import '../widgets/seats/seat_layout_card.dart';
import '../widgets/seats/seat_status_sheet.dart';
import '../data/seat_data.dart';
import '../data/app_badges.dart';
import '../widgets/page_header.dart';

class SeatsPage extends StatefulWidget {
  const SeatsPage({super.key});

  @override
  State<SeatsPage> createState() => _SeatsPageState();
}

class _SeatsPageState extends State<SeatsPage> {
  List<SeatModel> get seats => SeatData.seats;

  int rows = 4;
  int columns = 8;

  @override
  void initState() {
    super.initState();
    _generateSeats();

    AppBadges.seatsCount.value = seats
        .where((e) => e.status == SeatStatus.reserved)
        .length;
  }

  void _generateSeats() {
    seats.clear();

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        seats.add(
          SeatModel(
            id: '${String.fromCharCode(65 + r)}${c + 1}',
            row: r,
            column: c,
          ),
        );
      }
    }

    setState(() {});
  }

  void _showLayoutManager() {
    final rowController = TextEditingController(text: rows.toString());

    final columnController = TextEditingController(text: columns.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 380,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Reshape seat layout",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const Spacer(),

                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFF8EC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xffF2DFC2)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.brown),

                          SizedBox(width: 12),

                          Expanded(
                            child: Text("This will rebuild your seat grid."),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: rowController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Rows",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: TextFormField(
                            controller: columnController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Columns",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Total seats: ${rows * columns}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0F7B94),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          rows = int.tryParse(rowController.text) ?? 4;

                          columns = int.tryParse(columnController.text) ?? 8;

                          _generateSeats();

                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.save),
                        label: const Text("Apply Layout"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  int get availableCount =>
      seats.where((e) => e.status == SeatStatus.available).length;

  int get occupiedCount =>
      seats.where((e) => e.status == SeatStatus.occupied).length;

  int get reservedCount =>
      seats.where((e) => e.status == SeatStatus.reserved).length;

  int get disabledCount =>
      seats.where((e) => e.status == SeatStatus.disabled).length;

  double get occupancyPercent {
    final usableSeats = seats
        .where((e) => e.status != SeatStatus.disabled)
        .length;

    if (usableSeats == 0) {
      return 0;
    }

    return occupiedCount / usableSeats;
  }

  void _showSeatEditor(SeatModel seat) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SeatStatusSheet(
        seat: seat,

        onStatusChanged: (status) {
          setState(() {
            seat.status = status;
          });

          AppBadges.seatsCount.value = seats
              .where((e) => e.status == SeatStatus.reserved)
              .length;
        },

        onRename: () {
          _renameSpecificSeat(seat);
        },

        onDelete: () {
          _deleteSpecificSeat(seat);
        },
      ),
    );
  }

  void _resetAllSeats() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Reset Seats",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to set all seats to Available?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),

            onPressed: () {
              Navigator.pop(context);

              setState(() {
                for (final seat in seats) {
                  seat.status = SeatStatus.available;
                }
              });
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _renameSpecificSeat(SeatModel seat) {
    final controller = TextEditingController(text: seat.id);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Rename Seat",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),

        content: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: "Seat Name",
            hintText: "Enter seat name",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xff0F7B94), width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0F7B94),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                seat.id = controller.text.trim();
              });

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteSpecificSeat(SeatModel seat) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Delete Seat",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        content: Text('Delete ${seat.id}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                seats.remove(seat);
              });

              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),

          PageHeader(
            title: "Seats",
            subtitle: "Manage reservations",
            icon: Icons.event_seat,
          ),

          /// HERO CARD
          SeatHeroCard(
            availableSeats: availableCount,
            totalSeats: seats.length,
            occupancyPercent: occupancyPercent,
          ),

          const SizedBox(height: 20),

          /// KPI ROW 1
          Row(
            children: [
              Expanded(
                child: SeatKpiCard(
                  title: "Available",
                  value: availableCount.toString(),
                  icon: Icons.check_circle,
                  color: const Color(0xff4CD778),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: SeatKpiCard(
                  title: "Occupied",
                  value: occupiedCount.toString(),
                  icon: Icons.people,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// KPI ROW 2
          Row(
            children: [
              Expanded(
                child: SeatKpiCard(
                  title: "Reserved",
                  value: reservedCount.toString(),
                  icon: Icons.schedule,
                  color: Colors.amber,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: SeatKpiCard(
                  title: "Disabled",
                  value: disabledCount.toString(),
                  icon: Icons.block,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// ACTIONS
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: _resetAllSeats,
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          "Reset",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: _showLayoutManager,
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.grid_view_rounded, color: Color(0xff0F7B94)),
                        SizedBox(width: 8),
                        Text(
                          "Layout ($rows x $columns)",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// LAYOUT
          SeatLayoutCard(
            seats: seats,
            columns: columns,
            onSeatTap: (seat) {
              _showSeatEditor(seat);
            },
          ),
        ],
      ),
    );
  }
}
