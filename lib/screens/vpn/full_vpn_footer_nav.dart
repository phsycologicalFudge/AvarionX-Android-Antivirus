import 'package:flutter/material.dart';

class FullVpnFooterNav extends StatelessWidget {
  final String active;
  final Function(String) onTabChange;

  const FullVpnFooterNav({
    super.key,
    required this.active,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scheme.surface.withOpacity(0.0),
              scheme.surfaceContainer,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(context, Icons.vpn_key_outlined, "Connection", "connection"),
              _buildItem(context, Icons.dns_outlined, "DNS", "dns"),
              _buildItem(context, Icons.tune_rounded, "Customisation", "customisation"),
              _buildItem(context, Icons.settings_outlined, "Settings", "settings"),
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
