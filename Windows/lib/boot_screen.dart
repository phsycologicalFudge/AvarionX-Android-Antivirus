import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../services/av_engine.dart';
import '../utils/defs_manager.dart';
import '../services/theme_manager.dart';
import 'main_shell.dart';

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen>
    with TickerProviderStateMixin {

  late final AnimationController _pulseController;
  late final AnimationController _fadeOutController;
  late final Timer _textTimer;

  int _currentIndex = 0;

  final List<String> _messages = [
    'Preparing protection...',
    'Loading definitions...',
    'Initializing engine...',
    'Optimizing memory...',
    'Starting services...',
  ];

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

    _textTimer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (!mounted) return;
        setState(() {
          _currentIndex =
              (_currentIndex + 1) % _messages.length;
        });
      },
    );

    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 1));

    await DefsManager.ensureLiteDefinitions();
    await AvEngine.ensureInitialized();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const MainShell(),
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
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final themeName = context.watch<ThemeManager>().themeName;

    final logo = (themeName == 'white' || themeName == 'emerald')
        ? 'assets/images/logo_light.png'
        : 'assets/images/logo_dark.png';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: Tween<double>(begin: 1, end: 0)
            .animate(_fadeOutController),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (_, __) {
                  final scale =
                      1.0 + (_pulseController.value * 0.05);
                  return Transform.scale(
                    scale: scale,
                    child: ClipOval(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset(
                          logo,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 35),

              Text(
                'AVarionX Security',
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
                    FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                child: Text(
                  _messages[_currentIndex],
                  key: ValueKey(_messages[_currentIndex]),
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: text.bodyLarge?.color?.withOpacity(0.9),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Text(
                '© ColourSwift Technologies',
                style: text.bodySmall?.copyWith(
                  color:
                  text.bodySmall?.color?.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
