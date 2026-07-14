import 'package:flutter/material.dart';

class ActivityItem {
  final String title;
  final String subtitle;
  final String status;
  final Color color;
  final IconData icon;

  const ActivityItem({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.color,
    required this.icon,
  });
}

class RecentActivity extends StatelessWidget {
  final List<ActivityItem> items;

  const RecentActivity({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF141C2D),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Text(
            "No recent scans",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141C2D),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: item.color.withValues(alpha: 0.15),
              child: Icon(
                item.icon,
                color: item.color,
              ),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(item.subtitle),
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.status,
                style: TextStyle(
                  color: item.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}