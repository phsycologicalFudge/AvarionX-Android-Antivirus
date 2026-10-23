import 'package:flutter/material.dart';
import 'package:colourswift_av/translations/app_localizations.dart';

class AvFooter extends StatelessWidget {
  final bool showTitle;

  const AvFooter({super.key, this.showTitle = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
      child: Opacity(
        opacity: theme.brightness == Brightness.dark ? 0.58 : 0.72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showTitle) ...[
              Text(
                'AvarionX',
                style: text.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 3),
            ],
            Text(
              AppLocalizations.of(context)!.homeProtectedByVXTITANIUM,
              style: text.labelSmall?.copyWith(
                letterSpacing: 0.2,
                color: scheme.onSurface.withOpacity(0.62),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
