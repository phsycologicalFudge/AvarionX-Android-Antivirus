import 'package:AvarionX/rtp_logs.dart';
import 'package:AvarionX/settings_screen.dart';
import 'package:AvarionX/widgets/footer_nav.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'scan_screen.dart';
import 'quarantine/quarantine_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  String _active = 'home';
  Key _homeKey = UniqueKey();
  Key _rtpKey = UniqueKey();
  Key _quarantineKey = UniqueKey();

  int get _index {
    switch (_active) {
      case 'scan':
        return 1;
      case 'settings':
        return 4;
      case 'quarantine':
        return 2;
      case 'rtp':
        return 3;
      case 'home':
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          FooterNav(
            active: _active,
            onTabChange: (tab) {
              setState(() {
                _active = tab;
                if (tab == 'home') _homeKey = UniqueKey();
                if (tab == 'quarantine') _quarantineKey = UniqueKey();
                if (tab == 'rtp') _rtpKey = UniqueKey();
              });
            },
          ),
          Expanded(
            child: IndexedStack(
              index: _index,
              children: [
                AvHomeScreen(key: _homeKey),
                const ScanScreen(),
                QuarantineScreen(key: _quarantineKey),
                RtpLogsScreen(key: _rtpKey),
                const SettingsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
