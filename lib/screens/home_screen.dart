import 'package:colourswift_av/screens/password%20manager/password_manager_screen.dart';
import 'package:colourswift_av/screens/scan/cleaner_screen.dart';
import 'package:colourswift_av/screens/vpn/NetworkProtectionScreen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/defs_auto_update_service.dart';
import '../services/realtime_protection_service.dart';
import '../services/update_service.dart';
import '../utils/animated_route.dart';
import '../widgets/antivirus_bridge.dart';
import 'exclusions/exclusion_manager_screen.dart';
import 'scan_screen.dart';
import '../services/service_manager.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
  String? remoteVersion;
  String version = '';
  String defsVersion = '';

  late AnimationController _popupController;
  late Animation<Offset> _popupAnimation;
  late Animation<double> _popupOpacity;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const String _autoUpdateKey = 'defs_auto_update_enabled';

  bool _pressed = false;

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
    final prefs = await SharedPreferences.getInstance();
    setState(() => isPro = prefs.getBool('isPro') ?? false);
  }

  Future<void> _togglePro() async {
    final prefs = await SharedPreferences.getInstance();
    final newStatus = !isPro;
    await prefs.setBool('isPro', newStatus);
    setState(() => isPro = newStatus);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(newStatus ? 'Pro activated' : 'Pro deactivated')),
    );
  }

  Future<void> _loadAutoUpdatePref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      autoUpdateDefs = prefs.getBool('defs_auto_update_enabled') ?? false;
    });
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
    _loadProtectionState();
  }

  @override
  void initState() {
    super.initState();

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

    DefsAutoUpdateService.maybeRun().then((_) async {
      if (!mounted) return;
      await _loadDefsVersion();
      await _refreshUpdateState();
    });

    _popupController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

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

        return Dialog(
          backgroundColor: theme.cardColor.withOpacity(0.92),
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Realtime Protection',
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Along with blocking suspicious files downloaded intentionally (or by malware), RTP uses a local VPN to block malicious domains system-wide.\n\n'
                      'When enabled, network filtering remains active unless:\n'
                      '• Disabled manually via Terminal\n'
                      '• Replaced by another VPN\n\n'
                      'File protection continues regardless as long as RTP is enabled.',
                  style: text.bodySmall?.copyWith(
                    height: 1.4,
                    color: text.bodySmall?.color?.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ),
              ],
            ),
          ),
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
        final isDark = theme.brightness == Brightness.dark;

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
                final defsPath = '${dir.path}/defs.vxpack';
                final keyPath = '${dir.path}/defs_key.bin';

                try {
                  AntivirusBridge().reload(defsPath, keyPath);
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
                          ? 'Database updated • Auto updates enabled'
                          : 'Database updated successfully',
                    ),
                  ),
                );
              } catch (_) {
                if (!mounted || !mountedSheet) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(content: Text('Database update failed')),
                );
              }
            });

            return Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor.withOpacity(isDark ? 0.92 : 0.96),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.45 : 0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
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
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Updating Database',
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
                          'Version $newRemoteVersion',
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
                          theme.colorScheme.onSurface.withOpacity(0.12),
                          valueColor: AlwaysStoppedAnimation(
                            theme.colorScheme.primary,
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
                              'Automatically download future updates',
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
    final prefs = await SharedPreferences.getInstance();

    final rtp = prefs.getBool('protectionEnabled') ?? false;
    final net = prefs.getBool('networkProtectionEnabled') ?? false;
    final conflict = rtp && net ? await _isAnotherVpnActive() : false;

    setState(() {
      protectionEnabled = rtp;
      networkEnabled = rtp && net && !conflict;
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

    if (rtp) {
      _startBackgroundScan();
    } else {
      _stopBackgroundScan();
    }
  }

  Future<void> _toggleProtection() async {
    final prefs = await SharedPreferences.getInstance();

    if (protectionEnabled) {
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

    bool netEnabled = false;

    if (!conflict) {
      await AvServiceManager.startVpn();
      netEnabled = true;
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
      backgroundColor: theme.cardColor,
      builder: (context) {
        bool localCloudScan = useCloudScan;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    Text(
                      'ENGINE READY • VX-TITANIUM-v7',
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.shield_rounded),
                      title: const Text('Smart Scan'),
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
                      title: const Text('Rapid Scan'),
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
                      title: const Text('Installed Apps'),
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
                      title: const Text('File / App Scan'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          animatedRoute(const ScanScreen(startMode: ScanMode.single)),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Use cloud-assisted scan', style: text.bodyMedium),
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
    if (!networkEnabled || vpnConflict) return Icons.shield_moon_rounded;
    return Icons.verified_user;
  }

  String _stateTitle() {
    if (!protectionEnabled) return 'Protection';
    if (vpnConflict) return 'Protection';
    return 'Protection';
  }

  String _stateLine1() {
    if (!protectionEnabled) return 'Device protection is off';
    if (!networkEnabled || vpnConflict) return 'Partial protection enabled';
    return 'Your device is fully protected';
  }

  String _stateLine2() {
    if (!protectionEnabled) return 'Tap to turn on';
    if (!networkEnabled) return 'Network protection disabled';
    if (vpnConflict) return 'Another VPN is active';
    return 'Tap to turn off';
  }

  Widget _buildTopBar(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  'CS Security',
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
                    child: const Text(
                      'SPONSOR',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSideDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Drawer(
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.92),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Text(
                  'Features',
                  style: text.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: theme.colorScheme.onSurface.withOpacity(0.18),
              ),
              _drawerItem(
                context,
                icon: Icons.wifi_lock_rounded,
                label: 'Network Protection',
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
                icon: Icons.key_rounded,
                label: 'MetaPass',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    animatedRoute(const PasswordTestScreen()),
                  );
                },
              ),
              _drawerItem(
                context,
                icon: Icons.cleaning_services_rounded,
                label: 'Cleaner Pro',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    animatedRoute(const CleanerScreen()),
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
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    final accent = _stateAccent(theme);
    final ring = _ringValue();

    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          onTap: _toggleProtection,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            scale: _pressed ? 0.97 : 1.0,
            child: CircularPercentIndicator(
              radius: 86,
              lineWidth: 12,
              percent: ring.clamp(0.0, 1.0),
              animation: true,
              animateFromLastPercent: true,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor:
              theme.colorScheme.onSurface.withOpacity(isDark ? 0.14 : 0.10),
              progressColor: accent,
              center: AnimatedScale(
                duration: const Duration(milliseconds: 120),
                scale: _pressed ? 0.94 : 1.0,
                child: Icon(
                  _stateIcon(),
                  size: 46,
                  color: accent,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          _stateLine1(),
          style: text.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          _stateLine2(),
          style: text.bodySmall?.copyWith(
            color: text.bodySmall?.color?.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          defsVersion.isEmpty
              ? 'Database updating'
              : 'Database v$defsVersion • Auto updated',
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
              label: const Text('Scan'),
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

        const SizedBox(height: 10),
        IconButton(
          onPressed: _showRtpInfo,
          icon: Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: theme.iconTheme.color?.withOpacity(0.65),
          ),
          splashRadius: 18,
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
    final isDark = theme.brightness == Brightness.dark;

    final bg = theme.scaffoldBackgroundColor.withOpacity(isDark ? 0.35 : 0.6);
    final border = theme.colorScheme.onSurface.withOpacity(isDark ? 0.10 : 0.08);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.28 : 0.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
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
                  child: Icon(icon, color: color, size: 24),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildSideDrawer(context),
    backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.18),
                    isDark ? Colors.black : theme.scaffoldBackgroundColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
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
                          child: _buildSectionTitle(context, 'Quick Features'),
                        ),
                        const SizedBox(height: 6),
                        _buildFeatureRow(
                          context,
                          title: 'MetaPass',
                          description: 'Generate secure offline passwords.',
                          icon: Icons.key_rounded,
                          color: Colors.amberAccent,
                          onTap: () => Navigator.push(
                            context,
                            animatedRoute(const PasswordTestScreen()),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureRow(
                          context,
                          title: 'Cleaner Pro',
                          description:
                          'Find duplicates, old media, and unused apps to reclaim storage automatically.',
                          icon: Icons.cleaning_services_rounded,
                          color: Colors.blueAccent,
                          onTap: () => Navigator.push(
                            context,
                            animatedRoute(const CleanerScreen()),
                          ),
                        ),
                        const SizedBox(height: 12),
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
