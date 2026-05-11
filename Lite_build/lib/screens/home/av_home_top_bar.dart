import 'package:flutter/material.dart';
import 'package:colourswift_av/translations/app_localizations.dart';

class AvHomeTopBar extends StatelessWidget {
  final String title;
  final bool isPro;
  final VoidCallback? onMenuTap;

  const AvHomeTopBar({
    super.key,
    required this.title,
    required this.isPro,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 18, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
            color: theme.colorScheme.onSurface.withOpacity(0.88),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      color: theme.colorScheme.onSurface.withOpacity(0.88),
                    ),
                  ),
                ),
                if (isPro) ...[
                  const SizedBox(width: 9),
                  Text(
                    loc.proBadge,
                    style: text.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.35,
                      color: theme.colorScheme.onSurface.withOpacity(0.62),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}