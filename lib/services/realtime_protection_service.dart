import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:io';
import 'package:colourswift_av/services/scan%20api/headless_scan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/scan_ui_screen.dart';
import '../utils/exclusions_store.dart';
import '../widgets/antivirus_bridge.dart';
import 'av_engine.dart';
import 'cloud_helper_service.dart';
import 'foreground_service.dart';
import 'quarantine_service.dart';
import 'package:crypto/crypto.dart';

bool scanFileIsolate(String path) {
  try {
    final bridge = AntivirusBridge();
    final res = bridge.scanFile(path);
    final decoded = jsonDecode(res);
    final hits = decoded['hits'] as Map?;
    return hits != null && hits.isNotEmpty;
  } catch (_) {
    return false;
  }
}

class RealtimeProtectionService {
  static bool _running = false;
  static Map<String, int> _seen = {};
  static StreamSubscription? _eventSub;
  static Timer? _shizukuLoop;
  static bool _watcherRunning = false;
  static Timer? _scheduledScanTimer;
  static bool _scheduledScanRunning = false;
  static RootIsolateToken? _rootToken;
  static const MethodChannel _fgChannel = MethodChannel('colourswift/foreground_service');
  static bool _fgHandlerAttached = false;
  static Isolate? _scheduledIso;
  static ReceivePort? _scheduledIsoPort;
  static SendPort? _scheduledCmd;
  static bool _scheduledCancelRequested = false;
  static final CloudScanner _cloud = CloudScanner(
    endpoint: 'https://efkou1u21ooih2hko.colourswift.com',
    apiKey: '23JVO3ojo23oO3O423rrTR',
  );

  static const _eventChannel = EventChannel('colourswift/realtime_stream');
  static const EventChannel _watcherStateChannel = EventChannel('colourswift/watcher_state');
  static StreamSubscription? _watcherStateSub;

  static const MethodChannel _watcherChannel = MethodChannel('colourswift/system_watcher');

  static const _allowed = {
    'com', 'apk', 'zip', 'rar', '7z', 'pdf', 'txt', 'md', 'json', 'exe'
  };
  static const _skip = {
    'mp3', 'mp4', 'm4a', 'mov', 'jpg', 'png', 'jpeg', 'heic', 'webp'
  };
  static const _maxSize = 100 * 1024 * 1024;

  static Future<void> _reconcileShizuku() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool('shizuku_enabled') ?? false;

      if (!enabled) {
        if (_watcherRunning) {
          await _watcherChannel.invokeMethod('stop');
          _watcherRunning = false;
        }
        return;
      }

      if (!_watcherRunning) {
        await _watcherChannel.invokeMethod('start');
        _watcherRunning = true;
      }
    } catch (_) {
      if (_watcherRunning) {
        try {
          await _watcherChannel.invokeMethod('stop');
        } catch (_) {}
        _watcherRunning = false;
      }
    }
  }

  static void _attachWatcherStateStream() {
    if (_watcherStateSub != null) return;

    _watcherStateSub = _watcherStateChannel.receiveBroadcastStream().listen((event) async {
      final alive = event == true;
      if (!alive) {
        _watcherRunning = false;
        await _reconcileShizuku();
      }
    }, onError: (_) {});
  }

  static Future<void> start() async {
    if (_running) return;
    _running = true;
    _rootToken ??= RootIsolateToken.instance;

    await _loadIndex();
    await ExclusionsStore.instance.init();
    await AvEngine.ensureInitialized();
    await ForegroundService.start(title: 'AVarionX', text: 'Protection active');
    if (!_fgHandlerAttached) {
      _fgHandlerAttached = true;
      _fgChannel.setMethodCallHandler((call) async {
        if (call.method == 'cancelScheduledScan') {
          await cancelScheduledScan();
        }
      });
    }
    await _startScheduledScans();

    await _reconcileShizuku();
    _attachWatcherStateStream();

    _shizukuLoop = Timer.periodic(
      const Duration(seconds: 2),
          (_) => _reconcileShizuku(),
    );

    _eventSub = _eventChannel.receiveBroadcastStream().listen(
          (dynamic event) async {
        if (event is! String) return;
        final name = p.basename(event);
        if (name.startsWith('.pending-')) return;
        await _scanSingleFile(event);
      },
      onError: (_) {},
    );
  }

  static Future<void> stop() async {
    try {
      await _watcherChannel.invokeMethod('stop');
    } catch (_) {}

    await _eventSub?.cancel();
    await _watcherStateSub?.cancel();
    _watcherStateSub = null;
    _eventSub = null;
    _running = false;
    _shizukuLoop?.cancel();
    _shizukuLoop = null;
    _scheduledScanTimer?.cancel();
    _scheduledScanTimer = null;
    await _saveIndex();
    await ForegroundService.stop();
  }

  static Future<void> _startScheduledScans() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('scheduled_scan_enabled') ?? true;
    if (!enabled) return;

    final intervalHours = prefs.getInt('scheduled_scan_hours') ?? 168;

    _scheduledScanTimer?.cancel();
    _scheduledScanTimer = Timer.periodic(
      Duration(hours: intervalHours),
          (_) => _runScheduledScan(),
    );

    unawaited(_runScheduledScan());
  }

  static Future<void> _runScheduledScan() async {
    if (_scheduledScanRunning) return;
    _scheduledScanRunning = true;

    try {
      await ForegroundService.showScanOngoing(
        title: 'Scheduled scan running',
        text: 'Starting...',
      );

      final prefs = await SharedPreferences.getInstance();
      final useCloud = prefs.getBool('useCloudScan') ?? false;
      final mode = _scheduledModeFromPrefs(prefs);
      final token = _rootToken;

      final rp = ReceivePort();
      _scheduledIsoPort?.close();
      _scheduledIsoPort = rp;

      _scheduledCmd = null;

      _scheduledIso = await Isolate.spawn(
        _scheduledScanEntry,
        {
          'send': rp.sendPort,
          'useCloud': useCloud,
          'token': token,
          'mode': mode.index,
        },
        debugName: 'scheduled_scan',
      );

      int lastScanned = 0;
      int quarantined = 0;
      int quarantineFailed = 0;

      await for (final msg in rp) {
        if (msg is! Map) continue;

        final t = msg['t'];

        if (t == 'ready') {
          final cmd = msg['cmd'];
          if (cmd is SendPort) {
            _scheduledCmd = cmd;
            if (_scheduledCancelRequested) {
              try {
                _scheduledCmd?.send({'t': 'cancel'});
              } catch (_) {}
            }
          }
          continue;
        }

        if (t == 'progress') {
          final scanned = (msg['scanned'] as int?) ?? lastScanned;
          lastScanned = scanned;
          await ForegroundService.updateScanOngoing(
            text: 'Scanning... $scanned files',
          );
          continue;
        }

        if (t == 'hit') {
          final path = msg['path'];
          if (path is String && path.isNotEmpty) {
            try {
              await QuarantineService.quarantineFile(path);
              quarantined++;
            } catch (_) {
              quarantineFailed++;
            }
          }
          continue;
        }

        if (t == 'done') {
          final threats = (msg['threats'] as int?) ?? 0;
          final cancelled = msg['cancelled'] == true;

          await ForegroundService.hideScanOngoing();

          if (cancelled) {
            await ForegroundService.notify(
              title: 'Scheduled Scan',
              text: 'Cancelled',
            );
          } else {
            final text = quarantined > 0
                ? (quarantineFailed > 0
                ? '$quarantined quarantined, $quarantineFailed failed'
                : '$quarantined quarantined')
                : (threats > 0 ? '$threats detected, quarantine failed' : 'No threats detected');

            await ForegroundService.notify(
              title: 'Scheduled Scan Complete',
              text: text,
            );
          }

          break;
        }

        if (t == 'err') {
          final msgText = (msg['message'] as String?) ?? 'Scan failed to complete';
          await ForegroundService.hideScanOngoing();
          await ForegroundService.notify(
            title: 'Scheduled Scan',
            text: msgText,
          );
          break;
        }
      }
    } catch (_) {
      try {
        await ForegroundService.hideScanOngoing();
      } catch (_) {}
      await ForegroundService.notify(
        title: 'Scheduled Scan',
        text: 'Scan failed to complete',
      );
    } finally {
      _scheduledCmd = null;
      _scheduledCancelRequested = false;

      try {
        _scheduledIsoPort?.close();
      } catch (_) {}
      _scheduledIsoPort = null;

      try {
        _scheduledIso?.kill(priority: Isolate.immediate);
      } catch (_) {}
      _scheduledIso = null;

      _scheduledScanRunning = false;
    }
  }

  static ScanMode _scheduledModeFromPrefs(SharedPreferences prefs) {
    final raw = (prefs.getString('scheduled_scan_mode') ?? 'smart').toLowerCase();
    switch (raw) {
      case 'full':
        return ScanMode.full;
      case 'installed':
        return ScanMode.installed;
      case 'rapid':
        return ScanMode.rapid;
      case 'single':
        return ScanMode.single;
      default:
        return ScanMode.smart;
    }
  }

  static Future<bool> _waitUntilStable(
      File f, {
        Duration timeout = const Duration(seconds: 6),
        Duration poll = const Duration(milliseconds: 250),
      }) async {
    final deadline = DateTime.now().add(timeout);
    int? lastSig;
    int stableHits = 0;
    while (DateTime.now().isBefore(deadline)) {
      if (!await f.exists()) return false;
      final stat = await f.stat();
      final sig = stat.size ^ stat.modified.millisecondsSinceEpoch;
      if (lastSig != null && sig == lastSig) {
        stableHits++;
        if (stableHits >= 2) return true;
      } else {
        stableHits = 0;
        lastSig = sig;
      }
      await Future.delayed(poll);
    }
    return false;
  }

  static Future<void> cancelScheduledScan() async {
    if (!_scheduledScanRunning) return;

    _scheduledCancelRequested = true;

    try {
      _scheduledCmd?.send({'t': 'cancel'});
    } catch (_) {}

    try {
      _scheduledIso?.kill(priority: Isolate.immediate);
    } catch (_) {}

    try {
      _scheduledIsoPort?.close();
    } catch (_) {}

    try {
      await ForegroundService.hideScanOngoing();
    } catch (_) {}

    try {
      await ForegroundService.notify(
        title: 'Scheduled Scan',
        text: 'Cancelled',
      );
    } catch (_) {}
  }

  static Future<void> _scanSingleFile(String path) async {
    try {
      final f = File(path);
      if (!await f.exists()) return;
      if (ExclusionsStore.instance.isExcluded(path)) return;

      final ext = p.extension(path).replaceFirst('.', '').toLowerCase();
      if (_skip.contains(ext)) return;
      if (_allowed.isNotEmpty && !_allowed.contains(ext)) return;

      final size = await f.length();
      if (size <= 0 || size > _maxSize) return;

      final mtime = (await f.lastModified()).millisecondsSinceEpoch;
      final seenMtime = _seen[path];
      if (seenMtime != null && mtime <= seenMtime) return;

      await Future.delayed(const Duration(milliseconds: 180));

      final bytes = await f.readAsBytes();
      final sha = sha256.convert(bytes).toString();

      final cloudHit = await _cloud.checkBatch([sha]);
      if (cloudHit.contains(sha)) {
        if (!ExclusionsStore.instance.isExcluded(path)) {
          await _handleDetection(path);
        }
        _seen[path] = mtime;
        await _saveIndex();
        return;
      }

      final infected = await compute(scanFileIsolate, path);
      if (infected) {
        if (!ExclusionsStore.instance.isExcluded(path)) {
          await _handleDetection(path);
        }
      }

      _seen[path] = mtime;
      await _saveIndex();
    } catch (_) {}
  }

  static Future<void> _handleDetection(String path) async {
    try {
      await QuarantineService.quarantineFile(path);
      await ForegroundService.notify(
        title: 'Threat Detected',
        text: 'A file was quarantined: ${path.split('/').last}',
      );
    } catch (_) {
      await ForegroundService.notify(
        title: 'Threat Detected',
        text: 'Failed to quarantine: ${path.split('/').last}',
      );
    }
  }

  static Future<File> _indexFile() async {
    final dir = await getApplicationSupportDirectory();
    final f = File('${dir.path}/rt_seen.json');
    if (!await f.exists()) await f.create(recursive: true);
    return f;
  }

  static Future<void> _loadIndex() async {
    try {
      final f = await _indexFile();
      final s = await f.readAsString();
      if (s.isEmpty) return;
      final m = jsonDecode(s) as Map<String, dynamic>;
      _seen = m.map((k, v) => MapEntry(k, (v as num).toInt()));
    } catch (_) {
      _seen = {};
    }
  }

  static Future<void> _saveIndex() async {
    try {
      final f = await _indexFile();
      await f.writeAsString(jsonEncode(_seen));
    } catch (_) {}
  }
}

@pragma('vm:entry-point')
Future<void> _scheduledScanEntry(Map<String, dynamic> args) async {
  final SendPort send = args['send'] as SendPort;
  final bool useCloud = args['useCloud'] == true;
  final RootIsolateToken? token = args['token'] as RootIsolateToken?;
  final int modeIndex = (args['mode'] as int?) ?? ScanMode.smart.index;

  final cmdPort = ReceivePort();
  send.send({'t': 'ready', 'cmd': cmdPort.sendPort});

  var cancelled = false;

  final sub = cmdPort.listen((msg) {
    if (msg is Map && msg['t'] == 'cancel') {
      cancelled = true;
    }
  }, onError: (_) {});

  int scanned = 0;
  int lastSent = 0;

  try {
    final res = await runHeadlessScan(
      mode: ScanMode.values[modeIndex.clamp(0, ScanMode.values.length - 1)],
      useCloud: useCloud,
      quarantine: false,
      token: token,
      isCancelled: () => cancelled,
      onEvent: (e) {
        if (e.type == 'scan') {
          scanned++;
          if (scanned - lastSent >= 25) {
            lastSent = scanned;
            send.send({'t': 'progress', 'scanned': scanned});
          }
          return;
        }

        if (e.type == 'hit') {
          if (e.path != null) {
            send.send({'t': 'hit', 'path': e.path});
          }
          return;
        }

        if (e.type == 'err') {
          send.send({'t': 'err', 'path': e.path, 'message': e.message});
          return;
        }
      },
    );

    send.send({
      't': 'done',
      'scanned': res.scanned,
      'threats': res.threats,
      'cancelled': cancelled,
    });
  } catch (_) {
    send.send({'t': 'err'});
  } finally {
    try {
      await sub.cancel();
    } catch (_) {}
    try {
      cmdPort.close();
    } catch (_) {}
  }
}