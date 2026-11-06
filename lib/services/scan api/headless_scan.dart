import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
import 'package:crypto/crypto.dart' as crypto;

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
  final int size;

  _HeadlessTarget({
    required this.path,
    required this.name,
    this.pkg = '',
    this.size = 0,
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
  String? customRoot,
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

  final laneCount = await _scanLaneCount();
  final spawned = await Future.wait(List.generate(
    laneCount,
    (_) => HeadlessScanWorker.spawn(token).then<HeadlessScanWorker?>((w) => w, onError: (Object e) {
      onEvent?.call(
        HeadlessScanEvent('err', mode: mode, message: 'Scan worker init failed: $e'),
      );
      return null;
    }),
  ));
  final workers = spawned.whereType<HeadlessScanWorker>().toList();
  final HeadlessScanWorker? worker = workers.isEmpty ? null : workers.first;
  _InstalledVerdictCache? verdictCache;

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

  Future<bool> _isShaExcluded(String path) async {
    if (ex.shas.isEmpty) return false;
    try {
      final worker = hashWorker;
      var sha = worker == null ? '' : ((await worker.hashBatch([path]))[path]?['sha'] ?? '');
      if (sha.isEmpty) sha = (await crypto.sha256.bind(File(path).openRead()).first).toString();
      return ex.skipSha(sha);
    } catch (_) {
      return false;
    }
  }

  Future<void> _scanResolvedTarget({
    required String path,
    required String displayName,
    required bool respectFolderExclusions,
    required bool respectShaExclusions,
    required HeadlessScanWorker? w,
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

    if (!infected && w != null) {
      try {
        final raw = await w.scanRaw(path);
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

        if (respectShaExclusions && await _isShaExcluded(path)) {
          cleanCount++;
          onEvent?.call(
            HeadlessScanEvent('clean', mode: mode, path: path, name: displayName, scanned: scanned, total: total > 0 ? total : null),
          );
          return;
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

  Future<void> _scanInstalledTarget(_HeadlessTarget target, HeadlessScanWorker? w) async {
    _throwIfCancelled();
    nameByPath[target.path] = target.name;

    onEvent?.call(
      HeadlessScanEvent('current', mode: mode, path: target.path, name: target.name, scanned: scanned, total: total > 0 ? total : null),
    );

    scanned++;
    _emitProgress(path: target.path, name: target.name);

    if (ex.skipFolder(target.path)) return;

    final stat = verdictCache == null ? null : await _InstalledVerdictCache.statOf(target.path);
    final cachedSha = verdictCache?.cleanSha(target.path, stat);
    if (cachedSha != null) {
      if (cloudActive && cachedSha.isNotEmpty) engineCloudEnqueue(target.path, cachedSha);
      cleanCount++;
      onEvent?.call(HeadlessScanEvent('clean', mode: mode, path: target.path, name: target.name, scanned: scanned, total: total > 0 ? total : null));
      return;
    }

    bool infected = false;
    String label = 'Suspicious.Item';
    double confidence = 0.0;
    List<String> signals = const [];

    _throwIfCancelled();

    if (!infected && w != null) {
      try {
        final raw = await w.scanRaw(target.path);
        _throwIfCancelled();

        if (raw == null || raw.isEmpty) {
          cleanCount++;
          onEvent?.call(HeadlessScanEvent('clean', mode: mode, path: target.path, name: target.name, scanned: scanned, total: total > 0 ? total : null));
          return;
        }

        final decoded = jsonDecode(raw);
        final hits = decoded['hits'] as Map?;
        if (hits == null || hits.isEmpty) {
          if (decoded is Map && decoded.containsKey('scanned')) {
            verdictCache?.putClean(target.path, stat, (decoded['sha256'] ?? '').toString());
          }
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

        if (await _isShaExcluded(target.path)) {
          cleanCount++;
          onEvent?.call(HeadlessScanEvent('clean', mode: mode, path: target.path, name: target.name, scanned: scanned, total: total > 0 ? total : null));
          return;
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

  Future<void> _runPool<T>(List<T> items, Future<void> Function(T item, HeadlessScanWorker? w) scanOne) async {
    var next = 0;
    Future<void> lane(HeadlessScanWorker? w) async {
      while (next < items.length) {
        _throwIfCancelled();
        final item = items[next++];
        await scanOne(item, w);
      }
    }

    await Future.wait(workers.isEmpty ? [lane(null)] : [for (final w in workers) lane(w)]);
  }

  Future<void> _runFullFolderDrivenScan() async {
    onEvent?.call(HeadlessScanEvent('start', mode: mode, scanned: 0, total: null));
    onEvent?.call(HeadlessScanEvent('enumerated', mode: mode, scanned: 0, total: null));

    for (final storage in await listStorageRoots()) {
      final root = Directory(storage.path);
      if (!await root.exists()) continue;

      await for (final e in root.list(recursive: true, followLinks: false).handleError((error) {
        if (error is PathAccessException) return;
        if (error is FileSystemException) return;
        throw error;
      })) {
        _throwIfCancelled();
        if (e is! File) continue;

        final path = e.path;
        if (ex.skipFolder(path)) continue;
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

          if (await _isShaExcluded(path)) {
            cleanCount++;
            onEvent?.call(HeadlessScanEvent('clean', mode: mode, path: path, name: name, scanned: scanned, total: null));
            continue;
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
  }

  try {
    onEvent?.call(HeadlessScanEvent('start', mode: mode, scanned: 0, total: null));
    _throwIfCancelled();

    if (mode == ScanMode.installed) {
      final apps = await _listInstalledAppTargets(onEvent: onEvent);
      total = apps.length;

      onEvent?.call(HeadlessScanEvent(apps.isEmpty ? 'empty' : 'enumerated', mode: mode, scanned: 0, total: total));

      verdictCache = await _InstalledVerdictCache.open();
      await _runPool(apps, _scanInstalledTarget);
    } else if (mode == ScanMode.rapid) {
      final files = <_HeadlessTarget>[];

      for (final storage in await listStorageRoots()) {
        final dir = Directory('${storage.path}/Download');
        if (!await dir.exists()) continue;
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

        await _runPool(files, (target, w) => _scanResolvedTarget(
              path: target.path,
              displayName: target.name,
              respectFolderExclusions: true,
              respectShaExclusions: true,
              w: w,
            ));
      }
    } else if (mode == ScanMode.smart) {
      final filesFuture = _enumerateSmartFiles(ex, _cancelled);

      onEvent?.call(HeadlessScanEvent('stage_change', mode: mode, message: 'Stage 1: Installed Apps'));
      final apps = await _listInstalledAppTargets(onEvent: onEvent);
      total = apps.length;
      if (apps.isNotEmpty) {
        onEvent?.call(HeadlessScanEvent('enumerated', mode: mode, scanned: scanned, total: total));
      }
      verdictCache = await _InstalledVerdictCache.open();
      await _runPool(apps, _scanInstalledTarget);

      final files = await filesFuture;
      _throwIfCancelled();
      total = apps.length + files.length;
      onEvent?.call(HeadlessScanEvent(total == 0 ? 'empty' : 'enumerated', mode: mode, scanned: scanned, total: total));

      if (files.isNotEmpty) {
        onEvent?.call(HeadlessScanEvent('stage_change', mode: mode, message: 'Stage 2: Files'));
        final nonApkFiles = files.where((f) => _ext(f.path) != 'apk').toList();
        final apkFiles = files.where((f) => _ext(f.path) == 'apk').toList();
        await _runPool(nonApkFiles, (target, w) => _scanResolvedTarget(path: target.path, displayName: target.name, respectFolderExclusions: true, respectShaExclusions: true, w: w));
        await _runPool(apkFiles, (target, w) => _scanResolvedTarget(path: target.path, displayName: target.name, respectFolderExclusions: true, respectShaExclusions: true, w: w));
      }
    } else if (mode == ScanMode.full) {
      await _runFullFolderDrivenScan();
    } else if (mode == ScanMode.custom) {
      final files = <_HeadlessTarget>[];
      final dir = Directory(customRoot ?? '');

      if (customRoot != null && await dir.exists()) {
        await for (final e in _safeList(dir, recursive: true)) {
          _throwIfCancelled();
          if (e is! File) continue;
          if (ex.skipFolder(e.path)) continue;
          files.add(_HeadlessTarget(path: e.path, name: e.path.split('/').last));
        }
      }

      final ordered = [
        ...files.where((f) => _ext(f.path) != 'apk'),
        ...files.where((f) => _ext(f.path) == 'apk'),
      ];

      total = ordered.length;
      onEvent?.call(HeadlessScanEvent(ordered.isEmpty ? 'empty' : 'enumerated', mode: mode, scanned: 0, total: total));

      if (ordered.isNotEmpty && cloudActive) {
        onEvent?.call(HeadlessScanEvent('stage_change', mode: mode, message: 'Stage 1: Local Scan'));
      }

      await _runPool(ordered, (target, w) => _scanResolvedTarget(path: target.path, displayName: target.name, respectFolderExclusions: true, respectShaExclusions: true, w: w));
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
          await _scanResolvedTarget(path: e.path, displayName: e.path.split('/').last, respectFolderExclusions: false, respectShaExclusions: false, w: worker);
        }
      }
    }
  } catch (e) {
    if (e is! CancelledScan) {
      onEvent?.call(HeadlessScanEvent('err', mode: mode, message: 'Enumeration failed: $e'));
    }
  } finally {
    for (final w in workers) {
      try {
        w.requestClose();
      } catch (_) {}
    }
    await verdictCache?.save(prune: !cancelled);
  }

  if (cloudActive) {
    if (cancelled) {
      try {
        await engineCloudFinishAsync(0);
      } catch (_) {}
    } else {
      onEvent?.call(HeadlessScanEvent('stage_change', mode: mode, message: mode == ScanMode.smart ? 'Stage 3: Cloud Verification' : 'Stage 2: Cloud Verification'));
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
            final hitLabel = 'Detected';
            final hitConfidence = 1.0;
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

  enginePurge();

  sw.stop();
  ScanLogListener.setHandler(null);

  if (recordReport) {
    await recordManualReportEvent(scanned: scanned, threats: detections.length, cancelled: cancelled);
  }

  onEvent?.call(HeadlessScanEvent('done', mode: mode, scanned: scanned, total: total > 0 ? total : null, message: cancelled ? 'cancelled' : null));

  return HeadlessScanResult(mode: mode, scanned: scanned, threats: detections.length, clean: cleanCount, total: total, cancelled: cancelled, duration: sw.elapsed, detections: detections);
}

class StorageRoot {
  final String path;
  final bool removable;
  final String label;

  const StorageRoot(this.path, this.removable, this.label);
}

final RegExp _volumeDirName = RegExp(r'^([0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}|[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})$');

Future<List<StorageRoot>> listStorageRoots() async {
  try {
    final raw = await const MethodChannel('colourswift/storage_permission').invokeMethod<List<dynamic>>('listStorageRoots');
    final roots = [
      for (final r in raw ?? const [])
        if (r is Map && r['path'] is String) StorageRoot(r['path'] as String, r['removable'] == true, (r['label'] ?? '').toString()),
    ];
    if (roots.isNotEmpty) return roots;
  } catch (_) {}
  final roots = [const StorageRoot('/storage/emulated/0', false, '')];
  try {
    await for (final e in Directory('/storage').list(followLinks: false)) {
      final name = e.path.split('/').last;
      if (e is Directory && _volumeDirName.hasMatch(name)) roots.add(StorageRoot(e.path, true, ''));
    }
  } catch (_) {}
  return roots;
}

Future<List<_HeadlessTarget>> _enumerateSmartFiles(ExclusionService ex, bool Function() cancelled) async {
  const skipDirs = {'android', 'music', 'movies', 'podcasts', 'ringtones', 'alarms', 'notifications'};
  final out = <_HeadlessTarget>[];
  try {
    for (final storage in await listStorageRoots()) {
      final root = Directory(storage.path);
      if (!await root.exists()) continue;
      final folders = <String>[];
      await for (final e in _safeList(root)) {
        if (cancelled()) return out;
        if (e is Directory && !skipDirs.contains(e.path.split('/').last.toLowerCase())) folders.add(e.path);
      }
      for (final dirPath in folders) {
        await for (final entity in _safeList(Directory(dirPath), recursive: true)) {
          if (cancelled()) return out;
          if (entity is! File) continue;
          final path = entity.path;
          if (ex.skipFolder(path)) continue;
          final size = await _safeLength(entity);
          if (size < 0 || !isAllowedScanFile(_ext(path), size)) continue;
          out.add(_HeadlessTarget(path: path, name: path.split('/').last, size: size));
        }
      }
    }
  } catch (_) {}
  out.sort((a, b) => a.size.compareTo(b.size));
  return out;
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

Future<int> _scanLaneCount() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getInt('scan_limits_max_concurrent') ?? 2;
    return v < 1 ? 1 : (v > 4 ? 4 : v);
  } catch (_) {
    return 1;
  }
}

class _InstalledVerdictCache {
  final File _file;
  final String _stamp;
  final Map<String, dynamic> _apps;
  final Set<String> _seen = {};
  bool _dirty = false;

  _InstalledVerdictCache._(this._file, this._stamp, this._apps);

  static Future<_InstalledVerdictCache?> open() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final defs = await File('${dir.path}/defs.cs').stat();
      final info = await PackageInfo.fromPlatform();
      final stamp = '${info.version}+${info.buildNumber}|${defs.size}|${defs.modified.millisecondsSinceEpoch}';
      final file = File('${dir.path}/installed_verdicts.json');
      var apps = <String, dynamic>{};
      if (await file.exists()) {
        final decoded = jsonDecode(await file.readAsString());
        if (decoded is Map && decoded['stamp'] == stamp && decoded['apps'] is Map) {
          apps = Map<String, dynamic>.from(decoded['apps'] as Map);
        }
      }
      return _InstalledVerdictCache._(file, stamp, apps);
    } catch (_) {
      return null;
    }
  }

  static Future<FileStat?> statOf(String path) async {
    try {
      final s = await File(path).stat();
      return s.type == FileSystemEntityType.notFound ? null : s;
    } catch (_) {
      return null;
    }
  }

  String? cleanSha(String path, FileStat? stat) {
    _seen.add(path);
    if (stat == null) return null;
    final e = _apps[path];
    if (e is! Map) return null;
    if (e['s'] != stat.size || e['m'] != stat.modified.millisecondsSinceEpoch || e['c'] != stat.changed.millisecondsSinceEpoch) {
      return null;
    }
    return (e['h'] ?? '').toString();
  }

  void putClean(String path, FileStat? stat, String sha) {
    if (stat == null) return;
    _apps[path] = {
      's': stat.size,
      'm': stat.modified.millisecondsSinceEpoch,
      'c': stat.changed.millisecondsSinceEpoch,
      'h': sha,
    };
    _dirty = true;
  }

  Future<void> save({required bool prune}) async {
    if (prune) {
      final before = _apps.length;
      _apps.removeWhere((k, _) => !_seen.contains(k));
      if (_apps.length != before) _dirty = true;
    }
    if (!_dirty) return;
    try {
      final tmp = File('${_file.path}.tmp');
      await tmp.writeAsString(jsonEncode({'stamp': _stamp, 'apps': _apps}), flush: true);
      await tmp.rename(_file.path);
      _dirty = false;
    } catch (_) {}
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