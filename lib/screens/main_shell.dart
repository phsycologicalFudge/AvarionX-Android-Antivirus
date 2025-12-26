import 'package:flutter/material.dart';
import '../widgets/footer_nav.dart';
import 'terminal_screen.dart';
import 'home_screen.dart';
import 'scan_screen.dart';
import 'settings/settings_screen.dart';
import 'quarantine/quarantine_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  String _active = 'home';
  Key _homeKey = UniqueKey();
  Key _quarantineKey = UniqueKey();

  int get _index {
    switch (_active) {
      case 'scan':
        return 1;
      case 'terminal':
        return 2;
      case 'quarantine':
        return 3;
      case 'settings':
        return 4;
      case 'home':
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          AvHomeScreen(key: _homeKey),
          const ScanScreen(),
          const ConsoleScreen(),
          QuarantineScreen(key: _quarantineKey),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: FooterNav(
        active: _active,
        onTabChange: (tab) {
          setState(() {
            _active = tab;
            if (tab == 'home') {
              _homeKey = UniqueKey();
            }
            if (tab == 'quarantine') {
              _quarantineKey = UniqueKey();
            }
          });
        },
      ),
    );
  }
}

