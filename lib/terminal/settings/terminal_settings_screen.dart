import 'package:flutter/material.dart';

import '../../screens/settings/widgets/settings_section_header.dart';
import '../../screens/settings/widgets/settings_setting_tile.dart';
import 'package:colourswift_av/widgets/av_header.dart';

class TerminalSettingsScreen extends StatelessWidget {
  const TerminalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AvHeader(
        title: 'Terminal Settings',
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          const SettingsSectionHeader(title: 'Terminal'),
          const SizedBox(height: 10),
          Opacity(
            opacity: 0.45,
            child: IgnorePointer(
              child: SettingsSettingTile(
                icon: Icons.tune_rounded,
                title: 'Coming soon',
                subtitle: 'Custom packages coming soon!',
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
