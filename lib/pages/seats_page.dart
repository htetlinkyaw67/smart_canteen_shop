import 'package:flutter/material.dart';

import '../models/seat_model.dart';

import '../widgets/seats/seat_hero_card.dart';
import '../widgets/seats/seat_kpi_card.dart';
import '../widgets/seats/seat_layout_card.dart';
import '../widgets/seats/seat_status_sheet.dart';
import '../data/seat_data.dart';
import '../data/app_badges.dart';
import '../widgets/page_header.dart';
import 'notification_page.dart';

class SeatsPage extends StatefulWidget {
  const SeatsPage({super.key});

  @override
  State<SeatsPage> createState() => _SeatsPageState();
}

class _SeatsPageState extends State<SeatsPage> {
  List<SeatModel> get seats => SeatData.seats;

  bool _isShopOpen = true; // SHOP STATUS STATE

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

  static const int seatsPerTable = 4;

  int rows = 4;
  int columns = 4;

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

    final totalTables = rows * columns;

    for (int index = 0; index < totalTables; index++) {
      seats.add(
        SeatModel(
          id: 'T${index + 1}',
          row: index ~/ columns,
          column: index % columns,
        ),
      );
    }
  }

  void _updateSeatBadge() {
    AppBadges.seatsCount.value = seats
        .where((seat) => seat.status == SeatStatus.reserved)
        .length;
  }

  String _generateNextTableName() {
    int tableNumber = 1;

    while (seats.any(
      (table) => table.id.trim().toLowerCase() == 'T$tableNumber'.toLowerCase(),
    )) {
      tableNumber++;
    }

    return 'T$tableNumber';
  }

  void _showAddTableSheet() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(
      text: _generateNextTableName(),
    );

    SeatStatus selectedStatus = SeatStatus.available;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 44,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(0xffD9E1E5),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xffE8F6F8),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.add_circle_outline_rounded,
                                color: Color(0xff0F7B94),
                                size: 27,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add New Table',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xff172B35),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Each table contains 4 seats',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff7B8A92),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(sheetContext);
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                          ],
                        ),

                        const SizedBox(height: 26),

                        const Text(
                          'Table name',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff34454D),
                          ),
                        ),

                        const SizedBox(height: 9),

                        TextFormField(
                          controller: nameController,
                          autofocus: true,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: 'Example: T1',
                            prefixIcon: const Icon(
                              Icons.event_seat_outlined,
                              color: Color(0xff0F7B94),
                            ),
                            filled: true,
                            fillColor: const Color(0xffF7FAFB),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 17,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xffE4ECEF),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xff0F7B94),
                                width: 1.8,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Colors.redAccent,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Colors.redAccent,
                                width: 1.8,
                              ),
                            ),
                          ),
                          validator: (value) {
                            final seatName = value?.trim() ?? '';

                            if (seatName.isEmpty) {
                              return 'Please enter a table name';
                            }

                            final alreadyExists = seats.any(
                              (seat) =>
                                  seat.id.trim().toLowerCase() ==
                                  seatName.toLowerCase(),
                            );

                            if (alreadyExists) {
                              return 'A table with this name already exists';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Initial status',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff34454D),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _addSeatStatusOption(
                              status: SeatStatus.available,
                              selectedStatus: selectedStatus,
                              label: 'Available',
                              icon: Icons.check_circle_outline_rounded,
                              color: const Color(0xff26B85A),
                              onTap: () {
                                setSheetState(() {
                                  selectedStatus = SeatStatus.available;
                                });
                              },
                            ),
                            _addSeatStatusOption(
                              status: SeatStatus.occupied,
                              selectedStatus: selectedStatus,
                              label: 'Occupied',
                              icon: Icons.people_outline_rounded,
                              color: Colors.redAccent,
                              onTap: () {
                                setSheetState(() {
                                  selectedStatus = SeatStatus.occupied;
                                });
                              },
                            ),
                            _addSeatStatusOption(
                              status: SeatStatus.reserved,
                              selectedStatus: selectedStatus,
                              label: 'Reserved',
                              icon: Icons.schedule_rounded,
                              color: Colors.amber.shade700,
                              onTap: () {
                                setSheetState(() {
                                  selectedStatus = SeatStatus.reserved;
                                });
                              },
                            ),
                            _addSeatStatusOption(
                              status: SeatStatus.disabled,
                              selectedStatus: selectedStatus,
                              label: 'Disabled',
                              icon: Icons.block_rounded,
                              color: Colors.grey,
                              onTap: () {
                                setSheetState(() {
                                  selectedStatus = SeatStatus.disabled;
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xffF7FAFB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xffE5ECEF)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xff0F7B94),
                                size: 21,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'This table will add 4 seats. You currently have '
                                  '${seats.length} tables and ${seats.length * seatsPerTable} seats.',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xff60727B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xff0F7B94),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: () {
                              final isValid =
                                  formKey.currentState?.validate() ?? false;

                              if (!isValid) {
                                return;
                              }

                              final tableName = nameController.text.trim();
                              final newIndex = seats.length;

                              final newTable = SeatModel(
                                id: tableName,
                                row: newIndex ~/ columns,
                                column: newIndex % columns,
                                status: selectedStatus,
                              );

                              // Close the bottom sheet before rebuilding the page.
                              Navigator.of(sheetContext).pop();

                              if (!mounted) {
                                return;
                              }

                              setState(() {
                                seats.add(newTable);
                              });

                              _updateSeatBadge();

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: const Color(0xff172B35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    content: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: Color(0xff4CD778),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            '${newTable.id} added with 4 seats',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                            },
                            icon: const Icon(Icons.add_rounded),
                            label: const Text(
                              'Add Table',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
      },
    );
  }

  Widget _addSeatStatusOption({
    required SeatStatus status,
    required SeatStatus selectedStatus,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedStatus == status;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.12)
              : const Color(0xffF7FAFB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : const Color(0xffE3EAED),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 19,
              color: isSelected ? color : Colors.grey.shade600,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? color : const Color(0xff51636C),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 7),
              Icon(Icons.check_circle_rounded, size: 17, color: color),
            ],
          ],
        ),
      ),
    );
  }

  int get totalTableCount => seats.length;

  int get availableTableCount {
    return seats.where((table) => table.status == SeatStatus.available).length;
  }

  int get occupiedTableCount {
    return seats.where((table) => table.status == SeatStatus.occupied).length;
  }

  int get reservedTableCount {
    return seats.where((table) => table.status == SeatStatus.reserved).length;
  }

  int get disabledTableCount {
    return seats.where((table) => table.status == SeatStatus.disabled).length;
  }

  double get occupancyPercent {
    final usableTables = totalTableCount - disabledTableCount;

    if (usableTables <= 0) {
      return 0;
    }

    return occupiedTableCount / usableTables;
  }

  void _showTableEditor(SeatModel table) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SeatStatusSheet(
        seat: table,
        onStatusChanged: (status) {
          setState(() {
            table.status = status;
          });

          _updateSeatBadge();
        },
        onRename: () {
          _renameSpecificTable(table);
        },
        onDelete: () {
          _deleteSpecificTable(table);
        },
      ),
    );
  }

  void _resetAllTables() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Reset Tables',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
          ),
          content: const Text('Set every table status back to Available?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xff0F7B94),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);

                setState(() {
                  for (final table in seats) {
                    table.status = SeatStatus.available;
                  }
                });

                _updateSeatBadge();
              },
              child: const Text('Reset Tables'),
            ),
          ],
        );
      },
    );
  }

  void _renameSpecificTable(SeatModel seat) {
    final controller = TextEditingController(text: seat.id);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Rename Table",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),

        content: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: "Table Name",
            hintText: "Enter table name",
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

  void _deleteSpecificTable(SeatModel seat) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Delete Table",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Delete ${seat.id}? This will remove all 4 seats from this table.',
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
              setState(() {
                seats.remove(seat);
                _updateSeatBadge();
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(this.context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('${seat.id} and its 4 seats were deleted'),
                ),
              );
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
            title: "Moe's Burmese Kitchen",
            subtitle: "Manage tables",
            icon: Icons.table_restaurant_rounded,
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

            notificationCount: 6,

            onNotification: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              );
            },

            onLogout: _handleLogout,
          ),

          /// HERO CARD
          SeatHeroCard(
            availableTables: availableTableCount,
            totalTables: totalTableCount,
            occupancyPercent: occupancyPercent,
          ),

          const SizedBox(height: 20),

          /// KPI ROW 1
          Row(
            children: [
              Expanded(
                child: SeatKpiCard(
                  title: 'Available Tables',
                  value: availableTableCount.toString(),
                  icon: Icons.check_circle_rounded,
                  color: const Color(0xff25B95B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SeatKpiCard(
                  title: 'Occupied Tables',
                  value: occupiedTableCount.toString(),
                  icon: Icons.table_bar_rounded,
                  color: const Color(0xffF05D68),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SeatKpiCard(
                  title: 'Reserved Tables',
                  value: reservedTableCount.toString(),
                  icon: Icons.schedule_rounded,
                  color: const Color(0xffEFB62F),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SeatKpiCard(
                  title: 'Disabled Tables',
                  value: disabledTableCount.toString(),
                  icon: Icons.block_rounded,
                  color: const Color(0xff899399),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ACTIONS
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: _resetAllTables,
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
                  onTap: _showAddTableSheet,
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xff0F7B94),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xff0F7B94,
                          ).withValues(alpha: 0.20),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.table_restaurant_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Add Table",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// LAYOUT
          SeatLayoutCard(
            seats: seats,
            columns: 4,
            onSeatTap: (table) {
              _showTableEditor(table);
            },
          ),

          /// BOTTOM SPACE
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
