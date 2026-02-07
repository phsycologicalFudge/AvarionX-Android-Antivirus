import 'package:flutter/material.dart';
import '../widgets/footer_nav.dart';
import 'explore tab/explore_screen.dart';
import 'home_screen.dart';
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
  Key _homeKey = UniqueKey();
  Key _exploreKey = UniqueKey();
  Key _quarantineKey = UniqueKey();

  final GlobalKey<SettingsScreenState> _settingsKey = GlobalKey<SettingsScreenState>();

  int get _index {
    switch (_active) {
      case 'scan':
        return 1;
      case 'explore':
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
          ExploreScreen(key: _exploreKey),
          QuarantineScreen(key: _quarantineKey),
          SettingsScreen(key: _settingsKey),
        ],
      ),
      bottomNavigationBar: FooterNav(
        active: _active,
        onTabChange: (tab) {
          setState(() {
            _active = tab;
            if (tab == 'home') _homeKey = UniqueKey();
            if (tab == 'explore') _exploreKey = UniqueKey();
            if (tab == 'quarantine') _quarantineKey = UniqueKey();
          });

          if (tab == 'settings') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _settingsKey.currentState?.refresh();
            });
          }
        },

      ),
    );
  }
}
