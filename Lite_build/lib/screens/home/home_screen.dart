import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/build_flags.dart';
import '../../constants/launch_flag.dart';
import '../../services/defs_auto_update_service.dart';
import '../../services/purchase_service.dart';
import '../../services/realtime_protection_service.dart';
import '../../services/scan_scheduler.dart';
import '../../services/scan_session_service.dart';
import '../../services/service_manager.dart';
import '../../services/theme/theme_manager.dart';
import '../../services/update_service.dart';
import '../../translations/app_localizations.dart';
import '../../utils/animated_route.dart';
import '../../widgets/antivirus_bridge.dart';
import '../../widgets/mesh_background.dart';
import '../quarantine/quarantine_screen.dart';
import '../scan_ui_screen.dart';
import 'av_home_drawer.dart';
import 'av_home_feature_row.dart';
import 'av_home_primary_control.dart';
import 'av_home_top_bar.dart';
import 'device_security_screen.dart';
import 'security_report_screen.dart';
import '../settings/settings_screen.dart';

class AvHomeScreen extends StatefulWidget {
  const AvHomeScreen({super.key});

  @override
  State<AvHomeScreen> createState() => AvHomeScreenState();
}

class AvHomeScreenState extends State<AvHomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Future<void> refresh() async {
    await _loadProtectionState();
    await _loadProStatus();
    await _loadDefsVersion();
  }

  bool protectionEnabled = false;
  double protectionPercent = 0.0;
  bool goldHeaderEnabled = false;
  Timer? _periodicScanTimer;
  Timer? _scheduledEnableTimer;
  bool isPro = false;
  bool hasUpdate = false;
  bool useCloudScan = false;
  bool vpnActive = false;
  bool vpnConflict = false;
  bool autoUpdateDefs = false;
  bool shizukuRtpEnabled = false;
  String? remoteVersion;
  String version = '';
  String defsVersion = '';
  bool _defsSyncing = false;

  late AnimationController _popupController;
  late Animation<Offset> _popupAnimation;
  late Animation<double> _popupOpacity;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  static const String _autoUpdateKey = 'defs_auto_update_enabled';

  bool _proStatusResolved = false;
  bool _pressed = false;
  bool _loadingProtectionState = false;
  bool _updateLogShown = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openScanDrawer() {
    Navigator.push(
      context,
      animatedRoute(
        ScanModesScreen(
          useCloudScan: useCloudScan,
          onCloudScanChanged: (value) {
            setState(() => useCloudScan = value);
          },
        ),
      ),
    );
  }

  void _handleDrawerItem(String tag) {
    switch (tag) {
      case 'scan':
        _handleScanButton();
        break;
      case 'settings':
        Navigator.push(context, animatedRoute(const SettingsScreen()));
        break;
      case 'quarantine':
        Navigator.push(context, animatedRoute(const QuarantineScreen()));
        break;
      case 'security_report':
        Navigator.push(context, animatedRoute(const SecurityReportScreen()));
        break;
      case 'protection':
        _showRtpInfo();
        break;
      default:
        break;
    }
  }

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

  Future<void> _syncDefsOnForeground({
    bool forceServerCheck = false,
  }) async {
    if (_defsSyncing) return;
    _defsSyncing = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final rtpEnabled = prefs.getBool('protectionEnabled') ?? false;

      if (rtpEnabled) {
        await RealtimeProtectionService.ensureDefsReady(
          forceServerCheck: forceServerCheck,
        );
      } else {
        final result = await UpdateService.ensureDatabaseReady(
          forceServerCheck: forceServerCheck,
          minCheckInterval: const Duration(minutes: 15),
        );

        if (result['downloaded'] == true) {
          final paths = await UpdateService.getLocalPaths();
          try {
            AntivirusBridge().reload(
              paths['defsPath']!,
              paths['keyPath']!,
            );
          } catch (_) {}
        }
      }

      await _loadDefsVersion();
      await _refreshUpdateState();
    } finally {
      _defsSyncing = false;
    }
  }

  Future<void> _loadProStatus() async {
    final prefs = await SharedPreferences.getInstance();

    final cachedBillingPro = prefs.getBool('billing_is_pro') ?? false;
    final cachedServerSignedIn =
        prefs.getBool('billing_server_session_signed_in') ?? false;
    final cachedServerPro =
        prefs.getBool('billing_server_session_pro') ?? false;

    final cachedEffective =
        cachedBillingPro || (cachedServerSignedIn && cachedServerPro);

    if (mounted) {
      setState(() {
        isPro = cachedEffective;
        _proStatusResolved = true;
      });
    }

    await PurchaseService.restore();

    final billingPro = await PurchaseService.hasPro();
    final effective = billingPro;

    if (!mounted) return;

    setState(() {
      isPro = effective;
      _proStatusResolved = true;
    });
  }

  Future<void> _loadAutoUpdatePref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      autoUpdateDefs = prefs.getBool('defs_auto_update_enabled') ?? false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadShizukuRtpState();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

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
    _loadAutoUpdatePref();
    _loadDefsVersion();
    _loadShizukuRtpState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _syncDefsOnForeground(forceServerCheck: true);
    });

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadProtectionState();
      _loadProStatus();
      _loadDefsVersion();
      _syncDefsOnForeground(forceServerCheck: true);
    }
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
    bool started = false;

    final messenger = ScaffoldMessenger.maybeOf(context);

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
            if (!started) {
              started = true;
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
                  final defsPath = '${dir.path}/defs.vxpack';
                  final keyPath = '${dir.path}/defs_key.bin';

                  try {
                    AntivirusBridge().reload(defsPath, keyPath);
                  } catch (e) {
                    debugPrint('[DefsUpdate] Engine reload failed: $e');
                  }

                  if (!mounted || !mountedSheet) return;

                  Navigator.of(context, rootNavigator: true).pop();

                  if (!mounted) return;

                  setState(() {
                    hasUpdate = false;
                    remoteVersion = null;
                  });

                  messenger?.showSnackBar(
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
                  Navigator.of(context, rootNavigator: true).pop();
                  messenger?.showSnackBar(
                    SnackBar(content: Text(l10n.updateDbUpdateFailed)),
                  );
                }
              });
            }

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
                          backgroundColor: sheetTheme.colorScheme.onSurface
                              .withOpacity(0.12),
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
    setState(
        () => goldHeaderEnabled = prefs.getBool('goldHeaderEnabled') ?? false);
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

      if (!mounted) return;

      setState(() {
        protectionEnabled = rtp;
        vpnConflict = false;
        vpnActive = false;
        protectionPercent = rtp ? 1.0 : 0.0;
      });

      if (!rtp) {
        try {
          await AvServiceManager.stopProtection();
        } catch (_) {}
        _stopBackgroundScan();
        _scheduledEnableTimer?.cancel();
        await ScheduledScanScheduler.disable();
        return;
      }

      try {
        await AvServiceManager.startProtection();
      } catch (_) {
        await ScheduledScanScheduler.disable();
        await prefs.setBool('protectionEnabled', false);

        if (!mounted) return;

        setState(() {
          protectionEnabled = false;
          vpnActive = false;
          vpnConflict = false;
          protectionPercent = 0.0;
        });

        _stopBackgroundScan();
        return;
      }

      _startBackgroundScan();
      _scheduledEnableTimer?.cancel();
      _scheduledEnableTimer = Timer(const Duration(minutes: 10), () async {
        await ScheduledScanScheduler.enableFromPrefs();
      });

      if (!mounted) return;
      setState(() {
        vpnActive = false;
        vpnConflict = false;
        protectionPercent = 1.0;
      });
    } finally {
      _loadingProtectionState = false;
    }
  }

  Future<void> _toggleProtection() async {
    final prefs = await SharedPreferences.getInstance();

    if (protectionEnabled) {
      _scheduledEnableTimer?.cancel();
      await ScheduledScanScheduler.disable();

      try {
        await AvServiceManager.stopProtection();
      } catch (_) {}

      _stopBackgroundScan();

      await prefs.setBool('protectionEnabled', false);

      setState(() {
        protectionEnabled = false;
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

    await AvServiceManager.startProtection();
    _startBackgroundScan();

    _scheduledEnableTimer?.cancel();
    _scheduledEnableTimer = Timer(const Duration(minutes: 10), () async {
      await ScheduledScanScheduler.enableFromPrefs();
    });

    await prefs.setBool('protectionEnabled', true);

    setState(() {
      protectionEnabled = true;
      vpnActive = false;
      vpnConflict = false;
      protectionPercent = 1.0;
    });
  }

  void _startBackgroundScan() => RealtimeProtectionService.start();
  void _stopBackgroundScan() => RealtimeProtectionService.stop();

  Future<void> _handleScanButton() async {
    final session = ScanSessionService.instance;

    if (session.isScanning || session.cancelling) {
      Navigator.push(context, animatedRoute(const ScanScreen()));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final showScanModePicker = prefs.getBool('show_scan_mode_picker') ?? false;

    if (showScanModePicker) {
      _openScanDrawer();
      return;
    }

    Navigator.push(
      context,
      animatedRoute(const ScanScreen(startMode: ScanMode.smart)),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _periodicScanTimer?.cancel();
    _popupController.dispose();
    _pulseController.dispose();
    _scheduledEnableTimer?.cancel();
    super.dispose();
  }

  Color _stateAccent(ThemeData theme) {
    if (!protectionEnabled) return Colors.redAccent;
    return Colors.greenAccent;
  }

  IconData _stateIcon() {
    if (!protectionEnabled) return Icons.shield_outlined;
    if (shizukuRtpEnabled) return Icons.gavel_rounded;
    return Icons.verified_user;
  }

  String _stateLine1(AppLocalizations l10n) {
    if (!protectionEnabled) return l10n.stateOffLine1;
    if (shizukuRtpEnabled) return l10n.stateAdvancedActiveLine1;
    return 'Real-Time Protection';
  }

  LinearGradient _proHeaderGradient(ThemeData theme) {
    return const LinearGradient(
      colors: [
        Color(0xFFBFA14A),
        Color(0xFF8C6B1F),
        Color(0xFF5A4616),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final accent = _stateAccent(theme);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      drawer: AvHomeDrawer(
        isPro: isPro,
        onItemTap: _handleDrawerItem,
      ),
      body: SafeArea(
        child: Stack(
          children: [
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
                  Stack(
                    children: [
                      if (isPro && isDark && goldHeaderEnabled)
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: _proHeaderGradient(theme),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          theme.colorScheme.surface,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              AvHomeTopBar(
                                title: l10n.appName,
                                isPro: isPro,
                                onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                              ),
                            ],
                          ),
                        )
                      else
                        AvHomeTopBar(
                          title: l10n.appName,
                          isPro: isPro,
                          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 22),
                    child: Column(
                      children: [
                        AvHomePrimaryControl(
                          pressed: _pressed,
                          onPressedChanged: (v) => setState(() => _pressed = v),
                          onToggleProtection: () {
                            HapticFeedback.lightImpact();
                            _toggleProtection();
                          },
                          accent: accent,
                          isDark: isDark,
                          icon: _stateIcon(),
                          line1: _stateLine1(l10n),
                          defsLine: defsVersion.isEmpty
                              ? l10n.dbUpdating
                              : l10n.dbVersionAutoUpdated(defsVersion),
                        ),
                        const SizedBox(height: 20),
                        AvHomeFeatureRow(
                          title: 'Scan Now',
                          description: 'Manually check your device for malware',
                          icon: Icons.search_rounded,
                          color: theme.colorScheme.primary,
                          onTap: _handleScanButton,
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder<DeviceSecuritySummary>(
                          future: DeviceSecurityScreen.loadSummary(),
                          builder: (context, snapshot) {
                            final summary =
                                snapshot.data ?? const DeviceSecuritySummary.empty();

                            return AvHomeFeatureRow(
                              title: 'Device Security',
                              description: summary.homeLabel,
                              icon: Icons.security_rounded,
                              color: summary.hasRisk
                                  ? Colors.redAccent
                                  : Colors.blueAccent,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  animatedRoute(const DeviceSecurityScreen()),
                                ).then((_) {
                                  if (!mounted) return;
                                  setState(() {});
                                });
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        _SecurityOverviewPreview(
                          protectionEnabled: protectionEnabled,
                          defsVersion: defsVersion,
                          onGenerateReport: () => Navigator.push(
                            context,
                            animatedRoute(const SecurityReportScreen()),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const _AvarionXSecurityFooter(),
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
}

class _AvarionXSecurityFooter extends StatelessWidget {
  const _AvarionXSecurityFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    return Opacity(
      opacity: theme.brightness == Brightness.dark ? 0.58 : 0.72,
      child: Column(
        children: [
          Text(
            'AvarionX',
            style: text.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Protected by VX-TITANIUM',
            style: text.labelSmall?.copyWith(
              letterSpacing: 0.2,
              color: scheme.onSurface.withOpacity(0.62),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityOverviewPreview extends StatefulWidget {
  final bool protectionEnabled;
  final String defsVersion;
  final VoidCallback onGenerateReport;

  const _SecurityOverviewPreview({
    required this.protectionEnabled,
    required this.defsVersion,
    required this.onGenerateReport,
  });

  @override
  State<_SecurityOverviewPreview> createState() => _SecurityOverviewPreviewState();
}

class _SecurityOverviewPreviewState extends State<_SecurityOverviewPreview> {
  late Future<_HomeSecuritySnapshot> _future;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _future = _loadSnapshot();

    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      setState(() {
        _future = _loadSnapshot();
      });
    });
  }

  @override
  void didUpdateWidget(covariant _SecurityOverviewPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.protectionEnabled != widget.protectionEnabled ||
        oldWidget.defsVersion != widget.defsVersion) {
      setState(() {
        _future = _loadSnapshot();
      });
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<_HomeSecuritySnapshot> _loadSnapshot() async {
    final prefs = await SharedPreferences.getInstance();

    return _HomeSecuritySnapshot(
      manualScans: prefs.getInt('security_report_manual_scans_total') ?? 0,
      rtpScans: prefs.getInt('security_report_rtp_scans_total') ?? 0,
      scheduledScans: prefs.getInt('security_report_scheduled_scans_total') ?? 0,
      threats: prefs.getInt('security_report_threats_total') ?? 0,
      filesChecked: prefs.getInt('security_report_files_scanned_total') ?? 0,
      lastManualScanAt: prefs.getInt('security_report_last_manual_scan_at'),
      lastRtpEventAt: prefs.getInt('security_report_last_rtp_event_at'),
      lastScheduledScanAt: prefs.getInt('security_report_last_scheduled_scan_at'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    const color = Colors.teal;

    return FutureBuilder<_HomeSecuritySnapshot>(
      future: _future,
      builder: (context, snapshot) {
        final data = snapshot.data ?? const _HomeSecuritySnapshot.empty();

        return Card(
          elevation: 0,
          color: theme.cardTheme.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onGenerateReport,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 76,
                    color: color.withOpacity(0.16),
                    child: const Icon(
                      Icons.summarize_rounded,
                      color: color,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 14, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Security Overview',
                            style: text.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: scheme.onSurface.withOpacity(0.88),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            data.latestLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall?.copyWith(
                              height: 1.35,
                              color: scheme.onSurface.withOpacity(0.54),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _OverviewMetric(
                                  label: 'Files checked',
                                  value: _compactCount(data.filesChecked),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _OverviewMetric(
                                  label: 'Threats',
                                  value: _compactCount(data.threats),
                                ),
                              ),
                            ],
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
      },
    );
  }
}

String _compactCount(int value) {
  if (value >= 1000000) {
    final compact = value / 1000000;
    return '${compact.toStringAsFixed(compact >= 10 ? 0 : 1)}M';
  }
  if (value >= 1000) {
    final compact = value / 1000;
    return '${compact.toStringAsFixed(compact >= 10 ? 0 : 1)}K';
  }
  return value.toString();
}

class _OverviewMetric extends StatelessWidget {
  final String label;
  final String value;

  const _OverviewMetric({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(theme.brightness == Brightness.dark ? 0.56 : 0.54),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.onSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.labelSmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.46),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSecuritySnapshot {
  final int manualScans;
  final int rtpScans;
  final int scheduledScans;
  final int threats;
  final int? lastManualScanAt;
  final int? lastRtpEventAt;
  final int? lastScheduledScanAt;
  final int filesChecked;

  const _HomeSecuritySnapshot({
    required this.manualScans,
    required this.rtpScans,
    required this.scheduledScans,
    required this.threats,
    required this.lastManualScanAt,
    required this.lastRtpEventAt,
    required this.lastScheduledScanAt,
    required this.filesChecked,
  });

  const _HomeSecuritySnapshot.empty()
      : manualScans = 0,
        rtpScans = 0,
        scheduledScans = 0,
        threats = 0,
        filesChecked = 0,
        lastManualScanAt = null,
        lastRtpEventAt = null,
        lastScheduledScanAt = null;

  String get latestLabel {
    final latest = [
      lastManualScanAt,
      lastRtpEventAt,
      lastScheduledScanAt,
    ].whereType<int>().fold<int?>(null, (prev, value) {
      if (prev == null) return value;
      return value > prev ? value : prev;
    });

    if (latest == null) return 'No report data yet';
    return 'Last activity ${_relativeTime(latest)}';
  }

  static String _relativeTime(int millis) {
    final date = DateTime.fromMillisecondsSinceEpoch(millis);
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}


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

  void _startMode(ScanMode mode) {
    Navigator.pushReplacement(
      context,
      animatedRoute(ScanScreen(startMode: mode)),
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
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(
          'Scan Modes',
          style: text.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: MeshBackground(
        blobs: themeManager.meshBlobs,
        base: scheme.surface,
        child: SafeArea(
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
                  title: l10n.scanModeSingleTitle,
                  subtitle: l10n.scanModeSingleSubtitle,
                  icon: Icons.insert_drive_file_rounded,
                  color: Colors.teal,
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
                                      ? 'Cloud-assisted checks enabled'
                                      : 'Local scan engine only',
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
