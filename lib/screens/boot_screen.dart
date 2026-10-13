import 'dart:async';
import 'package:colourswift_av/screens/permissions_intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/av_engine.dart';
import '../services/cloud/cloud_auth_service.dart';
import '../services/defs_update_scheduler.dart';
import '../services/purchase_service.dart';
import 'main_shell.dart';
import 'package:provider/provider.dart';
import '../services/theme/theme_manager.dart';
import '../translations/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../constants/launch_flag.dart';
import '../main.dart' show applyScanLimitsFromPrefs;
import 'quarantine/quarantine_screen.dart';

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> with TickerProviderStateMixin {
  late AnimationController _fadeOutController;
  late AnimationController _dotController;

  static const String _onboardingKey = 'onboarding_done_v2';

  @override
  void initState() {
    super.initState();

    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _initEngine();
  }

  Future<void> _initEngine() async {
    await DefsUpdateScheduler.init();
    await PurchaseService.init();
    await applyScanLimitsFromPrefs();
    unawaited(CloudAuthService.ensureRegistered());

    final info = await PackageInfo.fromPlatform();
    final currentVersion = '${info.version}+${info.buildNumber}';

    final prefs = await SharedPreferences.getInstance();
    final lastSeen = prefs.getString('last_seen_app_version');

    bool showUpdateLog = false;
    if (lastSeen == null) {
      await prefs.setString('last_seen_app_version', currentVersion);
    } else if (lastSeen != currentVersion) {
      showUpdateLog = true;
      await prefs.setString('last_seen_app_version', currentVersion);
    }

    bool openQuarantine = false;
    try {
      const channel = MethodChannel('colourswift/foreground_service');
      final result = await channel.invokeMethod<Map>('getLaunchExtras');
      openQuarantine = result?['open_quarantine'] == true;
    } catch (_) {}

    await AvEngine.ensureInitialized();

    if (!mounted) return;
    await _fadeOutController.forward();

    final done = prefs.getBool(_onboardingKey) ?? false;

    if (!mounted) return;

    if (openQuarantine) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const QuarantineScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => done
            ? Provider(
          create: (_) => LaunchFlags(
            showUpdateLog: showUpdateLog,
            currentVersion: currentVersion,
          ),
          child: const MainShell(),
        )
            : const PermissionsIntroScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _fadeOutController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    context.watch<ThemeManager>().themeName;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: Tween<double>(begin: 1, end: 0).animate(_fadeOutController),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'AvarionX',
                style: text.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                  letterSpacing: 3.0,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.bootOptimisingYourProtection,
                style: text.bodyMedium?.copyWith(
                  color: text.bodyLarge?.color?.withOpacity(0.5),
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 10),
              AnimatedBuilder(
                animation: _dotController,
                builder: (context, _) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (i) {
                      final opacity = ((_dotController.value * 3) - i).clamp(0.3, 1.0);
                      return Opacity(
                        opacity: opacity,
                        child: Text(
                          '•',
                          style: text.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}