import 'package:flutter/material.dart';

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

    final bool isTerminal = active == 'terminal';

    final Color bgColor = isTerminal
        ? theme.cardColor
        : (theme.brightness == Brightness.dark
        ? scheme.surface.withOpacity(0.96)
        : scheme.surfaceVariant.withOpacity(0.96));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              theme.brightness == Brightness.dark ? 0.25 : 0.12,
            ),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(context, Icons.home_rounded, 'Home', 'home'),
          _buildItem(context, Icons.terminal_rounded, 'Terminal', 'terminal'),
          _buildItem(context, Icons.shield_outlined, 'Removed', 'quarantine'),
          _buildItem(context, Icons.settings_outlined, 'Settings', 'settings'),
        ],
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

    final bool isActive = active == tag;
    final bool isTerminal = active == 'terminal';

    final Color activeColor = scheme.primary;
    final Color inactiveColor = scheme.onSurface.withOpacity(0.55);

    final Color color = isActive ? activeColor : inactiveColor;

    final Color bg = isActive
        ? activeColor.withOpacity(isTerminal ? 0.20 : 0.14)
        : Colors.transparent;

    return GestureDetector(
      onTap: () => onTabChange(tag),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: text.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}