import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String selectedFilter = "All";

  final List<Map<String, dynamic>> allNotifications = [
    {
      "category": "Orders",
      "icon": Icons.shopping_bag_rounded,
      "iconColor": const Color(0xff0F7B94),
      "title": "New Order Received",
      "description": "Student ordered Chicken Fried Rice x2.",
      "time": "2 mins ago",
      "unread": true,
    },
    {
      "category": "Orders",
      "icon": Icons.shopping_bag_rounded,
      "iconColor": const Color(0xff0F7B94),
      "title": "New Order Received",
      "description": "Student ordered Bubble Tea x1.",
      "time": "10 mins ago",
      "unread": true,
    },
    {
      "category": "Orders",
      "icon": Icons.local_shipping_rounded,
      "iconColor": const Color(0xff0F7B94),
      "title": "Order Completed",
      "description": "Order #1024 has been picked up successfully.",
      "time": "30 mins ago",
      "unread": false,
    },
    {
      "category": "Points",
      "icon": Icons.stars_rounded,
      "iconColor": const Color(0xff19A7CE),
      "title": "Points Exchange Approved",
      "description": "500 points exchange request has been approved.",
      "time": "1 hour ago",
      "unread": false,
    },
    {
      "category": "Points",
      "icon": Icons.stars_rounded,
      "iconColor": const Color(0xff19A7CE),
      "title": "Points Exchange Approved",
      "description": "250 points exchange request has been approved.",
      "time": "2 hours ago",
      "unread": false,
    },
    {
      "category": "Points",
      "icon": Icons.stars_rounded,
      "iconColor": const Color(0xff19A7CE),
      "title": "Points Exchange Approved",
      "description": "1000 points exchange request has been approved.",
      "time": "Yesterday",
      "unread": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = selectedFilter == "All"
        ? allNotifications
        : allNotifications
              .where((item) => item["category"] == selectedFilter)
              .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F7B94),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.done_all_rounded,
              size: 22,
              color: Colors.white,
            ),
            tooltip: "Mark all as read",
            onPressed: () {
              setState(() {
                for (var n in allNotifications) {
                  n["unread"] = false;
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color(0xff0F7B94),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                _buildFilterChip("All"),
                const SizedBox(width: 8),
                _buildFilterChip("Orders"),
                const SizedBox(width: 8),
                _buildFilterChip("Points"),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xff19A7CE)),

          Expanded(
            child: filteredNotifications.isEmpty
                ? Center(
                    child: Text(
                      "No notifications found",
                      style: TextStyle(color: Colors.blueGrey.shade400),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final item = filteredNotifications[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.delete_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            allNotifications.remove(item);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Notification deleted"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: NotificationCard(
                          icon: item["icon"],
                          iconColor: item["iconColor"],
                          title: item["title"],
                          description: item["description"],
                          time: item["time"],
                          unread: item["unread"],
                          onTap: () {
                            setState(() {
                              item["unread"] = false;
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          selectedFilter = label;
        });
      },
      selectedColor: const Color(0xff19A7CE),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      backgroundColor: const Color(0xff0F7B94),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.transparent : const Color(0xff19A7CE),
        ),
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String time;
  final bool unread;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.time,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: unread ? Colors.white : const Color(0xffF4F9FD),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: unread ? const Color(0xffBBDEFB) : Colors.transparent,
            width: 1,
          ),
          boxShadow: unread
              ? [
                  BoxShadow(
                    color: const Color(0xff0F7B94).withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: iconColor.withOpacity(0.12),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                if (unread)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xff19A7CE),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: unread
                                ? FontWeight.w700
                                : FontWeight.w600,
                            fontSize: 14,
                            color: const Color(0xff0F7B94),
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: Colors.blueGrey.shade400,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
