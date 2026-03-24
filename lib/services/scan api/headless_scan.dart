import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
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
      });
}

class _HeadlessTarget {
  final String path;
  final String name;

  _HeadlessTarget({
    required this.path,
    required this.name,
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
  int cleanCount = 0;
  int total = 0;
  bool cancelled = false;

  HeadlessScanWorker? worker;
  try {
    worker = await HeadlessScanWorker.spawn(token);
  } catch (e) {
    onEvent?.call(
      HeadlessScanEvent(
        'err',
        mode: mode,
        message: 'Scan worker init failed: $e',
      ),
    );
    worker = null;
  }

  HashCacheWorker? hashWorker;
  CloudScanner? cloud;

  if (useCloud && mode != ScanMode.full) {
    try {
      final dir = await getApplicationDocumentsDirectory();
      hashWorker = await HashCacheWorker.spawn('${dir.path}/hashcache.bin');
      cloud = CloudScanner(
        endpoint: 'https://efkou1u21ooih2hko.colourswift.com',
        apiKey: '23JVO3ojo23oO3O423rrTR',
      );
    } catch (e) {
      onEvent?.call(
        HeadlessScanEvent(
          'err',
          mode: mode,
          message: 'Cloud init failed: $e',
        ),
      );
      hashWorker = null;
      cloud = null;
    }
  }

  bool _cancelled() => isCancelled?.call() == true;

  void _throwIfCancelled() {
    if (_cancelled()) {
      cancelled = true;
      throw CancelledScan();
    }
  }

  void _emitProgress({
    required String path,
    required String name,
  }) {
    onEvent?.call(
      HeadlessScanEvent(
        'progress',
        mode: mode,
        path: path,
        name: name,
        scanned: scanned,
        total: total > 0 ? total : null,
      ),
    );
  }

  Future<void> _scanResolvedTarget({
    required String path,
    required String displayName,
    required bool allowCloud,
    required bool respectFolderExclusions,
    required bool respectShaExclusions,
  }) async {
    if (respectFolderExclusions && ex.skipFolder(path)) {
      return;
    }

    _throwIfCancelled();

    onEvent?.call(
      HeadlessScanEvent(
        'current',
        mode: mode,
        path: path,
        name: displayName,
        scanned: scanned,
        total: total > 0 ? total : null,
      ),
    );

    scanned++;
    _emitProgress(path: path, name: displayName);

    bool infected = false;
    String label = 'Suspicious.Item';
    double confidence = 0.0;
    List<String> signals = const [];

    if (allowCloud && hashWorker != null && cloud != null) {
      try {
        final hashesByPath = await hashWorker.hashBatch([path]);
        final hashes = hashesByPath[path];

        if (hashes != null) {
          final md5 = hashes['md5'] ?? '';
          final sha = hashes['sha'] ?? '';

          if (respectShaExclusions && sha.isNotEmpty && ex.skipSha(sha)) {
            return;
          }

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
        onEvent?.call(
          HeadlessScanEvent(
            'err',
            mode: mode,
            path: path,
            name: displayName,
            message: 'Cloud check failed: $e',
          ),
        );
      }
    }

    _throwIfCancelled();

    if (!infected && worker != null) {
      try {
        final raw = await worker!.scanRaw(path);
        _throwIfCancelled();

        if (raw == null || raw.isEmpty) {
          cleanCount++;
          onEvent?.call(
            HeadlessScanEvent(
              'clean',
              mode: mode,
              path: path,
              name: displayName,
              scanned: scanned,
              total: total > 0 ? total : null,
            ),
          );
          return;
        }

        final decoded = jsonDecode(raw);
        final hits = decoded['hits'] as Map?;
        if (hits == null || hits.isEmpty) {
          cleanCount++;
          onEvent?.call(
            HeadlessScanEvent(
              'clean',
              mode: mode,
              path: path,
              name: displayName,
              scanned: scanned,
              total: total > 0 ? total : null,
            ),
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
          } else if (signals.any((s) => s.startsWith('ML_Detection('))) {
            label = 'Generic.Suspicious';
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
          HeadlessScanEvent(
            'err',
            mode: mode,
            path: path,
            name: displayName,
            message: 'Local scan failed: $e',
          ),
        );
        cleanCount++;
        onEvent?.call(
          HeadlessScanEvent(
            'clean',
            mode: mode,
            path: path,
            name: displayName,
            scanned: scanned,
            total: total > 0 ? total : null,
          ),
        );
        return;
      }
    }

    _throwIfCancelled();

    if (!infected) {
      cleanCount++;
      onEvent?.call(
        HeadlessScanEvent(
          'clean',
          mode: mode,
          path: path,
          name: displayName,
          scanned: scanned,
          total: total > 0 ? total : null,
        ),
      );
      return;
    }

    final detection = HeadlessDetection(
      path: path,
      name: displayName,
      label: label,
      confidence: confidence,
      signals: signals,
    );

    detections.add(detection);

    if (quarantine) {
      try {
        await QuarantineService.quarantineFile(path);
      } catch (e) {
        onEvent?.call(
          HeadlessScanEvent(
            'err',
            mode: mode,
            path: path,
            name: displayName,
            message: 'Quarantine failed: $e',
          ),
        );
      }
    }

    onEvent?.call(
      HeadlessScanEvent(
        'hit',
        mode: mode,
        path: path,
        name: displayName,
        scanned: scanned,
        total: total > 0 ? total : null,
        label: label,
        confidence: confidence,
        signals: signals,
      ),
    );
  }

  Future<void> _scanInstalledTarget(_HeadlessTarget target) async {
    _throwIfCancelled();

    onEvent?.call(
      HeadlessScanEvent(
        'current',
        mode: mode,
        path: target.path,
        name: target.name,
        scanned: scanned,
        total: total > 0 ? total : null,
      ),
    );

    scanned++;
    _emitProgress(path: target.path, name: target.name);

    if (ex.skipFolder(target.path)) {
      return;
    }

    bool infected = false;
    String label = 'Suspicious.Item';
    double confidence = 0.0;
    List<String> signals = const [];

    if (useCloud && hashWorker != null && cloud != null) {
      try {
        final hashesByPath = await hashWorker.hashBatch([target.path]);
        final hashes = hashesByPath[target.path];

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
        onEvent?.call(
          HeadlessScanEvent(
            'err',
            mode: mode,
            path: target.path,
            name: target.name,
            message: 'Cloud check failed: $e',
          ),
        );
      }
    }

    _throwIfCancelled();

    if (!infected && worker != null) {
      try {
        final raw = await worker!.scanRaw(target.path);
        _throwIfCancelled();

        if (raw == null || raw.isEmpty) {
          cleanCount++;
          onEvent?.call(
            HeadlessScanEvent(
              'clean',
              mode: mode,
              path: target.path,
              name: target.name,
              scanned: scanned,
              total: total > 0 ? total : null,
            ),
          );
          return;
        }

        final decoded = jsonDecode(raw);
        final hits = decoded['hits'] as Map?;
        if (hits == null || hits.isEmpty) {
          cleanCount++;
          onEvent?.call(
            HeadlessScanEvent(
              'clean',
              mode: mode,
              path: target.path,
              name: target.name,
              scanned: scanned,
              total: total > 0 ? total : null,
            ),
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
          } else if (signals.any((s) => s.startsWith('ML_Detection('))) {
            label = 'Generic.Suspicious';
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
          HeadlessScanEvent(
            'err',
            mode: mode,
            path: target.path,
            name: target.name,
            message: 'Local scan failed: $e',
          ),
        );
        cleanCount++;
        onEvent?.call(
          HeadlessScanEvent(
            'clean',
            mode: mode,
            path: target.path,
            name: target.name,
            scanned: scanned,
            total: total > 0 ? total : null,
          ),
        );
        return;
      }
    }

    _throwIfCancelled();

    if (!infected) {
      cleanCount++;
      onEvent?.call(
        HeadlessScanEvent(
          'clean',
          mode: mode,
          path: target.path,
          name: target.name,
          scanned: scanned,
          total: total > 0 ? total : null,
        ),
      );
      return;
    }

    final detection = HeadlessDetection(
      path: target.path,
      name: target.name,
      label: label,
      confidence: confidence,
      signals: signals,
    );

    detections.add(detection);

    if (quarantine) {
      try {
        await QuarantineService.quarantineFile(target.path);
      } catch (e) {
        onEvent?.call(
          HeadlessScanEvent(
            'err',
            mode: mode,
            path: target.path,
            name: target.name,
            message: 'Quarantine failed: $e',
          ),
        );
      }
    }

    onEvent?.call(
      HeadlessScanEvent(
        'hit',
        mode: mode,
        path: target.path,
        name: target.name,
        scanned: scanned,
        total: total > 0 ? total : null,
        label: label,
        confidence: confidence,
        signals: signals,
      ),
    );
  }

  Future<void> _runFullFolderDrivenScan() async {
    final root = Directory('/storage/emulated/0');

    onEvent?.call(
      HeadlessScanEvent(
        'start',
        mode: mode,
        scanned: 0,
        total: null,
      ),
    );

    onEvent?.call(
      HeadlessScanEvent(
        'enumerated',
        mode: mode,
        scanned: 0,
        total: null,
      ),
    );

    if (!await root.exists()) {
      return;
    }

    await for (final e in root
        .list(recursive: true, followLinks: false)
        .handleError((error) {
      if (error is PathAccessException) return;
      if (error is FileSystemException) return;
      throw error;
    })) {
      _throwIfCancelled();
      if (e is! File) continue;

      final path = e.path;
      final name = path.split('/').last;

      onEvent?.call(
        HeadlessScanEvent(
          'current',
          mode: mode,
          path: path,
          name: name,
          scanned: scanned,
          total: null,
        ),
      );

      scanned++;
      _emitProgress(path: path, name: name);

      if (worker == null) {
        continue;
      }

      try {
        final raw = await worker!.scanRaw(path);
        _throwIfCancelled();

        if (raw == null || raw.isEmpty) {
          cleanCount++;
          onEvent?.call(
            HeadlessScanEvent(
              'clean',
              mode: mode,
              path: path,
              name: name,
              scanned: scanned,
              total: null,
            ),
          );
          continue;
        }

        final decoded = jsonDecode(raw);
        final hits = decoded['hits'] as Map?;
        if (hits == null || hits.isEmpty) {
          cleanCount++;
          onEvent?.call(
            HeadlessScanEvent(
              'clean',
              mode: mode,
              path: path,
              name: name,
              scanned: scanned,
              total: null,
            ),
          );
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
            } else {
              label = 'Suspicious.Item';
              confidence = 0.70;
            }
          }
        }

        final detection = HeadlessDetection(
          path: path,
          name: name,
          label: label,
          confidence: confidence,
          signals: signals,
        );

        detections.add(detection);

        if (quarantine) {
          try {
            await QuarantineService.quarantineFile(path);
          } catch (e) {
            onEvent?.call(
              HeadlessScanEvent(
                'err',
                mode: mode,
                path: path,
                name: name,
                message: 'Quarantine failed: $e',
              ),
            );
          }
        }

        onEvent?.call(
          HeadlessScanEvent(
            'hit',
            mode: mode,
            path: path,
            name: name,
            scanned: scanned,
            total: null,
            label: label,
            confidence: confidence,
            signals: signals,
          ),
        );
      } catch (e) {
        if (e is CancelledScan) rethrow;
        onEvent?.call(
          HeadlessScanEvent(
            'err',
            mode: mode,
            path: path,
            name: name,
            message: 'Local scan failed: $e',
          ),
        );
      }
    }
  }

  try {
    onEvent?.call(
      HeadlessScanEvent(
        'start',
        mode: mode,
        scanned: 0,
        total: null,
      ),
    );

    _throwIfCancelled();

    if (mode == ScanMode.installed) {
      final apps = await _listInstalledAppTargets(onEvent: onEvent);
      total = apps.length;

      onEvent?.call(
        HeadlessScanEvent(
          apps.isEmpty ? 'empty' : 'enumerated',
          mode: mode,
          scanned: 0,
          total: total,
        ),
      );

      for (final target in apps) {
        _throwIfCancelled();
        await _scanInstalledTarget(target);
      }
    } else if (mode == ScanMode.rapid) {
      final files = <_HeadlessTarget>[];
      final dir = Directory('/storage/emulated/0/Download');

      if (await dir.exists()) {
        await for (final e in dir.list(recursive: true, followLinks: false)) {
          _throwIfCancelled();
          if (e is! File) continue;

          final path = e.path;
          if (ex.skipFolder(path)) continue;

          final ext = _ext(path);
          if (ext != 'apk') continue;

          final size = await e.length();
          if (size > 200 * 1024 * 1024) continue;

          files.add(_HeadlessTarget(path: path, name: path.split('/').last));
        }
      }

      total = files.length;

      onEvent?.call(
        HeadlessScanEvent(
          files.isEmpty ? 'empty' : 'enumerated',
          mode: mode,
          scanned: 0,
          total: total,
        ),
      );

      for (final target in files) {
        _throwIfCancelled();
        await _scanResolvedTarget(
          path: target.path,
          displayName: target.name,
          allowCloud: useCloud,
          respectFolderExclusions: true,
          respectShaExclusions: false,
        );
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
                name == 'notifications') {
              continue;
            }
            folders.add(e.path);
          }
        }
      }

      final files = <_HeadlessTarget>[];

      for (final dirPath in folders) {
        _throwIfCancelled();

        final dir = Directory(dirPath);
        if (!await dir.exists()) continue;

        await for (final entity
        in dir.list(recursive: true, followLinks: false)) {
          _throwIfCancelled();
          if (entity is! File) continue;

          final path = entity.path;
          if (ex.skipFolder(path)) continue;

          final ext = _ext(path);
          final size = await entity.length();
          if (!_isAllowedSmart(ext, size)) continue;

          files.add(_HeadlessTarget(path: path, name: path.split('/').last));
        }
      }

      files.sort((a, b) {
        try {
          return File(a.path).lengthSync().compareTo(File(b.path).lengthSync());
        } catch (_) {
          return 0;
        }
      });

      total = files.length;

      onEvent?.call(
        HeadlessScanEvent(
          files.isEmpty ? 'empty' : 'enumerated',
          mode: mode,
          scanned: 0,
          total: total,
        ),
      );

      for (final target in files) {
        _throwIfCancelled();
        await _scanResolvedTarget(
          path: target.path,
          displayName: target.name,
          allowCloud: useCloud,
          respectFolderExclusions: true,
          respectShaExclusions: true,
        );
      }
    } else if (mode == ScanMode.full) {
      await _runFullFolderDrivenScan();
    } else {
      final root = Directory('/storage/emulated/0');

      onEvent?.call(
        HeadlessScanEvent(
          'enumerated',
          mode: mode,
          scanned: 0,
          total: null,
        ),
      );

      if (await root.exists()) {
        await for (final e in root
            .list(recursive: true, followLinks: false)
            .handleError((error) {
          if (error is PathAccessException) return;
          if (error is FileSystemException) return;
          throw error;
        })) {
          _throwIfCancelled();
          if (e is! File) continue;
          await _scanResolvedTarget(
            path: e.path,
            displayName: e.path.split('/').last,
            allowCloud: false,
            respectFolderExclusions: false,
            respectShaExclusions: false,
          );
        }
      }
    }
  } catch (e) {
    if (e is! CancelledScan) {
      onEvent?.call(
        HeadlessScanEvent(
          'err',
          mode: mode,
          message: 'Enumeration failed: $e',
        ),
      );
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
      onEvent?.call(
        HeadlessScanEvent(
          'err',
          mode: mode,
          message: 'Hash flush failed: $e',
        ),
      );
    }
  }

  try {
    await CacheManager.clearAll();
  } catch (_) {}

  sw.stop();

  onEvent?.call(
    HeadlessScanEvent(
      'done',
      mode: mode,
      scanned: scanned,
      total: total > 0 ? total : null,
      message: cancelled ? 'cancelled' : null,
    ),
  );

  return HeadlessScanResult(
    mode: mode,
    scanned: scanned,
    threats: detections.length,
    clean: cleanCount,
    total: total,
    cancelled: cancelled,
    duration: sw.elapsed,
    detections: detections,
  );
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

String _ext(String path) {
  final name = path.split('/').last;
  final dot = name.lastIndexOf('.');
  if (dot <= 0) return '';
  return name.substring(dot + 1).toLowerCase();
}

bool _isAllowedFile(String ext, int size) {
  const allowed = {
    'apk',
    'zip',
    'pdf',
    'md',
    'exe',
    'js',
    'dex',
    'html',
    'jar',
  };

  if (!allowed.contains(ext)) return false;
  if (size > 100 * 1024 * 1024) return false;

  return true;
}

bool _isAllowedSmart(String ext, int size) {
  const allowed = {
    'apk',
    'zip',
    'pdf',
    'md',
    'exe',
    'js',
    'dex',
    'html',
    'jar',
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
    'clean': r.clean,
    'total': r.total,
    'cancelled': r.cancelled,
    'duration_ms': r.duration.inMilliseconds,
  };
}