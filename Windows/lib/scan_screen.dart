import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'scan_types.dart';
import '../services/headless_scan.dart';

class ScanScreen extends StatefulWidget {
  final ScanMode? startMode;
  final VoidCallback? onReturnHome;

  const ScanScreen({super.key, this.startMode, this.onReturnHome});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  HeadlessScanSession? _session;
  StreamSubscription? _sub;

  final List<String> _lines = [];
  final List<String> _pending = [];

  final ScrollController _logCtrl = ScrollController();
  Timer? _flushTimer;

  int _scanned = 0;
  int _total = 0;

  DateTime? _startedAt;
  String? _target;

  double get _progress {
    if (_total <= 0) return 0;
    final p = _scanned / _total;
    if (p < 0) return 0;
    if (p > 1) return 1;
    return p;
  }

  String get _eta {
    final s = _startedAt;
    if (s == null) return '';
    if (_total <= 0 || _scanned <= 0 || _scanned >= _total) return '';
    final elapsed = DateTime.now().difference(s).inSeconds;
    if (elapsed <= 0) return '';
    final rate = _scanned / elapsed;
    if (rate <= 0) return '';
    final remaining = ((_total - _scanned) / rate).round();
    if (remaining <= 0) return '';
    final m = remaining ~/ 60;
    final r = remaining % 60;
    if (m <= 0) return '${r}s';
    return '${m}m ${r}s';
  }

  @override
  void dispose() {
    _stop();
    _flushTimer?.cancel();
    _logCtrl.dispose();
    super.dispose();
  }

  void _scheduleFlush() {
    _flushTimer ??= Timer(const Duration(milliseconds: 120), () {
      _flushTimer = null;
      if (!mounted) return;

      if (_pending.isNotEmpty) {
        setState(() {
          _lines.addAll(_pending);
          _pending.clear();
          if (_lines.length > 300) {
            _lines.removeRange(0, _lines.length - 300);
          }
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_logCtrl.hasClients) return;
          _logCtrl.jumpTo(_logCtrl.position.maxScrollExtent);
        });
      }
    });
  }

  Future<void> _stop() async {
    try {
      _session?.cancel();
    } catch (_) {}
    try {
      await _sub?.cancel();
    } catch (_) {}
    _session = null;
    _sub = null;
  }

  Future<void> _start(String targetPath) async {
    await _stop();

    setState(() {
      _target = targetPath;
      _lines.clear();
      _pending.clear();
      _scanned = 0;
      _total = 0;
      _startedAt = DateTime.now();
    });

    final s = await HeadlessScanner.start(targetPath);
    _session = s;

    _sub = s.events.listen((e) {
      if (!mounted) return;

      if (e is ScanProgress) {
        _scanned = e.scanned;
        _total = e.total;
        setState(() {});
        return;
      }

      if (e is ScanLog) {
        if (e.message.isNotEmpty) {
          _pending.add(e.message);
          _scheduleFlush();
        }
        return;
      }

      if (e is ScanFailed) {
        _pending.add(e.message);
        _scheduleFlush();
        return;
      }

      if (e is ScanCompleted) {
        final hits = (e.result?['hits'] as Map?)?.length ?? 0;
        _pending.add('Completed, hits: $hits');
        if (_total > 0) _scanned = _total;
        _scheduleFlush();
        setState(() {});
      }
    });
  }

  Future<void> _pickAndScanFile() async {
    final res = await FilePicker.platform.pickFiles(allowMultiple: false);
    final path = res?.files.single.path;
    if (path == null || path.isEmpty) return;
    await _start(path);
  }

  Future<void> _pickAndScanFolder() async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path == null || path.isEmpty) return;
    await _start(path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final running = _session != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await _stop();
            if (!context.mounted) return;
            Navigator.of(context).pop();
            widget.onReturnHome?.call();
          },
        ),
        actions: [
          if (running)
            IconButton(
              onPressed: () async {
                await _stop();
                if (!mounted) return;
                setState(() {});
              },
              icon: const Icon(Icons.stop_rounded),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: running ? null : _pickAndScanFile,
                    icon: const Icon(Icons.insert_drive_file_rounded),
                    label: const Text('Scan file'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: running ? null : _pickAndScanFolder,
                    icon: const Icon(Icons.folder_rounded),
                    label: const Text('Scan folder'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surface.withOpacity(0.55),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((_target ?? '').isNotEmpty)
                    Text(
                      _target!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withOpacity(0.7),
                      ),
                    ),
                  if ((_target ?? '').isNotEmpty) const SizedBox(height: 8),
                  LinearProgressIndicator(value: running ? _progress : 0),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('$_scanned / $_total'),
                      const Spacer(),
                      if (_eta.isNotEmpty) Text('ETA: $_eta'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.surface.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: (_lines.isEmpty && _pending.isEmpty)
                    ? Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'No log yet.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withOpacity(0.65),
                    ),
                  ),
                )
                    : ListView.builder(
                  controller: _logCtrl,
                  itemCount: _lines.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        _lines[i],
                        style: theme.textTheme.bodySmall,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
