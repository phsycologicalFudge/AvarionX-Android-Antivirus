import 'package:flutter/material.dart';
import 'package:colourswift_av/translations/app_localizations.dart';

class AvHomeTopBar extends StatelessWidget {
  final String title;
  final bool isPro;

  const AvHomeTopBar({
    super.key,
    required this.title,
    required this.isPro,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: theme.colorScheme.onSurface.withOpacity(0.88),
                  ),
                ),
                if (isPro) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade700,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      loc.proBadge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
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