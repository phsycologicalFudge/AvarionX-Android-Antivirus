import 'dart:async';
import 'package:colourswift_av/screens/permissions_intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/av_engine.dart';
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
  String _selectedIcon = 'default';
  late AnimationController _pulseController;
  late AnimationController _fadeOutController;
  late Timer _textTimer;
  int _currentIndex = 0;

  static const String _onboardingKey = 'onboarding_done_v2';

  late List<String> _messages;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _messages = const [
      'Preparing protection...',
      'Loading definitions...',
      'Initializing engine...',
      'Optimizing memory...',
      'Starting services...',
    ];

    _textTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _currentIndex = (_currentIndex + 1) % _messages.length);
    });

    _loadSelectedIcon();
    _initEngine();
  }

  Future<void> _loadSelectedIcon() async {
    final prefs = await SharedPreferences.getInstance();
    final icon = prefs.getString('selectedIcon') ?? 'default';
    if (!mounted) return;
    setState(() => _selectedIcon = icon);
  }

  Future<void> _initEngine() async {
    await DefsUpdateScheduler.init();
    await PurchaseService.init();
    await applyScanLimitsFromPrefs();

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
    _pulseController.dispose();
    _fadeOutController.dispose();
    _textTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = 1.0 + (_pulseController.value * 0.05);
                  return Transform.scale(
                    scale: scale,
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipOval(
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/icons/ic_launcher_$_selectedIcon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 35),
              Text(
                l10n.appName,
                style: text.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: Text(
                  _messages[_currentIndex],
                  key: ValueKey(_messages[_currentIndex]),
                  style: text.titleMedium?.copyWith(
                    color: text.bodyLarge?.color?.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                '© ColourSwift Technologies',
                style: text.bodySmall?.copyWith(
                  color: text.bodySmall?.color?.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}