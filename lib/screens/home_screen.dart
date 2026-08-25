// legacy file

import 'package:colourswift_av/screens/password%20manager/password_manager_screen.dart';
import 'package:colourswift_av/screens/scan/cleaner_screen.dart';
import 'package:colourswift_av/screens/scan/scheduled_scan_screen.dart';
import 'package:colourswift_av/screens/vpn/NetworkProtectionScreen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/build_flags.dart';
import '../services/defs_auto_update_service.dart';
import '../services/pro_temp_service.dart';
import '../services/realtime_protection_service.dart';
import '../services/scan api/scan_types.dart';
import '../services/scan_scheduler.dart';
import '../services/update_service.dart';
import '../translations/app_localizations.dart';
import '../utils/animated_route.dart';
import '../widgets/ads/ads_config.dart';
import '../widgets/antivirus_bridge.dart';
import 'link checker/link_check_screen.dart';
import 'scan/main_scan_ui/scan_screen.dart';
import '../services/service_manager.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../widgets/update_log.dart';
import '../constants/launch_flag.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class AvHomeScreen extends StatefulWidget {
  const AvHomeScreen({super.key});

  @override
  State<AvHomeScreen> createState() => _AvHomeScreenState();
}

class _AvHomeScreenState extends State<AvHomeScreen> with TickerProviderStateMixin {
  bool protectionEnabled = false;
  double protectionPercent = 0.0;
  bool hideGoldHeader = false;
  Timer? _periodicScanTimer;
  bool isPro = false;
  bool hasUpdate = false;
  bool useCloudScan = false;
  bool networkEnabled = false;
  bool vpnActive = false;
  bool vpnConflict = false;
  bool autoUpdateDefs = false;
  bool shizukuRtpEnabled = false;
  String? remoteVersion;
  String version = '';
  String defsVersion = '';

  late AnimationController _popupController;
  late Animation<Offset> _popupAnimation;
  late Animation<double> _popupOpacity;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  static const String _autoUpdateKey = 'defs_auto_update_enabled';

  bool _pressed = false;
  bool _loadingProtectionState = false;
  bool _updateLogShown = false;

  Future<void> _loadShizukuRtpState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      shizukuRtpEnabled = prefs.getBool('shizuku_enabled') ?? false;
    });
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => version = info.version);
  }

  Future<void> _loadDefsVersion() async {
    final v = await UpdateService.getLocalVersion();
    if (mounted) {
      setState(() => defsVersion = v);
    }
  }

  Future<void> _loadProStatus() async {
    final effective = await ProGate.sync();
    if (!mounted) return;
    setState(() => isPro = effective);
  }

  Future<void> _togglePro() async {
    final prefs = await SharedPreferences.getInstance();
    final newStatus = !isPro;
    await prefs.setBool('isPro', newStatus);
    setState(() => isPro = newStatus);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(newStatus ? AppLocalizations.of(context)!.homeLegacyProActivated : AppLocalizations.of(context)!.homeLegacyProDeactivated)),
    );
  }

  Future<void> _loadAutoUpdatePref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      autoUpdateDefs = prefs.getBool('defs_auto_update_enabled') ?? false;
    });
  }

  Future<String> _getDnsModeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final vpnMode = prefs.getString('networkProtectionMode');
    final basicMode = prefs.getString('networkDnsMode');

    debugPrint('[CS VPN] _getDnsModeFromPrefs vpnMode=$vpnMode basicMode=$basicMode');

    if (vpnMode == 'cloud') return 'cloud';
    if (basicMode == 'adult') return 'adult';
    return 'malware';
  }

  Future<void> _loadCloudToggle() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      useCloudScan = prefs.getBool('useCloudScan') ?? false;
    });
  }

  Future<bool> _isAnotherVpnActive() async {
    final chan = MethodChannel("cs_vpn_state");
    try {
      return await chan.invokeMethod<bool>("isAnotherVpnActive") ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> requestVpnPermission() async {
    const chan = MethodChannel("cs_vpn_permission");
    final ok = await chan.invokeMethod<bool>("prepareVpn");
    return ok == true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadShizukuRtpState();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final flags = Provider.of<LaunchFlags>(context, listen: false);
      if (flags.showUpdateLog != true) return;

      final prefs = await SharedPreferences.getInstance();
      final key = 'update_log_shown_${flags.currentVersion}';

      if (prefs.getBool(key) == true) return;

      await prefs.setBool(key, true);

    });

    SharedPreferences.getInstance().then((prefs) {
      if (!(prefs.getBool('defs_auto_update_enabled') ?? false)) {
        prefs.setBool('defs_auto_update_enabled', true);
      }
    });

    _loadHeaderPref();
    _loadProtectionState();
    _loadVersion();
    _loadProStatus();
    _loadCloudToggle();
    _loadAutoUpdatePref();
    _loadDefsVersion();
    _loadShizukuRtpState();

    DefsAutoUpdateService.maybeRun().then((_) async {
      if (!mounted) return;
      await _loadDefsVersion();
      await _refreshUpdateState();
    });

    _popupController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _pulseAnim = Tween(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseController.repeat();

    _popupAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _popupController,
      curve: Curves.easeOutCubic,
    ));

    _popupOpacity = CurvedAnimation(
      parent: _popupController,
      curve: Curves.easeIn,
    );
  }

  void _showRtpInfo() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        final theme = Theme.of(context);
        final text = theme.textTheme;
        final l10n = AppLocalizations.of(context)!;

        return AlertDialog(
          backgroundColor: theme.colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            l10n.rtpInfoTitle,
            style: text.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            l10n.rtpInfoBody,
            style: text.bodySmall?.copyWith(
              height: 1.4,
              color: text.bodySmall?.color?.withOpacity(0.85),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  void _startUpdate(String newRemoteVersion) {
    double progress = 0.0;
    bool autoUpdate = false;
    bool mountedSheet = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        final theme = Theme.of(context);
        final text = theme.textTheme;
        final l10n = AppLocalizations.of(context)!;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future.microtask(() async {
              try {
                double lastShown = 0;

                final ok = await UpdateService.downloadDatabase(
                  onProgress: (p) {
                    if (!mountedSheet) return;
                    if ((p - lastShown).abs() >= 0.01) {
                      lastShown = p;
                      setSheetState(() => progress = p);
                    }
                  },
                );

                if (!ok || !mounted || !mountedSheet) return;

                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool(_autoUpdateKey, autoUpdate);
                await UpdateService.setLocalVersion(newRemoteVersion);

                final dir = await getApplicationDocumentsDirectory();
                final defsPath = '${dir.path}/defs.cs';

                try {
                  AntivirusBridge().reload(defsPath);
                } catch (e) {
                  debugPrint('[DefsUpdate] Engine reload failed: $e');
                }

                Navigator.pop(context);

                setState(() {
                  hasUpdate = false;
                  remoteVersion = null;
                });

                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: Text(
                      autoUpdate
                          ? l10n.updateDbUpdatedAutoOn
                          : l10n.updateDbUpdatedSuccess,
                    ),
                  ),
                );
              } catch (_) {
                if (!mounted || !mountedSheet) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(content: Text(l10n.updateDbUpdateFailed)),
                );
              }
            });

            final sheetTheme = Theme.of(context);

            return Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
              child: Card(
                color: sheetTheme.colorScheme.surfaceContainerHigh,
                elevation: 10,
                shadowColor: Colors.black.withOpacity(0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.system_update_rounded,
                            color: sheetTheme.colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l10n.updateDbTitle,
                              style: text.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.updateDbVersionLabel(newRemoteVersion),
                          style: text.bodySmall?.copyWith(
                            color: text.bodySmall?.color?.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor:
                          sheetTheme.colorScheme.onSurface.withOpacity(0.12),
                          valueColor: AlwaysStoppedAnimation(
                            sheetTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: text.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Switch(
                            value: autoUpdate,
                            onChanged: (v) {
                              setSheetState(() => autoUpdate = v);
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.updateDbAutoDownloadLabel,
                              style: text.bodySmall?.copyWith(
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      mountedSheet = false;
    });
  }

  Future<void> _loadHeaderPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => hideGoldHeader = prefs.getBool('hideGoldHeader') ?? true);
  }

  Future<void> _checkForDatabaseUpdate() async {
    final remote = await UpdateService.checkServerVersion();
    if (remote == null) return;

    final remoteVer = remote['version'] ?? '0.0.0';
    final localVer = await UpdateService.getLocalVersion();

    if (remoteVer != localVer) {
      setState(() {
        hasUpdate = true;
        remoteVersion = remoteVer;
      });
    } else {
      setState(() {
        hasUpdate = false;
        remoteVersion = null;
      });
    }
  }

  Future<void> _refreshUpdateState() async {
    final prefs = await SharedPreferences.getInstance();
    final auto = prefs.getBool('defs_auto_update_enabled') ?? false;

    if (auto) {
      setState(() {
        hasUpdate = false;
        remoteVersion = null;
      });
      return;
    }

    final remote = await UpdateService.checkServerVersion();
    if (remote == null) return;

    final remoteVer = remote['version'] ?? '0.0.0';
    final localVer = await UpdateService.getLocalVersion();

    setState(() {
      hasUpdate = remoteVer != localVer;
      remoteVersion = hasUpdate ? remoteVer : null;
    });
  }

  Future<void> _loadProtectionState() async {
    if (_loadingProtectionState) return;
    _loadingProtectionState = true;

    try {
      final prefs = await SharedPreferences.getInstance();

      final rtp = prefs.getBool('protectionEnabled') ?? false;
      final netPref = prefs.getBool('networkProtectionEnabled') ?? false;

      bool conflict = false;
      try {
        conflict = rtp && netPref ? await _isAnotherVpnActive() : false;
      } catch (_) {
        conflict = false;
      }

      if (!mounted) return;

      setState(() {
        protectionEnabled = rtp;
        networkEnabled = rtp && netPref && !conflict;
        vpnConflict = conflict;
        vpnActive = networkEnabled;

        if (!rtp) {
          protectionPercent = 0.0;
        } else if (!networkEnabled || conflict) {
          protectionPercent = 0.6;
        } else {
          protectionPercent = 1.0;
        }
      });

      if (!rtp) {
        try {
          await AvServiceManager.stopProtection();
        } catch (_) {}
        try {
          await AvServiceManager.stopVpn();
        } catch (_) {}
        _stopBackgroundScan();
        await ScheduledScanScheduler.disable();
        return;
      }

      try {
        await AvServiceManager.startProtection();
      } catch (_) {
        await ScheduledScanScheduler.disable();
        await prefs.setBool('protectionEnabled', false);
        await prefs.setBool('networkProtectionEnabled', false);

        if (!mounted) return;

        setState(() {
          protectionEnabled = false;
          networkEnabled = false;
          vpnActive = false;
          vpnConflict = false;
          protectionPercent = 0.0;
        });

        _stopBackgroundScan();
        return;
      }

      bool netEnabled = false;

      if (netPref) {
        bool conflict2 = false;
        try {
          conflict2 = await _isAnotherVpnActive();
        } catch (_) {
          conflict2 = false;
        }

        if (!conflict2) {
          try {
            final dnsMode = await _getDnsModeFromPrefs();
            await AvServiceManager.startVpn(dnsMode: dnsMode);
            netEnabled = true;
          } catch (_) {
            await prefs.setBool('networkProtectionEnabled', false);
            netEnabled = false;
          }
        }
      }

      _startBackgroundScan();
      await ScheduledScanScheduler.enableFromPrefs();

      if (!mounted) return;

      setState(() {
        networkEnabled = netEnabled;
        vpnActive = netEnabled;
        vpnConflict = !netEnabled && netPref ? true : false;
        protectionPercent = netEnabled ? 1.0 : 0.6;
      });
    } finally {
      _loadingProtectionState = false;
    }
  }

  Future<void> _toggleProtection() async {
    final prefs = await SharedPreferences.getInstance();

    if (protectionEnabled) {
      await ScheduledScanScheduler.disable();
      await AvServiceManager.stopProtection();
      await AvServiceManager.stopVpn();
      _stopBackgroundScan();

      await prefs.setBool('protectionEnabled', false);
      await prefs.setBool('networkProtectionEnabled', false);

      setState(() {
        protectionEnabled = false;
        networkEnabled = false;
        vpnActive = false;
        vpnConflict = false;
        protectionPercent = 0.0;
      });

      return;
    }

    final status = await Permission.notification.request();
    if (!status.isGranted) {
      return;
    }

    final vpnOk = await requestVpnPermission();
    if (!vpnOk) {
      return;
    }

    final conflict = await _isAnotherVpnActive();

    await AvServiceManager.startProtection();
    _startBackgroundScan();

    await ScheduledScanScheduler.enableFromPrefs();

    bool netEnabled = false;

    if (!conflict) {
      try {
        final dnsMode = await _getDnsModeFromPrefs();
        await AvServiceManager.startVpn(dnsMode: dnsMode);
        netEnabled = true;
      } catch (_) {
        netEnabled = false;
      }
    }

    await prefs.setBool('protectionEnabled', true);
    await prefs.setBool('networkProtectionEnabled', netEnabled);

    setState(() {
      protectionEnabled = true;
      networkEnabled = netEnabled;
      vpnActive = netEnabled;
      vpnConflict = conflict;
      protectionPercent = netEnabled ? 1.0 : 0.6;
    });
  }

  void _startBackgroundScan() => RealtimeProtectionService.start();
  void _stopBackgroundScan() => RealtimeProtectionService.stop();

  void _openScanDrawer() {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      builder: (context) {
        bool localCloudScan = useCloudScan;
        final l10n = AppLocalizations.of(context)!;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.80,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    Text(
                      l10n.engineReadyBanner,
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Divider(height: 1, color: theme.colorScheme.outlineVariant),
                    ListTile(
                      leading: const Icon(Icons.storage_rounded),
                      title: Text(l10n.scanModeFullTitle),
                      subtitle: Text(
                        l10n.scanModeFullSubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                          color: text.bodySmall?.color?.withOpacity(0.65),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          animatedRoute(const ScanScreen(startMode: ScanMode.full)),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.manage_search_rounded),
                      title: Text(l10n.scanModeSmartTitle),
                      subtitle: Text(
                        l10n.scanModeSmartSubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                          color: text.bodySmall?.color?.withOpacity(0.65),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          animatedRoute(const ScanScreen(startMode: ScanMode.smart)),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.bolt_rounded),
                      title: Text(l10n.scanModeRapidTitle),
                      subtitle: Text(
                        l10n.scanModeRapidSubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                          color: text.bodySmall?.color?.withOpacity(0.65),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          animatedRoute(const ScanScreen(startMode: ScanMode.rapid)),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.apps_rounded),
                      title: Text(l10n.scanModeInstalledTitle),
                      subtitle: Text(
                        l10n.scanModeInstalledSubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                          color: text.bodySmall?.color?.withOpacity(0.65),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          animatedRoute(const ScanScreen(startMode: ScanMode.installed)),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.insert_drive_file_rounded),
                      title: Text(l10n.scanModeSingleTitle),
                      subtitle: Text(
                        l10n.scanModeSingleSubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                          color: text.bodySmall?.color?.withOpacity(0.65),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          animatedRoute(const ScanScreen(startMode: ScanMode.single)),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Divider(height: 1, color: theme.colorScheme.outlineVariant),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.useCloudAssistedScan, style: text.bodyMedium),
                          Switch(
                            value: localCloudScan,
                            onChanged: (v) async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('useCloudScan', v);
                              setSheetState(() => localCloudScan = v);
                              setState(() => useCloudScan = v);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _periodicScanTimer?.cancel();
    _popupController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  double _ringValue() {
    if (!protectionEnabled) return 0.0;
    if (!networkEnabled || vpnConflict) return 0.6;
    return 1.0;
  }

  Color _stateAccent(ThemeData theme) {
    if (!protectionEnabled) return Colors.redAccent;
    if (!networkEnabled || vpnConflict) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  IconData _stateIcon() {
    if (!protectionEnabled) return Icons.shield_outlined;
    if (shizukuRtpEnabled) return Icons.gavel_rounded;
    if (!networkEnabled || vpnConflict) return Icons.shield_moon_rounded;
    return Icons.verified_user;
  }

  String _stateTitle(AppLocalizations l10n) {
    return l10n.protectionTitle;
  }

  String _stateLine1(AppLocalizations l10n) {
    if (!protectionEnabled) return l10n.stateOffLine1;
    if (shizukuRtpEnabled && protectionEnabled) return l10n.stateAdvancedActiveLine1;
    if (!networkEnabled || vpnConflict) return l10n.stateFileOnlyLine1;
    return l10n.stateProtectedLine1;
  }

  String _stateLine2(AppLocalizations l10n) {
    if (!protectionEnabled) return l10n.stateOffLine2;
    if (!networkEnabled) return l10n.stateFileOnlyLine2;
    if (vpnConflict) return l10n.stateVpnConflictLine2;
    return l10n.stateProtectedLine2;
  }

  Widget _buildTopBar(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  l10n.appName,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: theme.colorScheme.onSurface.withOpacity(0.88),
                  ),
                ),
                if (isPro) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade700,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      l10n.proBadge,
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Drawer(
        backgroundColor: theme.colorScheme.surfaceContainerLow,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Text(
                  l10n.featuresDrawerTitle,
                  style: text.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant,
              ),
              _drawerItem(
                context,
                icon: Icons.wifi_lock_rounded,
                label: l10n.featureNetworkProtection,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    animatedRoute(const NetworkProtectionScreen()),
                  );
                },
              ),
              _drawerItem(
                context,
                icon: Icons.schedule_rounded,
                label: l10n.featureScheduledScans,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    animatedRoute(const ScheduledScansScreen()),
                  );
                },
              ),
              _drawerItem(
                context,
                icon: Icons.cleaning_services_rounded,
                label: l10n.featureCleanerPro,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    animatedRoute(const CleanerScreen()),
                  );
                },
              ),
              _drawerItem(
                context,
                icon: Icons.link_rounded,
                label: l10n.featureLinkChecker,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    animatedRoute(const LinkCheckScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        label,
        style: text.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildPrimaryControl(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    final accent = _stateAccent(theme);
    final ring = _ringValue();

    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: () {
            HapticFeedback.lightImpact();
            _toggleProtection();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularPercentIndicator(
                radius: 86,
                lineWidth: 12,
                percent: ring.clamp(0.0, 1.0),
                animation: true,
                animateFromLastPercent: true,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor:
                theme.colorScheme.onSurface.withOpacity(isDark ? 0.14 : 0.10),
                progressColor: accent.withOpacity(0.85),
                center: AnimatedScale(
                  duration: const Duration(milliseconds: 120),
                  scale: _pressed ? 0.94 : 1.0,
                  child: Icon(
                    _stateIcon(),
                    size: 60,
                    color: accent,
                  ),
                ),
              ),
              if (shizukuRtpEnabled && protectionEnabled)
                IgnorePointer(
                  child: SizedBox(
                    width: 172,
                    height: 172,
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, __) {
                        final t = _pulseController.value;
                        final opacity = 0.35 + math.sin(t * math.pi * 2) * 0.25;

                        return CustomPaint(
                          painter: _RingPulsePainter(
                            color: accent.withOpacity(opacity.clamp(0.15, 0.6)),
                            strokeWidth: 12,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          _stateLine1(l10n),
          style: text.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          _stateLine2(l10n),
          style: text.bodySmall?.copyWith(
            color: text.bodySmall?.color?.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          defsVersion.isEmpty
              ? l10n.dbUpdating
              : l10n.dbVersionAutoUpdated(defsVersion),
          style: text.bodySmall?.copyWith(
            fontSize: 12,
            color: text.bodySmall?.color?.withOpacity(0.55),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTapDown: (_) {
              HapticFeedback.lightImpact();
              setState(() => _pressed = true);
            },
            onTapUp: (_) {
              setState(() => _pressed = false);
            },
            onTapCancel: () {
              setState(() => _pressed = false);
            },
            child: OutlinedButton.icon(
              onPressed: _openScanDrawer,
              icon: const Icon(Icons.search_rounded, size: 18),
              label: Text(l10n.scanButton),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
      child: Text(
        title,
        style: text.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.onSurface.withOpacity(0.86),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(
      BuildContext context, {
        required String title,
        required String description,
        required IconData icon,
        required Color color,
        VoidCallback? onTap,
      }) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface.withOpacity(0.88),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: text.bodySmall?.copyWith(
                        height: 1.35,
                        color: text.bodySmall?.color?.withOpacity(0.72),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: theme.iconTheme.color?.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: theme.colorScheme.surface,
            ),
            if (shizukuRtpEnabled && protectionEnabled)
              IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.0, -0.18),
                      radius: 0.85,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(isDark ? 0.55 : 0.40),
                      ],
                    ),
                  ),
                ),
              ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  if (isPro && isDark && !hideGoldHeader)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: _proHeaderGradient(theme),
                      ),
                      child: _buildTopBar(context),
                    )
                  else
                    _buildTopBar(context),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 22),
                    child: Column(
                      children: [
                        _buildPrimaryControl(context),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _buildSectionTitle(context, l10n.recommendedSectionTitle),
                        ),
                        const SizedBox(height: 6),
                        _buildFeatureRow(
                          context,
                          title: l10n.featureScheduledScans,
                          description: l10n.recommendedScheduledScansDesc,
                          icon: Icons.schedule_rounded,
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          onTap: () => Navigator.push(
                            context,
                            animatedRoute(const ScheduledScansScreen()),
                          ),
                        ),

                        const SizedBox(height: 12),
                        _buildFeatureRow(
                          context,
                          title: l10n.featureCleanerPro,
                          description: l10n.recommendedCleanerProDesc,
                          icon: Icons.cleaning_services_rounded,
                          color: Colors.blueAccent,
                          onTap: () => Navigator.push(
                            context,
                            animatedRoute(const CleanerScreen()),
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (!isPro && kEnableAds)
                          const Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 4),
                            child: AdBanner(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _proHeaderGradient(ThemeData theme) {
    final isPurple =
        theme.colorScheme.primary.value == const Color(0xFF7C5CFF).value;

    if (isPurple) {
      return const LinearGradient(
        colors: [
          Color(0xFF4A3A6A),
          Color(0xFF2E2447),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }

    return const LinearGradient(
      colors: [
        Color(0xFF8A6A1F),
        Color(0xFF5A4616),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, {
        required String title,
        required String description,
        required IconData icon,
        required Color color,
        VoidCallback? onTap,
      }) {
    return _buildFeatureRow(
      context,
      title: title,
      description: description,
      icon: icon,
      color: color,
      onTap: onTap,
    );
  }
}

class _RingPulsePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _RingPulsePainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final radius = (size.width / 2) - (strokeWidth / 2);

    canvas.drawCircle(
      size.center(Offset.zero),
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPulsePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}