import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class RtpLogsScreen extends StatefulWidget {
  const RtpLogsScreen({super.key});

  @override
  State<RtpLogsScreen> createState() => _RtpLogsScreenState();
}

class _RtpLogsScreenState extends State<RtpLogsScreen> {
  bool _loading = true;
  Timer? _timer;

  static const _refreshInterval = Duration(seconds: 2);

  String? _readError;
  String? _watchingPath;

  final List<_NameEvent> _feed = [];
  final List<_NameEvent> _detections = [];

  @override
  void initState() {
    super.initState();
    _loadLogs(initial: true);
    _timer = Timer.periodic(_refreshInterval, (_) => _loadLogs(initial: false));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadLogs({required bool initial}) async {
    if (initial) {
      setState(() {
        _loading = true;
      });
    }

    final exeDir = File(Platform.resolvedExecutable).parent.path;
    final logsDir = Directory('$exeDir/rtp_logs');
    final logFile = File('${logsDir.path}/rtp_main.log');

    String? nextError;
    String? nextWatching;

    final nextFeed = <_NameEvent>[];
    final nextDetections = <_NameEvent>[];

    try {
      if (!logFile.existsSync()) {
        nextError = 'Missing file';
      } else {
        final lines = const LineSplitter().convert(logFile.readAsStringSync());
        for (final raw in lines) {
          final line = raw.trim();
          if (line.isEmpty) continue;

          final time = _extractBracketTime(line);
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

            final type = (obj['type'] as String?) ?? '';
            if (type != 'proc_snapshot') continue;

            final stage = (obj['stage'] as String?) ?? '';
            if (stage != 'baseline' && stage != 'live' && stage.isNotEmpty) {}

            final timeFromJson = (obj['time'] as String?) ?? time;
            final procs = obj['processes'];
            if (procs is List) {
              for (final p in procs) {
                if (p is! Map) continue;
                final name = (p['name'] as String?)?.trim() ?? '';
                if (name.isEmpty) continue;
                nextFeed.add(_NameEvent(time: timeFromJson, name: name));
              }
            }
          } catch (_) {}
        }
      }
    } catch (_) {
      nextError = 'Failed to read';
    }

    try {
      final detDir = Directory('${logsDir.path}/detections');
      if (detDir.existsSync()) {
        final files = detDir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.json'))
            .toList()
          ..sort((a, b) => b.path.compareTo(a.path));

        for (final f in files) {
          try {
            final obj = jsonDecode(f.readAsStringSync());
            if (obj is! Map<String, dynamic>) continue;
            final name = (obj['name'] as String?)?.trim() ?? '';
            final time = (obj['time'] as String?)?.trim() ?? '';
            if (name.isEmpty) continue;
            nextDetections.add(_NameEvent(time: time, name: name));
          } catch (_) {}
        }
      }
    } catch (_) {}

    if (!mounted) return;

    final dedupFeed = _dedupByNameKeepingLatest(nextFeed);
    final dedupDet = _dedupByNameKeepingLatest(nextDetections);

    setState(() {
      _readError = nextError;
      _watchingPath = nextWatching;
      _feed
        ..clear()
        ..addAll(dedupFeed.take(120));
      _detections
        ..clear()
        ..addAll(dedupDet.take(80));
      _loading = false;
    });
  }

  static List<_NameEvent> _dedupByNameKeepingLatest(List<_NameEvent> items) {
    final seen = <String, _NameEvent>{};
    for (final e in items.reversed) {
      final key = e.name.toLowerCase();
      if (!seen.containsKey(key)) seen[key] = e;
    }
    final out = seen.values.toList();
    out.sort((a, b) => b.time.compareTo(a.time));
    return out;
  }

  static String _extractBracketTime(String line) {
    if (!line.startsWith('[')) return '';
    final j = line.indexOf(']');
    if (j <= 1) return '';
    return line.substring(1, j).trim();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Realtime Protection Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadLogs(initial: false),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FlatHeader(
                    title: 'Live activity',
                    subtitle: _readError == null
                        ? (_watchingPath == null ? '' : 'Watching: $_watchingPath')
                        : 'Log unavailable',
                    bad: _readError != null,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _feed.isEmpty
                        ? _FlatPanel(
                      child: Text(
                        'No named process events yet.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(0.7),
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: _feed.length,
                      itemBuilder: (context, i) => _NameRow(
                        time: _feed[i].time,
                        name: _feed[i].name,
                        icon: Icons.apps_rounded,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FlatHeader(
                    title: 'Detections',
                    subtitle: '',
                    bad: false,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _detections.isEmpty
                        ? _FlatPanel(
                      child: Text(
                        'No detections.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(0.7),
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: _detections.length,
                      itemBuilder: (context, i) => _NameRow(
                        time: _detections[i].time,
                        name: _detections[i].name,
                        icon: Icons.warning_amber_rounded,
                      ),
                    ),
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

class _FlatHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool bad;

  const _FlatHeader({
    required this.title,
    required this.subtitle,
    required this.bad,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.65)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        Text(
          bad ? 'ERROR' : 'OK',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: bad ? cs.error : cs.primary,
          ),
        ),
      ],
    );
  }
}

class _FlatPanel extends StatelessWidget {
  final Widget child;

  const _FlatPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _NameRow extends StatelessWidget {
  final String time;
  final String name;
  final IconData icon;

  const _NameRow({
    required this.time,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final t = time.isEmpty ? '' : time;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cs.surface.withOpacity(0.55),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: cs.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (t.isNotEmpty)
              Text(
                t,
                style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.6)),
              ),
          ],
        ),
      ),
    );
  }
}

class _NameEvent {
  final String time;
  final String name;

  const _NameEvent({required this.time, required this.name});
}
