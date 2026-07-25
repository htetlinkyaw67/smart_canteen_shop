import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isShopOpen;
  final ValueChanged<bool>? onStatusChanged;
  final VoidCallback? onLogout;

  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isShopOpen = true,
    this.onStatusChanged,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // ADDED MORE TOP AND BOTTOM PADDING HERE (20 vertical)
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
      child: Row(
        children: [
          // SMART CANTEEN CIRCULAR LOGO
          Container(
            width: 46,
            height: 46,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,

              // Makes the outer container circular
              shape: BoxShape.circle,

              border: Border.all(
                color: const Color(0xff0F7B94).withOpacity(0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              // Makes the logo image circular
              child: Image.asset(
                'assets/images/smart_canteen_logo.jpg',
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.storefront_rounded,
                      color: Color(0xff0F7B94),
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          // TITLE & SUBTITLE + "Owner Dashboard • OPEN / CLOSED"
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    // DOT SEPARATOR
                    Text(
                      "  •  ",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                      ),
                    ),

                    // INLINE CLICKABLE STATUS TEXT
                    if (onStatusChanged != null)
                      GestureDetector(
                        onTap: () => onStatusChanged!(!isShopOpen),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isShopOpen
                                ? const Color(0xff10B981).withOpacity(0.12)
                                : Colors.red.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isShopOpen
                                      ? const Color(0xff10B981)
                                      : Colors.red,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isShopOpen ? "OPEN" : "CLOSED",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isShopOpen
                                      ? const Color(0xff10B981)
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // LOGOUT BUTTON
          if (onLogout != null)
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onLogout,
              tooltip: "Logout",
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.grey,
                size: 22,
              ),
            ),
        ],
      ),
    );
  }
}
