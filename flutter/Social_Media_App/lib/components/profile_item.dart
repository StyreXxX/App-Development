import 'package:flutter/material.dart';
class ProfileItem extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? value;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;

  const ProfileItem({
    super.key,
    required this.label,
    this.icon,
    this.value,
    this.onEdit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.85),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: icon != null
            ? Icon(icon, color: theme.colorScheme.primary, size: 24)
            : null,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label: ',
              style: theme.textTheme.bodyMedium!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (value != null)
              Expanded(
                child: Text(
                  value!,
                  style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16),
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: Icon(Icons.edit, color: theme.colorScheme.primary, size: 20),
                onPressed: onEdit,
              ),
            if (onTap != null)
              Icon(Icons.chevron_right, color: theme.colorScheme.onSurface, size: 20),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}