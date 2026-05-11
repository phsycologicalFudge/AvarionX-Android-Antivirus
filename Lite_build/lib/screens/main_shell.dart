import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'scan_ui_screen.dart';
import 'settings/settings_screen.dart';
import 'quarantine/quarantine_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  String _active = 'home';

  final GlobalKey<AvHomeScreenState> _homeKey = GlobalKey<AvHomeScreenState>();
  final GlobalKey<SettingsScreenState> _settingsKey = GlobalKey<SettingsScreenState>();
  Key _quarantineKey = UniqueKey();

  int get _index {
    switch (_active) {
      case 'scan':
        return 1;
      case 'quarantine':
        return 2;
      case 'settings':
        return 3;
      case 'home':
      default:
        return 0;
    }
  }

  void _setActiveTab(String tab) {
    setState(() {
      _active = tab;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: _index,
        children: [
          AvHomeScreen(key: _homeKey),
          const ScanScreen(),
          QuarantineScreen(key: _quarantineKey),
          SettingsScreen(key: _settingsKey),
        ],
      ),
    );
  }
}
