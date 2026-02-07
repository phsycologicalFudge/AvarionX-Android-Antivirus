import 'package:colourswift_av/screens/password%20manager/password_manager_screen.dart';
import 'package:colourswift_av/screens/scan/cleaner_screen.dart';
import 'package:colourswift_av/screens/vpn/NetworkProtectionScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/build_flags.dart';
import '../../services/pro_temp_service.dart';
import '../../translations/app_localizations.dart';
import '../../widgets/ads/ads_config.dart';
import '../link checker/link_check_screen.dart';
import '../terminal_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool isPro = false;

  @override
  void initState() {
    super.initState();
    _loadProStatus();
  }

  Future<void> _loadProStatus() async {
    final effective = await ProGate.sync();
    if (!mounted) return;
    setState(() => isPro = effective);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final items = <_ExploreItem>[
      _ExploreItem(
        title: l10n.featureNetworkProtection,
        icon: Icons.public_outlined,
        subtitle: l10n.recommendedNetworkProtectionDesc,
        isProFeature: false,
        builder: (_) => const NetworkProtectionScreen(),
      ),
      _ExploreItem(
        title: l10n.featureLinkChecker,
        icon: Icons.link_outlined,
        subtitle: l10n.recommendedLinkCheckerDesc,
        isProFeature: false,
        builder: (_) => const LinkCheckScreen(),
      ),
      _ExploreItem(
        title: l10n.featureTerminal,
        icon: Icons.terminal_outlined,
        subtitle: l10n.recommendedTerminalDesc,
        isProFeature: false,
        builder: (_) => const ConsoleScreen(isActive: true),
      ),
      _ExploreItem(
        title: l10n.featureMetaPass,
        icon: Icons.key_outlined,
        subtitle: l10n.recommendedMetaPassDesc,
        isProFeature: false,
        builder: (_) => const PasswordTestScreen(),
      ),
      _ExploreItem(
        title: l10n.featureCleanerPro,
        icon: Icons.cleaning_services_outlined,
        subtitle: l10n.recommendedCleanerProDesc,
        isProFeature: true,
        builder: (_) => const CleanerScreen(),
      ),
    ];

    Widget tileFor(_ExploreItem item) {
      final showPro = item.isProFeature && !isPro;

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
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
  final bool isProFeature;
  final WidgetBuilder builder;

  const _ExploreItem({
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.isProFeature,
    required this.builder,
  });
}
