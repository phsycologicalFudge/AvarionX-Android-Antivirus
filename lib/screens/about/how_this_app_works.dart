import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HowThisAppWorksScreen extends StatelessWidget {
  const HowThisAppWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'How This App Works',
          style: text.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: text.bodyLarge?.color,
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        centerTitle: true,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              'How AvarionX Works',
              style: text.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'AvarionX is a mobile security app that combines on device antivirus scanning, network protection, and optional VPN features. '
                  'The antivirus engine is powered by VX-Titanium.',
              style: text.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'If you use network protection or VPN features, the app connects to ColourSwift services to apply your settings, manage your account access, and route protected traffic.',
              style: text.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Key Features',
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('• Real-time protection for downloaded threats'),
            const Text('• Network protection with DNS filtering'),
            const Text('• Optional Secure VPN mode'),
            const Text('• Built in tools such as Link Checker'),
            const SizedBox(height: 20),
            Text(
              'Notes',
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Some features may require sign in, an active plan, or device permissions to work properly.',
              style: text.bodyMedium,
            ),
            const SizedBox(height: 12),
            Center(
              child: SvgPicture.asset(
                'assets/illustrations/thumbs_up_stickman.svg',
                width: 84,
                height: 84,
              ),
            ),
          ],
        ),
      ),
    );
  }
}