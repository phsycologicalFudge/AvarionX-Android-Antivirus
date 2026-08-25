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

    final expansionTheme = theme.copyWith(dividerColor: Colors.transparent);

    return Drawer(
      backgroundColor: scheme.surfaceContainerHighest.withOpacity(0.92),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                      Theme(
                        data: expansionTheme,
                        child: ExpansionTile(
                          initiallyExpanded: false,
                          tilePadding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                          childrenPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.extension_outlined,
                            size: 20,
                            color: scheme.onSurface.withOpacity(0.62),
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.featuresDrawerTitle,
                            style: text.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface.withOpacity(0.86),
                            ),
                          ),
                          iconColor: scheme.onSurface.withOpacity(0.58),
                          collapsedIconColor: scheme.onSurface.withOpacity(0.58),
                          children: [
                            _DrawerSubItem(
                              icon: Icons.android_rounded,
                              label: AppLocalizations.of(context)!.homeDrawerApkAnalyser,
                              onTap: () => _navigate(context, 'apk_analyser'),
                            ),
                            _DrawerSubItem(
                              icon: Icons.link_rounded,
                              label: loc.featureLinkChecker,
                              onTap: () => _navigate(context, 'link_check'),
                            ),
                            _DrawerSubItem(
                              icon: Icons.lock_outline_rounded,
                              label: loc.featureMetaPass,
                              onTap: () => _navigate(context, 'password_manager'),
                            ),
                            _DrawerSubItem(
                              icon: Icons.cleaning_services_rounded,
                              label: loc.featureCleanerPro,
                              onTap: () => _navigate(context, 'cleaner'),
                            ),
                            _DrawerSubItem(
                              icon: Icons.schedule_rounded,
                              label: loc.featureScheduledScans,
                              onTap: () => _navigate(context, 'scheduled_scan'),
                            ),
                          ],
                        ),
                      ),
                      Theme(
                        data: expansionTheme,
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                          childrenPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.tune_rounded,
                            size: 20,
                            color: scheme.onSurface.withOpacity(0.62),
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.homeDrawerAdvanced,
                            style: text.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface.withOpacity(0.86),
                            ),
                          ),
                          iconColor: scheme.onSurface.withOpacity(0.58),
                          collapsedIconColor: scheme.onSurface.withOpacity(0.58),
                          children: [
                            _DrawerSubItem(
                              icon: Icons.terminal_outlined,
                              label: loc.featureTerminal,
                              onTap: () => _navigate(context, 'terminal'),
                            ),
                            _DrawerSubItem(
                              icon: Icons.computer_outlined,
                              label: loc.exploreMultiThreadingTitle,
                              onTap: () => _navigate(context, 'scan_limits'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Divider(height: 1, color: scheme.outlineVariant.withOpacity(0.5)),
                      const SizedBox(height: 6),
                      _DrawerItem(
                        icon: Icons.settings_outlined,
                        label: AppLocalizations.of(context)!.footerSettings,
                        onTap: () => _navigate(context, 'settings'),
                      ),
                      _DrawerItem(
                        icon: Icons.inventory_2_outlined,
                        label: AppLocalizations.of(context)!.homeDrawerQuarantine,
                        onTap: () => _navigate(context, 'quarantine'),
                      ),
                      if (!isPro)
                        _DrawerItem(
                          icon: Icons.workspace_premium_rounded,
                          label: AppLocalizations.of(context)!.homeDrawerUpgradeToPro,
                          iconColor: scheme.onSurface.withOpacity(0.64),
                          labelColor: scheme.onSurface.withOpacity(0.82),
                          onTap: () => _navigate(context, 'upgrade_pro'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: InkWell(
                onTap: () => _navigate(context, 'vpn_upsell'),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: scheme.onSurface.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          'assets/icons/vpn_icon.png',
                          width: 26,
                          height: 26,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.homeDrawerAvarionxVPN,
                              style: text.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurface.withOpacity(0.75),
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              AppLocalizations.of(context)!.homeDrawerProtectYourInternetWithOurUnlimitedVPN,
                              style: text.bodySmall?.copyWith(
                                fontSize: 10,
                                height: 1.2,
                                color: scheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

class _DrawerSubItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerSubItem({
    required this.icon,
    required this.label,
    required this.onTap,
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
        padding: const EdgeInsets.fromLTRB(4, 11, 8, 11),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: scheme.onSurface.withOpacity(0.52),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: text.bodyMedium?.copyWith(
                color: scheme.onSurface.withOpacity(0.74),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}