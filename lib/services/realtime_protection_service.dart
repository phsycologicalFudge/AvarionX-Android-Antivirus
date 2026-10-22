import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:io';
import 'dart:ui';
import 'package:colourswift_av/services/scan%20api/headless_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/scan/main_scan_ui/scan_screen.dart';
import 'exclusion_service.dart';
import '../widgets/antivirus_bridge.dart';
import 'av_engine.dart';
import 'update_service.dart';
import 'foreground_service.dart';
import 'quarantine_service.dart';
import 'package:crypto/crypto.dart';
import '../services/scan api/scan_types.dart';

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
  static final Set<String> _inFlight = <String>{};
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
  static Timer? _defsSyncTimer;
  static bool _defsSyncRunning = false;

  static const _eventChannel = EventChannel('colourswift/realtime_stream');
  static const EventChannel _watcherStateChannel = EventChannel('colourswift/watcher_state');
  static StreamSubscription? _watcherStateSub;

  static const MethodChannel _watcherChannel = MethodChannel('colourswift/system_watcher');
  static final ExclusionService _exclusions = ExclusionService();

  static const _allowed = {
    'com', 'apk', 'zip', 'rar', '7z', 'pdf', 'txt', 'md', 'json', 'exe'
  };
  static const _skip = {
    'mp3', 'mp4', 'm4a', 'mov', 'jpg', 'png', 'jpeg', 'heic', 'webp'
  };
  static const _maxSize = 100 * 1024 * 1024;

  static String _tag = 'DU';
  static Future<void> _logChain = Future.value();
  static final File _logFile = File('/storage/emulated/0/Documents/avarionx_rtp.log');

  static void markBackground(bool enabled) {
    _tag = 'DB';
    _log('main enabled=$enabled');
  }

  static String _rid(String s) {
    var h = 0;
    for (final c in s.codeUnits) {
      h = (31 * h + c) & 0xFFFFFFFF;
    }
    return h.toRadixString(16).padLeft(8, '0');
  }

  static String _ext(String s) {
    final i = s.lastIndexOf('.');
    if (i < 0) return '';
    final e = s.substring(i + 1).toLowerCase();
    if (e.contains('/')) return '';
    final b = StringBuffer();
    for (final c in e.codeUnits) {
      if ((c >= 48 && c <= 57) || (c >= 97 && c <= 122)) b.writeCharCode(c);
      if (b.length >= 8) break;
    }
    return b.toString();
  }

  static void _log(String m) {
    final n = DateTime.now();
    String z(int v, int w) => v.toString().padLeft(w, '0');
    final line =
        '${z(n.month, 2)}-${z(n.day, 2)} ${z(n.hour, 2)}:${z(n.minute, 2)}:${z(n.second, 2)}.${z(n.millisecond, 3)} $pid $_tag $m\n';
    _logChain = _logChain.then((_) async {
      try {
        if (!_logFile.existsSync()) _logFile.createSync(recursive: true);
        await _logFile.writeAsString(line, mode: FileMode.append, flush: true);
      } catch (_) {}
    });
  }

  static Future<Map<String, dynamic>> ensureDefsReady({
    bool forceServerCheck = false,
  }) async {
    if (_defsSyncRunning) {
      return {
        'checked': false,
        'downloaded': false,
      };
    }

    _defsSyncRunning = true;

    try {
      final result = await UpdateService.ensureDatabaseReady(
        forceServerCheck: forceServerCheck,
        minCheckInterval: const Duration(minutes: 30),
      );

      if (result['downloaded'] == true) {
        final paths = await UpdateService.getLocalPaths();
        try {
          AntivirusBridge().reload(
            paths['defsPath']!,
          );
        } catch (_) {}
      }

      return result;
    } catch (_) {
      return {
        'checked': false,
        'downloaded': false,
      };
    } finally {
      _defsSyncRunning = false;
    }
  }

  static Future<void> _reconcileShizuku() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool('shizuku_enabled') ?? false;

      if (!enabled) {
        try {
          await _watcherChannel.invokeMethod('stop');
        } catch (_) {}

        _watcherRunning = false;
      }
    } catch (_) {
      try {
        await _watcherChannel.invokeMethod('stop');
      } catch (_) {}

      _watcherRunning = false;
    }
  }

  static void _attachWatcherStateStream() {
    if (_watcherStateSub != null) return;

    try {
      _watcherStateSub = _watcherStateChannel.receiveBroadcastStream().listen(
            (event) async {
          final alive = event == true;
          _watcherRunning = alive;

          if (!alive) {
            await _reconcileShizuku();
          }
        },
        onError: (_) {
          _watcherRunning = false;
        },
      );
    } catch (_) {
      _watcherRunning = false;
    }
  }

  static Future<void> start() async {
    if (_running) return;
    _running = true;
    _rootToken ??= RootIsolateToken.instance;

    final sw = Stopwatch()..start();
    _log('start begin');

    final defs = await ensureDefsReady(forceServerCheck: true);
    _log('start defs ms=${sw.elapsedMilliseconds} dl=${defs['downloaded']}');
    await _loadIndex();
    await _exclusions.load();
    await AvEngine.ensureInitialized();
    _log('start engine ms=${sw.elapsedMilliseconds}');
    await ForegroundService.start(title: 'AvarionX', text: 'Protection active');
    _log('start fg ms=${sw.elapsedMilliseconds}');

    if (!_fgHandlerAttached) {
      _fgHandlerAttached = true;
      _fgChannel.setMethodCallHandler((call) async {
        if (call.method == 'cancelScheduledScan') {
          await cancelScheduledScan();
        }
      });
    }

    await _startScheduledScans();

    _defsSyncTimer?.cancel();
    _defsSyncTimer = Timer.periodic(
      const Duration(minutes: 30),
          (_) => unawaited(ensureDefsReady()),
    );

    final prefs = await SharedPreferences.getInstance();
    final shizukuEnabled = prefs.getBool('shizuku_enabled') ?? false;

    if (shizukuEnabled) {
      await _reconcileShizuku();
      _attachWatcherStateStream();

      _shizukuLoop = Timer.periodic(
        const Duration(seconds: 2),
            (_) => _reconcileShizuku(),
      );
    } else {
      _watcherRunning = false;
    }

    _eventSub = _eventChannel.receiveBroadcastStream().listen(
          (dynamic event) async {
        if (event is! String) return;

        if (event.startsWith('app::')) {
          _log('ev id=${_rid(event)} k=app');
          final parts = event.split('::');
          if (parts.length < 3) return;
          final packageName = parts[1];
          final apkPath = parts.sublist(2).join('::');
          if (packageName.isEmpty || apkPath.isEmpty) return;
          await _scanInstalledApp(packageName, apkPath);
          return;
        }

        _log('ev id=${_rid(event)} k=file ext=${_ext(event)}');
        final name = p.basename(event);
        if (name.startsWith('.pending-')) {
          _log('skip id=${_rid(event)} r=pending');
          return;
        }
        await _scanSingleFile(event);
      },
      onError: (e) {
        _log('listen err t=${e.runtimeType}');
      },
    );
    _log('start listen ms=${sw.elapsedMilliseconds}');
  }

  static Future<void> stop() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final shizukuEnabled = prefs.getBool('shizuku_enabled') ?? false;

      if (shizukuEnabled) {
        try {
          await _watcherChannel.invokeMethod('stop');
        } catch (_) {}
      }
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

    _defsSyncTimer?.cancel();
    _defsSyncTimer = null;

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

    final lastRun = prefs.getInt('scheduled_scan_last_started_at') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final intervalMs = Duration(hours: intervalHours).inMilliseconds;

    if (now - lastRun >= intervalMs) {
      unawaited(_runScheduledScan());
    }
  }

  static Future<void> _runScheduledScan() async {
    if (_scheduledScanRunning) return;
    _scheduledScanRunning = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        'scheduled_scan_last_started_at',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (_) {}

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final useCloud = prefs.getBool('useCloudScan') ?? false;
      final mode = _scheduledModeFromPrefs(prefs);
      final token = _rootToken;

      final rp = ReceivePort();
      _scheduledIsoPort?.close();
      _scheduledIsoPort = rp;

      _scheduledCmd = null;
      _scheduledCancelRequested = false;

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

      int quarantined = 0;
      int quarantineFailed = 0;
      int threatsSeen = 0;

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

        if (t == 'hit') {
          threatsSeen++;
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
          final cancelled = msg['cancelled'] == true;
          final scanned = (msg['scanned'] as num?)?.toInt() ?? 0;
          final threats = (msg['threats'] as num?)?.toInt() ?? threatsSeen;

          await _recordScheduledReportEvent(
            scanned: scanned,
            threats: threats,
            cancelled: cancelled,
          );

          if (cancelled) {
            await ForegroundService.toast(text: 'Scheduled scan cancelled');
          } else {
            if (threatsSeen <= 0) {
              await ForegroundService.toast(text: 'Scheduled scan, no threats');
            } else {
              final text = quarantined > 0
                  ? (quarantineFailed > 0 ? '$quarantined quarantined, $quarantineFailed failed' : '$quarantined quarantined')
                  : 'Detected $threatsSeen threats, quarantine failed';

              await ForegroundService.notify(
                title: 'Threat Detected',
                text: text,
              );
            }
          }

          break;
        }

        if (t == 'err') {
          final msgText = (msg['message'] as String?) ?? 'Scan failed to complete';
          await ForegroundService.toast(text: msgText);
          break;
        }
      }
    } catch (_) {
      await ForegroundService.toast(text: 'Scan failed to complete');
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

    _scheduledCmd = null;
    _scheduledIsoPort = null;
    _scheduledIso = null;

    _scheduledScanRunning = false;

    await ForegroundService.toast(text: 'Scheduled scan cancelled');
  }

  static ScanMode _scheduledModeFromPrefs(SharedPreferences prefs) {
    final raw = (prefs.getString('scheduled_scan_mode') ?? 'rapid').toLowerCase();
    switch (raw) {
      case 'full':
        return ScanMode.full;
      case 'installed':
        return ScanMode.installed;
      case 'rapid':
        return ScanMode.rapid;
      case 'single':
        return ScanMode.single;
      case 'smart':
        return ScanMode.smart;
      default:
        return ScanMode.rapid;
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

  static Future<void> _recordRealtimeReportEvent({
    required bool threat,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;

    await prefs.setInt(
      'security_report_rtp_scans_total',
      (prefs.getInt('security_report_rtp_scans_total') ?? 0) + 1,
    );

    await prefs.setInt(
      'security_report_files_scanned_total',
      (prefs.getInt('security_report_files_scanned_total') ?? 0) + 1,
    );

    if (threat) {
      await prefs.setInt(
        'security_report_threats_total',
        (prefs.getInt('security_report_threats_total') ?? 0) + 1,
      );
    }

    await prefs.setInt('security_report_last_rtp_event_at', now);
  }

  static Future<void> _recordScheduledReportEvent({
    required int scanned,
    required int threats,
    required bool cancelled,
  }) async {
    if (cancelled) return;

    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;

    await prefs.setInt(
      'security_report_scheduled_scans_total',
      (prefs.getInt('security_report_scheduled_scans_total') ?? 0) + 1,
    );

    await prefs.setInt(
      'security_report_files_scanned_total',
      (prefs.getInt('security_report_files_scanned_total') ?? 0) + scanned,
    );

    await prefs.setInt(
      'security_report_threats_total',
      (prefs.getInt('security_report_threats_total') ?? 0) + threats,
    );

    await prefs.setInt('security_report_last_scheduled_scan_at', now);
  }

  static Future<bool> _isOnline() async {
    try {
      final result = await InternetAddress.lookup('api.colourswift.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _engineCloudScan(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final useCloud = prefs.getBool('useCloudScan') ?? false;

    bool cloudOn = false;
    if (useCloud) {
      try {
        final dir = await getApplicationDocumentsDirectory();
        setEngineDataDir(dir.path);
      } catch (_) {}
      setEngineCloudEnabled(true);
      try {
        cloudOn = await _isOnline() && engineCloudBegin() == 0;
      } catch (_) {
        cloudOn = false;
      }
    } else {
      setEngineCloudEnabled(false);
    }

    final localHit = await compute(scanFileIsolate, path);
    if (localHit) {
      if (cloudOn) {
        try {
          await engineCloudFinishAsync(0);
        } catch (_) {}
      }
      return true;
    }

    if (!cloudOn) return false;

    try {
      final raw = await engineCloudFinishAsync(20000);
      final decoded = jsonDecode(raw);
      final results = decoded is Map ? decoded['results'] : null;
      if (results is List) {
        for (final r in results) {
          if (r is Map && (r['path'] ?? '').toString() == path) {
            return true;
          }
        }
      }
    } catch (_) {}
    return false;
  }

  static Future<bool> _isExcluded(String path) async {
    await _exclusions.refreshIfStale();
    return _exclusions.skipFolder(path);
  }

  static Future<void> _scanSingleFile(String path) async {
    final id = _rid(path);
    if (_inFlight.contains(path)) {
      _log('skip id=$id r=inflight');
      return;
    }
    _inFlight.add(path);
    final sw = Stopwatch()..start();

    try {
      final f = File(path);
      if (!await f.exists()) {
        _log('skip id=$id r=missing');
        return;
      }
      if (await _isExcluded(path)) {
        _log('skip id=$id r=excl');
        return;
      }

      final ext = p.extension(path).replaceFirst('.', '').toLowerCase();
      if (_skip.contains(ext)) {
        _log('skip id=$id r=ext');
        return;
      }
      if (_allowed.isNotEmpty && !_allowed.contains(ext)) {
        _log('skip id=$id r=ext');
        return;
      }

      final stable = await _waitUntilStable(f);
      _log('stable id=$id ok=$stable ms=${sw.elapsedMilliseconds}');
      if (!stable) return;

      if (!await f.exists()) {
        _log('skip id=$id r=missing');
        return;
      }
      if (await _isExcluded(path)) {
        _log('skip id=$id r=excl');
        return;
      }

      final size = await f.length();
      if (size <= 0 || size > _maxSize) {
        _log('skip id=$id r=size');
        return;
      }

      final mtime = (await f.lastModified()).millisecondsSinceEpoch;
      final seenMtime = _seen[path];
      if (seenMtime != null && mtime <= seenMtime) {
        _log('skip id=$id r=seen');
        return;
      }

      final bytes = await f.readAsBytes();
      final sha = sha256.convert(bytes).toString();
      if (_exclusions.skipSha(sha)) {
        _log('skip id=$id r=sha');
        return;
      }

      final infected = await _engineCloudScan(path);
      _log('engine id=$id infected=$infected ms=${sw.elapsedMilliseconds}');
      if (infected) {
        _seen[path] = mtime;
        unawaited(_saveIndex());

        await _recordRealtimeReportEvent(threat: true);

        if (!await _isExcluded(path)) {
          await _handleDetection(path);
        }
        return;
      }

      _seen[path] = mtime;
      unawaited(_saveIndex());

      await _recordRealtimeReportEvent(threat: false);

      final fileName = p.basename(path);
      final ok = await ForegroundService.toast(text: 'Clean: $fileName');
      _log('toast id=$id ok=$ok ms=${sw.elapsedMilliseconds}');
    } catch (e) {
      _log('err id=$id t=${e.runtimeType} ms=${sw.elapsedMilliseconds}');
    } finally {
      _inFlight.remove(path);
    }
  }

  static Future<void> _scanInstalledApp(String packageName, String apkPath) async {
    final id = _rid('app::$packageName::$apkPath');
    if (packageName == 'com.colourswift.cssecurity') {
      _log('skip id=$id r=self');
      return;
    }
    if (_inFlight.contains(apkPath)) {
      _log('skip id=$id r=inflight');
      return;
    }
    _inFlight.add(apkPath);
    final sw = Stopwatch()..start();

    try {
      final f = File(apkPath);
      if (!await f.exists()) {
        _log('skip id=$id r=missing');
        return;
      }
      if (await _isExcluded(apkPath)) {
        _log('skip id=$id r=excl');
        return;
      }

      final size = await f.length();
      if (size <= 0 || size > _maxSize) {
        _log('skip id=$id r=size');
        return;
      }

      final bytes = await f.readAsBytes();
      final sha = sha256.convert(bytes).toString();
      if (_exclusions.skipSha(sha)) {
        _log('skip id=$id r=sha');
        return;
      }

      final infected = await _engineCloudScan(apkPath);
      _log('engine id=$id infected=$infected ms=${sw.elapsedMilliseconds}');
      if (infected) {
        await _recordRealtimeReportEvent(threat: true);
        if (!await _isExcluded(apkPath)) {
          await _handleAppDetection(packageName, apkPath);
        }
        return;
      }

      await _recordRealtimeReportEvent(threat: false);
      final ok = await ForegroundService.toast(text: 'Clean: $packageName');
      _log('toast id=$id ok=$ok ms=${sw.elapsedMilliseconds}');
    } catch (e) {
      _log('err id=$id t=${e.runtimeType} ms=${sw.elapsedMilliseconds}');
    } finally {
      _inFlight.remove(apkPath);
    }
  }

  static Future<void> _handleAppDetection(String packageName, String apkPath) async {
    final id = _rid('app::$packageName::$apkPath');
    String appName = packageName;
    try {
      const ch = MethodChannel('cs.fastapps');
      final List<dynamic> apps = await ch.invokeMethod('listUserApps');
      final match = apps.cast<Map>().firstWhere(
            (e) => e['package'] == packageName,
        orElse: () => {},
      );
      if (match.isNotEmpty && match['name'] is String) {
        appName = match['name'] as String;
      }
    } catch (e) {
      _log('appname id=$id t=${e.runtimeType}');
    }

    try {
      await QuarantineService.quarantineApp(
        packageName: packageName,
        appName: appName,
        apkPath: apkPath,
      );
      _log('quar id=$id ok=true');
      final prefs = await SharedPreferences.getInstance();
      final autoDismissSeconds =
          prefs.getInt('rtp_notification_auto_dismiss_seconds') ?? 0;

      final ok = await ForegroundService.notify(
        title: 'Threat Detected',
        text: 'Suspicious app flagged: $appName',
        autoDismissAfterSeconds:
        autoDismissSeconds > 0 ? autoDismissSeconds : null,
        openQuarantineOnClick: true,
      );
      _log('notify id=$id ok=$ok');
    } catch (e) {
      _log('quar id=$id ok=false t=${e.runtimeType}');
      final prefs = await SharedPreferences.getInstance();
      final autoDismissSeconds =
          prefs.getInt('rtp_notification_auto_dismiss_seconds') ?? 0;

      final ok = await ForegroundService.notify(
        title: 'Threat Detected',
        text: 'Suspicious app detected: $appName',
        autoDismissAfterSeconds:
        autoDismissSeconds > 0 ? autoDismissSeconds : null,
        openQuarantineOnClick: true,
      );
      _log('notify id=$id ok=$ok');
    }
  }

  static Future<void> _handleDetection(String path) async {
    final id = _rid(path);
    try {
      await QuarantineService.quarantineFile(path);
      _log('quar id=$id ok=true');
      final prefs = await SharedPreferences.getInstance();
      final autoDismissSeconds =
          prefs.getInt('rtp_notification_auto_dismiss_seconds') ?? 0;

      final ok = await ForegroundService.notify(
        title: 'Threat Detected',
        text: 'A file was quarantined: ${path.split('/').last}',
        autoDismissAfterSeconds:
        autoDismissSeconds > 0 ? autoDismissSeconds : null,
        openQuarantineOnClick: true,
      );
      _log('notify id=$id ok=$ok');
    } catch (e) {
      _log('quar id=$id ok=false t=${e.runtimeType}');
      final prefs = await SharedPreferences.getInstance();
      final autoDismissSeconds =
          prefs.getInt('rtp_notification_auto_dismiss_seconds') ?? 0;

      final ok = await ForegroundService.notify(
        title: 'Threat Detected',
        text: 'Failed to quarantine: ${path.split('/').last}',
        autoDismissAfterSeconds:
        autoDismissSeconds > 0 ? autoDismissSeconds : null,
        openQuarantineOnClick: true,
      );
      _log('notify id=$id ok=$ok');
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
Future<void> rtpBackgroundMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final enabled = prefs.getBool('protectionEnabled') ?? false;

  RealtimeProtectionService.markBackground(enabled);

  if (!enabled) return;

  await RealtimeProtectionService.start();

  final keepAlive = Completer<void>();
  await keepAlive.future;
}

@pragma('vm:entry-point')
Future<void> _scheduledScanEntry(Map<String, dynamic> args) async {
  final SendPort send = args['send'] as SendPort;
  final bool useCloud = args['useCloud'] == true;
  final RootIsolateToken? token = args['token'] as RootIsolateToken?;
  final int modeIndex = (args['mode'] as int?) ?? ScanMode.rapid.index;

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
      recordReport: false,
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