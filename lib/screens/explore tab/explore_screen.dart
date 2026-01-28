import 'package:colourswift_av/screens/password%20manager/password_manager_screen.dart';
import 'package:colourswift_av/screens/scan/cleaner_screen.dart';
import 'package:colourswift_av/screens/vpn/NetworkProtectionScreen.dart';
import 'package:flutter/material.dart';

import '../link checker/link_check_screen.dart';
import '../terminal_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = <_ExploreItem>[
      _ExploreItem(
        title: 'Network Protection',
        icon: Icons.public_rounded,
        builder: (_) => const NetworkProtectionScreen(),
      ),
      _ExploreItem(
        title: 'Link Checker',
        icon: Icons.link_rounded,
        builder: (_) => const LinkCheckScreen(),
      ),
      _ExploreItem(
        title: 'MetaPass',
        icon: Icons.key_rounded,
        builder: (_) => const PasswordTestScreen(),
      ),
      _ExploreItem(
        title: 'Cleaner Pro',
        icon: Icons.cleaning_services_rounded,
        builder: (_) => const CleanerScreen(),
      ),
      _ExploreItem(
        title: 'Terminal',
        icon: Icons.terminal_rounded,
        builder: (_) => const ConsoleScreen(isActive: true),
      ),
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surface,
      ),
      body: ListView(
        children: [
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: items.map((item) {
                  return ListTile(
                    leading: Icon(
                      item.icon,
                      color: theme.colorScheme.onSurface.withOpacity(0.9),
                    ),
                    title: Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: theme.colorScheme.onSurface.withOpacity(0.55),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: item.builder),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreItem {
  final String title;
  final IconData icon;
  final WidgetBuilder builder;

  const _ExploreItem({
    required this.title,
    required this.icon,
    required this.builder,
  });
}
