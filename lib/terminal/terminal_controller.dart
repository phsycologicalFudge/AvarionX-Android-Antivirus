import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:colourswift_av/terminal/sys_info.dart';
import 'package:colourswift_av/terminal/terminal_commandHandler.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/cloud_helper_service.dart';
import '../services/exclusion_service.dart';
import '../services/quarantine_service.dart';
import '../services/service_manager.dart';
import '../utils/hash_cache_worker.dart';
import '../widgets/antivirus_bridge.dart';

class TerminalController {
  late final List<TerminalCommand> _commands;
  final List<String> log = [];

  bool _isScanning = false;
  bool _useCloudPref = false;

  StreamSubscription? _procSub;
  CloudScanner? _cloudScanner;

  static const _processStream =
  EventChannel('colourswift/process_logs');

  static const _heuristicStream =
  EventChannel('colourswift/heuristic_logs');

  void init(void Function(String) emit) {
    _heuristicStream.receiveBroadcastStream().listen((event) {
      _append(event.toString(), emit);
    });

    _append("AVarionX Terminal v2.0", emit);
    _append("Type 'help' for terminal documentation.", emit);
    _loadCloudPref();

    _cloudScanner = CloudScanner(
      endpoint: 'https://efkou1u21ooih2hko.colourswift.com',
      apiKey: '23JVO3ojo23oO3O423rrTR',
    );

    _commands = _buildCommands();
  }

  String _formatLog(String raw) {
    final ts = DateTime.now();
    final time =
        '${ts.hour.toString().padLeft(2, '0')}:'
        '${ts.minute.toString().padLeft(2, '0')}:'
        '${ts.second.toString().padLeft(2, '0')}';

    if (raw.startsWith('[')) {
      return '[$time] $raw';
    }

    return '[$time] [INFO] $raw';
  }

  void _append(String text, void Function(String) emit) {
    final line = _formatLog(text);
    log.add(line);
    emit(line);
  }

  Future<void> runCommand(String cmd, void Function(String) emit) async {
    final raw = cmd.trim();
    if (raw.isEmpty) return;

    _append("AX@local > $raw", emit);

    var lower = raw.toLowerCase();
    bool forceCloud = false;

    if (lower.contains('/c')) {
      forceCloud = true;
      lower = lower.replaceAll('/c', '').trim();
    }

    for (final command in _commands) {
      if (command.matches(lower)) {
        await command.run(raw, forceCloud, emit);
        return;
      }
    }

    _append("Unknown command. Type 'help'.", emit);
  }

  Future<void> _openTerminalDocs(void Function(String) emit) async {
    const url = 'https://colourswift.com/terminal_documentation';
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _append("[ERROR] Unable to open documentation", emit);
    }
  }

  Future<void> _loadCloudPref() async {
    final prefs = await SharedPreferences.getInstance();
    _useCloudPref = prefs.getBool('useCloudScan') ?? false;
  }

  Future<bool> _requestVpnPermission() async {
    const chan = MethodChannel("cs_vpn_permission");
    try {
      return await chan.invokeMethod<bool>("prepareVpn") == true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _ensureStorageAccess() async {
    if (!Platform.isAndroid) return true;
    try {
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
        var status = await Permission.storage.request();
        return status.isGranted;
      }
    } catch (_) {
      return false;
    }
  }

  Future<void> _runInfoCommand(void Function(String) emit) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final defsPath = p.join(appDir.path, 'defs.vxpack');
      final keyPath = p.join(appDir.path, 'defs_key.bin');

      final android = await DeviceInfoPlugin().androidInfo;
      final ram = await _getTotalRam();

      _append("[INFO] Engine version : VX-Titanium-v7", emit);
      _append(
        "[INFO] Definitions   : ${await File(defsPath).exists() && await File(keyPath).exists() ? "loaded" : "missing"}",
        emit,
      );
      _append("[INFO] Platform      : Android ${android.version.release}", emit);
      _append("[INFO] Device        : ${android.manufacturer} ${android.model}", emit);
      _append("[INFO] RAM           : $ram", emit);
      _append("[INFO] Build mode    : ${kReleaseMode ? "release" : "debug"}", emit);
    } catch (e) {
      _append("[INFO] Failed to read system info: $e", emit);
    }
  }

  List<TerminalCommand> _buildCommands() {
    return [
      TerminalCommand(
        matches: (i) => i == 'help',
        run: (_, __, emit) async {
          emit("Opening terminal documentation…");
          emit("https://colourswift.com/terminal_documentation");
          await _openTerminalDocs(emit);
        },
      ),

      TerminalCommand(
        matches: (i) => i == 'log on',
        run: (_, __, emit) async {
          const chan = MethodChannel('colourswift/system_watcher');
          await chan.invokeMethod('startLogs');
          emit('[LOG] heuristic logging enabled');
        },
      ),

      TerminalCommand(
        matches: (i) => i == 'log off',
        run: (_, __, emit) async {
          const chan = MethodChannel('colourswift/system_watcher');
          await chan.invokeMethod('stopLogs');
          emit('[LOG] heuristic logging disabled');
        },
      ),

      TerminalCommand(
        matches: (i) => i == 'proc on',
        run: (_, __, emit) async {
          if (_procSub != null) {
            emit('[PROC] already enabled');
            return;
          }

          _procSub = _processStream
              .receiveBroadcastStream()
              .listen((event) {
            _append(event.toString(), emit);
          });

          emit('[PROC] process stream enabled');
        },
      ),

      TerminalCommand(
        matches: (i) => i == 'proc off',
        run: (_, __, emit) async {
          await _procSub?.cancel();
          _procSub = null;
          emit('[PROC] process stream disabled');
        },
      ),

      TerminalCommand(
        matches: (i) => i == 'clear',
        run: (_, __, emit) async {
          log.clear();
          emit('');
        },
      ),

      TerminalCommand(
        matches: (i) => i == 'info',
        run: (_, __, emit) async {
          await _runInfoCommand(emit);
        },
      ),

      TerminalCommand(
        matches: (input) => input == 'vpn on',
        run: (_, __, emit) async {
          final ok = await _requestVpnPermission();
          if (!ok) {
            emit("[VPN] Permission denied");
            return;
          }
          emit("[VPN] Starting VPN");
          await AvServiceManager.startVpn();
          emit("[VPN] Active");
        },
      ),

      TerminalCommand(
        matches: (input) => input.startsWith('hash '),
        run: (raw, __, emit) async {
          final path = raw.substring(5).trim();
          if (path.isEmpty) {
            emit("[HASH] No file path provided");
            return;
          }
          await _runHashCommand(path, emit);
        },
      ),

      TerminalCommand(
        matches: (input) =>
        input == 'smart' || input == 'rapid' || input == 'single',
        run: (raw, forceCloud, emit) async {
          if (_isScanning) {
            emit("[ENGINE] A scan is already running");
            return;
          }

          final useCloud = forceCloud ? true : _useCloudPref;

          if (raw == 'smart') {
            await _runSmartScan(useCloud, emit);
          } else if (raw == 'rapid') {
            await _runRapidScan(useCloud, emit);
          } else {
            await _runSingleScan(useCloud, emit);
          }
        },
      ),

      TerminalCommand(
        matches: (i) => i == 'hash pick',
        run: (_, __, emit) async {
          await _runHashPick(emit);
        },
      ),

      TerminalCommand(
        matches: (i) => i.startsWith('check '),
        run: (raw, __, emit) async {
          final query = raw.substring(6).trim();
          if (query.isEmpty) {
            emit("[URL] No domain provided");
            return;
          }
          await _runUrlCheck(query, emit);
        },
      ),

      TerminalCommand(
        matches: (i) => i == 'cloud status',
        run: (_, __, emit) async {
          await _runCloudStatus(emit);
        },
      ),

      TerminalCommand(
        matches: (i) => i.startsWith('scan folder '),
        run: (raw, forceCloud, emit) async {
          if (_isScanning) {
            emit("[ENGINE] A scan is already running");
            return;
          }

          final path = raw.substring('scan folder '.length).trim();
          if (path.isEmpty) {
            emit("[SCAN] No folder path provided");
            return;
          }

          final useCloud = forceCloud ? true : _useCloudPref;
          await _runFolderScan(path, useCloud, emit);
        },
      ),

      TerminalCommand(
        matches: (i) => i.startsWith('sys '),
        run: (raw, __, emit) async {
          final cmd = raw.substring(4).trim();

          switch (cmd) {
            case 'uname':
              emit(await SysInfo.uname());
              break;
            case 'arch':
              emit(await SysInfo.arch());
              break;
            case 'uptime':
              emit(await SysInfo.uptime());
              break;
            case 'cpu':
              emit(await SysInfo.cpu());
              break;
            case 'mem':
              emit(await SysInfo.mem());
              break;
            case 'df':
              emit(await SysInfo.disk());
              break;
            case 'net':
              emit(await SysInfo.network());
              break;
            case 'battery':
              emit(await SysInfo.battery());
              break;
            default:
              emit('[SYS] Unknown system command');
          }
        },
      ),


    ];
  }

  Future<String> _getTotalRam() async {
    try {
      final meminfo = await File('/proc/meminfo').readAsLines();
      final line = meminfo.firstWhere((l) => l.startsWith('MemTotal'));
      final kb = int.parse(line.replaceAll(RegExp(r'[^0-9]'), ''));
      return '${(kb / 1024 / 1024).toStringAsFixed(1)} GB';
    } catch (_) {
      return 'unknown';
    }
  }

  Future<void> _runHashPick(void Function(String) emit) async {
    final res = await FilePicker.platform.pickFiles();
    if (res == null || res.files.isEmpty) {
      _append("[HASH] File selection cancelled", emit);
      return;
    }
    final path = res.files.single.path;
    if (path != null) await _runHashCommand(path, emit);
  }

  Future<void> _runHashCommand(String path, void Function(String) emit) async {
    final file = File(path);
    if (!await file.exists()) {
      _append("[HASH] File not found", emit);
      return;
    }
    final bytes = await file.readAsBytes();
    _append("[HASH] File   : ${p.basename(path)}", emit);
    _append("[HASH] MD5    : ${md5.convert(bytes)}", emit);
    _append("[HASH] SHA256 : ${sha256.convert(bytes)}", emit);
  }

  Future<void> _runUrlCheck(String input, void Function(String) emit) async {
    final target = input.replaceAll(RegExp(r'https?://'), '').split('/').first;
    if (target.isEmpty) {
      _append("[URL] Invalid address", emit);
      return;
    }
    final bridge = AntivirusBridge();
    final res = bridge.checkNetwork(target, target, 443);
    _append(
      res == 0
          ? "[SAFE] No database match"
          : "[THREAT MATCH] Domain exists in threat database",
      emit,
    );
  }

  Future<void> _runCloudStatus(void Function(String) emit) async {
    if (_cloudScanner == null) {
      _append("[CLOUD] Not initialised", emit);
      return;
    }
    try {
      final res = await _cloudScanner!.checkBatch([
        "2b4f33ba1a1e392ab3c79bb6dc848d5440239323220498ad84dd5f124d510484"
      ]);
      _append(res.isNotEmpty ? "[CLOUD] Online" : "[CLOUD] Reachable", emit);
    } catch (_) {
      _append("[CLOUD] Offline or unreachable", emit);
    }
  }

  Future<void> _runSmartScan(bool useCloud, void Function(String) emit) async {
    _isScanning = true;
    try {
      if (!await _ensureStorageAccess()) {
        _append("[ENGINE] Storage permission denied", emit);
        return;
      }
      final root = Directory('/storage/emulated/0/');
      final files = <String>[];
      final ex = ExclusionService();
      await ex.load();

      await for (final e in root.list(recursive: true, followLinks: false)) {
        if (e is File && _isSmartAllowed(_ext(e.path), await e.length())) {
          if (!ex.skipFolder(e.path)) files.add(e.path);
        }
      }

      await _scanFiles(files, useCloud, emit);
    } finally {
      _isScanning = false;
    }
  }

  Future<void> _runRapidScan(bool useCloud, void Function(String) emit) async {
    _isScanning = true;
    try {
      if (!await _ensureStorageAccess()) {
        _append("[ENGINE] Storage permission denied", emit);
        return;
      }
      final dir = Directory('/storage/emulated/0/Download');
      final files = <String>[];
      final ex = ExclusionService();
      await ex.load();

      if (await dir.exists()) {
        await for (final e in dir.list(recursive: true)) {
          if (e is File && _isRapidAllowed(_ext(e.path), await e.length())) {
            if (!ex.skipFolder(e.path)) files.add(e.path);
          }
        }
      }

      await _scanFiles(files, useCloud, emit);
    } finally {
      _isScanning = false;
    }
  }

  Future<void> _runSingleScan(bool useCloud, void Function(String) emit) async {
    _isScanning = true;
    try {
      final res = await FilePicker.platform.pickFiles();
      if (res == null || res.files.isEmpty) return;
      final path = res.files.single.path;
      if (path == null) return;

      final bridge = AntivirusBridge();
      final raw = bridge.scanFile(path);
      final decoded = jsonDecode(raw);
      final infected = (decoded['hits'] as Map?)?.isNotEmpty ?? false;

      if (infected) {
        await QuarantineService.quarantineFile(path);
        _append("[THREAT] Quarantined ${p.basename(path)}", emit);
      } else {
        _append("[RESULT] No threats found", emit);
      }
    } finally {
      _isScanning = false;
    }
  }

  Future<void> _runFolderScan(
      String folderPath,
      bool useCloud,
      void Function(String) emit,
      ) async {
    _isScanning = true;
    try {
      if (!await _ensureStorageAccess()) return;
      final dir = Directory(folderPath);
      if (!await dir.exists()) {
        _append("[SCAN] Folder does not exist", emit);
        return;
      }
      final files = <String>[];
      final ex = ExclusionService();
      await ex.load();

      await for (final e in dir.list(recursive: true)) {
        if (e is File && _isSmartAllowed(_ext(e.path), await e.length())) {
          if (!ex.skipFolder(e.path)) files.add(e.path);
        }
      }

      await _scanFiles(files, useCloud, emit);
    } finally {
      _isScanning = false;
    }
  }

  Future<void> _scanFiles(
      List<String> files,
      bool useCloud,
      void Function(String) emit,
      ) async {
    final bridge = AntivirusBridge();
    int infected = 0;

    for (final path in files) {
      final raw = bridge.scanFile(path);
      final decoded = jsonDecode(raw);
      final hit = (decoded['hits'] as Map?)?.isNotEmpty ?? false;

      if (hit) {
        infected++;
        await QuarantineService.quarantineFile(path);
        _append("[THREAT] ${p.basename(path)}", emit);
      } else {
        _append("[CLEAN] ${p.basename(path)}", emit);
      }
    }

    _append("[SUMMARY] $infected suspicious • ${files.length - infected} clean", emit);
  }

  String _ext(String path) {
    final i = path.lastIndexOf('.');
    return i <= 0 ? '' : path.substring(i + 1).toLowerCase();
  }

  bool _isSmartAllowed(String ext, int size) {
    const allowed = {'apk', 'xapk', 'apkm', 'zip', 'pdf', 'txt', 'md', 'exe'};
    return allowed.contains(ext) && size <= 100 * 1024 * 1024;
  }

  bool _isRapidAllowed(String ext, int size) {
    return ext == 'apk' && size <= 200 * 1024 * 1024;
  }
}
