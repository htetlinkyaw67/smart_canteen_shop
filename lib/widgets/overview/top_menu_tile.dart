import 'package:flutter/material.dart';
import '../../models/top_menu_item.dart';

class TopMenuTile extends StatelessWidget {
  final TopMenuItem item;
  final int rank;
  final VoidCallback? onTap;

  const TopMenuTile({
    super.key,
    required this.item,
    required this.rank,
    this.onTap,
  });

  Color get rankColor {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.blueGrey;
      case 3:
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  IconData get rankIcon {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.workspace_premium;
      case 3:
        return Icons.military_tech;
      default:
        return Icons.restaurant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: rank == 1 ? Colors.amber.withOpacity(.06) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: rank == 1
                ? Colors.amber.withOpacity(.25)
                : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            // Rank Badge
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: rankColor.withOpacity(.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(rankIcon, color: rankColor, size: 18),
                  const SizedBox(height: 2),
                  Text(
                    '#$rank',
                    style: TextStyle(
                      color: rankColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            // Item Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'အရေအတွက် ${item.soldCount}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Revenue Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item.revenue.toStringAsFixed(0)} ပွိုင့်',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(item.percentage * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
