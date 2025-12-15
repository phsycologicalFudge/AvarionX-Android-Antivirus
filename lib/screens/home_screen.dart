import 'package:colourswift_av/screens/password%20manager/password_manager_screen.dart';
import 'package:colourswift_av/screens/scan/cleaner_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/realtime_protection_service.dart';
import '../services/update_service.dart';
import '../utils/animated_route.dart';
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
  bool vpnActive = false;
  bool vpnConflict = false;
  String? remoteVersion;
  String version = '';

  late AnimationController _popupController;
  late Animation<Offset> _popupAnimation;
  late Animation<double> _popupOpacity;

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => version = info.version);
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
  void initState() {
    super.initState();
    _loadHeaderPref();
    _loadProtectionState();
    _loadVersion();
    _loadProStatus();
    _loadCloudToggle();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForDatabaseUpdate();
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
    double progress = 0;
    bool dialogMounted = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            Future.microtask(() async {
              try {
                double lastShown = 0;
                await UpdateService.downloadDatabase(
                  onProgress: (p) {
                    if ((p - lastShown).abs() >= 0.01 && dialogMounted) {
                      lastShown = p;
                      setStateDialog(() => progress = p);
                    }
                  },
                );

                if (!mounted || !dialogMounted) return;

                Navigator.of(context, rootNavigator: true).pop();

                await UpdateService.setLocalVersion(newRemoteVersion);

                if (!mounted) return;
                setState(() {
                  hasUpdate = false;
                  remoteVersion = null;
                });

                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(content: Text('Database updated successfully')),
                );
              } catch (_) {
                if (!mounted || !dialogMounted) return;
                Navigator.of(context, rootNavigator: true).pop();
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(content: Text('Database update failed')),
                );
              }
            });

            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: const Text('Updating Database'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(value: progress),
                    const SizedBox(height: 10),
                    Text('${(progress * 100).toStringAsFixed(0)}%'),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      dialogMounted = false;
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

  Future<void> _loadProtectionState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedState = prefs.getBool('protectionEnabled') ?? false;
    setState(() {
      protectionEnabled = savedState;
      protectionPercent = savedState ? 1.0 : 0.0;
    });
    if (protectionEnabled) _startBackgroundScan();
  }

  Future<void> _toggleProtection() async {
    final prefs = await SharedPreferences.getInstance();

    if (protectionEnabled) {
      await AvServiceManager.stopProtection();
      await AvServiceManager.stopVpn();
      _stopBackgroundScan();

      setState(() {
        protectionEnabled = false;
        vpnActive = false;
        vpnConflict = false;
        protectionPercent = 0.0;
      });

      prefs.setBool('protectionEnabled', false);
      return;
    }

    final status = await Permission.notification.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification permission required.')),
      );
      return;
    }

    final vpnOk = await requestVpnPermission();
    if (!vpnOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('VPN permission required for network protection.')),
      );
    }

    final conflict = await _isAnotherVpnActive();


    await AvServiceManager.startProtection();
    _startBackgroundScan();

    if (!conflict) {
      await AvServiceManager.startVpn();
    }
    setState(() {
      protectionEnabled = true;
      vpnActive = !conflict;
      vpnConflict = conflict;
      protectionPercent = 1.0;
    });

    prefs.setBool('protectionEnabled', true);

    if (conflict) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Another VPN is active. Network protection disabled.')),
      );
    }
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
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.55,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    Text(
                      'ENGINE READY • VX-TITANIUM-v6',
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: text.bodyLarge?.color?.withOpacity(0.75),
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
                          animatedRoute(
                              const ScanScreen(startMode: ScanMode.smart)),
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
                          animatedRoute(
                              const ScanScreen(startMode: ScanMode.rapid)),
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
                          animatedRoute(
                              const ScanScreen(startMode: ScanMode.installed)),
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
                          animatedRoute(
                              const ScanScreen(startMode: ScanMode.single)),
                        );
                      },
                    ),

                    const SizedBox(height: 10),
                    const Divider(height: 1),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Use cloud-assisted scan',
                              style: text.bodyMedium),
                          Switch(
                            value: localCloudScan,
                            onChanged: (v) async {
                              final prefs = await SharedPreferences
                                  .getInstance();
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

  Widget _buildProtectionCenter(TextTheme text) {
    if (!protectionEnabled) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.redAccent,
            size: 60,
          ),
          const SizedBox(height: 10),
          Text(
            'Protection Disabled',
            style: text.titleMedium?.copyWith(
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Tap to enable protection',
            style: text.bodySmall?.copyWith(
              color: text.bodySmall?.color?.withOpacity(0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }

    if (vpnConflict) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shield_moon_rounded,
            color: Colors.orangeAccent,
            size: 60,
          ),
          const SizedBox(height: 10),
          Text(
            'Partial Protection',
            style: text.titleMedium?.copyWith(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Another VPN is active',
            style: text.bodySmall?.copyWith(
              color: text.bodySmall?.color?.withOpacity(0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.verified_user,
          color: Colors.greenAccent,
          size: 60,
        ),
        const SizedBox(height: 10),
        Text(
          'Device Protected',
          style: text.titleMedium?.copyWith(
            color: text.bodyLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Tap to disable protection',
          style: text.bodySmall?.copyWith(
            color: text.bodySmall?.color?.withOpacity(0.7),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    final backgroundGradient = (isPro && isDark && !hideGoldHeader)
        ? const LinearGradient(
      colors: [Color(0xFFB8860B), Color(0xFF4B3B08)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    )
        : LinearGradient(
      colors: [
        theme.colorScheme.primary.withOpacity(0.25),
        isDark ? Colors.black : theme.scaffoldBackgroundColor,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            expandedHeight: isPro ? 80 : 80,
            backgroundColor: theme.appBarTheme.backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Image.asset(
                    //'assets/icons/logo3.png',
                   // width: 30,
                   // height: 30,
                 // ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'CS Security',
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: text.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: text.bodyLarge?.color,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  if (isPro) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade700,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ],
              ),
              background: Container(decoration: BoxDecoration(gradient: backgroundGradient)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _toggleProtection,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularPercentIndicator(
                                radius: 130.0,
                                lineWidth: 14.0,
                                animation: true,
                                animateFromLastPercent: true,
                                percent: protectionPercent,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor:
                                protectionEnabled ? Colors.greenAccent : Colors.redAccent,
                                backgroundColor: theme.dividerColor.withOpacity(0.1),
                                center: _buildProtectionCenter(text),
                              ),
                              Positioned(
                                top: 35,
                                right: 35,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.info_outline_rounded,
                                    size: 20,
                                    color: theme.iconTheme.color?.withOpacity(0.7),
                                  ),
                                  onPressed: _showRtpInfo,
                                  splashRadius: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          GestureDetector(
                            onTap: _openScanDrawer,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeOut,
                              width: double.infinity,
                              height: 46,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary.withOpacity(0.9),
                                    theme.colorScheme.primary.withOpacity(0.7),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary.withOpacity(0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.search_rounded,
                                      color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Scan Now',
                                    style: text.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if (hasUpdate && remoteVersion != null && remoteVersion!.isNotEmpty)
                            ...[
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: () => _startUpdate(remoteVersion!),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  textStyle: const TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w600),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.system_update_rounded, size: 18),
                                label: Text('Update to v${remoteVersion ?? ""}'),
                              ),
                            ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Terminal',
                        style: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: text.bodyLarge?.color,
                        ),
                      ),
                    ),

                    // Features
                    _buildFeatureCard(
                      context,
                      title: 'MetaPass',
                      description: 'Generate secure offline passwords.',
                      icon: Icons.key_rounded,
                      color: Colors.amberAccent,
                      onTap: () => Navigator.push(context,
                          animatedRoute(const PasswordTestScreen())),
                    ),
                    const SizedBox(height: 15),

                    _buildFeatureCard(
                      context,
                      title: 'Cleaner Pro',
                      description:
                      'Find duplicates, old media, and unused apps to reclaim storage automatically.',
                      icon: Icons.cleaning_services_rounded,
                      color: Colors.blueAccent,
                      onTap: () =>
                          Navigator.push(context, animatedRoute(const CleanerScreen())),
                    ),
                    const SizedBox(height: 15),

                    _buildFeatureCard(
                      context,
                      title: 'Wi-Fi Protection',
                      description:
                      '50% complete. RTP or "vpn on" command protects you against suspicious domain systemwide.',
                      icon: Icons.wifi_lock_rounded,
                      color: Colors.tealAccent,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context,
      {required String title,
        required String description,
        required IconData icon,
        required Color color,
        VoidCallback? onTap}) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark
              ? theme.cardColor
              : theme.colorScheme.surfaceVariant.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: text.bodyLarge?.color)),
                  const SizedBox(height: 6),
                  Text(description,
                      style: text.bodySmall?.copyWith(
                          color:
                          text.bodySmall?.color?.withOpacity(0.7),
                          height: 1.4)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios_rounded,
                color: text.bodySmall?.color?.withOpacity(0.6), size: 18),
          ],
        ),
      ),
    );
  }
}
