import 'package:flutter/material.dart';
import '../translations/app_localizations.dart';

class FooterNav extends StatelessWidget {
  final String active;
  final Function(String) onTabChange;

  const FooterNav({
    super.key,
    required this.active,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final isTerminal = active == 'terminal';

    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scheme.surface.withOpacity(0.0),
              (isTerminal ? scheme.surface : scheme.surfaceContainer),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(context, Icons.home_rounded, l10n.footerHome, 'home'),
              _buildItem(context, Icons.explore_rounded, l10n.footerExplore, 'explore'),
              _buildItem(context, Icons.shield_outlined, l10n.footerRemoved, 'quarantine'),
              _buildItem(context, Icons.settings_outlined, l10n.footerSettings, 'settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
      BuildContext context,
      IconData icon,
      String title,
      String tag,
      ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    final isActive = active == tag;

    final activeColor = scheme.primary;
    final inactiveColor = scheme.onSurfaceVariant;

    final color = isActive ? activeColor : inactiveColor;

    return InkWell(
      onTap: () => onTabChange(tag),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? scheme.primaryContainer : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isActive ? scheme.onPrimaryContainer : color,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: text.labelSmall?.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
