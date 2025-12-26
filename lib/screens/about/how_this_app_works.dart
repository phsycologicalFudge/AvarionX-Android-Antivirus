import 'package:flutter/material.dart';

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
              'How CS Security Works',
              style: text.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'CS Security is powered by VX-Titanium, a custom antivirus engine designed to provide strong core protection while keeping your data private. '
                  'All file scanning happens locally on your device, without tracking, profiling, or exporting your files.',
              style: text.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Core Principles',
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('• On-device scanning with no telemetry'),
            const Text('• Real-time protection for files and network'),
            const Text('• Lightweight and battery-conscious design'),
            const SizedBox(height: 20),
            Text(
              'Why is CS Security free?',
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'CS Security is free so that everyone can access essential protection without barriers. ',
              style: text.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
