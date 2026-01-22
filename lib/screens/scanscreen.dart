import 'package:flutter/material.dart';

enum ScanMode { none, smart, single, rapid, installed }
enum ScanState { idle, scanning, result, empty }

class DetectionResult {
  final String name;
  final String label;
  final double confidence;
  final List<String> signals;

  DetectionResult({
    required this.name,
    required this.label,
    required this.confidence,
    required this.signals,
  });
}

class ScanUiState {
  final ScanMode mode;
  final ScanState state;
  final int scanned;
  final int total;
  final String currentFile;
  final List<String> clean;
  final List<DetectionResult> infected;
  final List<String> logs;

  const ScanUiState({
    required this.mode,
    required this.state,
    required this.scanned,
    required this.total,
    required this.currentFile,
    required this.clean,
    required this.infected,
    required this.logs,
  });

  double get progress => total == 0 ? 0 : scanned / total;
}

class ScanUiScreen extends StatelessWidget {
  final ScanUiState state;
  final VoidCallback onCancel;
  final VoidCallback onFinish;

  const ScanUiScreen({
    super.key,
    required this.state,
    required this.onCancel,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (state.state) {
            ScanState.scanning => _buildScanning(theme, text),
            ScanState.result => _buildResult(theme, text),
            ScanState.empty => _buildEmpty(theme, text),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }

  Widget _buildScanning(ThemeData theme, TextTheme text) {
    final percent = (state.progress * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const Icon(Icons.shield_rounded, size: 64, color: Colors.greenAccent),
        const SizedBox(height: 24),
        Text(
          'Scanning... $percent%',
          style: text.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          state.currentFile,
          textAlign: TextAlign.center,
          style: text.bodySmall?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 20),
        LinearProgressIndicator(
          value: state.progress,
          minHeight: 6,
        ),
        const SizedBox(height: 20),
        Expanded(child: _logBox()),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: onCancel,
          icon: const Icon(Icons.close_rounded, color: Colors.redAccent),
          label: const Text(
            'Cancel Scan',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResult(ThemeData theme, TextTheme text) {
    final hasThreats = state.infected.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Icon(
            hasThreats ? Icons.warning_amber_rounded : Icons.verified_user_rounded,
            size: 64,
            color: hasThreats ? Colors.orangeAccent : Colors.greenAccent,
          ),
          const SizedBox(height: 25),
          Text(
            'Scan Complete',
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            hasThreats
                ? 'Suspicious: ${state.infected.length}'
                : 'Clean: ${state.clean.length}',
            style: text.bodyMedium?.copyWith(
              color: hasThreats ? Colors.orangeAccent : Colors.greenAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onFinish,
            child: const Text('Return Home'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme, TextTheme text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline_rounded, size: 60),
          const SizedBox(height: 20),
          Text(
            'No files to scan',
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onFinish,
            child: const Text('Return Home'),
          ),
        ],
      ),
    );
  }

  Widget _logBox() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: ListView.builder(
        itemCount: state.logs.length,
        itemBuilder: (context, i) {
          return Text(
            state.logs[i],
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          );
        },
      ),
    );
  }
}
