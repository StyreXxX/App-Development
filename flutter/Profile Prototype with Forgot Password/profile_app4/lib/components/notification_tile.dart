// components/notification_tile.dart
import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  final int count;

  const NotificationTile({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = count > 0
        ? 'You have $count pending friend requests'
        : 'No notifications';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          child: Icon(Icons.notifications),
        ),
        title: Text(
          message,
          style: theme.textTheme.bodyMedium!.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}