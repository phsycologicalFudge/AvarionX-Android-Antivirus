import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/antivirus_bridge.dart';
import '../../translations/app_localizations.dart';

class ScanLimitsScreen extends StatefulWidget {
  const ScanLimitsScreen({super.key});

  @override
  State<ScanLimitsScreen> createState() => _ScanLimitsScreenState();
}

class _ScanLimitsScreenState extends State<ScanLimitsScreen> {
  static const _kMaxConcurrentKey = 'scan_limits_max_concurrent';
  static const _kMaxThreadsKey = 'scan_limits_max_threads';

  bool _loading = true;

  int _maxConcurrent = 1;
  int _maxThreads = 0;

  late final int _coreCount;
  late final int _maxThreadsUiCap;

  final _concurrentController = TextEditingController();
  final _threadsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _coreCount = Platform.numberOfProcessors < 1 ? 1 : Platform.numberOfProcessors;
    _maxThreadsUiCap = _coreCount;
    _load();
  }

  @override
  void dispose() {
    _concurrentController.dispose();
    _threadsController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final mc = prefs.getInt(_kMaxConcurrentKey) ?? 1;
    final mt = prefs.getInt(_kMaxThreadsKey) ?? 0;

    _maxConcurrent = _clampMaxConcurrent(mc);
    _maxThreads = _clampMaxThreads(mt);

    _concurrentController.text = _maxConcurrent.toString();
    _threadsController.text = _maxThreads.toString();

    if (!mounted) return;
    setState(() => _loading = false);
  }

  int _parseInt(String s, int fallback) {
    final v = int.tryParse(s.trim());
    return v ?? fallback;
  }

  int _clampMaxConcurrent(int v) {
    if (v < 1) return 1;
    if (v > 4) return 4;
    return v;
  }

  int _clampMaxThreads(int v) {
    if (v < 0) return 0;
    if (v > _maxThreadsUiCap) return _maxThreadsUiCap;
    return v;
  }

  Future<void> _save() async {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final mc = _clampMaxConcurrent(
        _parseInt(_concurrentController.text, _maxConcurrent));
    final mt = _clampMaxThreads(
        _parseInt(_threadsController.text, _maxThreads));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kMaxConcurrentKey, mc);
    await prefs.setInt(_kMaxThreadsKey, mt);

    try {
      AntivirusBridge().setScanLimits(mc, mt);
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      _maxConcurrent = mc;
      _maxThreads = mt;
      _concurrentController.text = mc.toString();
      _threadsController.text = mt.toString();
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: const Text(
          'Settings updated',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _cardRow({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.16),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface.withOpacity(0.88),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: text.bodySmall?.copyWith(
                      height: 1.35,
                      color: text.bodySmall?.color?.withOpacity(0.72),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _numberField({
    required TextEditingController controller,
    required String hint,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 92,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w800),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHigh,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'Scan limits',
          style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: _loading
            ? Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        )
            : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card.outlined(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.16),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Limit how much the engine uses your CPU. Threads: 0 means auto.',
                          style: text.bodySmall?.copyWith(
                            height: 1.35,
                            color: text.bodySmall?.color?.withOpacity(0.72),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _cardRow(
                icon: Icons.speed_rounded,
                color: theme.colorScheme.tertiary,
                title: 'Max scan threads',
                subtitle: '0 = auto. Range: 0 to $_maxThreadsUiCap (cores: $_coreCount).',
                trailing: _numberField(
                  controller: _threadsController,
                  hint: _maxThreads.toString(),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_rounded, size: 18),
                  label: Text(l10n.ok),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
