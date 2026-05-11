import 'package:flutter/material.dart';

class SettingsProCard extends StatelessWidget {
  final bool isPro;
  final VoidCallback onOpenProOptions;
  final VoidCallback onOpenUpgrade;
  final VoidCallback onRestorePurchases;
  final String proSubtitle;
  final String unlockProLabel;
  final String proCustomizationLabel;

  const SettingsProCard({
    super.key,
    required this.isPro,
    required this.onOpenProOptions,
    required this.onOpenUpgrade,
    required this.onRestorePurchases,
    required this.proSubtitle,
    required this.unlockProLabel,
    required this.proCustomizationLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    if (isPro) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card.outlined(
            color: scheme.surfaceContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onOpenProOptions,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFB8860B).withOpacity(0.18),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: Color(0xFFB8860B),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            proCustomizationLabel,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            proSubtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: scheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onOpenUpgrade,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 6,
                    ),
                    child: Text(
                      'Change plan',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Card.outlined(
      color: scheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFB8860B).withOpacity(0.18),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFFB8860B),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unlockProLabel,
                        style: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        proSubtitle,
                        style: text.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFB8860B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: onOpenUpgrade,
                    child: Text(
                      unlockProLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: onRestorePurchases,
                    child: const Text('Restore'),
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