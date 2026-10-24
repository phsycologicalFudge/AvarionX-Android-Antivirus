import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/scan api/scan_types.dart';
import '../../services/theme/theme_manager.dart';
import '../../translations/app_localizations.dart';
import '../../utils/animated_route.dart';
import '../../widgets/av_header.dart';
import '../../widgets/mesh_background.dart';
import '../scan/main_scan_ui/scan_screen.dart';

class ScanModesScreen extends StatefulWidget {
  final bool useCloudScan;
  final ValueChanged<bool> onCloudScanChanged;

  const ScanModesScreen({
    super.key,
    required this.useCloudScan,
    required this.onCloudScanChanged,
  });

  @override
  State<ScanModesScreen> createState() => _ScanModesScreenState();
}

class _ScanModesScreenState extends State<ScanModesScreen> {
  late bool localCloudScan;

  @override
  void initState() {
    super.initState();
    localCloudScan = widget.useCloudScan;
  }

  Future<void> _setCloudScan(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useCloudScan', value);
    if (!mounted) return;
    setState(() {
      localCloudScan = value;
    });
    widget.onCloudScanChanged(value);
  }

  Future<void> _startMode(ScanMode mode) async {
    String? choice;
    if (mode == ScanMode.single) {
      choice = await ScanScreen.pickCustomChoice(context);
      if (choice == null || !mounted) return;
    }
    if (!mounted) return;
    Navigator.push(
      context,
      animatedRoute(ScanScreen(startMode: mode, customChoice: choice)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MeshBackground(
        blobs: themeManager.meshBlobs,
        base: scheme.surface,
        child: SafeArea(
          child: Column(
            children: [
              AvHeader(
                title: l10n.homeScanModes,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.engineReadyBanner,
                        style: text.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                          color: scheme.onSurface.withOpacity(0.58),
                        ),
                      ),
                      const SizedBox(height: 14),

                      _ScanModeBlock(
                        title: l10n.scanModeSmartTitle,
                        subtitle: l10n.scanModeSmartSubtitle,
                        icon: Icons.manage_search_rounded,
                        color: scheme.primary,
                        onTap: () => _startMode(ScanMode.smart),
                      ),
                      const SizedBox(height: 8),

                      _ScanModeBlock(
                        title: l10n.scanModeRapidTitle,
                        subtitle: l10n.scanModeRapidSubtitle,
                        icon: Icons.bolt_rounded,
                        color: Colors.amber,
                        onTap: () => _startMode(ScanMode.rapid),
                      ),
                      const SizedBox(height: 8),

                      _ScanModeBlock(
                        title: l10n.scanModeInstalledTitle,
                        subtitle: l10n.scanModeInstalledSubtitle,
                        icon: Icons.apps_rounded,
                        color: Colors.blueAccent,
                        onTap: () => _startMode(ScanMode.installed),
                      ),
                      const SizedBox(height: 8),

                      _ScanModeBlock(
                        title: l10n.scanModeCustomTitle,
                        subtitle: l10n.scanModeCustomSubtitle,
                        icon: Icons.folder_rounded,
                        color: scheme.primary,
                        onTap: () => _startMode(ScanMode.single),
                      ),
                      const SizedBox(height: 8),

                      _ScanModeBlock(
                        title: l10n.scanModeFullTitle,
                        subtitle: l10n.scanModeFullSubtitle,
                        icon: Icons.storage_rounded,
                        color: Colors.deepOrangeAccent,
                        onTap: () => _startMode(ScanMode.full),
                      ),

                      const SizedBox(height: 18),

                      Card(
                        elevation: 0,
                        color: theme.cardTheme.color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => _setCloudScan(!localCloudScan),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.useCloudAssistedScan,
                                        style: text.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: scheme.onSurface.withOpacity(0.88),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        localCloudScan
                                            ? l10n.homeCloudAssistedChecksEnabled
                                            : l10n.homeLocalScanEngineOnly,
                                        style: text.bodySmall?.copyWith(
                                          height: 1.35,
                                          color: scheme.onSurface.withOpacity(0.54),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: localCloudScan,
                                  onChanged: _setCloudScan,
                                  materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanModeBlock extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ScanModeBlock({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return Card(
      elevation: 0,
      color: theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 76,
                color: color.withOpacity(0.16),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: text.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurface.withOpacity(0.88),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                          height: 1.35,
                          color: scheme.onSurface.withOpacity(0.54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: theme.iconTheme.color?.withOpacity(0.35),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
