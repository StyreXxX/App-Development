import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final Map<String, dynamic> user;
  final Widget? trailing;
  final bool showAge;

  const UserTile({
    super.key,
    required this.user,
    this.trailing,
    this.showAge = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          backgroundImage: user['profile_pic_url'] != null
              ? NetworkImage(user['profile_pic_url'])
              : null,
          child: user['profile_pic_url'] == null
              ? const Icon(Icons.person)
              : null,
        ),
        title: Text(
          user['name'] ?? 'Unknown',
          style: theme.textTheme.bodyMedium!.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: showAge
            ? Text(
                'Age: ${user['age'] ?? 'N/A'}',
                style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16),
              )
            : null,
        trailing: trailing,
      ),
    );
  }
}