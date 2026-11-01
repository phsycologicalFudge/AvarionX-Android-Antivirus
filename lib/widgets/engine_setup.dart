import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/foreground_service.dart';
import '../utils/defs_manager.dart';
import 'antivirus_bridge.dart';

enum EngineSetupPhase { running, offline, unsupported, ready }

class EngineSetup {
  static bool _dialogOpen = false;

  static Future<EngineSetupPhase> run() async {
    if (engineState() == engineStateReady) return EngineSetupPhase.ready;
    final defsPath = await DefsManager.ensureLiteDefinitions();
    final code = await engineSetupAsync(defsPath);
    if (code == engineSetupOk) return EngineSetupPhase.ready;
    if (code == engineSetupOffline) return EngineSetupPhase.offline;
    await _notifyUnsupported();
    return EngineSetupPhase.unsupported;
  }

  static Future<void> _notifyUnsupported() async {
    final info = await PackageInfo.fromPlatform();
    final key = 'engine_unsupported_notified_${info.version}+${info.buildNumber}';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(key) == true) return;
    await prefs.setBool(key, true);
    await ForegroundService.notify(title: 'AvarionX', text: 'This app version is not supported');
  }

  static Future<void> ensureReady(BuildContext context) async {
    if (engineState() == engineStateReady || _dialogOpen) return;
    final phase = await EngineSetup.run().catchError((_) => EngineSetupPhase.offline);
    if (phase == EngineSetupPhase.ready) return;
    if (!context.mounted || _dialogOpen || engineState() == engineStateReady) return;
    _dialogOpen = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: _SetupFailureDialog(initialPhase: phase),
      ),
    );
    _dialogOpen = false;
  }
}

class _SetupFailureDialog extends StatefulWidget {
  final EngineSetupPhase initialPhase;

  const _SetupFailureDialog({required this.initialPhase});

  @override
  State<_SetupFailureDialog> createState() => _SetupFailureDialogState();
}

class _SetupFailureDialogState extends State<_SetupFailureDialog> {
  late EngineSetupPhase _phase = widget.initialPhase;
  bool _busy = false;

  Future<void> _retry() async {
    setState(() => _busy = true);
    final phase = await EngineSetup.run().catchError((_) => EngineSetupPhase.offline);
    if (!mounted) return;
    if (phase == EngineSetupPhase.ready) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _phase = phase;
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final offline = _phase == EngineSetupPhase.offline;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              offline ? Icons.wifi_off_rounded : Icons.gpp_bad_rounded,
              size: 40,
              color: scheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              offline ? 'No connection' : 'This app version is not supported',
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: scheme.onSurface),
              textAlign: TextAlign.center,
            ),
            if (offline) ...[
              const SizedBox(height: 8),
              Text(
                'Please check your internet connection. Internet is required once during setup.',
                style: text.bodySmall?.copyWith(color: scheme.onSurface.withOpacity(0.7), height: 1.3),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _busy ? null : _retry,
                  style: FilledButton.styleFrom(
                    elevation: 0,
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    surfaceTintColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _busy
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: scheme.onPrimary),
                        )
                      : const Text('Retry'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EngineSetupPanel extends StatefulWidget {
  final VoidCallback onReady;

  const EngineSetupPanel({super.key, required this.onReady});

  @override
  State<EngineSetupPanel> createState() => _EngineSetupPanelState();
}

class _EngineSetupPanelState extends State<EngineSetupPanel> {
  EngineSetupPhase _phase = EngineSetupPhase.running;

  @override
  void initState() {
    super.initState();
    _run();
  }

  void _retry() {
    setState(() => _phase = EngineSetupPhase.running);
    _run();
  }

  Future<void> _run() async {
    final phase = await EngineSetup.run().catchError((_) => EngineSetupPhase.offline);
    if (!mounted) return;
    setState(() => _phase = phase);
    if (phase == EngineSetupPhase.ready) widget.onReady();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    final (IconData icon, Color colour, String title, String? desc) = switch (_phase) {
      EngineSetupPhase.running => (Icons.shield_rounded, scheme.primary, 'Setting up engine...', null),
      EngineSetupPhase.ready => (Icons.verified_user_rounded, scheme.tertiary, 'Engine ready', null),
      EngineSetupPhase.offline => (
          Icons.wifi_off_rounded,
          scheme.error,
          'No connection',
          'Please check your internet connection. Internet is required once during setup.',
        ),
      EngineSetupPhase.unsupported => (Icons.gpp_bad_rounded, scheme.error, 'This app version is not supported', null),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 68, color: colour),
        const SizedBox(height: 16),
        Text(
          title,
          style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: scheme.onSurface),
          textAlign: TextAlign.center,
        ),
        if (desc != null) ...[
          const SizedBox(height: 10),
          Text(
            desc,
            style: text.bodyMedium?.copyWith(color: scheme.onSurface.withOpacity(0.78), height: 1.35),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 20),
        if (_phase == EngineSetupPhase.running)
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 3, color: scheme.primary),
          ),
        if (_phase == EngineSetupPhase.offline)
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _retry,
              style: FilledButton.styleFrom(
                elevation: 0,
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                surfaceTintColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Retry'),
            ),
          ),
      ],
    );
  }
}
