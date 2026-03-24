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
import '../services/cloud_helper_service.dart';
import '../services/exclusion_service.dart';
import '../services/foreground_service.dart';
import '../services/quarantine_service.dart';
import '../services/scan api/headless_scan.dart';
import '../services/scan_session_service.dart';
import '../utils/hash_cache_worker.dart';
import '../widgets/antivirus_bridge.dart';
import 'exclusions/exclusion_manager_screen.dart';
import 'main_shell.dart';

class LogBuffer {
  static final List<String> _messages = [];
  static final ValueNotifier<int> notifier = ValueNotifier<int>(0);
  static Timer? _flushTimer;

  static void add(String msg) {
    final now = DateTime.now();
    final time =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
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
    confidence:
    map['confidence'] is num ? (map['confidence'] as num).toDouble() : 0.0,
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
  bool cancellingUi = false;
  int scanned = 0;
  int total = 0;
  int fullCleanCount = 0;
  String currentFile = '';
  List<String> clean = [];
  List<DetectionResult> infected = [];
  bool? singleResult;

  ScanWorker? _scanWorker;
  Future<ScanWorker>? _scanWorkerFuture;

  bool _headlessCancelRequested = false;
  bool _headlessDetached = false;
  Future<void>? _activeScanFuture;
  final ScanSessionService _session = ScanSessionService.instance;
  late final VoidCallback _sessionListener;

  late AnimationController _pulse;
  final Stopwatch _uiProgressThrottle = Stopwatch();
  final Stopwatch _notifProgressThrottle = Stopwatch();

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

  bool _isHeadlessMultiMode(ScanMode m) {
    return m == ScanMode.smart ||
        m == ScanMode.rapid ||
        m == ScanMode.installed ||
        m == ScanMode.full;
  }

  String _notificationText() {
    if (mode == ScanMode.full) {
      if (currentFile.isEmpty) return 'Scanned: $scanned items';
      return 'Scanned: $scanned • $currentFile';
    }

    if (total > 0) {
      if (currentFile.isEmpty) return '$scanned / $total';
      return '$scanned / $total • $currentFile';
    }

    if (currentFile.isEmpty) return 'Preparing scan...';
    return currentFile;
  }

  Future<void> _showOngoingScanNotification() async {
    await ForegroundService.showScanOngoing(
      title: _modeTitle(),
      text: _notificationText(),
    );
  }

  Future<void> _updateOngoingScanNotification() async {
    await ForegroundService.updateScanOngoing(
      title: _modeTitle(),
      text: _notificationText(),
    );
  }

  Future<void> _finishOngoingScanNotification({
    required bool hasThreats,
    required bool wasCancelled,
  }) async {
    await ForegroundService.hideScanOngoing();

    if (wasCancelled) {
      await ForegroundService.toast(text: 'Scan cancelled');
      return;
    }

    await ForegroundService.notify(
      title: 'Scan complete',
      text: hasThreats
          ? '${infected.length} suspicious item${infected.length == 1 ? '' : 's'} found'
          : 'No threats detected',
    );
  }

  void _appendScanLog(String line) {
    LogBuffer.add(line);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _safeScrollToEnd();
    });
  }

  void _applyHeadlessEvent(HeadlessScanEvent e) {
    final name = e.name ?? (e.path?.split('/').last ?? '');
    final uiUpdateDue = !_uiProgressThrottle.isRunning ||
        _uiProgressThrottle.elapsedMilliseconds >= 120;

    if (e.type == 'start') {
      if (!_uiProgressThrottle.isRunning) _uiProgressThrottle.start();
      if (!_notifProgressThrottle.isRunning) _notifProgressThrottle.start();
      _pushSessionSnapshot();
      return;
    }

    if (e.type == 'enumerated' || e.type == 'empty') {
      final nextTotal = e.total ?? 0;

      total = nextTotal;
      if (e.type == 'empty') {
        _appendScanLog('[ENGINE] No readable files found.');
        if (mounted) {
          setState(() {
            state = ScanState.empty;
          });
        } else {
          state = ScanState.empty;
        }
      } else {
        _appendScanLog('[ENGINE] Files enumerated: ${e.total ?? 0}');
        if (mounted) {
          setState(() {
            total = nextTotal;
          });
        }
      }
      _pushSessionSnapshot();
      return;
    }

    if (e.type == 'current' || e.type == 'progress') {
      if (e.scanned != null) scanned = e.scanned!;
      if (e.total != null) total = e.total!;
      if (name.isNotEmpty) currentFile = name;

      if (mounted && uiUpdateDue) {
        _uiProgressThrottle
          ..reset()
          ..start();
        setState(() {});
      }

      if (!_notifProgressThrottle.isRunning ||
          _notifProgressThrottle.elapsedMilliseconds >= 700) {
        _notifProgressThrottle
          ..reset()
          ..start();
        unawaited(_updateOngoingScanNotification());
      }
      _pushSessionSnapshot();
      return;
    }

    if (e.type == 'clean') {
      if (e.scanned != null) scanned = e.scanned!;
      if (e.total != null) total = e.total!;
      if (name.isNotEmpty) currentFile = name;

      if (mode == ScanMode.full) {
        fullCleanCount++;
      } else if (name.isNotEmpty) {
        clean.add(name);
      }

      _appendScanLog('[CLEAN] $name');

      if (mounted && uiUpdateDue) {
        _uiProgressThrottle
          ..reset()
          ..start();
        setState(() {});
      }
      _pushSessionSnapshot();
      return;
    }

    if (e.type == 'hit') {
      if (e.scanned != null) scanned = e.scanned!;
      if (e.total != null) total = e.total!;
      if (name.isNotEmpty) currentFile = name;

      infected.add(
        DetectionResult(
          name: name,
          label: e.label ?? 'Suspicious.Item',
          confidence: e.confidence ?? 0.0,
          signals: e.signals ?? const [],
        ),
      );

      _appendScanLog('[THREAT] Quarantined $name');

      if (mounted) {
        setState(() {});
      }
      _pushSessionSnapshot();
      return;
    }

    if (e.type == 'err') {
      final message = e.message ?? 'Unknown error';
      _appendScanLog('[ERROR] $message');
      _pushSessionSnapshot();
      return;
    }
  }

  Future<void> _runHeadlessMultiScan(ScanMode m) async {
    _headlessCancelRequested = false;
    _headlessDetached = false;

    if (mounted) {
      setState(() {
        mode = m;
        state = ScanState.scanning;
        scanned = 0;
        total = 0;
        fullCleanCount = 0;
        currentFile = '';
        clean.clear();
        infected.clear();
        singleResult = null;
        cancellingUi = false;
      });
    } else {
      mode = m;
      state = ScanState.scanning;
      scanned = 0;
      total = 0;
      fullCleanCount = 0;
      currentFile = '';
      clean.clear();
      infected.clear();
      singleResult = null;
      cancellingUi = false;
    }

    _session.start(modeName: _modeName(m));

    LogBuffer.clear();
    _appendScanLog('[SCAN INIT] ${m.name}');
    await _showOngoingScanNotification();

    _uiProgressThrottle
      ..reset()
      ..start();
    _notifProgressThrottle
      ..reset()
      ..start();

    _pushSessionSnapshot();

    final future = runHeadlessScan(
      mode: m,
      useCloud: useCloudScan,
      quarantine: true,
      token: ServicesBinding.rootIsolateToken,
      isCancelled: () => _headlessCancelRequested,
      onEvent: _applyHeadlessEvent,
    );

    _activeScanFuture = future.then((result) async {
      scanned = result.scanned;
      if (result.total > 0) total = result.total;
      if (mode == ScanMode.full) {
        fullCleanCount = result.clean;
      }

      await _finishOngoingScanNotification(
        hasThreats: result.threats > 0,
        wasCancelled: result.cancelled,
      );

      if (result.cancelled) {
        _appendScanLog('[USER] Cancelled');
        _session.clear();
        return;
      }

      _appendScanLog(
        '[SUMMARY] ${result.threats} suspicious • ${result.clean} clean',
      );

      if (mounted) {
        if (result.scanned == 0 && result.threats == 0 && result.clean == 0) {
          setState(() {
            state = ScanState.empty;
          });
        } else {
          setState(() {
            state = ScanState.result;
          });
        }
      } else {
        if (result.scanned == 0 && result.threats == 0 && result.clean == 0) {
          state = ScanState.empty;
        } else {
          state = ScanState.result;
        }
      }

      _pushSessionSnapshot();
    }).catchError((_) async {
      await ForegroundService.hideScanOngoing();
      _appendScanLog('[ERROR] Scan failed to complete');
      if (mounted) {
        setState(() {
          state = ScanState.empty;
        });
      } else {
        state = ScanState.empty;
      }
      _pushSessionSnapshot();
    }).whenComplete(() {
      _activeScanFuture = null;
    });

    await _activeScanFuture;
  }

  @override
  void initState() {
    super.initState();

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    cloudScanner = CloudScanner(
      endpoint: 'https://efkou1u21ooih2hko.colourswift.com',
      apiKey: '23JVO3ojo23oO3O423rrTR',
    );

    _sessionListener = _onSessionChanged;
    _session.addListener(_sessionListener);

    _loadCloud();

    if (_session.isScanning || _session.cancelling) {
      _pullSessionSnapshot();
      return;
    }

    if (widget.startMode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        mode = widget.startMode!;
        _checkAndStart(mode);
      });
    }
  }

  @override
  void dispose() {
    _session.removeListener(_sessionListener);

    if (!_isHeadlessMultiMode(mode) || state != ScanState.scanning) {
      _killWorker();
    } else {
      _headlessDetached = true;
    }

    _pulse.dispose();
    _logScroll.dispose();
    super.dispose();
  }

  double get progress => total == 0 ? 0 : scanned / total;

  String _modeName(ScanMode m) {
    switch (m) {
      case ScanMode.smart:
        return 'smart';
      case ScanMode.single:
        return 'single';
      case ScanMode.rapid:
        return 'rapid';
      case ScanMode.installed:
        return 'installed';
      case ScanMode.full:
        return 'full';
      case ScanMode.none:
        return 'none';
    }
  }

  String _stateName(ScanState s) {
    switch (s) {
      case ScanState.idle:
        return 'idle';
      case ScanState.scanning:
        return 'scanning';
      case ScanState.result:
        return 'result';
      case ScanState.empty:
        return 'empty';
    }
  }

  ScanMode _scanModeFromName(String name) {
    switch (name) {
      case 'smart':
        return ScanMode.smart;
      case 'single':
        return ScanMode.single;
      case 'rapid':
        return ScanMode.rapid;
      case 'installed':
        return ScanMode.installed;
      case 'full':
        return ScanMode.full;
      default:
        return ScanMode.none;
    }
  }

  ScanState _scanStateFromName(String name) {
    switch (name) {
      case 'scanning':
        return ScanState.scanning;
      case 'result':
        return ScanState.result;
      case 'empty':
        return ScanState.empty;
      default:
        return ScanState.idle;
    }
  }

  List<Map<String, dynamic>> _infectedToSession() {
    return infected
        .map((d) => {
      'name': d.name,
      'label': d.label,
      'confidence': d.confidence,
      'signals': List<String>.from(d.signals),
    })
        .toList();
  }

  List<DetectionResult> _infectedFromSession() {
    return _session.infected
        .map(
          (m) => DetectionResult(
        name: m['name']?.toString() ?? '',
        label: m['label']?.toString() ?? 'Suspicious.Item',
        confidence: m['confidence'] is num
            ? (m['confidence'] as num).toDouble()
            : 0.0,
        signals: List<String>.from(m['signals'] ?? const <String>[]),
      ),
    )
        .toList();
  }

  void _pushSessionSnapshot() {
    _session.update(
      modeName: _modeName(mode),
      stateName: _stateName(state),
      scanned: scanned,
      total: total,
      fullCleanCount: fullCleanCount,
      currentFile: currentFile,
      clean: List<String>.from(clean),
      infected: _infectedToSession(),
      singleResult: singleResult,
      isScanning: state == ScanState.scanning,
      cancelling: cancellingUi,
    );
  }

  void _pullSessionSnapshot() {
    mode = _scanModeFromName(_session.modeName);
    state = _scanStateFromName(_session.stateName);
    scanned = _session.scanned;
    total = _session.total;
    fullCleanCount = _session.fullCleanCount;
    currentFile = _session.currentFile;
    clean = List<String>.from(_session.clean);
    infected = _infectedFromSession();
    singleResult = _session.singleResult;
    cancellingUi = _session.cancelling;
  }

  void _onSessionChanged() {
    if (!mounted) return;
    setState(() {
      _pullSessionSnapshot();
    });
  }

  void _cancelScan() async {
    if (cancelled || cancellingUi) return;

    cancelled = true;

    if (mounted) {
      setState(() {
        cancellingUi = true;
      });
    } else {
      cancellingUi = true;
    }

    _pushSessionSnapshot();

    await Future.delayed(const Duration(seconds: 2));

    if (_isHeadlessMultiMode(mode)) {
      _headlessCancelRequested = true;
      await ForegroundService.hideScanOngoing();
    } else {
      _killWorker();
    }

    LogBuffer.add('[USER] Cancelled');
    _session.clear();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
          (route) => false,
    );
  }

  void _finishToHome() {
    if (state != ScanState.scanning) {
      _session.clear();
    }

    if (!mounted) return;

    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
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
        granted =
            status.isGranted || await Permission.storage.request().isGranted;
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

    if (_isHeadlessMultiMode(m)) {
      await _runHeadlessMultiScan(m);
      return;
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

  Future<void> _runSingleFileScan() async {
    final picked = await FilePicker.platform.pickFiles(
      withData: false,
      allowMultiple: false,
    );
    if (picked == null || picked.files.isEmpty) {
      _finishToHome();
      return;
    }

    final file = picked.files.single;

    final pickedPath = file.path;
    if (pickedPath == null || pickedPath.isEmpty) {
      LogBuffer.add('[ERROR] Could not access file path from picker');
      _finishToHome();
      return;
    }

    setState(() {
      state = ScanState.scanning;
      currentFile = file.name;
      scanned = 0;
      total = 1;
      clean.clear();
      infected.clear();
      singleResult = null;
    });

    LogBuffer.add('[SCAN INIT] Single-file -> $pickedPath');
    await Future.delayed(const Duration(milliseconds: 40));

    final effectivePath = pickedPath;

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
      final hits = await cloudScanner.checkBatch([
        if (md5h.isNotEmpty) md5h,
        if (sha.isNotEmpty) sha,
      ]);

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
        final hits = await cloudScanner.checkBatch([
          if (md5h.isNotEmpty) md5h,
          if (sha.isNotEmpty) sha,
        ]);
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

  static bool _isAllowedFile(String ext, int size) {
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: null,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: switch (state) {
                ScanState.scanning => _buildScanning(context),
                ScanState.result => _buildResult(context),
                ScanState.empty => _buildEmpty(context),
                ScanState.idle => const SizedBox.shrink(),
              },
            ),
          ),
          if (cancellingUi)
            Positioned.fill(
              child: AbsorbPointer(
                child: ColoredBox(
                  color: theme.colorScheme.scrim.withOpacity(0.55),
                  child: Center(
                    child: Card(
                      elevation: 0,
                      color: theme.colorScheme.surfaceContainerHigh,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Cancelling scan…',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _modeAccent(ColorScheme scheme) {
    return switch (mode) {
      ScanMode.smart => scheme.tertiary,
      ScanMode.rapid => scheme.secondary,
      ScanMode.installed => scheme.primary,
      ScanMode.full => scheme.error,
      ScanMode.single => scheme.primary,
      _ => scheme.primary,
    };
  }

  IconData _modeIcon() {
    return switch (mode) {
      ScanMode.smart => Icons.shield_rounded,
      ScanMode.rapid => Icons.bolt_rounded,
      ScanMode.installed => Icons.apps_rounded,
      ScanMode.full => Icons.storage_rounded,
      ScanMode.single => Icons.insert_drive_file_rounded,
      _ => Icons.shield_rounded,
    };
  }

  String _modeTitle() {
    return switch (mode) {
      ScanMode.smart => 'Smart Scan',
      ScanMode.rapid => 'Rapid Scan',
      ScanMode.installed => 'Scan Installed Apps',
      ScanMode.full => 'Full Device Scan',
      ScanMode.single => 'Single Scan',
      _ => 'Scan',
    };
  }

  Widget _buildScanning(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    final accent = _modeAccent(scheme);
    final icon = _modeIcon();

    final pct = mode == ScanMode.full
        ? ''
        : '${(progress * 100).clamp(0.0, 100.0).toStringAsFixed(0)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        _glowIcon(icon, accent),
        const SizedBox(height: 18),
        Text(
          _modeTitle(),
          style: text.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.onSurface.withOpacity(0.92),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        if (mode == ScanMode.full)
          Text(
            'Scanned: $scanned items',
            style: text.bodySmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.72),
            ),
          )
        else
          Text(
            total <= 0 ? 'Progress: 0%' : 'Progress: $pct ($scanned / $total)',
            style: text.bodySmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.72),
            ),
          ),
        const SizedBox(height: 8),
        Text(
          currentFile,
          textAlign: TextAlign.center,
          style: text.bodySmall?.copyWith(
            color: scheme.onSurface.withOpacity(0.68),
            height: 1.25,
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: mode == ScanMode.full ? null : progress,
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 16),
        if (mode == ScanMode.full)
          Card(
            elevation: 0,
            color: scheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: scheme.outlineVariant.withOpacity(0.35),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Full Device Scan',
                    style: text.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This mode scans every readable file in storage, unfiltered.\n\n'
                        'Cloud-assisted scanning and app scanning are not used in this mode.',
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(0.72),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 190,
            child: _logBox(context),
          ),
        const Spacer(),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: TextButton.icon(
              onPressed: _cancelScan,
              icon: Icon(Icons.close_rounded, color: scheme.error),
              label: Text(
                'Cancel Scan',
                style: TextStyle(
                  color: scheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _threatLevel(double confidence) {
    if (confidence >= 0.999) return 'Confirmed';
    if (confidence >= 0.90) return 'High';
    return 'Medium';
  }

  String _displayLabel(String label) {
    switch (label) {
      case 'Found in cloud database':
      case 'Found in malware database':
        return 'Known malware';
      case 'Generic.Suspicious':
      case 'Suspicious.Item':
        return 'Suspicious activity detected';
      case 'Generic.Malware':
        return 'Malicious activity detected';
      case 'Android.Banker':
        return 'Android banking trojan';
      case 'Android.Spyware':
        return 'Android spyware';
      case 'Android.Adware':
        return 'Android adware';
      case 'Android.SMS.Fraud':
        return 'Android SMS fraud';
      default:
        return label.replaceAll('.', ' ');
    }
  }

  String _explainLabel(String label) {
    switch (label) {
      case 'Found in cloud database':
        return 'This item is listed in the ColourSwift cloud threat database.';
      case 'Found in malware database':
        return 'This item is listed in the offline malware database on your device.';
      case 'Android.Banker':
        return 'Designed to steal financial credentials, often using overlays, keylogging, or traffic interception.';
      case 'Android.Spyware':
        return 'Silently monitors activity or collects personal data such as messages, location, or device identifiers.';
      case 'Android.Adware':
        return 'Displays intrusive ads, performs redirects, or generates fraudulent ad traffic.';
      case 'Android.SMS.Fraud':
        return 'Attempts to send or trigger SMS actions without consent, which can cause unexpected charges.';
      case 'Generic.Malware':
        return 'Strong indicators of malicious intent were detected, even though it does not match a named family.';
      case 'Generic.Suspicious':
      case 'Suspicious.Item':
      default:
        return 'Indicators of suspicious behavior were detected. This can include abuse patterns seen in malware, but it may also be a false positive.';
    }
  }

  Widget _buildResult(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    final hasThreats = infected.isNotEmpty;

    final accent = hasThreats ? scheme.error : _modeAccent(scheme);
    final headerIcon =
    hasThreats ? Icons.warning_amber_rounded : Icons.verified_user_rounded;

    final cleanCount = mode == ScanMode.full ? fullCleanCount : clean.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _glowIcon(headerIcon, accent),
          const SizedBox(height: 16),
          Text(
            'Scan Complete',
            style: text.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: scheme.onSurface.withOpacity(0.95),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _pill(
                context,
                icon: Icons.shield_rounded,
                label: _modeTitle(),
              ),
              _pill(
                context,
                icon: hasThreats
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_rounded,
                label: hasThreats
                    ? 'Suspicious: ${infected.length}'
                    : 'Clean: $cleanCount',
                tint: hasThreats ? scheme.error : scheme.tertiary,
              ),
              if (mode == ScanMode.full)
                _pill(
                  context,
                  icon: Icons.storage_rounded,
                  label: 'Scanned: $scanned',
                ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: scheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasThreats
                        ? (mode == ScanMode.installed
                        ? 'Suspicious apps'
                        : 'Suspicious items')
                        : 'No threats detected',
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: hasThreats ? scheme.error : scheme.tertiary,
                    ),
                  ),
                  if (hasThreats)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: infected.length,
                      itemBuilder: (context, i) {
                        final d = infected[i];

                        return Theme(
                          data: theme.copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: const EdgeInsets.only(bottom: 10),
                            dense: true,
                            visualDensity:
                            const VisualDensity(vertical: -4),
                            leading: Icon(
                              Icons.warning_amber_rounded,
                              size: 18,
                              color: scheme.error,
                            ),
                            title: Text(
                              d.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: text.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(
                              _displayLabel(d.label),
                              style: text.bodySmall?.copyWith(
                                color: scheme.error.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: _pill(
                                  context,
                                  label:
                                  'Threat level: ${_threatLevel(d.confidence)}',
                                  tint: scheme.error,
                                ),
                              ),
                              Text(
                                _explainLabel(d.label),
                                style: text.bodySmall?.copyWith(
                                  color: scheme.onSurface.withOpacity(0.72),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  else
                    Text(
                      'No threats detected in scanned items.',
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurface.withOpacity(0.7),
                        height: 1.35,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _finishToHome,
              child: const Text('Return Home'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 60,
                color: scheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'No vulnerable files to scan',
                style: text.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: scheme.onSurface.withOpacity(0.92),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Your device did not contain any files matching the scan criteria.',
                style: text.bodySmall?.copyWith(
                  color: scheme.onSurface.withOpacity(0.7),
                  height: 1.35,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: _finishToHome,
                child: const Text('Return Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logBox(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ValueListenableBuilder(
          valueListenable: LogBuffer.notifier,
          builder: (context, _, __) {
            return ListView.builder(
              controller: _logScroll,
              itemCount: LogBuffer.all.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    LogBuffer.all[i],
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(0.72),
                      height: 1.2,
                      fontFamily: 'monospace',
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _pill(
      BuildContext context, {
        IconData? icon,
        required String label,
        Color? tint,
      }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    final c = tint ?? scheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: c),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: text.labelMedium?.copyWith(
              color: scheme.onSurface.withOpacity(0.82),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowIcon(IconData icon, Color color) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final glow = 0.35 + (_pulse.value * 0.55);
        final scale = 1.0 + (_pulse.value * 0.08);

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(glow),
                  blurRadius: 38,
                  spreadRadius: 10,
                ),
              ],
              gradient: LinearGradient(
                colors: [color.withOpacity(0.22), color.withOpacity(0.06)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(icon, size: 54, color: color),
          ),
        );
      },
    );
  }
}