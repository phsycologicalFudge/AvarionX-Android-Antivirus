import 'package:flutter/material.dart';
import 'package:colourswift_av/translations/app_localizations.dart';

class AvHomeDrawer extends StatelessWidget {
  final bool isPro;
  final void Function(String tag) onItemTap;

  const AvHomeDrawer({
    super.key,
    required this.isPro,
    required this.onItemTap,
  });

  void _navigate(BuildContext context, String tag) {
    Navigator.of(context).pop();
    onItemTap(tag);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: scheme.surfaceContainerHighest.withOpacity(0.92),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 12, 4, 14),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/icons/logo.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Text(
                        loc.appName,
                        style: text.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurface.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: scheme.outlineVariant.withOpacity(0.5)),
                const SizedBox(height: 8),
                _DrawerItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () => _navigate(context, 'settings'),
                ),
                _DrawerItem(
                  icon: Icons.inventory_2_outlined,
                  label: 'Quarantine',
                  onTap: () => _navigate(context, 'quarantine'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 13, 8, 13),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: iconColor ?? scheme.onSurface.withOpacity(0.62),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: text.bodyMedium?.copyWith(
                color: labelColor ?? scheme.onSurface.withOpacity(0.84),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
