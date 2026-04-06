import 'package:colourswift_av/screens/password%20manager/password_manager_screen.dart';
import 'package:colourswift_av/screens/scan/cleaner_screen.dart';
import 'package:flutter/material.dart';
import '../../translations/app_localizations.dart';
import '../apkAnalyser/apk_analyser.dart';
import '../link checker/link_check_screen.dart';
import '../scan/scan_limits_screen.dart';
import '../scan/scheduled_scan_screen.dart';
import '../terminal_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final items = <_ExploreItem>[
      _ExploreItem(
        title: 'APK Analyser',
        icon: Icons.android_rounded,
        subtitle: 'Create a detailed analysis on any APK',
        builder: (_) => const ApkAnalyserScreen(),
      ),
      _ExploreItem(
        title: l10n.featureLinkChecker,
        icon: Icons.link_outlined,
        subtitle: l10n.recommendedLinkCheckerDesc,
        builder: (_) => const LinkCheckScreen(),
      ),
      _ExploreItem(
        title: l10n.featureTerminal,
        icon: Icons.terminal_outlined,
        subtitle: l10n.recommendedTerminalDesc,
        builder: (_) => const ConsoleScreen(isActive: true),
      ),
      _ExploreItem(
        title: l10n.featureMetaPass,
        icon: Icons.key_outlined,
        subtitle: l10n.recommendedMetaPassDesc,
        builder: (_) => const PasswordTestScreen(),
      ),
      _ExploreItem(
        title: l10n.featureCleanerPro,
        icon: Icons.cleaning_services_outlined,
        subtitle: l10n.recommendedCleanerProDesc,
        builder: (_) => const CleanerScreen(),
      ),
      _ExploreItem(
        title: l10n.featureScheduledScans,
        icon: Icons.schedule_rounded,
        subtitle: l10n.recommendedScheduledScansDesc,
        builder: (_) => const ScheduledScansScreen(),
      ),
      _ExploreItem(
        title: l10n.exploreMultiThreadingTitle,
        icon: Icons.computer_outlined,
        subtitle: l10n.exploreMultiThreadingSubtitle,
        builder: (_) => const ScanLimitsScreen(),
      ),
    ];

    Widget tileFor(_ExploreItem item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Card(
          elevation: 0,
          color: scheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            dense: true,
            visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            leading: Icon(
              item.icon,
              size: 20,
              color: scheme.onSurfaceVariant,
            ),
            title: Text(
              item.title,
              style: text.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
            subtitle: item.subtitle == null
                ? null
                : Text(
              item.subtitle!,
              style: text.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.15,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 6,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: item.builder),
              );
            },
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(
          l10n.footerExplore,
          style: text.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surfaceTint,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              children: [
                ...items.map(tileFor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreItem {
  final String title;
  final IconData icon;
  final String? subtitle;
  final WidgetBuilder builder;

  const _ExploreItem({
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.builder,
  });
}