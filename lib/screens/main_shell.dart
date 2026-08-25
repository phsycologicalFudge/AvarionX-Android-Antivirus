import 'package:flutter/material.dart';
import 'explore tab/explore_screen.dart';
import 'home/home_screen.dart';
import 'scan/main_scan_ui/scan_screen.dart';
import 'settings/settings_screen.dart';
import 'quarantine/quarantine_screen.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  static _MainShellState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainShellState>();

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  String _active = 'home';

  final GlobalKey<AvHomeScreenState> _homeKey = GlobalKey<AvHomeScreenState>();
  final GlobalKey<SettingsScreenState> _settingsKey = GlobalKey<SettingsScreenState>();
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSub;
  Key _exploreKey = UniqueKey();
  Key _quarantineKey = UniqueKey();

  void _setActiveTab(String tab) {
    setState(() {
      _active = tab;
      if (tab == 'explore') _exploreKey = UniqueKey();
      if (tab == 'quarantine') _quarantineKey = UniqueKey();
    });

    if (tab == 'home') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _homeKey.currentState?.refresh();
      });
    }

    if (tab == 'settings') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _settingsKey.currentState?.refresh();
      });
    }
  }

  void goHome() => _setActiveTab('home');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  Widget _tab(String name, Widget child) {
    final visible = _active == name;
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      child: IgnorePointer(
        ignoring: !visible,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _tab('home', AvHomeScreen(key: _homeKey)),
          _tab('scan', const ScanScreen()),
          _tab('explore', ExploreScreen(key: _exploreKey)),
          _tab('quarantine', QuarantineScreen(key: _quarantineKey)),
          _tab('settings', SettingsScreen(key: _settingsKey)),
        ],
      ),
    );
  }
}