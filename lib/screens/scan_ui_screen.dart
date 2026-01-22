import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import 'exclusions/exclusion_manager_screen.dart';

@pragma('vm:entry-point')
void fullDeviceScanEntry(List<dynamic> args) {
  final SendPort root = args[0] as SendPort;
  final RootIsolateToken? token = args[1] as RootIsolateToken?;

  if (token != null) {
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);
  }

  final port = ReceivePort();
  root.send(port.sendPort);

  port.listen((msg) async {
    final SendPort ui = msg[0] as SendPort;
    final String dirPath = msg[1] as String;

    ui.send({'t': 'start', 'path': dirPath});

    AntivirusBridge? bridge;
    try {
      bridge = AntivirusBridge();
    } catch (_) {
      bridge = null;
    }

    final rootDir = Directory(dirPath);
    int scanned = 0;

    try {
      await for (final e in rootDir
          .list(recursive: true, followLinks: false)
          .handleError((error) {
        if (error is PathAccessException) return;
        if (error is FileSystemException) return;
        throw error;
      })) {
        if (e is! File) continue;

        final path = e.path;

        ui.send({'t': 'enum', 'path': path});
        scanned++;

        if (bridge == null) continue;

        try {
          final raw = bridge.scanFile(path);
          final decoded = jsonDecode(raw);
          final hits = decoded['hits'] as Map?;
          if (hits == null || hits.isEmpty) continue;

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

          ui.send({
            't': 'hit',
            'path': path,
            'res': {
              'label': label,
              'confidence': confidence,
              'signals': signals,
            },
          });
        } catch (_) {}
      }
    } catch (e) {
      ui.send({'t': 'err', 'e': e.toString()});
    } finally {
      ui.send({'t': 'done', 'count': scanned});
    }
  });
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

class LogBuffer {
  static final List<String> _messages = [];
  static final ValueNotifier<int> notifier = ValueNotifier<int>(0);
  static Timer? _flushTimer;

  static void add(String msg) {
    final now = DateTime.now();
    final time = "${now.hour}:${now.minute}:${now.second}";
    _messages.add('[$time] $msg');
    if (_messages.length > 300) _messages.removeAt(0);

    if (_flushTimer != null) return;

    _flushTimer = Timer(const Duration(milliseconds: 120), () {
      _flushTimer = null;
      notifier.value++;
    });
  }

  static List<String> get all => List.unmodifiable(_messages);

  static void clear() {
    _messages.clear();
    try {
      _flushTimer?.cancel();
    } catch (_) {}
    _flushTimer = null;
    notifier.value++;
  }
}

enum ScanMode { none, smart, single, rapid, installed, full }
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

DetectionResult _detectionFromRes({
  required String name,
  required dynamic res,
}) {
  if (res == null || res is! Map) {
    return DetectionResult(
      name: name,
      label: 'Suspicious.Item',
      confidence: 0.0,
      signals: const [],
    );
  }

  final map = Map<String, dynamic>.from(res);

  return DetectionResult(
    name: name,
    label: map['label']?.toString() ?? 'Suspicious.Item',
    confidence: map['confidence'] is num
        ? (map['confidence'] as num).toDouble()
        : 0.0,
    signals: List<String>.from(map['signals'] ?? const <String>[]),
  );
}

class ScanWorker {
  final ReceivePort _receive;
  final SendPort sendPort;
  final Isolate _iso;

  ScanWorker._(this._receive, this.sendPort, this._iso);

  static Future<ScanWorker> spawn() async {
    final receive = ReceivePort();
    final iso = await Isolate.spawn(_entry, receive.sendPort);
    final send = await receive.first as SendPort;
    return ScanWorker._(receive, send, iso);
  }

  static void _entry(SendPort root) {
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

    port.listen((msg) async {
      if (msg is Map && msg['t'] == 'close') {
        closing = true;
        maybeExit();
        return;
      }

      if (msg is! List || msg.length < 2) return;

      final send = msg[0] as SendPort;
      final path = msg[1] as String;

      if (bridge == null) {
        send.send(false);
        return;
      }

      busy = true;

      try {
        final raw = bridge!.scanFile(path);
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
            } else {
              label = 'Suspicious.Item';
              confidence = 0.70;
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
      } finally {
        busy = false;
        maybeExit();
      }
    });
  }

  Future<dynamic> scan(String path) async {
    final port = ReceivePort();
    sendPort.send([port.sendPort, path]);
    return await port.first;
  }

  void requestClose() {
    try {
      sendPort.send({'t': 'close'});
    } catch (_) {}
    try {
      _receive.close();
    } catch (_) {}
  }
}

class ScanScreen extends StatefulWidget {
  final ScanMode? startMode;
  const ScanScreen({super.key, this.startMode});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _AppTarget {
  final String name;
  final String package;
  final String path;
  _AppTarget({required this.name, required this.package, required this.path});
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool useCloudScan = false;
  late final CloudScanner cloudScanner;

  ScanMode mode = ScanMode.none;
  ScanState state = ScanState.idle;

  final ScrollController _logScroll = ScrollController();

  bool cancelled = false;
  int scanned = 0;
  int total = 0;
  String currentFile = '';
  List<String> clean = [];
  List<DetectionResult> infected = [];
  bool? singleResult;

  Isolate? _fullIso;
  ReceivePort? _fullUiPort;

  ScanWorker? _scanWorker;
  Future<ScanWorker>? _scanWorkerFuture;

  late AnimationController _pulse;

  static const MethodChannel _apkFast = MethodChannel("apk_fast");
  static const MethodChannel _fastApps = MethodChannel("cs.fastapps");

  Future<ScanWorker> _ensureWorker() async {
    final existing = _scanWorker;
    if (existing != null) return existing;

    final f = _scanWorkerFuture;
    if (f != null) return await f;

    final future = ScanWorker.spawn();
    _scanWorkerFuture = future;

    final w = await future;
    _scanWorker = w;
    _scanWorkerFuture = null;
    return w;
  }

  void _killWorker() {
    try {
      _scanWorker?.requestClose();
    } catch (_) {}
    _scanWorker = null;
    _scanWorkerFuture = null;
  }

  Future<Uint8List?> _loadApkBytesFast(String packageName) async {
    try {
      final bytes = await _apkFast.invokeMethod("readApkBytes", {
        "package": packageName,
      });
      if (bytes == null) return null;
      return bytes as Uint8List;
    } catch (_) {
      return null;
    }
  }

  void _safeScrollToEnd() {
    if (!_logScroll.hasClients) return;
    final position = _logScroll.position;
    if (!position.hasPixels) return;
    _logScroll.jumpTo(position.maxScrollExtent);
  }

  Future<void> _loadCloud() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      useCloudScan = prefs.getBool('useCloudScan') ?? false;
    });
  }

  void _showCloudInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cloud Scan Info'),
          content: const Text(
            'When cloud-assisted scanning is enabled, only two cryptographic hashes are sent per file:\n\n'
                ' • MD5\n'
                ' • SHA-256\n\n'
                'No filenames, file contents, or personal data are uploaded.\n'
                'These hashes are compared against known threats in the ColourSwift database.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    scanLogSink = LogBuffer.add;

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    cloudScanner = CloudScanner(
      endpoint: 'https://efkou1u21ooih2hko.colourswift.com',
      apiKey: '23JVO3ojo23oO3O423rrTR',
    );

    _loadCloud();

    if (widget.startMode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        mode = widget.startMode!;
        _checkAndStart(mode);
      });
    }
  }

  @override
  void dispose() {
    _killWorker();

    try {
      _fullUiPort?.close();
    } catch (_) {}
    _fullUiPort = null;

    try {
      _fullIso?.kill(priority: Isolate.immediate);
    } catch (_) {}
    _fullIso = null;

    _pulse.dispose();
    _logScroll.dispose();
    super.dispose();
  }

  double get progress => total == 0 ? 0 : scanned / total;

  void _cancelScan() {
    cancelled = true;

    _killWorker();

    try {
      _fullUiPort?.close();
    } catch (_) {}
    _fullUiPort = null;

    try {
      _fullIso?.kill(priority: Isolate.immediate);
    } catch (_) {}
    _fullIso = null;

    LogBuffer.add('[USER] Cancelled');

    if (mounted) Navigator.pop(context);
  }

  void _finishToHome() {
    if (mounted) Navigator.pop(context);
  }

  Future<void> _checkAndStart(ScanMode m) async {
    if (m == ScanMode.single || m == ScanMode.installed) {
      await _startScan(m);
      return;
    }

    bool granted = false;

    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      final sdk = info.version.sdkInt;

      if (sdk >= 30) {
        try {
          var status = await Permission.manageExternalStorage.status;
          if (!status.isGranted) {
            const platform = MethodChannel('colourswift/storage_permission');
            await platform.invokeMethod('openManageStorage');
            await Future.delayed(const Duration(seconds: 2));
            status = await Permission.manageExternalStorage.status;
          }
          granted = status.isGranted;
        } catch (_) {
          await openAppSettings();
        }
      } else {
        final status = await Permission.storage.status;
        granted = status.isGranted || await Permission.storage.request().isGranted;
      }
    } else {
      granted = true;
    }

    if (granted) {
      await _startScan(m);
    } else {
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _startScan(ScanMode m) async {
    if (state == ScanState.scanning) return;

    cancelled = false;

    if (m == ScanMode.single) {
      mode = m;
      LogBuffer.clear();
      LogBuffer.add('[SCAN INIT] ${m.name}');
      await _runSingleScan();
      return;
    }

    setState(() {
      mode = m;
      state = ScanState.scanning;
      scanned = 0;
      total = 0;
      currentFile = '';
      clean.clear();
      infected.clear();
      singleResult = null;
    });

    LogBuffer.clear();
    LogBuffer.add('[SCAN INIT] ${m.name}');

    switch (m) {
      case ScanMode.smart:
        await _runSmartScan();
        break;
      case ScanMode.rapid:
        await _runRapidScan();
        break;
      case ScanMode.installed:
        await _runInstalledScan();
        break;
      case ScanMode.full:
        await _runFullDeviceScan();
        break;
      default:
        break;
    }
  }

  String _ext(String path) {
    final name = path.split('/').last;
    final dot = name.lastIndexOf('.');
    if (dot <= 0) return '';
    return name.substring(dot + 1).toLowerCase();
  }

  Future<List<_AppTarget>> _getUserInstalledApps() async {
    try {
      final List<dynamic> raw = await _fastApps.invokeMethod("listUserApps");
      return raw.map((item) {
        final m = Map<String, dynamic>.from(item);
        return _AppTarget(
          name: m["name"] ?? "Unknown",
          package: m["package"] ?? "",
          path: m["path"] ?? "",
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _runFullDeviceScan() async {
    LogBuffer.add('[ENGINE] Full device scan');
    LogBuffer.add('[ENGINE] Target: /storage/emulated/0');

    setState(() {
      state = ScanState.scanning;
      scanned = 0;
      total = 0;
      currentFile = 'Initializing...';
    });

    enableScanLogs = false;

    final ready = ReceivePort();
    final iso = await Isolate.spawn(
      fullDeviceScanEntry,
      [ready.sendPort, ServicesBinding.rootIsolateToken],
    );
    _fullIso = iso;

    final SendPort worker = await ready.first as SendPort;

    final uiPort = ReceivePort();
    _fullUiPort = uiPort;

    worker.send([uiPort.sendPort, '/storage/emulated/0']);

    int localScanned = 0;
    final sw = Stopwatch()..start();
    String lastName = 'Scanning...';

    await for (final msg in uiPort) {
      if (!mounted || cancelled) break;
      if (msg is! Map) continue;

      switch (msg['t']) {
        case 'start':
          lastName = 'Scanning...';
          if (mounted) {
            setState(() {
              currentFile = lastName;
            });
          }
          break;

        case 'enum':
          localScanned++;
          lastName = msg['path'].toString().split('/').last;
          if (sw.elapsedMilliseconds >= 120) {
            sw.reset();
            if (mounted) {
              setState(() {
                scanned = localScanned;
                currentFile = lastName;
              });
            }
          }
          break;

        case 'hit':
          infected.add(
            _detectionFromRes(
              name: msg['path'].toString().split('/').last,
              res: msg['res'],
            ),
          );
          try {
            unawaited(
              QuarantineService.quarantineFile(
                msg['path'].toString(),
              ),
            );
          } catch (_) {}
          break;

        case 'err':
          LogBuffer.add('[ERROR] ${msg['e']}');
          break;

        case 'done':
          try {
            uiPort.close();
          } catch (_) {}
          break;
      }
    }

    try {
      _fullUiPort?.close();
    } catch (_) {}
    _fullUiPort = null;

    try {
      _fullIso?.kill(priority: Isolate.immediate);
    } catch (_) {}
    _fullIso = null;

    if (!mounted || cancelled) return;

    if (mounted) {
      setState(() {
        scanned = localScanned;
        currentFile = lastName;
      });
    }

    await CacheManager.clearAll();

    if (!mounted || cancelled) return;

    enableScanLogs = true;
    setState(() => state = ScanState.result);
  }

  Future<void> _runSmartScan() async {
    final root = Directory('/storage/emulated/0/');
    final folders = <String>[];

    await for (final e in root.list(followLinks: false)) {
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

    final files = <String>[];
    final x = ExclusionService();
    await x.load();

    for (final dirPath in folders) {
      if (!mounted || cancelled) break;

      final dir = Directory(dirPath);
      if (!await dir.exists()) continue;

      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        if (!mounted || cancelled) break;

        if (entity is File) {
          if (x.skipFolder(entity.path)) continue;

          final ext = _ext(entity.path);
          final size = await entity.length();
          if (!_isAllowedFile(ext, size)) continue;
          files.add(entity.path);
        }
      }
    }

    files.sort((a, b) {
      try {
        return File(a).lengthSync().compareTo(File(b).lengthSync());
      } catch (_) {
        return 0;
      }
    });

    if (!mounted || cancelled) return;

    if (files.isEmpty) {
      LogBuffer.add('[ENGINE] No files found.');
      if (mounted) setState(() => state = ScanState.empty);
      return;
    }

    LogBuffer.add('[ENGINE] Smart Scan: ${files.length} files.');
    await _scanFiles(files);
  }

  Future<void> _runSingleFileScan() async {
    final picked = await FilePicker.platform.pickFiles(withData: true);
    if (picked == null || picked.files.isEmpty) {
      _finishToHome();
      return;
    }

    final file = picked.files.single;

    setState(() {
      state = ScanState.scanning;
      currentFile = file.name;
      scanned = 0;
      total = 1;
      clean.clear();
      infected.clear();
      singleResult = null;
    });

    LogBuffer.add('[SCAN INIT] Single-file -> ${file.path ?? file.name}');
    await Future.delayed(const Duration(milliseconds: 40));

    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/${file.name}';
    String effectivePath = file.path ?? tempPath;

    if (file.path == null) {
      final bytes = file.bytes;
      if (bytes == null) {
        _finishToHome();
        return;
      }
      await File(tempPath).writeAsBytes(bytes, flush: true);
      effectivePath = tempPath;
    }

    bool infectedFlag = false;

    HashCacheWorker? hashWorker;
    String md5h = '';
    String sha = '';

    if (useCloudScan) {
      final dir = await getApplicationDocumentsDirectory();
      hashWorker = await HashCacheWorker.spawn('${dir.path}/hashcache.bin');
      final hashesByPath = await hashWorker.hashBatch([effectivePath]);
      final hashes = hashesByPath[effectivePath] ?? {'md5': '', 'sha': ''};
      md5h = hashes['md5'] ?? '';
      sha = hashes['sha'] ?? '';
      await hashWorker.flush();
    }

    if (useCloudScan) {
      LogBuffer.add('[CLOUD] Sending MD5=$md5h and SHA256=$sha to cloud');
      final hits = await cloudScanner.checkBatch([if (md5h.isNotEmpty) md5h, if (sha.isNotEmpty) sha]);

      if (hits.isNotEmpty) {
        infectedFlag = true;
        infected.add(
          DetectionResult(
            name: file.name,
            label: 'Found in cloud database',
            confidence: 1.0,
            signals: const [],
          ),
        );
      }
    }

    if (!infectedFlag) {
      final worker = await _ensureWorker();
      final res = await worker.scan(effectivePath);

      if (res is Map) {
        infectedFlag = true;
        infected.add(
          _detectionFromRes(
            name: file.name,
            res: res,
          ),
        );
      }
    }

    if (infectedFlag) {
      try {
        unawaited(QuarantineService.quarantineFile(effectivePath));
      } catch (_) {}
    } else {
      clean.add(file.name);
    }

    if (!mounted) return;

    setState(() {
      singleResult = infectedFlag;
      state = ScanState.result;
    });
  }

  Future<void> _runRapidScan() async {
    final dir = Directory('/storage/emulated/0/Download');
    final List<String> allPaths = [];

    final x = ExclusionService();
    await x.load();

    try {
      if (await dir.exists()) {
        await for (final entity in dir.list(recursive: true, followLinks: false)) {
          if (!mounted || cancelled) break;

          if (entity is File) {
            try {
              if (x.skipFolder(entity.path)) continue;
              final ext = _ext(entity.path);
              final size = await entity.length();
              if (ext != 'apk') continue;
              if (size > 200 * 1024 * 1024) continue;
              allPaths.add(entity.path);
            } catch (_) {}
          }
        }
      }
    } catch (e) {
      LogBuffer.add('[ERROR] Directory access failed: $e');
    }

    if (!mounted || cancelled) return;

    setState(() => total = allPaths.length);
    LogBuffer.add('[ENGINE] Files enumerated: $total');

    if (total == 0) {
      LogBuffer.add('[ENGINE] No readable files found.');
      if (mounted) setState(() => state = ScanState.empty);
      return;
    }

    await _scanFiles(allPaths);
  }

  Future<void> _runInstalledScan() async {
    final apps = await _getUserInstalledApps();
    if (!mounted) return;

    if (apps.isEmpty) {
      LogBuffer.add('[ENGINE] No user-installed apps found.');
      setState(() => state = ScanState.empty);
      return;
    }

    LogBuffer.add('[ENGINE] Installed apps found: ${apps.length}');
    LogBuffer.add(useCloudScan ? '[MODE] Cloud-assisted mode' : '[MODE] Offline mode');

    setState(() {
      state = ScanState.scanning;
      scanned = 0;
      total = apps.length;
      currentFile = '';
      clean.clear();
      infected.clear();
    });

    await _scanAppTargets(apps, cloud: useCloudScan);
    if (!mounted || cancelled) return;

    await Future.delayed(const Duration(milliseconds: 120));
    await CacheManager.clearAll();
    if (!mounted || cancelled) return;

    setState(() => state = ScanState.result);
  }

  Future<void> _runSingleScan() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.insert_drive_file_rounded),
                title: const Text('Scan a file'),
                onTap: () => Navigator.pop(context, 'file'),
              ),
              ListTile(
                leading: const Icon(Icons.apps_rounded),
                title: const Text('Scan an installed app'),
                onTap: () => Navigator.pop(context, 'app'),
              ),
              ListTile(
                leading: const Icon(Icons.rule_folder_rounded),
                title: const Text('Manage exclusions'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExclusionManagerScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.cloud_rounded),
                title: const Text('Cloud scan info'),
                onTap: () {
                  Navigator.pop(context);
                  _showCloudInfo();
                },
              ),
            ],
          ),
        );
      },
    );

    if (choice == null) {
      _finishToHome();
      return;
    }

    if (choice == 'file') {
      await _runSingleFileScan();
    } else if (choice == 'app') {
      await _runSingleAppScan();
    } else {
      _finishToHome();
    }
  }

  Future<void> _runSingleAppScan() async {
    final apps = await _getUserInstalledApps();
    if (apps.isEmpty) {
      LogBuffer.add('[ENGINE] No installed apps available.');
      _finishToHome();
      return;
    }

    final app = await showModalBottomSheet<_AppTarget>(
      context: context,
      builder: (_) {
        return ListView(
          children: apps.map((a) {
            return ListTile(
              leading: const Icon(Icons.apps_rounded),
              title: Text(a.name),
              onTap: () => Navigator.pop(context, a),
            );
          }).toList(),
        );
      },
    );

    if (app == null) {
      _finishToHome();
      return;
    }

    setState(() {
      state = ScanState.scanning;
      currentFile = app.name;
      scanned = 0;
      total = 1;
      clean.clear();
      infected.clear();
      singleResult = null;
    });

    bool infectedFlag = false;

    if (useCloudScan) {
      HashCacheWorker? hashWorker;
      String md5h = '';
      String sha = '';

      try {
        final dir = await getApplicationDocumentsDirectory();
        hashWorker = await HashCacheWorker.spawn('${dir.path}/hashcache.bin');
        final hashesByPath = await hashWorker.hashBatch([app.path]);
        final hashes = hashesByPath[app.path] ?? {'md5': '', 'sha': ''};
        md5h = hashes['md5'] ?? '';
        sha = hashes['sha'] ?? '';
        await hashWorker.flush();
      } catch (_) {}

      if (md5h.isNotEmpty || sha.isNotEmpty) {
        final hits = await cloudScanner.checkBatch([if (md5h.isNotEmpty) md5h, if (sha.isNotEmpty) sha]);
        if (hits.isNotEmpty) {
          infectedFlag = true;
          infected.add(
            DetectionResult(
              name: app.name,
              label: 'Found in cloud database',
              confidence: 1.0,
              signals: const [],
            ),
          );
        }
      }
    }

    if (!infectedFlag) {
      final worker = await _ensureWorker();
      final res = await worker.scan(app.path);

      if (res is Map) {
        infectedFlag = true;
        infected.add(
          _detectionFromRes(
            name: app.name,
            res: res,
          ),
        );
      }
    }

    if (!infectedFlag) {
      clean.add(app.name);
    }

    if (!mounted) return;

    setState(() {
      singleResult = infectedFlag;
      state = ScanState.result;
    });
  }

  Future<void> _scanAppTargets(List<_AppTarget> apps, {bool cloud = false}) async {
    if (apps.isEmpty) return;

    final ex = ExclusionService();
    await ex.load();

    HashCacheWorker? hashWorker;
    if (cloud) {
      final dir = await getApplicationDocumentsDirectory();
      hashWorker = await HashCacheWorker.spawn('${dir.path}/hashcache.bin');
    }

    final worker = await _ensureWorker();

    scanned = 0;
    clean.clear();
    infected.clear();

    final sw = Stopwatch()..start();
    String lastName = '';

    for (int i = 0; i < apps.length; i++) {
      if (!mounted || cancelled) break;

      final app = apps[i];

      if (ex.skipFolder(app.path)) {
        scanned = i + 1;
        continue;
      }

      lastName = app.name;
      if (sw.elapsedMilliseconds >= 120) {
        sw.reset();
        if (mounted) {
          setState(() {
            currentFile = lastName;
            scanned = i + 1;
          });
        }
      }

      LogBuffer.add('[SCAN] ${app.name}');

      bool infectedFlag = false;

      if (cloud && hashWorker != null) {
        try {
          final hashesByPath = await hashWorker.hashBatch([app.path]);
          final hashes = hashesByPath[app.path];

          if (hashes != null) {
            final md5h = hashes['md5'] ?? '';
            final sha = hashes['sha'] ?? '';

            if (md5h.isNotEmpty || sha.isNotEmpty) {
              final hits = await cloudScanner.checkBatch([if (md5h.isNotEmpty) md5h, if (sha.isNotEmpty) sha]);
              if (hits.isNotEmpty) {
                infectedFlag = true;
                infected.add(
                  DetectionResult(
                    name: app.name,
                    label: 'Found in cloud database',
                    confidence: 1.0,
                    signals: const [],
                  ),
                );
                LogBuffer.add('[CLOUD HIT] ${app.name}');
              }
            }
          }
        } catch (_) {}
      }

      if (!infectedFlag) {
        final res = await worker.scan(app.path);
        if (res is Map) {
          infectedFlag = true;
          infected.add(
            _detectionFromRes(
              name: app.name,
              res: res,
            ),
          );
          LogBuffer.add('[THREAT] ${app.name}');
        }
      }

      if (!infectedFlag) {
        clean.add(app.name);
        LogBuffer.add('[CLEAN] ${app.name}');
      }
    }

    if (hashWorker != null) {
      try {
        await hashWorker.flush();
      } catch (_) {}
    }

    if (!mounted || cancelled) return;

    setState(() {
      currentFile = lastName;
      scanned = apps.length;
    });

    LogBuffer.add('[SUMMARY] ${infected.length} suspicious • ${clean.length} clean');
  }

  Future<void> _scanFiles(List<String> files) async {
    total = files.length;

    if (total == 0) {
      LogBuffer.add('[ENGINE] No readable files found.');
      if (mounted) setState(() => state = ScanState.empty);
      return;
    }

    final ex = ExclusionService();
    await ex.load();

    final useCloud = useCloudScan;

    final fileHashes = <String, Map<String, String>>{};
    final cloudDetected = <String>{};

    HashCacheWorker? hashWorker;

    if (useCloud) {
      final dir = await getApplicationDocumentsDirectory();
      hashWorker = await HashCacheWorker.spawn('${dir.path}/hashcache.bin');

      LogBuffer.add('[STAGE 1] Getting file hashes (cached)...');

      final hashesByPath = await hashWorker.hashBatch(files);

      for (final entry in hashesByPath.entries) {
        final path = entry.key;
        final hashes = entry.value;

        final sha = hashes['sha'] ?? '';
        if (ex.skipSha(sha)) continue;

        fileHashes[path] = hashes;
      }

      await hashWorker.flush();
    }

    if (!mounted || cancelled) return;

    if (useCloud && fileHashes.isNotEmpty) {
      LogBuffer.add('[STAGE 2] Cloud hash lookup...');

      final toSend = <String>[];
      for (final hashes in fileHashes.values) {
        final md5h = hashes['md5'];
        final sha = hashes['sha'];
        if (md5h != null && md5h.isNotEmpty) toSend.add(md5h);
        if (sha != null && sha.isNotEmpty) toSend.add(sha);
      }

      if (toSend.isNotEmpty) {
        final hits = await cloudScanner.checkBatch(toSend);
        for (final h in hits) {
          cloudDetected.add(h);
        }
        if (hits.isNotEmpty) {
          LogBuffer.add('[CLOUD] ${hits.length} hash hits');
        }
      }
    }

    if (!mounted || cancelled) return;

    LogBuffer.add('[STAGE ${useCloud ? '3' : '1'}] Local scanning files...');

    scanned = 0;
    clean.clear();
    infected.clear();

    final worker = await _ensureWorker();

    final sw = Stopwatch()..start();
    final List<String> pendingLogs = [];
    String lastName = '';

    for (int i = 0; i < files.length; i++) {
      if (!mounted || cancelled) break;

      final path = files[i];
      if (ex.skipFolder(path)) continue;

      final name = path.split('/').last;
      lastName = name;

      if (sw.elapsedMilliseconds >= 120 || i == files.length - 1) {
        sw.reset();
        if (mounted) {
          setState(() {
            currentFile = lastName;
            scanned = i + 1;
          });
        }
      }

      bool infectedFlag = false;

      if (useCloud) {
        final hashes = fileHashes[path];
        if (hashes != null) {
          final md5h = hashes['md5'] ?? '';
          final sha = hashes['sha'] ?? '';
          if ((md5h.isNotEmpty && cloudDetected.contains(md5h)) ||
              (sha.isNotEmpty && cloudDetected.contains(sha))) {
            infectedFlag = true;

            infected.add(
              DetectionResult(
                name: name,
                label: 'Found in cloud database',
                confidence: 1.0,
                signals: const [],
              ),
            );

            pendingLogs.add('[THREAT] Quarantined $name');
            try {
              unawaited(QuarantineService.quarantineFile(path));
            } catch (_) {}

            LogBuffer.add('[CLOUD HIT] $name');
          }
        }
      }

      if (!infectedFlag) {
        final res = await worker.scan(path);

        if (res is Map) {
          infectedFlag = true;
          infected.add(
            _detectionFromRes(
              name: name,
              res: res,
            ),
          );
        }
      }

      if (infectedFlag) {
        pendingLogs.add('[THREAT] Quarantined $name');
        try {
          unawaited(QuarantineService.quarantineFile(path));
        } catch (_) {}
      } else {
        clean.add(name);
        pendingLogs.add('[CLEAN] $name');
      }

      if (pendingLogs.length >= 6 || i == files.length - 1) {
        for (final l in pendingLogs) {
          LogBuffer.add(l);
        }
        pendingLogs.clear();
        _safeScrollToEnd();
      }
    }

    if (!mounted || cancelled) return;

    LogBuffer.add('[SUMMARY] ${infected.length} suspicious • ${clean.length} clean');

    await CacheManager.clearAll();

    if (!mounted || cancelled) return;
    setState(() => state = ScanState.result);
  }

  static bool _isAllowedFile(String ext, int size) {
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (state) {
            ScanState.scanning => _buildScanning(theme, text),
            ScanState.result => _buildResult(theme, text),
            ScanState.empty => _buildEmpty(theme, text),
            ScanState.idle => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }

  Widget _buildScanning(ThemeData theme, TextTheme text) {
    final color = switch (mode) {
      ScanMode.smart => Colors.greenAccent,
      ScanMode.rapid => Colors.amberAccent,
      ScanMode.installed => Colors.purpleAccent,
      ScanMode.full => Colors.redAccent,
      _ => theme.colorScheme.primary,
    };

    final icon = switch (mode) {
      ScanMode.smart => Icons.shield_rounded,
      ScanMode.rapid => Icons.bolt_rounded,
      ScanMode.installed => Icons.apps_rounded,
      ScanMode.full => Icons.storage_rounded,
      _ => Icons.shield_rounded,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        _glowIcon(icon, color),
        const SizedBox(height: 24),
        if (mode == ScanMode.full)
          Text(
            'Scanned: $scanned items',
            style: text.bodySmall?.copyWith(color: Colors.white70),
          ),
        const SizedBox(height: 8),
        Text(
          currentFile,
          textAlign: TextAlign.center,
          style: text.bodySmall?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 20),
        LinearProgressIndicator(
          value: mode == ScanMode.full ? null : progress,
          color: color,
          backgroundColor: color.withOpacity(0.1),
          minHeight: 6,
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 20),
        if (mode == ScanMode.full)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Full Device Scan',
                  style: text.bodyMedium?.copyWith(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This mode does not support cloud assisted scanning, or app scanning currently.\n'
                      'It scans every file available in your storage, unfiltered unlike smart scan.\n\n'
                      'Future updates might add support for cloud mode and app scanning.',
                  style: text.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 180,
            child: _logBox(),
          ),
        const SizedBox(height: 20),

          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 8,
            ),
            child: TextButton.icon(
              onPressed: _cancelScan,
              icon: const Icon(Icons.close_rounded, color: Colors.redAccent),
              label: const Text(
                'Cancel Scan',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _explainLabel(String label) {
    switch (label) {
      case 'Found in cloud database':
        return 'This file exists within the ColourSwift cloud threat database.';
      case 'Android.Banker':
        return 'Designed to steal banking or financial credentials, often by overlaying fake login screens or intercepting sensitive data.';
      case 'Android.Spyware':
        return 'Silently monitors activity or collects personal data such as messages, location, or device identifiers.';
      case 'Android.Adware':
        return 'Displays intrusive advertisements, performs hidden redirects, or generates fraudulent ad traffic.';
      case 'Android.SMS.Fraud':
        return 'Attempts to send SMS commands without user consent, potentially causing unexpected charges.';
      case 'Found in malware database':
        return 'This file exists inside the malware database.';
      default:
        return 'Has behavior commonly associated with malware, but does not match a known malware family.';
    }
  }

  Widget _buildResult(ThemeData theme, TextTheme text) {
    final accent = switch (mode) {
      ScanMode.smart => Colors.greenAccent,
      ScanMode.single => Colors.blueAccent,
      ScanMode.rapid => Colors.amberAccent,
      ScanMode.installed => Colors.purpleAccent,
      _ => theme.colorScheme.primary,
    };

    final hasThreats = infected.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _glowIcon(
            hasThreats ? Icons.warning_amber_rounded : Icons.verified_user_rounded,
            hasThreats ? Colors.orangeAccent : accent,
          ),
          const SizedBox(height: 25),
          Text(
            'Scan Complete',
            style: text.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: accent,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            hasThreats ? 'Suspicious: ${infected.length}' : 'Clean: ${clean.length}',
            style: text.bodyMedium?.copyWith(
              color: hasThreats ? Colors.orangeAccent : Colors.greenAccent,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasThreats
                    ? Colors.orangeAccent.withOpacity(0.4)
                    : Colors.greenAccent.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasThreats
                      ? (mode == ScanMode.installed ? 'Suspicious apps' : 'Suspicious files')
                      : 'Your device looks safe',
                  style: text.titleSmall?.copyWith(
                    color: hasThreats ? Colors.orangeAccent : Colors.greenAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                if (hasThreats)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: infected.length,
                    itemBuilder: (context, i) {
                      final d = infected[i];
                      final pct = (d.confidence * 100).round();

                      return ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.warning_amber_rounded,
                          size: 18,
                          color: Colors.orangeAccent,
                        ),
                        title: Text(
                          d.name,
                          style: const TextStyle(
                            fontSize: 13,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        subtitle: Text(
                          d.label,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 36, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Confidence: $pct%',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                                Text(
                                  _explainLabel(d.label),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                if (!hasThreats)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'No threats detected in scanned items.',
                      style: text.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _finishToHome,
            child: const Text('Return Home'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme, TextTheme text) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 60,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 20),
              Text(
                'No vulnerable files to scan',
                style: text.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Your device did not contain any files matching the scan criteria.',
                style: text.bodySmall?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _finishToHome,
                child: const Text('Return Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logBox() {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: ValueListenableBuilder(
        valueListenable: LogBuffer.notifier,
        builder: (context, _, __) {
          return ListView.builder(
            controller: _logScroll,
            itemCount: LogBuffer.all.length,
            itemBuilder: (context, i) {
              return Text(
                LogBuffer.all[i],
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  height: 1.2,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _glowIcon(IconData icon, Color color) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final glow = 0.4 + (_pulse.value * 0.5);
        final scale = 1.0 + (_pulse.value * 0.1);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(glow),
                  blurRadius: 45,
                  spreadRadius: 10,
                ),
              ],
              gradient: LinearGradient(
                colors: [color.withOpacity(0.3), color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(icon, size: 55, color: color),
          ),
        );
      },
    );
  }
}
