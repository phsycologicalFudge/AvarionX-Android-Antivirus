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
        if (_isHashSignal(signals)) {
          label = _structuredHashLabel(path);
          confidence = 1.0;
        } else {
          final signature = signals.firstWhere(
                (s) =>
            !s.startsWith('ML_Detection(') &&
                s != 'HashMatch' &&
                !s.startsWith('SignerMatch('),
            orElse: () => '',
          );

          if (signature.isNotEmpty) {
            confidence = 0.95;
            label = _structuredSignatureLabel(signature, confidence);
          } else if (_isMlSignal(signals)) {
            label = 'Android.MUniverse.Susp';
            confidence = 0.80;
          } else {
            label = 'Suspicious.Item';
            confidence = 0.70;
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

bool _isApkPath(String path) => path.toLowerCase().endsWith('.apk');

bool _isHashSignal(List<String> signals) {
  return signals.contains('HashMatch') ||
      signals.any((s) => s.startsWith('SignerMatch('));
}

bool _isMlSignal(List<String> signals) {
  return signals.any((s) => s.startsWith('ML_Detection('));
}

String _signatureFamily(String raw) {
  final r = raw.toLowerCase();

  if (r.contains('miner')) return 'Miner';
  if (r.contains('dropper')) return 'Dropper';
  if (r.contains('banker')) return 'Banker';
  if (r.contains('spyware')) return 'Spyware';
  if (r.contains('adware')) return 'Adware';
  if (r.contains('sms')) return 'SMS.Fraud';
  if (r.contains('trojan')) return 'Trojan';
  if (r.contains('riskware')) return 'Riskware';

  return 'Generic';
}

String _structuredHashLabel(String path) {
  if (_isApkPath(path)) return 'Android.Generic.Sigg';
  return 'Generic.Hash.Match';
}

String _structuredSignatureLabel(String raw, double confidence) {
  final family = _signatureFamily(raw);
  final suffix = confidence >= 0.95 ? 'In' : 'Susp';
  return 'Android.Sigg.$family.$suffix';
}

String _structuredLabelFromSignals({
  required String path,
  required List<String> signals,
}) {
  if (_isHashSignal(signals)) {
    return _structuredHashLabel(path);
  }

  final signature = signals.firstWhere(
        (s) =>
    !s.startsWith('ML_Detection(') &&
        s != 'HashMatch' &&
        !s.startsWith('SignerMatch('),
    orElse: () => '',
  );

  if (signature.isNotEmpty) {
    return _structuredSignatureLabel(signature, 0.95);
  }

  if (_isMlSignal(signals)) {
    return 'Android.MUniverse.Susp';
  }

  return 'Suspicious.Item';
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

  bool useCloudScan = true;
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

  Future<void> _recordManualReportEvent({
    required int scannedCount,
    required int threatsCount,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(
      'security_report_manual_scans_total',
      (prefs.getInt('security_report_manual_scans_total') ?? 0) + 1,
    );
    await prefs.setInt(
      'security_report_files_scanned_total',
      (prefs.getInt('security_report_files_scanned_total') ?? 0) + scannedCount,
    );
    await prefs.setInt(
      'security_report_threats_total',
      (prefs.getInt('security_report_threats_total') ?? 0) + threatsCount,
    );
    await prefs.setInt('security_report_last_manual_scan_at', now);
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

    if (!prefs.containsKey('useCloudScan')) {
      await prefs.setBool('useCloudScan', true);
    }

    final enabled = prefs.getBool('useCloudScan') ?? true;

    if (!mounted) return;
    setState(() {
      useCloudScan = enabled;
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
            label: _structuredHashLabel(effectivePath),
            confidence: 1.0,
            signals: const ['HashMatch'],
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
    await _recordManualReportEvent(
      scannedCount: 1,
      threatsCount: infectedFlag ? 1 : 0,
    );
    if (!mounted) return;
    setState(() {
      scanned = 1;
      singleResult = infectedFlag;
      state = ScanState.result;
    });
  }

  Future<void> _runSingleScan() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.insert_drive_file_rounded,
                  color: theme.colorScheme.primary,
                ),
                title: Text(
                  'Scan a file',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface.withOpacity(0.88),
                  ),
                ),
                onTap: () => Navigator.pop(context, 'file'),
              ),
              ListTile(
                leading: Icon(
                  Icons.apps_rounded,
                  color: theme.colorScheme.secondary,
                ),
                title: Text(
                  'Scan an installed app',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface.withOpacity(0.88),
                  ),
                ),
                onTap: () => Navigator.pop(context, 'app'),
              ),
              ListTile(
                leading: Icon(
                  Icons.rule_folder_rounded,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                title: Text(
                  'Manage exclusions',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface.withOpacity(0.88),
                  ),
                ),
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
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ScanInstalledAppSheet(apps: apps),
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
              label: _structuredHashLabel(app.path),
              confidence: 1.0,
              signals: const ['HashMatch'],
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
    await _recordManualReportEvent(
      scannedCount: 1,
      threatsCount: infectedFlag ? 1 : 0,
    );
    if (!mounted) return;
    setState(() {
      scanned = 1;
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

  Color _modeAccent(ColorScheme scheme) {
    return switch (mode) {
      ScanMode.smart => scheme.secondary,
      ScanMode.rapid => scheme.primary,
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
                  color: Colors.black.withOpacity(0.55),
                  child: Center(
                    child: Card(
                      elevation: 0,
                      color: theme.cardTheme.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: theme.colorScheme.primary,
                              ),
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


  Widget _scanBlock({
    required BuildContext context,
    required Color accent,
    required IconData icon,
    required Widget child,
    double sideWidth = 78,
    EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(16, 16, 14, 16),
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: sideWidth,
                color: accent.withOpacity(
                  theme.brightness == Brightness.dark ? 0.18 : 0.12,
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: sideWidth,
                child: Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Icon(
                    icon,
                    color: accent,
                    size: 31,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w900,
        color: theme.colorScheme.onSurface.withOpacity(0.92),
      ),
    );
  }

  ButtonStyle _primaryButtonStyle(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilledButton.styleFrom(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15),
    );
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

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 6),
          _scanBlock(
            context: context,
            accent: accent,
            icon: icon,
            sideWidth: 84,
            padding: const EdgeInsets.fromLTRB(16, 18, 14, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _modeTitle(),
                  style: text.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface.withOpacity(0.92),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  mode == ScanMode.full
                      ? 'Scanned: $scanned items'
                      : total <= 0
                      ? 'Progress: 0%'
                      : 'Progress: $pct ($scanned / $total)',
                  style: text.bodySmall?.copyWith(
                    color: scheme.onSurface.withOpacity(0.56),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 13),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: mode == ScanMode.full ? null : progress,
                    minHeight: 7,
                    color: accent,
                    backgroundColor: scheme.surface.withOpacity(0.72),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _scanBlock(
            context: context,
            accent: scheme.primary,
            icon: Icons.description_rounded,
            padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current item',
                  style: text.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface.withOpacity(0.88),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  currentFile.isEmpty ? 'Preparing scan...' : currentFile,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall?.copyWith(
                    color: scheme.onSurface.withOpacity(0.54),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (mode != ScanMode.full)
            SizedBox(
              height: 190,
              child: _logBox(context),
            ),
          if (mode == ScanMode.full) const Spacer(),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 6),
              child: TextButton.icon(
                onPressed: _cancelScan,
                icon: Icon(Icons.close_rounded, color: scheme.error),
                label: Text(
                  'Cancel Scan',
                  style: TextStyle(
                    color: scheme.error,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _displayLabel(String label) {
    return label;
  }

  String _explainLabel(String label) {
    if (label == 'Android.Generic.Sigg') {
      return 'This APK was identified as malware! We recommend that you delete it.';
    }

    if (label == 'Generic.Hash.Match') {
      return 'This file was identified as malware! We recommend that you delete it.';
    }

    if (label == 'Android.MUniverse.Susp') {
      return 'This Android app shows patterns commonly associated with unsafe apps. We recommend to delete it.';
    }

    if (label.startsWith('Android.Sigg.')) {
      if (label.endsWith('.In')) {
        return 'This Android app matches a known threat pattern and may put your device or data at risk. We recommend to delete it.';
      }

      if (label.endsWith('.Susp')) {
        return 'This item shows suspicious activity or patterns that may put your device or data at risk.';
      }
    }

    return 'This item shows suspicious activity or patterns that may put your device or data at risk.';
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

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 22),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _scanBlock(
                    context: context,
                    accent: accent,
                    icon: headerIcon,
                    sideWidth: 84,
                    padding: const EdgeInsets.fromLTRB(16, 18, 14, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scan Complete',
                          style: text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: scheme.onSurface.withOpacity(0.92),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          hasThreats
                              ? '${infected.length} suspicious item${infected.length == 1 ? '' : 's'} found'
                              : 'No threats detected in scanned items.',
                          style: text.bodySmall?.copyWith(
                            color: scheme.onSurface.withOpacity(0.56),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _statChip(
                        context,
                        icon: Icons.storage_rounded,
                        label: '$scanned scanned',
                        accent: scheme.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _statChip(
                        context,
                        icon: hasThreats
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_rounded,
                        label: hasThreats
                            ? '${infected.length} suspicious'
                            : '$cleanCount clean',
                        accent: hasThreats ? scheme.error : scheme.secondary,
                      ),
                    ),
                  ],
                ),
                  const SizedBox(height: 12),
                  _scanBlock(
                    context: context,
                    accent: hasThreats ? scheme.error : scheme.secondary,
                    icon: hasThreats
                        ? Icons.report_rounded
                        : Icons.shield_rounded,
                    padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasThreats
                              ? (mode == ScanMode.installed
                              ? 'Suspicious apps'
                              : 'Suspicious items')
                              : 'No threats detected',
                          style: text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: scheme.onSurface.withOpacity(0.9),
                          ),
                        ),
                        if (hasThreats) ...[
                          const SizedBox(height: 8),
                          ...infected.map((d) {
                            return Theme(
                              data: theme.copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                childrenPadding:
                                const EdgeInsets.only(bottom: 12),
                                dense: true,
                                visualDensity:
                                const VisualDensity(vertical: -2),
                                leading: Icon(
                                  Icons.warning_amber_rounded,
                                  size: 18,
                                  color: scheme.error,
                                ),
                                title: Text(
                                  d.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: text.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: scheme.onSurface.withOpacity(0.88),
                                  ),
                                ),
                                subtitle: Text(
                                  _displayLabel(d.label),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: text.bodySmall?.copyWith(
                                    color: scheme.error.withOpacity(0.9),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                children: [
                                  Text(
                                    _explainLabel(d.label),
                                    style: text.bodySmall?.copyWith(
                                      color: scheme.onSurface.withOpacity(0.6),
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ] else ...[
                          const SizedBox(height: 6),
                          Text(
                            'No threats detected in scanned items.',
                            style: text.bodySmall?.copyWith(
                              color: scheme.onSurface.withOpacity(0.54),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: _primaryButtonStyle(context),
                      onPressed: _finishToHome,
                      child: Text(
                        'Return Home',
                        style: text.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _scanBlock(
                context: context,
                accent: scheme.primary,
                icon: Icons.info_outline_rounded,
                sideWidth: 84,
                padding: const EdgeInsets.fromLTRB(16, 18, 14, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No vulnerable files to scan',
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: scheme.onSurface.withOpacity(0.92),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Your device did not contain any files matching the scan criteria.',
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurface.withOpacity(0.54),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: _primaryButtonStyle(context),
                  onPressed: _finishToHome,
                  child: Text(
                    'Return Home',
                    style: text.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.onPrimary,
                    ),
                  ),
                ),
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
      color: theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            color: scheme.surface.withOpacity(theme.brightness == Brightness.dark ? 0.42 : 0.56),
            child: Text(
              'Scan log',
              style: text.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: scheme.onSurface.withOpacity(0.88),
              ),
            ),
          ),
          Expanded(
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
                            color: scheme.onSurface.withOpacity(0.54),
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
          ),
        ],
      ),
    );
  }

  Widget _statChip(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color accent,
      }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return Card(
      elevation: 0,
      color: theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: accent.withOpacity(theme.brightness == Brightness.dark ? 0.16 : 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 17, color: accent),
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.labelSmall?.copyWith(
                  color: scheme.onSurface.withOpacity(0.82),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowIcon(IconData icon, Color color) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 42, color: color),
    );
  }

}

class _ScanInstalledAppSheet extends StatefulWidget {
  final List<_AppTarget> apps;

  const _ScanInstalledAppSheet({required this.apps});

  @override
  State<_ScanInstalledAppSheet> createState() => _ScanInstalledAppSheetState();
}

class _ScanInstalledAppSheetState extends State<_ScanInstalledAppSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    final filtered = _query.isEmpty
        ? widget.apps
        : widget.apps.where((a) {
      return a.name.toLowerCase().contains(_query) ||
          a.package.toLowerCase().contains(_query);
    }).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.onSurface.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Installed Apps',
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: scheme.onSurface.withOpacity(0.92),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      style: text.bodyMedium?.copyWith(
                        color: scheme.onSurface.withOpacity(0.88),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search apps...',
                        hintStyle: text.bodyMedium?.copyWith(
                          color: scheme.onSurface.withOpacity(0.38),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: scheme.onSurface.withOpacity(0.45),
                        ),
                        filled: true,
                        fillColor: scheme.surfaceContainerHigh,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                  child: Text(
                    'No apps found.',
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                )
                    : ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) {
                    final app = filtered[i];
                    return _ScanAppListTile(
                      key: ValueKey(app.package),
                      app: app,
                      onTap: () => Navigator.pop(context, app),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ScanAppListTile extends StatefulWidget {
  final _AppTarget app;
  final VoidCallback onTap;

  const _ScanAppListTile({
    super.key,
    required this.app,
    required this.onTap,
  });

  @override
  State<_ScanAppListTile> createState() => _ScanAppListTileState();
}

class _ScanAppListTileState extends State<_ScanAppListTile> {
  static const _channel = MethodChannel('cs.fastapps');
  Uint8List? _iconBytes;

  @override
  void initState() {
    super.initState();
    _loadIcon();
  }

  @override
  void didUpdateWidget(covariant _ScanAppListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.app.package != widget.app.package) {
      _iconBytes = null;
      _loadIcon();
    }
  }

  Future<void> _loadIcon() async {
    try {
      final bytes = await _channel.invokeMethod<Uint8List>(
        'getAppIconPng',
        {'package': widget.app.package},
      );
      if (mounted) setState(() => _iconBytes = bytes);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 42,
                height: 42,
                child: _iconBytes != null
                    ? Image.memory(_iconBytes!, fit: BoxFit.cover)
                    : Container(
                  color: scheme.surfaceContainerHigh,
                  child: Icon(
                    Icons.android_rounded,
                    size: 24,
                    color: scheme.onSurface.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.app.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface.withOpacity(0.88),
                    ),
                  ),
                  Text(
                    widget.app.package,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: scheme.onSurface.withOpacity(0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}