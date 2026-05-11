import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/cache_manager.dart';
import '../services/cloud_helper_service.dart';
import '../services/exclusion_service.dart';
import '../services/quarantine_service.dart';
import '../utils/hash_cache_worker.dart';
import '../utils/worker_hash_isolate.dart';
import '../widgets/antivirus_bridge.dart';

typedef ScanLogSink = void Function(String msg);

ScanLogSink? scanLogSink;

class LogBuffer {
  static final List<String> _messages = [];
  static final ValueNotifier<int> notifier = ValueNotifier<int>(0);

  static void add(String msg) {
    final now = DateTime.now();
    final time = "${now.hour}:${now.minute}:${now.second}";
    _messages.add('[$time] $msg');
    if (_messages.length > 300) _messages.removeAt(0);
    notifier.value++;
    scanLogSink?.call(msg);
  }

  static List<String> get all => List.unmodifiable(_messages);

  static void clear() {
    _messages.clear();
    notifier.value++;
  }
}

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

class ScanWorker {
  final ReceivePort _receive;
  final SendPort sendPort;

  ScanWorker._(this._receive, this.sendPort);

  static Future<ScanWorker> spawn() async {
    final receive = ReceivePort();
    await Isolate.spawn(_entry, receive.sendPort);
    final send = await receive.first as SendPort;
    return ScanWorker._(receive, send);
  }

  static String _normalizeFamily(String raw) {
    final r = raw.toLowerCase();

    if (r.contains('miner')) return 'Android.Miner';
    if (r.contains('dropper')) return 'Android.Dropper';
    if (r.contains('banker')) return 'Android.Banker';
    if (r.contains('spyware')) return 'Android.Spyware';
    if (r.contains('adware')) return 'Android.Adware';
    if (r.contains('sms')) return 'Android.SMS.Fraud';

    return 'Generic.Malware';
  }

  static void _entry(SendPort root) {
    final port = ReceivePort();
    root.send(port.sendPort);

    port.listen((msg) {
      final send = msg[0] as SendPort;
      final path = msg[1] as String;

      try {
        final bridge = AntivirusBridge();
        final raw = bridge.scanFile(path);
        final decoded = jsonDecode(raw);
        final hits = decoded['hits'] as Map?;

        if (hits == null || hits.isEmpty) {
          send.send(null);
          return;
        }

        final signals = <String>[];

        for (final v in hits.values) {
          if (v is List) {
            for (final s in v) {
              if (s is String) signals.add(s);
            }
          }
        }

        String label = 'Suspicious.Item';
        double confidence = 0.0;

        if (signals.contains('HashMatch') ||
            signals.any((s) => s.startsWith('SignerMatch('))) {
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
          } else {
            final ml = signals.firstWhere(
                  (s) => s.startsWith('ML_Detection('),
              orElse: () => '',
            );

            if (ml.isNotEmpty) {
              label = 'Generic.Suspicious';
              confidence = 0.80;
            }
          }
        }

        send.send({
          'label': label,
          'confidence': confidence,
          'signals': signals,
        });
      } catch (_) {
        send.send(false);
      }
    });
  }

  Future<dynamic> scan(String path) async {
    final port = ReceivePort();
    sendPort.send([port.sendPort, path]);
    return await port.first;
  }
}

class AppTarget {
  final String name;
  final String package;
  final String path;

  AppTarget({
    required this.name,
    required this.package,
    required this.path,
  });
}

class ScanController {
  bool useCloudScan = false;
  bool cancelled = false;

  int scanned = 0;
  int total = 0;

  String currentFile = '';

  final List<String> clean = [];
  final List<DetectionResult> infected = [];

  late final CloudScanner cloudScanner;

  static const MethodChannel _fastApps = MethodChannel("cs.fastapps");
  static const MethodChannel _apkFast = MethodChannel("apk_fast");

  ScanController() {
    cloudScanner = CloudScanner(
      endpoint: 'https://efkou1u21ooih2hko.colourswift.com',
      apiKey: '23JVO3ojo23oO3O423rrTR',
    );
  }

  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    useCloudScan = prefs.getBool('useCloudScan') ?? false;
  }

  Future<bool> ensureStoragePermission() async {
    if (!Platform.isAndroid) return true;

    final info = await DeviceInfoPlugin().androidInfo;
    final sdk = info.version.sdkInt;

    if (sdk >= 30) {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        const platform = MethodChannel('colourswift/storage_permission');
        await platform.invokeMethod('openManageStorage');
        await Future.delayed(const Duration(seconds: 2));
        status = await Permission.manageExternalStorage.status;
      }
      return status.isGranted;
    } else {
      final status = await Permission.storage.status;
      return status.isGranted || await Permission.storage.request().isGranted;
    }
  }

  Future<List<AppTarget>> getUserInstalledApps() async {
    try {
      final List<dynamic> raw =
      await _fastApps.invokeMethod("listUserApps");
      return raw.map((item) {
        final m = Map<String, dynamic>.from(item);
        return AppTarget(
          name: m["name"] ?? "Unknown",
          package: m["package"] ?? "",
          path: m["path"] ?? "",
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> scanInstalledApps() async {
    final apps = await getUserInstalledApps();
    if (apps.isEmpty) {
      LogBuffer.add('[ENGINE] No user-installed apps found.');
      return;
    }

    final ex = ExclusionService();
    await ex.load();

    final scanWorker = await ScanWorker.spawn();

    scanned = 0;
    total = apps.length;
    clean.clear();
    infected.clear();

    for (final a in apps) {
      if (cancelled) break;
      if (ex.skipFolder(a.path)) continue;

      currentFile = a.name;
      scanned++;

      final res = await scanWorker.scan(a.path);
      if (res is Map) {
        infected.add(
          DetectionResult(
            name: a.name,
            label: res['label'],
            confidence: res['confidence'],
            signals: List<String>.from(res['signals'] ?? []),
          ),
        );
      } else {
        clean.add(a.name);
      }
    }

    await CacheManager.clearAll();
  }

  Future<void> scanFiles(List<String> files) async {
    total = files.length;
    scanned = 0;
    clean.clear();
    infected.clear();

    if (files.isEmpty) {
      LogBuffer.add('[ENGINE] No readable files found.');
      return;
    }

    final scanWorker = await ScanWorker.spawn();
    final cloudDetected = <String>{};
    final fileHashes = <String, Map<String, String>>{};

    HashCacheWorker? hashWorker;

    if (useCloudScan) {
      final dir = await getApplicationDocumentsDirectory();
      hashWorker = await HashCacheWorker.spawn('${dir.path}/hashcache.bin');
      final hashesByPath = await hashWorker.hashBatch(files);

      for (final e in hashesByPath.entries) {
        fileHashes[e.key] = e.value;
      }

      await hashWorker.flush();

      final toSend = <String>[];
      for (final h in fileHashes.values) {
        if (h['md5']?.isNotEmpty ?? false) toSend.add(h['md5']!);
        if (h['sha']?.isNotEmpty ?? false) toSend.add(h['sha']!);
      }

      if (toSend.isNotEmpty) {
        final hits = await cloudScanner.checkBatch(toSend);
        cloudDetected.addAll(hits);
      }
    }

    for (final path in files) {
      if (cancelled) break;

      final name = path.split('/').last;
      currentFile = name;
      scanned++;

      bool infectedFlag = false;

      if (useCloudScan) {
        final hashes = fileHashes[path];
        if (hashes != null) {
          if (cloudDetected.contains(hashes['md5']) ||
              cloudDetected.contains(hashes['sha'])) {
            infectedFlag = true;
            infected.add(
              DetectionResult(
                name: name,
                label: 'Found in cloud database',
                confidence: 1.0,
                signals: const [],
              ),
            );
            await QuarantineService.quarantineFile(path);
            continue;
          }
        }
      }

      final res = await scanWorker.scan(path);
      if (res is Map) {
        infectedFlag = true;
        infected.add(
          DetectionResult(
            name: name,
            label: res['label'],
            confidence: res['confidence'],
            signals: List<String>.from(res['signals'] ?? []),
          ),
        );
      }

      if (infectedFlag) {
        await QuarantineService.quarantineFile(path);
      } else {
        clean.add(path);
      }
    }

    await CacheManager.clearAll();
  }
}

bool scanFileIsolate(String path) {
  try {
    final bridge = AntivirusBridge();
    final raw = bridge.scanFile(path);
    final decoded = jsonDecode(raw);
    final hits = decoded['hits'] as Map?;
    return hits != null && hits.isNotEmpty;
  } catch (_) {
    return false;
  }
}

class BatchScanWorker {
  final ReceivePort _receive;
  final SendPort sendPort;

  BatchScanWorker._(this._receive, this.sendPort);

  static Future<BatchScanWorker> spawn() async {
    final receive = ReceivePort();
    await Isolate.spawn(_entry, receive.sendPort);
    final send = await receive.first as SendPort;
    return BatchScanWorker._(receive, send);
  }

  static void _entry(SendPort root) {
    final port = ReceivePort();
    root.send(port.sendPort);

    final bridge = AntivirusBridge();

    port.listen((msg) {
      final send = msg[0] as SendPort;
      final paths = (msg[1] as List).cast<String>();

      final out = <String, bool>{};

      for (final p in paths) {
        try {
          final raw = bridge.scanFile(p);
          final decoded = jsonDecode(raw);
          final hits = decoded['hits'] as Map?;
          out[p] = hits != null && hits.isNotEmpty;
        } catch (_) {
          out[p] = false;
        }
      }

      send.send(out);
    });
  }

  Future<Map<String, bool>> scanBatch(List<String> paths) async {
    final port = ReceivePort();
    sendPort.send([port.sendPort, paths]);
    return await port.first as Map<String, bool>;
  }
}

Iterable<List<T>> chunks<T>(List<T> items, int size) sync* {
  for (var i = 0; i < items.length; i += size) {
    final end = (i + size < items.length) ? i + size : items.length;
    yield items.sublist(i, end);
  }
}
