import 'package:flutter/material.dart';

class AvOption<T> {
  final T value;
  final IconData icon;
  final String label;
  final String subtitle;

  const AvOption({
    required this.value,
    required this.icon,
    required this.label,
    required this.subtitle,
  });
}

Future<T?> showAvOptionDialog<T>(
  BuildContext context, {
  required String title,
  required String subtitle,
  required List<AvOption<T>> options,
}) {
  final theme = Theme.of(context);
  final text = theme.textTheme;

  return showDialog<T>(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: text.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.55)),
            ),
            const SizedBox(height: 16),
            for (final o in options) ...[
              _AvOptionTile(option: o, onTap: () => Navigator.pop(ctx, o.value)),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    ),
  );
}

class _AvOptionTile extends StatelessWidget {
  final AvOption option;
  final VoidCallback onTap;

  const _AvOptionTile({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(option.icon, size: 22, color: theme.colorScheme.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.label, style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w800)),
                  Text(
                    option.subtitle,
                    style: text.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.55)),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withOpacity(0.35)),
          ],
        ),
      ),
    );
  }
}
