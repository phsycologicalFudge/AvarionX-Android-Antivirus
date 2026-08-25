import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/build_flags.dart';
import '../../../services/cloud_helper_service.dart';
import '../../../services/cloud/cloud_auth_service.dart';
import '../../../services/exclusion_service.dart';
import '../../../services/foreground_service.dart';
import '../../../services/quarantine_service.dart';
import '../../../services/reviews/review_service.dart';
import '../../../services/scan api/headless_scan.dart';
import '../../../services/scan api/community_submissions/community_submission_service.dart';
import '../../../services/scan api/scan_types.dart';
import '../../../services/scan_session_service.dart';
import '../../../utils/hash_cache_worker.dart';
import '../../../widgets/mesh_background.dart';
import '../../../services/theme/theme_manager.dart';
import '../../exclusions/exclusion_manager_screen.dart';
import '../../main_shell.dart';

import 'app_target.dart';
import 'log_buffer.dart';
import 'scan_installed_app_sheet.dart';
import 'scan_isolate_worker.dart';

import '../../../translations/app_localizations.dart';
class ScanScreen extends StatefulWidget {
  final ScanMode? startMode;

  const ScanScreen({super.key, this.startMode});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool useCloudScan = true;
  late final CloudScanner cloudScanner;

  ScanMode mode = ScanMode.none;
  ScanState state = ScanState.idle;

  bool cancelled = false;
  bool cancellingUi = false;
  bool openingPicker = false;
  int scanned = 0;
  int total = 0;
  int fullCleanCount = 0;
  String currentFile = '';
  String currentPath = '';
  String currentStageMessage = '';
  List<String> clean = [];
  List<DetectionResult> infected = [];
  bool? singleResult;

  bool _vpnUpsellVisible = true;
  bool isFlashingStage = false;
  Timer? _stageFlashTimer;

  ScanWorker? _scanWorker;
  Future<ScanWorker>? _scanWorkerFuture;
  bool _headlessCancelRequested = false;
  bool _headlessDetached = false;
  Future<void>? _activeScanFuture;

  final ScanSessionService _session = ScanSessionService.instance;
  late final VoidCallback _sessionListener;

  late AnimationController _pulse;
  late AnimationController _spinController;
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
    final l10n = AppLocalizations.of(context)!;
    if (mode == ScanMode.full) {
      if (currentFile.isEmpty) return l10n.scanNotificationFullItems(scanned);
      return l10n.scanNotificationCurrent(scanned, currentFile);
    }
    if (total > 0) {
      if (currentFile.isEmpty) return l10n.scanNotificationProgress(scanned, total);
      return l10n.scanNotificationProgressCurrent(scanned, total, currentFile);
    }
    if (currentFile.isEmpty) return l10n.scanPreparing;
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
      await ForegroundService.toast(
        text: AppLocalizations.of(context)!.scanCancelled,
      );
      return;
    }
    await ForegroundService.notify(
      title: AppLocalizations.of(context)!.scanUiScanComplete,
      text: hasThreats
          ? AppLocalizations.of(context)!.scanSuspiciousItemsFound(
              infected.length,
              infected.length == 1 ? '' : 's',
            )
          : AppLocalizations.of(context)!.resultNoThreatsTitle,
    );
  }


  void _appendScanLog(String line) {
    LogBuffer.add(line);
  }

  void _applyHeadlessEvent(HeadlessScanEvent e) {
    final name = e.name ?? (e.path?.split('/').last ?? '');
    final uiUpdateDue = !_uiProgressThrottle.isRunning || _uiProgressThrottle.elapsedMilliseconds >= 120;

    if (e.type == 'stage_change') {
      currentStageMessage = e.message ?? '';
      currentFile = '';
      currentPath = '';
      isFlashingStage = true;
      if (mounted) setState(() {});

      _stageFlashTimer?.cancel();
      _stageFlashTimer = Timer(const Duration(milliseconds: 2200), () {
        if (mounted) setState(() => isFlashingStage = false);
      });
      _pushSessionSnapshot();
      return;
    }

    if (e.type == 'hashing') {
      currentFile = name;
      if (e.path != null) currentPath = e.path!;
      if (mounted && uiUpdateDue) {
        _uiProgressThrottle..reset()..start();
        setState(() {});
      }
      return;
    }

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
        if (mounted) {
          setState(() { state = ScanState.empty; });
        } else {
          state = ScanState.empty;
        }
      } else {
        if (mounted) {
          setState(() { total = nextTotal; });
        }
      }
      _pushSessionSnapshot();
      return;
    }

    if (e.type == 'current' || e.type == 'progress') {
      if (e.scanned != null) scanned = e.scanned!;
      if (e.total != null) total = e.total!;
      if (name.isNotEmpty) currentFile = name;
      if (e.path != null) currentPath = e.path!;

      if (mounted && uiUpdateDue) {
        _uiProgressThrottle..reset()..start();
        setState(() {});
      }
      if (!_notifProgressThrottle.isRunning || _notifProgressThrottle.elapsedMilliseconds >= 700) {
        _notifProgressThrottle..reset()..start();
        unawaited(_updateOngoingScanNotification());
      }
      _pushSessionSnapshot();
      return;
    }

    if (e.type == 'clean') {
      if (e.scanned != null) scanned = e.scanned!;
      if (e.total != null) total = e.total!;
      if (name.isNotEmpty) currentFile = name;
      if (e.path != null) currentPath = e.path!;

      if (mode == ScanMode.full) {
        fullCleanCount++;
      } else if (name.isNotEmpty) {
        clean.add(name);
      }

      if (mounted && uiUpdateDue) {
        _uiProgressThrottle..reset()..start();
        setState(() {});
      }
      _pushSessionSnapshot();
      return;
    }

    if (e.type == 'hit') {
      if (e.scanned != null) scanned = e.scanned!;
      if (e.total != null) total = e.total!;
      if (name.isNotEmpty) currentFile = name;
      if (e.path != null) currentPath = e.path!;

      infected.add(
        DetectionResult(
          name: name,
          label: e.label ?? 'Suspicious.Item',
          confidence: e.confidence ?? 0.0,
          signals: e.signals ?? const [],
          path: e.path,
          quarantinePath: e.quarantinePath,
          apkSize: e.apkSize,
        ),
      );
      if (mounted) setState(() {});
      _pushSessionSnapshot();
      return;
    }

    if (e.type == 'err') {
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
        currentPath = '';
        currentStageMessage = '';
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
      currentPath = '';
      currentStageMessage = '';
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
      if (result.threats == 0 && !result.cancelled && result.scanned > 0) {
        unawaited(ReviewService().onCleanScanCompleted());
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

    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    cloudScanner = CloudScanner(
      endpoint: 'https://api.colourswift.com/hash_cloud',
      apiKey: CloudAuthService.sessionToken ?? '',
    );

    _sessionListener = _onSessionChanged;
    _session.addListener(_sessionListener);
    _loadVpnUpsellPref();

    if (_session.isScanning || _session.cancelling) {
      _loadCloud();
      _pullSessionSnapshot();
      return;
    }

    if (widget.startMode != null) {
      _loadCloud().then((_) {
        if (!mounted) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          mode = widget.startMode!;
          _checkAndStart(mode);
        });
      });
    } else {
      _loadCloud();
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
    _spinController.dispose();
    _stageFlashTimer?.cancel();
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
      'path': d.path,
      'quarantinePath': d.quarantinePath,
      'apkSize': d.apkSize,
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
        path: m['path']?.toString(),
        quarantinePath: m['quarantinePath']?.toString(),
        apkSize: m['apkSize'] is num ? (m['apkSize'] as num).toInt() : null,
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

  void _navigateHome() {
    final shell = MainShell.of(context);
    final nav = Navigator.of(context);

    if (shell != null) {
      shell.goHome();
      if (nav.canPop()) nav.pop();
    } else {
      nav.pop();
    }
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

    _session.removeListener(_sessionListener);
    _session.clear();

    if (!mounted) return;
    _navigateHome();
  }

  void _finishToHome() {
    _session.removeListener(_sessionListener);

    if (state != ScanState.scanning) {
      debugPrint(
        '[COMMUNITY] Return to home trigger state=${state.name} detections=${infected.length}',
      );
      unawaited(
        CommunitySubmissionService.processManualDetections(
          List<DetectionResult>.from(infected),
        ),
      );
      _session.clear();
    }
    if (!mounted) return;
    _navigateHome();
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

  Future<List<AppTarget>> _getUserInstalledApps() async {
    try {
      final List<dynamic> raw = await _fastApps.invokeMethod("listUserApps");
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

  Future<void> _runSingleFileScan() async {
    if (mounted) {
      setState(() {
        openingPicker = true;
      });
    }
    final picked = await FilePicker.platform.pickFiles(
      withData: false,
      allowMultiple: false,
    );
    if (mounted) {
      setState(() {
        openingPicker = false;
      });
    }
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
            label: structuredHashLabel(effectivePath),
            confidence: 1.0,
            signals: const ['HashMatch'],
            path: effectivePath,
          ),
        );
      }
    }
    if (!infectedFlag) {
      final worker = await _ensureWorker();
      final res = await worker.scan(effectivePath);
      if (res is Map) {
        infectedFlag = true;
        final detection = detectionFromRes(
          name: file.name,
          res: res,
        );
        infected.add(
          DetectionResult(
            name: detection.name,
            label: detection.label,
            confidence: detection.confidence,
            signals: detection.signals,
            path: effectivePath,
          ),
        );
      }
    }
    if (infectedFlag) {
      int apkSize = 0;
      String? quarantinePath;
      try {
        apkSize = await File(effectivePath).length();
      } catch (_) {}
      if (QuarantineService.canQuarantinePath(effectivePath)) {
        try {
          final meta = await QuarantineService.quarantineFile(effectivePath);
          final qPath = meta['qPath'];
          final size = meta['size'];
          if (qPath is String && qPath.isNotEmpty) quarantinePath = qPath;
          if (size is num) apkSize = size.toInt();
        } catch (_) {}
      }
      if (infected.isNotEmpty) {
        final detection = infected.last;
        infected[infected.length - 1] = DetectionResult(
          name: detection.name,
          label: detection.label,
          confidence: detection.confidence,
          signals: detection.signals,
          path: effectivePath,
          quarantinePath: quarantinePath,
          apkSize: apkSize,
        );
      }
    } else {
      clean.add(file.name);
    }
    await recordManualReportEvent(
      scanned: 1,
      threats: infectedFlag ? 1 : 0,
      cancelled: false,
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
      barrierColor: Colors.black,
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
                  AppLocalizations.of(context)!.singleChoiceScanFile,
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
                  AppLocalizations.of(context)!.singleChoiceScanInstalledApp,
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
                  AppLocalizations.of(context)!.singleChoiceManageExclusions,
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
    if (mounted) {
      setState(() {
        openingPicker = true;
      });
    }
    final apps = await _getUserInstalledApps();
    if (apps.isEmpty) {
      if (mounted) {
        setState(() {
          openingPicker = false;
        });
      }
      LogBuffer.add('[ENGINE] No installed apps available.');
      _finishToHome();
      return;
    }
    if (mounted) {
      setState(() {
        openingPicker = false;
      });
    }
    final app = await showModalBottomSheet<AppTarget>(
      context: context,
      barrierColor: Colors.black,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) => ScanInstalledAppSheet(apps: apps),
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
              label: structuredHashLabel(app.path),
              confidence: 1.0,
              signals: const ['HashMatch'],
              path: app.path,
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
        final detection = detectionFromRes(
          name: app.name,
          res: res,
        );
        infected.add(
          DetectionResult(
            name: detection.name,
            label: detection.label,
            confidence: detection.confidence,
            signals: detection.signals,
            path: app.path,
          ),
        );
      }
    }
    if (infectedFlag && infected.isNotEmpty) {
      int apkSize = 0;
      try {
        apkSize = await File(app.path).length();
      } catch (_) {}
      final detection = infected.last;
      infected[infected.length - 1] = DetectionResult(
        name: detection.name,
        label: detection.label,
        confidence: detection.confidence,
        signals: detection.signals,
        path: app.path,
        apkSize: apkSize,
      );
    } else if (!infectedFlag) {
      clean.add(app.name);
    }
    await recordManualReportEvent(
      scanned: 1,
      threats: infectedFlag ? 1 : 0,
      cancelled: false,
    );
    if (!mounted) return;
    setState(() {
      scanned = 1;
      singleResult = infectedFlag;
      state = ScanState.result;
    });
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
    final l10n = AppLocalizations.of(context)!;
    return switch (mode) {
      ScanMode.smart => l10n.scanTitleSmart,
      ScanMode.rapid => l10n.scanTitleRapid,
      ScanMode.installed => l10n.scanTitleInstalled,
      ScanMode.full => l10n.scanTitleFull,
      ScanMode.single => l10n.scanTitleSingle,
      _ => l10n.scanTitleDefault,
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final themeManager = Provider.of<ThemeManager>(context);
    final scheme = theme.colorScheme;
    final hasThreats = infected.isNotEmpty;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: null,
      body: ClipRect(
        child: MeshBackground(
          blobs: themeManager.meshBlobs,
          base: scheme.surface,
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOut,
                    color: hasThreats
                        ? scheme.error.withOpacity(0.22)
                        : Colors.transparent,
                  ),
                ),
              ),
              if (openingPicker)
                Positioned.fill(
                  child: ColoredBox(
                    color: scheme.surface,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: scheme.primary,
                      ),
                    ),
                  ),
                ),
              if (!openingPicker)
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
                                  AppLocalizations.of(context)!.cancellingScan,
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
        ),
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
    return _buildScanningMain(context);
  }

  Widget _buildStageFlash(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                RotationTransition(
                  turns: _spinController,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.1),
                          theme.colorScheme.primary,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Icon(Icons.shield_rounded, size: 40, color: theme.colorScheme.primary),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            currentStageMessage,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningMain(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final accent = infected.isNotEmpty ? scheme.error : _modeAccent(scheme);
    final icon = _modeIcon();
    final pct = mode == ScanMode.full ? '' : '${(progress * 100).clamp(0.0, 100.0).toStringAsFixed(0)}%';

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
                if (currentStageMessage.isNotEmpty)
                  Text(
                    currentStageMessage,
                    style: text.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: accent,
                    ),
                  ),
                const SizedBox(height: 5),
                Text(
                  mode == ScanMode.full
                      ? AppLocalizations.of(context)!.scanUiScannedItems(scanned)
                      : total <= 0
                      ? AppLocalizations.of(context)!.scanProgressZero
                      : AppLocalizations.of(context)!.scanUiProgress(pct, scanned, total),
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

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotationTransition(
                    turns: _spinController,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: scheme.primary.withOpacity(0.3),
                          width: 3,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                      child: Icon(
                        Icons.search_rounded,
                        size: 32,
                        color: scheme.primary.withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    currentFile.isEmpty ? AppLocalizations.of(context)!.scanUiPreparingEngine : currentFile,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface.withOpacity(0.88),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentPath.isEmpty ? AppLocalizations.of(context)!.scanUiLoadingTargetS : currentPath,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(0.45),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 6),
              child: TextButton.icon(
                onPressed: _cancelScan,
                icon: Icon(Icons.close_rounded, color: scheme.error),
                label: Text(
                  AppLocalizations.of(context)!.cancelScan,
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
    final lastDot = label.lastIndexOf('.');
    if (lastDot <= 0) return label;
    return '${label.substring(0, lastDot + 1)}\n${label.substring(lastDot + 1)}';
  }

  Uri? _threatUrl(String label) {
    if (label == 'Android.KnownMalware.HashMatch' ||
        label == 'Generic.KnownMalware.HashMatch') {
      return Uri.parse('https://colourswift.com/threatDatabase/hashmatch');
    }
    if (label == 'Android.MUniverse.Gen') {
      return Uri.parse('https://colourswift.com/threatDatabase/muniverse');
    }
    final parts = label.split('.');
    if (parts.length >= 3) {
      final slug = parts[2].toLowerCase();
      return Uri.parse('https://colourswift.com/threatDatabase/$slug');
    }
    return null;
  }

  Future<void> _openThreatUrl(String label) async {
    final url = _threatUrl(label);
    if (url == null) return;
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    }
  }

  Future<void> _openVpnAppStoreListing() async {
    if (kGithubBuild) {
      final url = Uri.parse('https://github.com/phsycologicalFudge/AvarionX-VPN');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
      return;
    }

    const pkg = 'com.colourswift.avarionxvpn';
    final market = Uri.parse('market://details?id=$pkg');
    final web = Uri.parse('https://play.google.com/store/apps/details?id=$pkg');

    try {
      final launched = await launchUrl(
        market,
        mode: LaunchMode.externalNonBrowserApplication,
      );
      if (launched) return;
    } catch (_) {}

    if (await canLaunchUrl(web)) {
      await launchUrl(web, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _loadVpnUpsellPref() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissed = prefs.getBool('scan_vpn_upsell_dismissed') ?? false;
    if (dismissed && mounted) setState(() => _vpnUpsellVisible = false);
  }

  Future<void> _dismissVpnUpsell() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('scan_vpn_upsell_dismissed', true);
    if (mounted) setState(() => _vpnUpsellVisible = false);
  }

  Widget _buildVpnUpsellCard(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return Card(
      elevation: 0,
      color: theme.cardTheme.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: _openVpnAppStoreListing,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      'assets/icons/vpn_icon.png',
                      width: 26,
                      height: 26,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.scanUiAvarionxVPN,
                          style: text.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface.withOpacity(0.75),
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppLocalizations.of(context)!.scanUiProtectYourInternetWithOurUnlimitedVPN,
                          style: text.bodySmall?.copyWith(
                            fontSize: 10,
                            height: 1.2,
                            color: scheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _dismissVpnUpsell,
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: scheme.onSurface.withOpacity(0.35),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.scanUiTapMe,
                style: text.bodySmall?.copyWith(
                  fontSize: 10,
                  color: scheme.onSurface.withOpacity(0.28),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
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
                          AppLocalizations.of(context)!.scanComplete,
                          style: text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: scheme.onSurface.withOpacity(0.92),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          hasThreats
                              ? AppLocalizations.of(context)!.scanSuspiciousItemsFound(
                                  infected.length,
                                  infected.length == 1 ? '' : 's',
                                )
                              : AppLocalizations.of(context)!.resultNoThreatsBody,
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
                          label: AppLocalizations.of(context)!.scanUiScanned(scanned),
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
                              ? AppLocalizations.of(context)!.scanSuspiciousCount(infected.length)
                              : AppLocalizations.of(context)!.scanCleanCount(cleanCount),
                          accent: hasThreats ? scheme.error : scheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _scanBlock(
                    context: context,
                    accent: hasThreats ? Colors.transparent : scheme.secondary,
                    icon: hasThreats
                        ? Icons.report_rounded
                        : Icons.shield_rounded,
                    sideWidth: hasThreats ? 0 : 42,
                    padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasThreats
                              ? (mode == ScanMode.installed
                              ? AppLocalizations.of(context)!.resultSuspiciousAppsTitle
                              : AppLocalizations.of(context)!.resultSuspiciousItemsTitle)
                              : AppLocalizations.of(context)!.resultNoThreatsTitle,
                          style: text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: scheme.onSurface.withOpacity(0.9),
                          ),
                        ),
                        if (hasThreats) ...[
                          const SizedBox(height: 8),
                          ...infected.map((d) {
                            return InkWell(
                              onTap: () => _openThreatUrl(d.label),
                              borderRadius: BorderRadius.circular(6),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 9),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      size: 18,
                                      color: scheme.error,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            d.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: text.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: scheme.onSurface.withOpacity(0.88),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  d.label.replaceAll('.', '\u2024'),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: text.bodySmall?.copyWith(
                                                    color: scheme.error.withOpacity(0.9),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: Icon(
                                                  Icons.info_outline_rounded,
                                                  size: 14,
                                                  color: scheme.onSurface.withOpacity(0.4),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ] else ...[
                          const SizedBox(height: 6),
                          Text(
                            AppLocalizations.of(context)!.resultNoThreatsBody,
                            style: text.bodySmall?.copyWith(
                              color: scheme.onSurface.withOpacity(0.54),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: _primaryButtonStyle(context),
                onPressed: _finishToHome,
                child: Text(
                  AppLocalizations.of(context)!.scanUiReturn,
                  style: text.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          if (_vpnUpsellVisible && !hasThreats) ...[
            _buildVpnUpsellCard(context),
            const SizedBox(height: 8),
          ],
        ],
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
                      AppLocalizations.of(context)!.emptyTitle,
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: scheme.onSurface.withOpacity(0.92),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      AppLocalizations.of(context)!.emptyBody,
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
                    AppLocalizations.of(context)!.returnHome,
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
