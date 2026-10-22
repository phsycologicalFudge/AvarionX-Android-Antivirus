import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'scan_types.dart';
import '../../utils/hash_cache_worker.dart';
import '../../widgets/antivirus_bridge.dart';
import '../../widgets/scan_log_listener.dart';
import '../cache_manager.dart';
import '../cloud_helper_service.dart';
import '../exclusion_service.dart';
import '../quarantine_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeadlessScanResult {
  final ScanMode mode;
  final int scanned;
  final int threats;
  final int clean;
  final int total;
  final bool cancelled;
  final Duration duration;
  final List<HeadlessDetection> detections;

  HeadlessScanResult({
    required this.mode,
    required this.scanned,
    required this.threats,
    required this.clean,
    required this.total,
    required this.cancelled,
    required this.duration,
    required this.detections,
  });
}

class HeadlessDetection {
  final String path;
  final String name;
  final String label;
  final double confidence;
  final List<String> signals;

  HeadlessDetection({
    required this.path,
    required this.name,
    required this.label,
    required this.confidence,
    required this.signals,
  });
}

class HeadlessScanEvent {
  final String type;
  final ScanMode? mode;
  final String? path;
  final String? name;
  final String? message;
  final int? scanned;
  final int? total;
  final String? label;
  final double? confidence;
  final List<String>? signals;
  final String? quarantinePath;
  final int? apkSize;
  final String? entryName;

  HeadlessScanEvent(
      this.type, {
        this.mode,
        this.path,
        this.name,
        this.message,
        this.scanned,
        this.total,
        this.label,
        this.confidence,
        this.signals,
        this.quarantinePath,
        this.apkSize,
        this.entryName,
      });
}

class _HeadlessTarget {
  final String path;
  final String name;
  final String pkg;

  _HeadlessTarget({
    required this.path,
    required this.name,
    this.pkg = '',
  });
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
      bridge = AntivirusBridge(enableScanLogs: false);
    } catch (_) {
      bridge = null;
    }

    var closing = false;
    var busy = false;

    void maybeExit() {
      if (!closing) return;
      if (busy) return;
      try {
        bridge?.free();
      } catch (_) {}
      try {
        port.close();
      } catch (_) {}
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
    clearScanCallback();
    try {
      _iso.kill(priority: Isolate.immediate);
    } catch (_) {}
    try {
      _receive.close();
    } catch (_) {}
  }
}

class CancelledScan implements Exception {}

const int _cloudFinishTimeoutMs = 25000;

Future<HeadlessScanResult> runHeadlessScan({
  required ScanMode mode,
  bool useCloud = false,
  bool quarantine = true,
  bool recordReport = true,
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

  try {
    await ScanLogListener.ensureStarted();
  } catch (_) {}
  ScanLogListener.setHandler((path, entry) {
    onEvent?.call(HeadlessScanEvent('entry', mode: mode, path: path, name: path.split('/').last, entryName: entry));
  });

  final ex = ExclusionService();
  await ex.load();

  final detections = <HeadlessDetection>[];
  int scanned = 0;
  int cleanCount = 0;
  int total = 0;
  bool cancelled = false;

  HeadlessScanWorker? worker;
  try {
    worker = await HeadlessScanWorker.spawn(token);
  } catch (e) {
    onEvent?.call(
      HeadlessScanEvent('err', mode: mode, message: 'Scan worker init failed: $e'),
    );
    worker = null;
  }

  HashCacheWorker? hashWorker;
  bool cloudActive = false;
  final nameByPath = <String, String>{};
  setEngineCloudEnabled(useCloud);

  if (useCloud) {
    try {
      final dir = await getApplicationDocumentsDirectory();
      setEngineDataDir(dir.path);
      hashWorker = await HashCacheWorker.spawn('${dir.path}/hashcache.bin');
      if (await _isOnline()) {
        cloudActive = engineCloudBegin() == 0;
      }
    } catch (e) {
      onEvent?.call(
        HeadlessScanEvent('err', mode: mode, message: 'Cloud init failed: $e'),
      );
      cloudActive = false;
    }
  }

  bool _cancelled() => isCancelled?.call() == true;

  void _throwIfCancelled() {
    if (_cancelled()) {
      cancelled = true;
      throw CancelledScan();
    }
  }

  void _emitProgress({required String path, required String name}) {
    onEvent?.call(
      HeadlessScanEvent('progress', mode: mode, path: path, name: name, scanned: scanned, total: total > 0 ? total : null),
    );
  }

  Future<(String?, int)> _prepareDetectedFile(String path) async {
    int apkSize = 0;
    try {
      apkSize = await File(path).length();
    } catch (_) {}

    String? quarantinePath;
    if (quarantine && QuarantineService.canQuarantinePath(path)) {
      try {
        final meta = await QuarantineService.quarantineFile(path);
        final qPath = meta['qPath'];
        final size = meta['size'];
        if (qPath is String && qPath.isNotEmpty) quarantinePath = qPath;
        if (size is num) apkSize = size.toInt();
      } catch (e) {
        onEvent?.call(HeadlessScanEvent('err', mode: mode, path: path, message: 'Quarantine failed: $e'));
      }
    }

    return (quarantinePath, apkSize);
  }

  Future<void> _scanResolvedTarget({
    required String path,
    required String displayName,
    required bool respectFolderExclusions,
    required bool respectShaExclusions,
  }) async {
    if (respectFolderExclusions && ex.skipFolder(path)) return;
    _throwIfCancelled();
    nameByPath[path] = displayName;

    onEvent?.call(
      HeadlessScanEvent('current', mode: mode, path: path, name: displayName, scanned: scanned, total: total > 0 ? total : null),
    );

    scanned++;
    _emitProgress(path: path, name: displayName);

    bool infected = false;
    String label = 'Suspicious.Item';
    double confidence = 0.0;
    List<String> signals = const [];

    _throwIfCancelled();

    if (!infected && worker != null) {
      try {
        final raw = await worker!.scanRaw(path);
        _throwIfCancelled();

        if (raw == null || raw.isEmpty) {
          cleanCount++;
          onEvent?.call(
            HeadlessScanEvent('clean', mode: mode, path: path, name: displayName, scanned: scanned, total: total > 0 ? total : null),
          );
          return;
        }

        final decoded = jsonDecode(raw);
        final hits = decoded['hits'] as Map?;
        if (hits == null || hits.isEmpty) {
          cleanCount++;
          onEvent?.call(
            HeadlessScanEvent('clean', mode: mode, path: path, name: displayName, scanned: scanned, total: total > 0 ? total : null),
          );
          return;
        }

        final sigs = <String>[];
        for (final v in hits.values) {
          if (v is List) {
            for (final s in v) {
              if (s is String) sigs.add(s);
            }
          }
        }

        signals = sigs;

        if (isHashSignal(signals)) {
          label = structuredHashLabel(path);
          confidence = 1.0;
        } else {
          final signature = signals.firstWhere(
                (s) => !s.startsWith('ML_Detection(') && s != 'HashMatch' && !s.startsWith('SignerMatch('),
            orElse: () => '',
          );

          if (signature.isNotEmpty) {
            confidence = 0.95;
            label = structuredSignatureLabel(signature);
          } else if (isMlSignal(signals)) {
            label = 'Andr/VXgen2';
            confidence = 0.80;
          } else {
            label = 'Suspicious.Item';
            confidence = 0.70;
          }
        }

        infected = true;
      } catch (e) {
        if (e is CancelledScan) rethrow;
        onEvent?.call(
          HeadlessScanEvent('err', mode: mode, path: path, name: displayName, message: 'Local scan failed: $e'),
        );
        cleanCount++;
        onEvent?.call(
          HeadlessScanEvent('clean', mode: mode, path: path, name: displayName, scanned: scanned, total: total > 0 ? total : null),
        );
        return;
      }
    }

    _throwIfCancelled();

    if (!infected) {
      cleanCount++;
      onEvent?.call(
        HeadlessScanEvent('clean', mode: mode, path: path, name: displayName, scanned: scanned, total: total > 0 ? total : null),
      );
      return;
    }

    final detection = HeadlessDetection(path: path, name: displayName, label: label, confidence: confidence, signals: signals);
    detections.add(detection);

    final prepared = await _prepareDetectedFile(path);

    onEvent?.call(
      HeadlessScanEvent('hit', mode: mode, path: path, name: displayName, scanned: scanned, total: total > 0 ? total : null, label: label, confidence: confidence, signals: signals, quarantinePath: prepared.$1, apkSize: prepared.$2),
    );
  }

  Future<void> _scanInstalledTarget(_HeadlessTarget target) async {
    _throwIfCancelled();
    nameByPath[target.path] = target.name;

    onEvent?.call(
      HeadlessScanEvent('current', mode: mode, path: target.path, name: target.name, scanned: scanned, total: total > 0 ? total : null),
    );

    scanned++;
    _emitProgress(path: target.path, name: target.name);

    if (ex.skipFolder(target.path)) return;

    bool infected = false;
    String label = 'Suspicious.Item';
    double confidence = 0.0;
    List<String> signals = const [];

    _throwIfCancelled();

    if (!infected && worker != null) {
      try {
        final raw = await worker!.scanRaw(target.path);
        _throwIfCancelled();

        if (raw == null || raw.isEmpty) {
          cleanCount++;
          onEvent?.call(HeadlessScanEvent('clean', mode: mode, path: target.path, name: target.name, scanned: scanned, total: total > 0 ? total : null));
          return;
        }

        final decoded = jsonDecode(raw);
        final hits = decoded['hits'] as Map?;
        if (hits == null || hits.isEmpty) {
          cleanCount++;
          onEvent?.call(HeadlessScanEvent('clean', mode: mode, path: target.path, name: target.name, scanned: scanned, total: total > 0 ? total : null));
          return;
        }

        final sigs = <String>[];
        for (final v in hits.values) {
          if (v is List) {
            for (final s in v) {
              if (s is String) sigs.add(s);
            }
          }
        }

        signals = sigs;

        if (isHashSignal(signals)) {
          label = structuredHashLabel(target.path);
          confidence = 1.0;
        } else {
          final signature = signals.firstWhere(
                (s) => !s.startsWith('ML_Detection(') && s != 'HashMatch' && !s.startsWith('SignerMatch('),
            orElse: () => '',
          );

          if (signature.isNotEmpty) {
            confidence = 0.95;
            label = structuredSignatureLabel(signature);
          } else if (isMlSignal(signals)) {
            label = 'Andr/VXgen2';
            confidence = 0.80;
          } else {
            label = 'Suspicious.Item';
            confidence = 0.70;
          }
        }

        infected = true;
      } catch (e) {
        if (e is CancelledScan) rethrow;
        onEvent?.call(HeadlessScanEvent('err', mode: mode, path: target.path, name: target.name, message: 'Local scan failed: $e'));
        cleanCount++;
        onEvent?.call(HeadlessScanEvent('clean', mode: mode, path: target.path, name: target.name, scanned: scanned, total: total > 0 ? total : null));
        return;
      }
    }

    _throwIfCancelled();

    if (!infected) {
      cleanCount++;
      onEvent?.call(HeadlessScanEvent('clean', mode: mode, path: target.path, name: target.name, scanned: scanned, total: total > 0 ? total : null));
      return;
    }

    final detection = HeadlessDetection(path: target.path, name: target.name, label: label, confidence: confidence, signals: signals);
    detections.add(detection);

    final prepared = await _prepareDetectedFile(target.path);

    onEvent?.call(HeadlessScanEvent('hit', mode: mode, path: target.path, name: target.name, scanned: scanned, total: total > 0 ? total : null, label: label, confidence: confidence, signals: signals, quarantinePath: prepared.$1, apkSize: prepared.$2));
  }

  Future<void> _runFullFolderDrivenScan() async {
    final root = Directory('/storage/emulated/0');

    onEvent?.call(HeadlessScanEvent('start', mode: mode, scanned: 0, total: null));
    onEvent?.call(HeadlessScanEvent('enumerated', mode: mode, scanned: 0, total: null));

    if (!await root.exists()) return;

    await for (final e in root.list(recursive: true, followLinks: false).handleError((error) {
      if (error is PathAccessException) return;
      if (error is FileSystemException) return;
      throw error;
    })) {
      _throwIfCancelled();
      if (e is! File) continue;

      final path = e.path;
      final name = path.split('/').last;
      nameByPath[path] = name;

      onEvent?.call(HeadlessScanEvent('current', mode: mode, path: path, name: name, scanned: scanned, total: null));

      scanned++;
      _emitProgress(path: path, name: name);

      if (worker == null) continue;

      try {
        final raw = await worker!.scanRaw(path);
        _throwIfCancelled();

        if (raw == null || raw.isEmpty) {
          cleanCount++;
          onEvent?.call(HeadlessScanEvent('clean', mode: mode, path: path, name: name, scanned: scanned, total: null));
          continue;
        }

        final decoded = jsonDecode(raw);
        final hits = decoded['hits'] as Map?;
        if (hits == null || hits.isEmpty) {
          cleanCount++;
          onEvent?.call(HeadlessScanEvent('clean', mode: mode, path: path, name: name, scanned: scanned, total: null));
          continue;
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

        if (isHashSignal(signals)) {
          label = structuredHashLabel(path);
          confidence = 1.0;
        } else {
          final signature = signals.firstWhere(
                (s) => !s.startsWith('ML_Detection(') && s != 'HashMatch' && !s.startsWith('SignerMatch('),
            orElse: () => '',
          );

          if (signature.isNotEmpty) {
            confidence = 0.95;
            label = structuredSignatureLabel(signature);
          } else if (isMlSignal(signals)) {
            label = 'Andr/VXgen2';
            confidence = 0.80;
          } else {
            label = 'Suspicious.Item';
            confidence = 0.70;
          }
        }

        final detection = HeadlessDetection(path: path, name: name, label: label, confidence: confidence, signals: signals);
        detections.add(detection);

        final prepared = await _prepareDetectedFile(path);

        onEvent?.call(HeadlessScanEvent('hit', mode: mode, path: path, name: name, scanned: scanned, total: null, label: label, confidence: confidence, signals: signals, quarantinePath: prepared.$1, apkSize: prepared.$2));
      } catch (e) {
        if (e is CancelledScan) rethrow;
        onEvent?.call(HeadlessScanEvent('err', mode: mode, path: path, name: name, message: 'Local scan failed: $e'));
      }
    }
  }

  try {
    onEvent?.call(HeadlessScanEvent('start', mode: mode, scanned: 0, total: null));
    _throwIfCancelled();

    if (mode == ScanMode.installed) {
      final apps = await _listInstalledAppTargets(onEvent: onEvent);
      total = apps.length;

      onEvent?.call(HeadlessScanEvent(apps.isEmpty ? 'empty' : 'enumerated', mode: mode, scanned: 0, total: total));

      for (final target in apps) {
        _throwIfCancelled();
        await _scanInstalledTarget(target);
      }
    } else if (mode == ScanMode.rapid) {
      final files = <_HeadlessTarget>[];
      final dir = Directory('/storage/emulated/0/Download');

      if (await dir.exists()) {
        await for (final e in _safeList(dir, recursive: true)) {
          _throwIfCancelled();
          if (e is! File) continue;

          final path = e.path;
          if (ex.skipFolder(path)) continue;

          final ext = _ext(path);
          if (ext != 'apk') continue;

          final size = await _safeLength(e);
          if (size < 0 || size > 200 * 1024 * 1024) continue;

          files.add(_HeadlessTarget(path: path, name: path.split('/').last));
        }
      }

      total = files.length;
      onEvent?.call(HeadlessScanEvent(files.isEmpty ? 'empty' : 'enumerated', mode: mode, scanned: 0, total: total));

      if (files.isNotEmpty) {
        if (cloudActive) {
          onEvent?.call(HeadlessScanEvent('stage_change', mode: mode, message: 'Stage 1: Local Scan'));
        }

        for (final target in files) {
          _throwIfCancelled();
          await _scanResolvedTarget(
            path: target.path,
            displayName: target.name,
            respectFolderExclusions: true,
            respectShaExclusions: true,
          );
        }
      }
    } else if (mode == ScanMode.smart) {
      final root = Directory('/storage/emulated/0/');
      final folders = <String>[];

      if (await root.exists()) {
        await for (final e in _safeList(root)) {
          _throwIfCancelled();
          if (e is Directory) {
            final name = e.path.split('/').last.toLowerCase();
            if (name == 'android' || name == 'music' || name == 'movies' || name == 'podcasts' || name == 'ringtones' || name == 'alarms' || name == 'notifications') continue;
            folders.add(e.path);
          }
        }
      }

      final allFiles = <_HeadlessTarget>[];

      for (final dirPath in folders) {
        _throwIfCancelled();
        final dir = Directory(dirPath);
        if (!await dir.exists()) continue;

        await for (final entity in _safeList(dir, recursive: true)) {
          _throwIfCancelled();
          if (entity is! File) continue;

          final path = entity.path;
          if (ex.skipFolder(path)) continue;

          final ext = _ext(path);
          final size = await _safeLength(entity);
          if (size < 0) continue;
          if (!isAllowedScanFile(ext, size)) continue;

          allFiles.add(_HeadlessTarget(path: path, name: path.split('/').last));
        }
      }

      allFiles.sort((a, b) {
        final aIsApk = _ext(a.path) == 'apk';
        final bIsApk = _ext(b.path) == 'apk';
        if (aIsApk && !bIsApk) return 1;
        if (!aIsApk && bIsApk) return -1;
        try {
          return File(a.path).lengthSync().compareTo(File(b.path).lengthSync());
        } catch (_) {
          return 0;
        }
      });

      final nonApkFiles = allFiles.where((f) => _ext(f.path) != 'apk').toList();
      final apkFiles    = allFiles.where((f) => _ext(f.path) == 'apk').toList();

      total = allFiles.length;
      onEvent?.call(HeadlessScanEvent(allFiles.isEmpty ? 'empty' : 'enumerated', mode: mode, scanned: 0, total: total));

      if (allFiles.isNotEmpty) {
        if (cloudActive) {
          onEvent?.call(HeadlessScanEvent('stage_change', mode: mode, message: 'Stage 1: Local Scan'));
        }

        for (final target in nonApkFiles) {
          _throwIfCancelled();
          await _scanResolvedTarget(path: target.path, displayName: target.name, respectFolderExclusions: true, respectShaExclusions: true);
        }

        for (final target in apkFiles) {
          _throwIfCancelled();
          await _scanResolvedTarget(path: target.path, displayName: target.name, respectFolderExclusions: true, respectShaExclusions: true);
        }
      }
    } else if (mode == ScanMode.full) {
      await _runFullFolderDrivenScan();
    } else {
      final root = Directory('/storage/emulated/0');

      onEvent?.call(HeadlessScanEvent('enumerated', mode: mode, scanned: 0, total: null));

      if (await root.exists()) {
        await for (final e in root.list(recursive: true, followLinks: false).handleError((error) {
          if (error is PathAccessException) return;
          if (error is FileSystemException) return;
          throw error;
        })) {
          _throwIfCancelled();
          if (e is! File) continue;
          await _scanResolvedTarget(path: e.path, displayName: e.path.split('/').last, respectFolderExclusions: false, respectShaExclusions: false);
        }
      }
    }
  } catch (e) {
    if (e is! CancelledScan) {
      onEvent?.call(HeadlessScanEvent('err', mode: mode, message: 'Enumeration failed: $e'));
    }
  } finally {
    try {
      worker?.requestClose();
    } catch (_) {}
  }

  if (cloudActive) {
    if (cancelled) {
      try {
        await engineCloudFinishAsync(0);
      } catch (_) {}
    } else {
      onEvent?.call(HeadlessScanEvent('stage_change', mode: mode, message: 'Stage 2: Cloud Verification'));
      try {
        final raw = await engineCloudFinishAsync(_cloudFinishTimeoutMs);
        final decoded = jsonDecode(raw);
        if (decoded is Map && decoded['state'] == 'timeout') {
          onEvent?.call(HeadlessScanEvent('err', mode: mode, message: 'Cloud verification timed out, using local results'));
        }
        final results = decoded is Map ? decoded['results'] : null;
        if (results is List) {
          for (final r in results) {
            if (r is! Map) continue;
            final path = (r['path'] ?? '').toString();
            if (path.isEmpty) continue;
            final cloudLabel = (r['label'] ?? 'Cloud.Molecule').toString();

            if (hashWorker != null) {
              try {
                final hashes = (await hashWorker.hashBatch([path]))[path];
                final sha = hashes?['sha'] ?? '';
                if (sha.isNotEmpty && ex.skipSha(sha)) continue;
              } catch (_) {}
            }

            final name = nameByPath[path] ?? _displayName(path);
            if (cleanCount > 0) cleanCount--;
            onEvent?.call(HeadlessScanEvent('unclean', mode: mode, path: path, name: name));

            final isHash = cloudLabel == 'Cloud.Hash';
            final hitLabel = isHash ? structuredHashLabel(path) : cloudLabel;
            final hitConfidence = isHash ? 1.0 : 0.80;
            final hitSignals = isHash ? const ['HashMatch'] : const ['CloudMolecule'];
            detections.add(HeadlessDetection(path: path, name: name, label: hitLabel, confidence: hitConfidence, signals: hitSignals));
            final prepared = await _prepareDetectedFile(path);
            onEvent?.call(HeadlessScanEvent('hit', mode: mode, path: path, name: name, scanned: scanned, total: total > 0 ? total : null, label: hitLabel, confidence: hitConfidence, signals: hitSignals, quarantinePath: prepared.$1, apkSize: prepared.$2));
          }
        }
      } catch (e) {
        onEvent?.call(HeadlessScanEvent('err', mode: mode, message: 'Cloud verification failed: $e'));
      }
    }
  }

  if (hashWorker != null) {
    try {
      await hashWorker.flush();
    } catch (e) {
      onEvent?.call(HeadlessScanEvent('err', mode: mode, message: 'Hash flush failed: $e'));
    }
  }

  try {
    await CacheManager.clearAll();
  } catch (_) {}

  sw.stop();
  ScanLogListener.setHandler(null);

  if (recordReport) {
    await recordManualReportEvent(scanned: scanned, threats: detections.length, cancelled: cancelled);
  }

  onEvent?.call(HeadlessScanEvent('done', mode: mode, scanned: scanned, total: total > 0 ? total : null, message: cancelled ? 'cancelled' : null));

  return HeadlessScanResult(mode: mode, scanned: scanned, threats: detections.length, clean: cleanCount, total: total, cancelled: cancelled, duration: sw.elapsed, detections: detections);
}

Future<List<_HeadlessTarget>> _listInstalledAppTargets({
  void Function(HeadlessScanEvent e)? onEvent,
}) async {
  try {
    const MethodChannel ch = MethodChannel("cs.fastapps");
    final List<dynamic> raw = await ch.invokeMethod("listUserApps");
    return raw.map((e) {
      final map = Map<String, dynamic>.from(e);
      return _HeadlessTarget(
        path: (map['path'] ?? '').toString(),
        name: (map['name'] ?? 'Unknown').toString(),
        pkg: (map['package'] ?? '').toString(),
      );
    }).where((e) => e.path.isNotEmpty).toList();
  } catch (e) {
    onEvent?.call(
      HeadlessScanEvent(
        'err',
        message: 'listUserApps failed: $e',
      ),
    );
    return [];
  }
}

String _displayName(String path) {
  try {
    return path.split('/').last;
  } catch (_) {
    return path;
  }
}

Stream<FileSystemEntity> _safeList(Directory dir, {bool recursive = false}) {
  return dir.list(recursive: recursive, followLinks: false).handleError((error) {
    if (error is FileSystemException) return;
    throw error;
  });
}

Future<int> _safeLength(File f) async {
  try {
    return await f.length();
  } catch (_) {
    return -1;
  }
}

String _ext(String path) {
  final name = path.split('/').last;
  final dot = name.lastIndexOf('.');
  if (dot <= 0) return '';
  return name.substring(dot + 1).toLowerCase();
}

Future<bool> _isOnline() async {
  try {
    final result = await InternetAddress.lookup('api.colourswift.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}

Future<void> recordManualReportEvent({
  required int scanned,
  required int threats,
  required bool cancelled,
}) async {
  if (cancelled) return;

  final prefs = await SharedPreferences.getInstance();
  final now = DateTime.now().millisecondsSinceEpoch;

  await prefs.setInt(
    'security_report_manual_scans_total',
    (prefs.getInt('security_report_manual_scans_total') ?? 0) + 1,
  );

  await prefs.setInt(
    'security_report_files_scanned_total',
    (prefs.getInt('security_report_files_scanned_total') ?? 0) + scanned,
  );

  await prefs.setInt(
    'security_report_threats_total',
    (prefs.getInt('security_report_threats_total') ?? 0) + threats,
  );

  await prefs.setInt('security_report_last_manual_scan_at', now);
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
    'clean': r.clean,
    'total': r.total,
    'cancelled': r.cancelled,
    'duration_ms': r.duration.inMilliseconds,
  };
}