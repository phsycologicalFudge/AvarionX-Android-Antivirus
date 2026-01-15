import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:crypto/crypto.dart';
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

class LogBuffer {
  static final List<String> _messages = [];
  static final ValueNotifier<int> notifier = ValueNotifier<int>(0);

  static void add(String msg) {
    final now = DateTime.now();
    final time = "${now.hour}:${now.minute}:${now.second}";
    _messages.add('[$time] $msg');
    if (_messages.length > 300) _messages.removeAt(0);
    notifier.value++;
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

class ScanScreen extends StatefulWidget {
  final ScanMode? startMode;
  const ScanScreen({super.key, this.startMode});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
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
        } else {
          final signals = <String>[];

          for (final v in hits.values) {
            if (v is List) {
              for (final s in v) {
                if (s is String) {
                  signals.add(s);
                }
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
        }
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
  String rustStatus = '';
  List<String> clean = [];
  List<DetectionResult> infected = [];
  bool? singleResult;

  late AnimationController _pulse;

  static const MethodChannel _apkFast = MethodChannel("apk_fast");

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

    _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);

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
    _pulse.dispose();
    _logScroll.dispose();
    super.dispose();
  }

  double get progress => total == 0 ? 0 : scanned / total;

  void _cancelScan() {
    cancelled = true;
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
      cancelled = false;
      scanned = 0;
      total = 0;
      currentFile = '';
      rustStatus = '';
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

  bool _isImage(String ext) {
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic'].contains(ext);
  }

  static const MethodChannel _fastApps = MethodChannel("cs.fastapps");

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

    for (final dirPath in folders) {
      final dir = Directory(dirPath);
      if (!await dir.exists()) continue;

      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          final x = ExclusionService();
          await x.load();
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

    if (files.isEmpty) {
      LogBuffer.add('[ENGINE] No files found.');
      if (mounted) setState(() => state = ScanState.empty);
      return;
    }

    LogBuffer.add('[ENGINE] Smart Scan: ${files.length} files.');
    await _scanFiles(files);
  }

  Future<void> _runSingleFileScan() async {
    final res = await FilePicker.platform.pickFiles();
    if (res == null || res.files.isEmpty) {
      _finishToHome();
      return;
    }

    final file = res.files.single;
    setState(() {
      state = ScanState.scanning;
      currentFile = file.name;
      scanned = 0;
      total = 1;
      clean.clear();
      infected.clear();
      singleResult = null;
    });

    LogBuffer.add('[SCAN INIT] Single-file → ${file.path}');
    await Future.delayed(const Duration(milliseconds: 60));

    bool infectedFlag = false;

    final dir = await getApplicationDocumentsDirectory();
    final hashWorker = await HashCacheWorker.spawn(
      '${dir.path}/hashcache.bin',
    );

    final hashesByPath = await hashWorker.hashBatch([file.path!]);
    final hashes = hashesByPath[file.path!] ?? {'md5': '', 'sha': ''};
    final md5h = hashes['md5'] ?? '';
    final sha = hashes['sha'] ?? '';

    await hashWorker.flush();

    if (useCloudScan) {
      LogBuffer.add('[CLOUD] Sending MD5=$md5h and SHA256=$sha to cloud');
      final hits = await cloudScanner.checkBatch([md5h, sha]);

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
      } else {
        final scanWorker = await ScanWorker.spawn();
        final tempDir = await getTemporaryDirectory();
        final tempPath = '${tempDir.path}/${file.name}';

        if (file.bytes != null) {
          await File(tempPath).writeAsBytes(file.bytes!, flush: true);
        } else if (file.path != null) {
          await File(file.path!).copy(tempPath);
        } else {
          throw Exception('No readable file data');
        }

        final res = await scanWorker.scan(tempPath);

        if (res is Map) {
          infectedFlag = true;
          infected.add(
            DetectionResult(
              name: file.name,
              label: res['label'],
              confidence: res['confidence'],
              signals: List<String>.from(res['signals'] ?? []),
            ),
          );
        }
      }
    } else {
      final scanWorker = await ScanWorker.spawn();
      final res = await scanWorker.scan(file.path!);

      if (res is Map) {
        infectedFlag = true;
        infected.add(
          DetectionResult(
            name: file.name,
            label: res['label'],
            confidence: res['confidence'],
            signals: List<String>.from(res['signals'] ?? []),
          ),
        );
      }
    }

    if (infectedFlag) {
      unawaited(
        QuarantineService.quarantineFile(file.path!),
      );
    }

    setState(() {
      singleResult = infectedFlag;
      state = ScanState.result;
    });
  }

  Future<void> _runRapidScan() async {
    final dir = Directory('/storage/emulated/0/Download');
    final List<String> allPaths = [];

    try {
      if (await dir.exists()) {
        await for (final entity in dir.list(recursive: true, followLinks: false)) {
          if (entity is File) {
            try {
              final x = ExclusionService();
              await x.load();
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
    LogBuffer.add('[ENGINE] Offline scanning only');

    setState(() {
      state = ScanState.scanning;
      scanned = 0;
      total = apps.length;
    });

    await _scanAppTargets(apps, cloud: false);
    if (!mounted || cancelled) return;
    await Future.delayed(const Duration(milliseconds: 200));
    await CacheManager.clearAll();
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

    final scanWorker = await ScanWorker.spawn();
    final res = await scanWorker.scan(app.path);

    if (res is Map) {
      infected.add(
        DetectionResult(
          name: app.name,
          label: res['label'],
          confidence: res['confidence'],
          signals: List<String>.from(res['signals'] ?? []),
        ),
      );
      singleResult = true;
    } else {
      clean.add(app.name);
      singleResult = false;
    }

    setState(() {
      state = ScanState.result;
    });
    }

  Future<void> _scanAppTargets(List<_AppTarget> apps, {bool cloud = false}) async {
    if (apps.isEmpty) return;

    final ex = ExclusionService();
    await ex.load();

    final scanWorker = await ScanWorker.spawn();

    scanned = 0;
    clean.clear();
    infected.clear();

    final paths = <String>[];
    final names = <String, String>{};
    for (final a in apps) {
      if (ex.skipFolder(a.path)) continue;
      paths.add(a.path);
      names[a.path] = a.name;
    }

    if (paths.isEmpty) {
      LogBuffer.add('[ENGINE] No apps to scan after exclusions.');
      if (mounted) {
        setState(() {
          state = ScanState.empty;
          total = 0;
          scanned = 0;
        });
      }
      return;
    }

    setState(() {
      total = paths.length;
      scanned = 0;
    });

    LogBuffer.add('[STAGE 1] Offline scanning apps...');

    int done = 0;
    for (final p in paths) {
      if (!mounted || cancelled) return;

      final name = names[p] ?? p;

      setState(() {
        currentFile = name;
        scanned = ++done;
      });

      final res = await scanWorker.scan(p);

      if (res is Map) {
        final label = res['label'];
        final conf = res['confidence'];

        infected.add(
          DetectionResult(
            name: name,
            label: label,
            confidence: conf,
            signals: List<String>.from(res['signals'] ?? []),
          ),
        );
      } else {
        clean.add(name);
      }
    }
  }
  Future<void> _scanFiles(List<String> files) async {
    total = files.length;
    if (total == 0) {
      LogBuffer.add('[ENGINE] No readable files found.');
      if (mounted) setState(() => state = ScanState.empty);
      LogBuffer.add('[SUMMARY] ${infected.length} suspicious apps • ${clean
          .length} clean');
      return;
    }

    final scanWorker = await ScanWorker.spawn();
    final fileHashes = <String, Map<String, String>>{};
    final cloudDetected = <String>{};

    final useCloud = useCloudScan;

    final List<String> pendingLogs = [];

    HashCacheWorker? hashWorker;

    if (useCloud) {
      final dir = await getApplicationDocumentsDirectory();
      hashWorker = await HashCacheWorker.spawn(
        '${dir.path}/hashcache.bin',
      );

      LogBuffer.add('[STAGE 1] Resolving file hashes (cached)...');

      final hashesByPath = await hashWorker.hashBatch(files);

      for (final entry in hashesByPath.entries) {
        final path = entry.key;
        final hashes = entry.value;

        final ex = ExclusionService();
        await ex.load();

        final sha = hashes['sha'] ?? '';
        if (ex.skipSha(sha)) continue;

        fileHashes[path] = hashes;
      }

      await hashWorker.flush();
    }

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

    LogBuffer.add('[STAGE ${useCloud ? '3' : '1'}] Local scanning files...');

    scanned = 0;
    clean.clear();
    infected.clear();

    for (int i = 0; i < files.length; i++) {
      if (!mounted || cancelled) break;

      final path = files[i];
      final name = path
          .split('/')
          .last;

      if (i % 5 == 0 || i == files.length - 1) {
        setState(() {
          currentFile = name;
          scanned = i + 1;
        });
      }

      bool infectedFlag = false;

      if (useCloud) {
        final hashes = fileHashes[path];
        if (hashes != null) {
          final md5h = hashes['md5'] ?? '';
          final sha = hashes['sha'] ?? '';if (cloudDetected.contains(md5h) || cloudDetected.contains(sha)) {
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
              unawaited(
                QuarantineService.quarantineFile(path),
              );
            } catch (_) {}

            LogBuffer.add('[CLOUD HIT] $name');
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
        pendingLogs.add('[THREAT] Quarantined $name');
        try {
          unawaited(
            QuarantineService.quarantineFile(path),
          );
        } catch (_) {}
      } else {
        clean.add(path);
        pendingLogs.add('[CLEAN] $name');
      }
      if (pendingLogs.length >= 5 || i == files.length - 1) {
        for (final l in pendingLogs) {
          LogBuffer.add(l);
        }
        pendingLogs.clear();
        _safeScrollToEnd();
      }
    }
    LogBuffer.add(
        '[SUMMARY] ${infected.length} suspicious • ${clean.length} clean'
    );

    if (!mounted || cancelled) return;

    await CacheManager.clearAll();
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
      ScanMode.single => Colors.blueAccent,
      ScanMode.rapid => Colors.amberAccent,
      ScanMode.installed => Colors.purpleAccent,
      _ => theme.colorScheme.primary,
    };

    final icon = switch (mode) {
      ScanMode.smart => Icons.shield_rounded,
      ScanMode.single => Icons.insert_drive_file_rounded,
      ScanMode.rapid => Icons.bolt_rounded,
      ScanMode.installed => Icons.apps_rounded,
      _ => Icons.shield_rounded,
    };

    final percent = (progress * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        _glowIcon(icon, color),
        const SizedBox(height: 24),
        Text(
          'Scanning... $percent%',
          style: text.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          currentFile,
          textAlign: TextAlign.center,
          style: text.bodySmall?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 20),
        LinearProgressIndicator(
          value: progress,
          color: color,
          backgroundColor: color.withOpacity(0.1),
          minHeight: 6,
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 20),
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

      case 'Generic.Trojan':
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
            hasThreats
                ? 'Suspicious: ${infected.length}'
                : 'Clean: ${clean.length}',
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
                      ? (mode == ScanMode.installed
                      ? 'Suspicious apps'
                      : 'Suspicious files')
                      : 'Your device looks safe',
                  style: text.titleSmall?.copyWith(
                    color:
                    hasThreats ? Colors.orangeAccent : Colors.greenAccent,
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

bool _scanFileIsolate(String path) {
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

Iterable<List<T>> _chunks<T>(List<T> items, int size) sync* {
  for (var i = 0; i < items.length; i += size) {
    final end = (i + size < items.length) ? i + size : items.length;
    yield items.sublist(i, end);
  }
}
