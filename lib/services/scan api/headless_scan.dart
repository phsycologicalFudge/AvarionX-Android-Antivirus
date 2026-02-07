import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import '../../screens/scan_ui_screen.dart';
import '../../utils/hash_cache_worker.dart';
import '../../widgets/antivirus_bridge.dart';
import '../cache_manager.dart';
import '../cloud_helper_service.dart';
import '../exclusion_service.dart';
import '../quarantine_service.dart';

class HeadlessScanResult {
  final ScanMode mode;
  final int scanned;
  final int threats;
  final Duration duration;
  final List<HeadlessDetection> detections;

  HeadlessScanResult({
    required this.mode,
    required this.scanned,
    required this.threats,
    required this.duration,
    required this.detections,
  });
}

class HeadlessDetection {
  final String path;
  final String label;
  final double confidence;
  final List<String> signals;

  HeadlessDetection({
    required this.path,
    required this.label,
    required this.confidence,
    required this.signals,
  });
}

class HeadlessScanEvent {
  final String type;
  final String? path;
  final String? message;

  HeadlessScanEvent(this.type, {this.path, this.message});
}

class HeadlessScanWorker {
  final ReceivePort _receive;
  final SendPort sendPort;
  final Isolate _iso;

  HeadlessScanWorker._(this._receive, this.sendPort, this._iso);

  static Future<HeadlessScanWorker> spawn(RootIsolateToken? token) async {
    final receive = ReceivePort();
    final iso = await Isolate.spawn(_entry, {
      'root': receive.sendPort,
      'token': token,
    });
    final send = await receive.first as SendPort;
    return HeadlessScanWorker._(receive, send, iso);
  }

  @pragma('vm:entry-point')
  static void _entry(Map<String, dynamic> args) {
    final SendPort root = args['root'] as SendPort;
    final RootIsolateToken? token = args['token'] as RootIsolateToken?;

    if (token != null) {
      try {
        BackgroundIsolateBinaryMessenger.ensureInitialized(token);
      } catch (_) {}
    }

    final port = ReceivePort();
    root.send(port.sendPort);

    AntivirusBridge? bridge;
    try {
      bridge = AntivirusBridge();
    } catch (_) {
      bridge = null;
    }

    var closing = false;
    var busy = false;

    void maybeExit() {
      if (!closing) return;
      if (busy) return;
      try {
        port.close();
      } catch (_) {}
      Isolate.exit();
    }

    port.listen((msg) {
      if (msg is Map && msg['t'] == 'close') {
        closing = true;
        maybeExit();
        return;
      }

      if (msg is! List || msg.length < 2) return;

      final SendPort reply = msg[0] as SendPort;
      final String path = msg[1] as String;

      if (bridge == null) {
        reply.send(null);
        return;
      }

      busy = true;
      try {
        final raw = bridge!.scanFile(path);
        reply.send(raw);
      } catch (_) {
        reply.send(null);
      } finally {
        busy = false;
        maybeExit();
      }
    });
  }

  Future<String?> scanRaw(String path) async {
    final rp = ReceivePort();
    sendPort.send([rp.sendPort, path]);
    final v = await rp.first;
    if (v is String) return v;
    return null;
  }

  void requestClose() {
    try {
      sendPort.send({'t': 'close'});
    } catch (_) {}
    try {
      _receive.close();
    } catch (_) {}
  }

  void killNow() {
    try {
      _iso.kill(priority: Isolate.immediate);
    } catch (_) {}
    try {
      _receive.close();
    } catch (_) {}
  }
}

class CancelledScan implements Exception {}

Future<HeadlessScanResult> runHeadlessScan({
  required ScanMode mode,
  bool useCloud = false,
  bool quarantine = true,
  RootIsolateToken? token,
  void Function(HeadlessScanEvent e)? onEvent,
  bool Function()? isCancelled,
}) async {
  final sw = Stopwatch()..start();

  if (token != null) {
    try {
      BackgroundIsolateBinaryMessenger.ensureInitialized(token);
    } catch (_) {}
  }

  final ex = ExclusionService();
  await ex.load();

  final detections = <HeadlessDetection>[];
  int scanned = 0;

  HeadlessScanWorker? worker;
  try {
    worker = await HeadlessScanWorker.spawn(token);
  } catch (e) {
    onEvent?.call(HeadlessScanEvent('err', message: 'Scan worker init failed: $e'));
    worker = null;
  }

  HashCacheWorker? hashWorker;
  CloudScanner? cloud;

  if (useCloud) {
    try {
      final dir = await getApplicationDocumentsDirectory();
      hashWorker = await HashCacheWorker.spawn('${dir.path}/hashcache.bin');
      cloud = CloudScanner(
        endpoint: 'https://efkou1u21ooih2hko.colourswift.com',
        apiKey: '23JVO3ojo23oO3O423rrTR',
      );
    } catch (e) {
      onEvent?.call(HeadlessScanEvent('err', message: 'Cloud init failed: $e'));
      hashWorker = null;
      cloud = null;
    }
  }

  bool _cancelled() => isCancelled?.call() == true;

  void _throwIfCancelled() {
    if (_cancelled()) throw CancelledScan();
  }

  Future<void> scanFile(String path) async {
    if (ex.skipFolder(path)) return;
    _throwIfCancelled();

    scanned++;
    onEvent?.call(HeadlessScanEvent('scan', path: path));

    bool infected = false;
    String label = 'Suspicious.Item';
    double confidence = 0.0;
    List<String> signals = const [];

    if (useCloud && hashWorker != null && cloud != null) {
      try {
        final hashesByPath = await hashWorker.hashBatch([path]);
        final hashes = hashesByPath[path];
        if (hashes != null) {
          final md5 = hashes['md5'] ?? '';
          final sha = hashes['sha'] ?? '';
          if (md5.isNotEmpty || sha.isNotEmpty) {
            _throwIfCancelled();
            final hits = await cloud.checkBatch([
              if (md5.isNotEmpty) md5,
              if (sha.isNotEmpty) sha,
            ]);
            if (hits.isNotEmpty) {
              infected = true;
              label = 'Found in cloud database';
              confidence = 1.0;
            }
          }
        }
      } catch (e) {
        if (e is CancelledScan) rethrow;
        onEvent?.call(HeadlessScanEvent('err', path: path, message: 'Cloud check failed: $e'));
      }
    }

    _throwIfCancelled();

    if (!infected && worker != null) {
      try {
        final raw = await worker!.scanRaw(path);
        _throwIfCancelled();
        if (raw == null || raw.isEmpty) return;

        final decoded = jsonDecode(raw);
        final hits = decoded['hits'] as Map?;
        if (hits != null && hits.isNotEmpty) {
          final sigs = <String>[];
          for (final v in hits.values) {
            if (v is List) {
              for (final s in v) {
                if (s is String) sigs.add(s);
              }
            }
          }

          signals = sigs;

          if (signals.contains('HashMatch') || signals.any((s) => s.startsWith('SignerMatch('))) {
            label = 'Found in malware database';
            confidence = 1.0;
          } else {
            final yara = signals.firstWhere(
                  (s) =>
              !s.startsWith('ML_Detection(') &&
                  s != 'HashMatch' &&
                  !s.startsWith('SignerMatch('),
              orElse: () => '',
            );

            if (yara.isNotEmpty) {
              label = _normalizeFamily(yara);
              confidence = 0.95;
            } else if (signals.any((s) => s.startsWith('ML_Detection('))) {
              label = 'Generic.Suspicious';
              confidence = 0.80;
            } else {
              label = 'Suspicious.Item';
              confidence = 0.70;
            }
          }

          infected = true;
        }
      } catch (e) {
        if (e is CancelledScan) rethrow;
        onEvent?.call(HeadlessScanEvent('err', path: path, message: 'Local scan failed: $e'));
      }
    }

    _throwIfCancelled();

    if (infected) {
      detections.add(
        HeadlessDetection(
          path: path,
          label: label,
          confidence: confidence,
          signals: signals,
        ),
      );

      if (quarantine) {
        try {
          await QuarantineService.quarantineFile(path);
        } catch (e) {
          onEvent?.call(HeadlessScanEvent('err', path: path, message: 'Quarantine failed: $e'));
        }
      }

      onEvent?.call(HeadlessScanEvent('hit', path: path));
    }
  }

  bool isAllowedSmart(String ext, int size) {
    const allowed = {
      'apk',
      'xapk',
      'apkm',
      'zip',
      'pdf',
      'txt',
      'md',
      'exe',
    };
    if (!allowed.contains(ext)) return false;
    if (size > 100 * 1024 * 1024) return false;
    return true;
  }

  try {
    _throwIfCancelled();

    if (mode == ScanMode.installed) {
      final apps = await _listInstalledApps(onEvent: onEvent);
      for (final p in apps) {
        _throwIfCancelled();
        await scanFile(p);
      }
    } else if (mode == ScanMode.rapid) {
      final dir = Directory('/storage/emulated/0/Download');
      if (await dir.exists()) {
        await for (final e in dir.list(recursive: true, followLinks: false)) {
          _throwIfCancelled();
          if (e is! File) continue;

          final path = e.path;
          if (ex.skipFolder(path)) continue;

          final name = path.split('/').last;
          final dot = name.lastIndexOf('.');
          final ext = dot > 0 ? name.substring(dot + 1).toLowerCase() : '';
          if (ext != 'apk') continue;

          final size = await e.length();
          if (size > 200 * 1024 * 1024) continue;

          await scanFile(path);
        }
      }
    } else if (mode == ScanMode.smart) {
      final root = Directory('/storage/emulated/0/');
      final folders = <String>[];

      if (await root.exists()) {
        await for (final e in root.list(followLinks: false)) {
          _throwIfCancelled();
          if (e is Directory) {
            final name = e.path.split('/').last.toLowerCase();
            if (name == 'android' ||
                name == 'music' ||
                name == 'movies' ||
                name == 'podcasts' ||
                name == 'ringtones' ||
                name == 'alarms' ||
                name == 'notifications') continue;
            folders.add(e.path);
          }
        }
      }

      final files = <String>[];

      for (final dirPath in folders) {
        _throwIfCancelled();

        final dir = Directory(dirPath);
        if (!await dir.exists()) continue;

        await for (final entity in dir.list(recursive: true, followLinks: false)) {
          _throwIfCancelled();
          if (entity is! File) continue;

          final path = entity.path;
          if (ex.skipFolder(path)) continue;

          final name = path.split('/').last;
          final dot = name.lastIndexOf('.');
          final ext = dot > 0 ? name.substring(dot + 1).toLowerCase() : '';

          final size = await entity.length();
          if (!isAllowedSmart(ext, size)) continue;

          files.add(path);
        }
      }

      _throwIfCancelled();

      files.sort((a, b) {
        try {
          return File(a).lengthSync().compareTo(File(b).lengthSync());
        } catch (_) {
          return 0;
        }
      });

      for (final path in files) {
        _throwIfCancelled();
        await scanFile(path);
      }
    } else if (mode == ScanMode.full) {
      final root = Directory('/storage/emulated/0');
      if (await root.exists()) {
        await for (final e in root.list(recursive: true, followLinks: false)) {
          _throwIfCancelled();
          if (e is! File) continue;
          await scanFile(e.path);
        }
      }
    } else {
      final root = Directory('/storage/emulated/0');
      if (await root.exists()) {
        await for (final e in root.list(recursive: true, followLinks: false)) {
          _throwIfCancelled();
          if (e is! File) continue;
          await scanFile(e.path);
        }
      }
    }
  } catch (e) {
    if (e is! CancelledScan) {
      onEvent?.call(HeadlessScanEvent('err', message: 'Enumeration failed: $e'));
    }
  } finally {
    try {
      worker?.requestClose();
    } catch (_) {}
  }

  if (hashWorker != null) {
    try {
      await hashWorker.flush();
    } catch (e) {
      onEvent?.call(HeadlessScanEvent('err', message: 'Hash flush failed: $e'));
    }
  }

  try {
    await CacheManager.clearAll();
  } catch (_) {}

  sw.stop();

  return HeadlessScanResult(
    mode: mode,
    scanned: scanned,
    threats: detections.length,
    duration: sw.elapsed,
    detections: detections,
  );
}

Future<List<String>> _listInstalledApps({
  void Function(HeadlessScanEvent e)? onEvent,
}) async {
  try {
    final MethodChannel ch = const MethodChannel("cs.fastapps");
    final List<dynamic> raw = await ch.invokeMethod("listUserApps");
    return raw
        .map((e) => Map<String, dynamic>.from(e)['path'])
        .whereType<String>()
        .toList();
  } catch (e) {
    onEvent?.call(HeadlessScanEvent('err', message: 'listUserApps failed: $e'));
    return [];
  }
}

String _ext(String path) {
  final name = path.split('/').last;
  final dot = name.lastIndexOf('.');
  if (dot <= 0) return '';
  return name.substring(dot + 1).toLowerCase();
}

bool _isAllowedFile(String ext, int size) {
  const allowed = {
    'apk',
    'xapk',
    'apkm',
    'zip',
    'pdf',
    'txt',
    'md',
    'exe',
  };

  if (!allowed.contains(ext)) return false;
  if (size > 100 * 1024 * 1024) return false;

  return true;
}

String _normalizeFamily(String raw) {
  final r = raw.toLowerCase();
  if (r.contains('miner')) return 'Android.Miner';
  if (r.contains('dropper')) return 'Android.Dropper';
  if (r.contains('banker')) return 'Android.Banker';
  if (r.contains('spyware')) return 'Android.Spyware';
  if (r.contains('adware')) return 'Android.Adware';
  if (r.contains('sms')) return 'Android.SMS.Fraud';
  return 'Generic.Malware';
}

Future<Map<String, dynamic>> runHeadlessScanSummary({
  required ScanMode mode,
  bool useCloud = false,
  RootIsolateToken? token,
}) async {
  final r = await runHeadlessScan(
    mode: mode,
    useCloud: useCloud,
    quarantine: false,
    token: token,
  );

  return {
    'mode': r.mode.toString(),
    'scanned': r.scanned,
    'threats': r.threats,
    'duration_ms': r.duration.inMilliseconds,
  };
}

