import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:AvarionX/quarantine/quarantine_screen.dart';
import 'package:AvarionX/rtp_logs.dart';
import 'package:AvarionX/scan_types.dart';
import 'package:flutter/material.dart';
import '../scan_screen.dart';
import 'services/rtp_service.dart';

class AvHomeScreen extends StatelessWidget {
  const AvHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Home',
              style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 520,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _RtpToggleRow(),
                        const SizedBox(height: 12),
                        _NavRow(
                          icon: Icons.search_rounded,
                          title: 'Scan',
                          subtitle: 'Run a smart scan.',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ScanScreen(
                                  startMode: ScanMode.smart,
                                  onReturnHome: () {},
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _NavRow(
                          icon: Icons.warning_amber_rounded,
                          title: 'Quarantine',
                          subtitle: 'View detected threats.',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const QuarantineScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _NavRow(
                          icon: Icons.receipt_long_rounded,
                          title: 'Realtime logs',
                          subtitle: 'Open the full event log.',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RtpLogsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  const Expanded(
                    child: _HomeLiveLogPanel(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surface.withOpacity(0.55),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: cs.primary, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: cs.onSurface.withOpacity(0.45)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RtpToggleRow extends StatefulWidget {
  const _RtpToggleRow();

  @override
  State<_RtpToggleRow> createState() => _RtpToggleRowState();
}

class _RtpToggleRowState extends State<_RtpToggleRow> {
  bool _enabled = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final r = await RtpService.refreshRunning();
    if (!mounted) return;
    setState(() => _enabled = r);
  }

  Future<void> _setEnabled(bool v) async {
    if (_busy) return;
    setState(() => _busy = true);

    try {
      if (v) {
        await RtpService.start();
      } else {
        await RtpService.stop();
      }
      setState(() => _enabled = RtpService.isRunning);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: cs.surface.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield_rounded,
            size: 22,
            color: _enabled ? cs.primary : cs.onSurface.withOpacity(0.55),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Realtime Protection',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  _enabled ? 'Enabled' : 'Disabled',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withOpacity(0.65),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _enabled,
            onChanged: _busy ? null : _setEnabled,
          ),
        ],
      ),
    );
  }
}

class _HomeLiveLogPanel extends StatefulWidget {
  const _HomeLiveLogPanel();

  @override
  State<_HomeLiveLogPanel> createState() => _HomeLiveLogPanelState();
}

class _HomeLiveLogPanelState extends State<_HomeLiveLogPanel> {
  Timer? _timer;
  static const _refreshInterval = Duration(seconds: 2);

  String? _watching;
  final List<_ProcLine> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(_refreshInterval, (_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final exeDir = File(Platform.resolvedExecutable).parent.path;
    final logFile = File('$exeDir/rtp_logs/rtp_main.log');

    final next = <_ProcLine>[];
    String? nextWatching;

    try {
      if (logFile.existsSync()) {
        final lines = const LineSplitter().convert(logFile.readAsStringSync());
        for (final raw in lines) {
          final line = raw.trim();
          if (line.isEmpty) continue;

          final msg = _stripBracketPrefix(line);

          if (msg.startsWith('watching:')) {
            final p = msg.substring('watching:'.length).trim();
            if (p.isNotEmpty) nextWatching = p;
            continue;
          }

          if (!(line.startsWith('{') && line.endsWith('}'))) continue;

          try {
            final obj = jsonDecode(line);
            if (obj is! Map<String, dynamic>) continue;
            if ((obj['type'] as String?) != 'proc_snapshot') continue;

            final time = (obj['time'] as String?) ?? '';
            final procs = obj['processes'];
            if (procs is List) {
              for (final p in procs) {
                if (p is! Map) continue;
                final name = (p['name'] as String?)?.trim() ?? '';
                if (name.isEmpty) continue;
                next.add(_ProcLine(time: time, name: name));
              }
            }
          } catch (_) {}
        }
      }
    } catch (_) {}

    final seen = <String>{};
    final dedup = <_ProcLine>[];
    for (final e in next.reversed) {
      final k = e.name.toLowerCase();
      if (seen.contains(k)) continue;
      seen.add(k);
      dedup.add(e);
      if (dedup.length >= 18) break;
    }

    if (!mounted) return;
    setState(() {
      _watching = nextWatching;
      _items
        ..clear()
        ..addAll(dedup);
    });
  }

  static String _stripBracketPrefix(String line) {
    if (!line.startsWith('[')) return line.trim();
    final j = line.indexOf(']');
    if (j == -1) return line.trim();
    return line.substring(j + 1).trim();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Live activity',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              Icon(Icons.circle, size: 8, color: cs.primary.withOpacity(0.8)),
              const SizedBox(width: 6),
              Text(
                'Live',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.primary.withOpacity(0.85),
                ),
              ),
            ],
          ),
          if ((_watching ?? '').isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Watching: $_watching',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.65)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 10),
          Expanded(
            child: _items.isEmpty
                ? Align(
              alignment: Alignment.topLeft,
              child: Text(
                'No named processes yet.',
                style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.65)),
              ),
            )
                : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, i) {
                final it = _items[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.apps_rounded, size: 16, color: cs.onSurface.withOpacity(0.75)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          it.name,
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (it.time.isNotEmpty)
                        Text(
                          it.time,
                          style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.6)),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcLine {
  final String time;
  final String name;

  const _ProcLine({required this.time, required this.name});
}
