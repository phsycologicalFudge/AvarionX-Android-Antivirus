import 'dart:async';
import 'dart:isolate';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/antivirus_bridge.dart';
import '../utils/defs_loader.dart';
import '../utils/defs_manager.dart';

class AvEngine {
  static Future<int>? _initFuture;
  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static const String _kMaxConcurrentKey = 'scan_limits_max_concurrent';
  static const String _kMaxThreadsKey = 'scan_limits_max_threads';

  static void prewarm() {
    if (_initFuture != null) return;
    Future.delayed(const Duration(milliseconds: 400), () {
      ensureInitialized();
    });
  }

  static Future<int> ensureInitialized() {
    if (_initFuture != null) return _initFuture!;
    _initFuture = _init();
    return _initFuture!;
  }

  static Future<int> _init() async {
    try {
      await ensureAntivirusFiles();
      final (defsPath, keyPath) = await DefsManager.ensureLiteDefinitions();

      final prefs = await SharedPreferences.getInstance();
      final maxConcurrent = prefs.getInt(_kMaxConcurrentKey) ?? 1;
      final maxThreads = prefs.getInt(_kMaxThreadsKey) ?? 0;

      final result = await _runRustInit(
        defsPath,
        keyPath,
        maxConcurrent,
        maxThreads,
      );

      _initialized = (result == 0);
      return result;
    } catch (_) {
      return -1;
    }
  }

  static Future<int> _runRustInit(
      String defsPath,
      String keyPath,
      int maxConcurrent,
      int maxThreads,
      ) async {
    final receivePort = ReceivePort();

    await Isolate.spawn<_InitMessage>(
      _rustInitEntry,
      _InitMessage(
        sendPort: receivePort.sendPort,
        defsPath: defsPath,
        keyPath: keyPath,
        maxConcurrent: maxConcurrent,
        maxThreads: maxThreads,
      ),
    );

    return await receivePort.first as int;
  }
}

class _InitMessage {
  final SendPort sendPort;
  final String defsPath;
  final String keyPath;
  final int maxConcurrent;
  final int maxThreads;

  _InitMessage({
    required this.sendPort,
    required this.defsPath,
    required this.keyPath,
    required this.maxConcurrent,
    required this.maxThreads,
  });
}

void _rustInitEntry(_InitMessage msg) {
  try {
    final av = AntivirusBridge(enableScanLogs: false);
    av.setScanLimits(msg.maxConcurrent, msg.maxThreads);
    final code = av.init(msg.defsPath, msg.keyPath);
    av.free();
    msg.sendPort.send(code);
  } catch (_) {
    msg.sendPort.send(-1);
  }
}
