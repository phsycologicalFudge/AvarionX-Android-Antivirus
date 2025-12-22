import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import '../services/cloud_helper_service.dart';
import '../services/exclusion_service.dart';
import '../services/quarantine_service.dart';
import '../services/service_manager.dart';
import '../widgets/antivirus_bridge.dart';
import '../utils/hash_cache_worker.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsoleScreen extends StatefulWidget {
  const ConsoleScreen({super.key});

  @override
  State<ConsoleScreen> createState() => _ConsoleScreenState();
}

class _ConsoleScreenState extends State<ConsoleScreen>
    with AutomaticKeepAliveClientMixin {
  final List<String> _log = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();

  bool _isScanning = false;
  bool _useCloudPref = false;

  CloudScanner? _cloudScanner;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _append("CS Security Terminal v1.0");
    _append("Type 'help' for terminal documentation.");
    _loadCloudPref();
    _cloudScanner = CloudScanner(
      endpoint: 'https://efkou1u21ooih2hko.colourswift.com',
      apiKey: '23JVO3ojo23oO3O423rrTR',
    );
  }

  Future<void> _openTerminalDocs() async {
    const url = 'https://colourswift.com/terminal_documentation';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _append("[ERROR] Unable to open documentation");
    }
  }

  Future<void> _loadCloudPref() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _useCloudPref = prefs.getBool('useCloudScan') ?? false;
    });
  }

  void _append(String text) {
    if (!mounted) return;
    setState(() => _log.add(text));
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!_scroll.hasClients) return;
      final max = _scroll.position.maxScrollExtent;
      _scroll.jumpTo(max);
    });
  }

  Future<bool> _requestVpnPermission() async {
    final chan = MethodChannel("cs_vpn_permission");
    try {
      final ok = await chan.invokeMethod<bool>("prepareVpn");
      return ok == true;
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
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        return status.isGranted;
      }
    } catch (_) {
      return false;
    }
  }

  Future<void> _runCommand(String cmd) async {
    final raw = cmd.trim();
    if (raw.isEmpty) return;

    _append("> $raw");

    var lower = raw.toLowerCase();
    bool forceCloud = false;

    if (lower.contains('/c')) {
      forceCloud = true;
      lower = lower.replaceAll('/c', '').trim();
    }

    if (lower == "help") {
      _append("Opening terminal documentation…");
      _append("https://colourswift.com/terminal_documentation");
      await _openTerminalDocs();
      return;
    }

    if (lower == "clear") {
      setState(() => _log.clear());
      return;
    }

    if (lower == "vpn on") {
      final ok = await _requestVpnPermission();
      if (!ok) {
        _append("[VPN] Permission denied");
        return;
      }
      _append("[VPN] Starting VPN");
      await AvServiceManager.startVpn();
      _append("[VPN] Active");
      return;
    }

    if (lower == "vpn off") {
      _append("[VPN] Stopping VPN");
      await AvServiceManager.stopVpn();
      _append("[VPN] Disabled");
      return;
    }

    if (lower.startsWith("check ")) {
      final query = lower.substring(6).trim();
      if (query.isEmpty) {
        _append("[URL] No domain provided");
        return;
      }
      await _runUrlCheck(query);
      return;
    }

    if (lower == "cloud status") {
      await _runCloudStatus();
      return;
    }

    if (lower.startsWith("scan folder ")) {
      if (_isScanning) {
        _append("[ENGINE] A scan is already running");
        return;
      }

      final path = lower.substring("scan folder ".length).trim();
      if (path.isEmpty) {
        _append("[SCAN] No folder path provided");
        return;
      }

      final useCloud = forceCloud ? true : _useCloudPref;
      await _runFolderScan(path, useCloud);
      return;
    }

    if (lower == "smart" || lower == "rapid" || lower == "single") {
      if (_isScanning) {
        _append("[ENGINE] A scan is already running");
        return;
      }
      final useCloud = forceCloud ? true : _useCloudPref;

      if (lower == "smart") {
        _append(
            useCloud ? "[SCAN] Smart scan with cloud" : "[SCAN] Smart scan");
        await _runSmartScan(useCloud);
        return;
      }

      if (lower == "rapid") {
        _append(
            useCloud ? "[SCAN] Rapid scan with cloud" : "[SCAN] Rapid scan");
        await _runRapidScan(useCloud);
        return;
      }

      if (lower == "single") {
        _append(useCloud
            ? "[SCAN] Single file scan with cloud"
            : "[SCAN] Single file scan");
        await _runSingleScan(useCloud);
        return;
      }
    }

    _append("Unknown command. Type 'help'.");
  }

  Future<void> _runUrlCheck(String input) async {
    var target = input
        .replaceAll("https://", "")
        .replaceAll("http://", "")
        .trim()
        .split("/")
        .first;

    if (target.isEmpty) {
      _append("[URL] Invalid address");
      return;
    }

    _append("[URL] Checking → $target");

    int res = 0;

    try {
      final bridge = AntivirusBridge();
      res = bridge.checkNetwork(target, target, 443);
    } catch (e) {
      _append("[URL] IOC engine error: $e");
      return;
    }

    if (res == 0) {
      _append("[SAFE] No database match");
    } else {
      _append("[THREAT MATCH] Domain exists in threat database");
    }
  }

  Future<void> _runSmartScan(bool useCloud) async {
    _isScanning = true;
    try {
      final granted = await _ensureStorageAccess();
      if (!granted) {
        _append("[ENGINE] Storage permission denied");
        _isScanning = false;
        return;
      }

      final root = Directory('/storage/emulated/0/');
      final folders = <String>[];

      try {
        await for (final e in root.list(followLinks: false)) {
          if (e is Directory) {
            final name = e.path
                .split('/')
                .last
                .toLowerCase();
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
      } catch (_) {
        _append("[ENGINE] Failed to enumerate root storage");
      }

      final files = <String>[];
      final ex = ExclusionService();
      await ex.load();

      for (final dirPath in folders) {
        final dir = Directory(dirPath);
        if (!await dir.exists()) continue;

        await for (final entity in dir.list(
            recursive: true, followLinks: false)) {
          if (entity is File) {
            final path = entity.path;
            if (ex.skipFolder(path)) continue;
            final ext = _ext(path);
            final size = await entity.length();
            if (!_isSmartAllowed(ext, size)) continue;
            files.add(path);
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
        _append("[ENGINE] No files found.");
        _isScanning = false;
        return;
      }

      _append("[ENGINE] Smart Scan: ${files.length} files.");
      await _scanFiles(files, useCloud);
    } finally {
      _isScanning = false;
    }
  }

  Future<void> _runRapidScan(bool useCloud) async {
    _isScanning = true;
    try {
      final granted = await _ensureStorageAccess();
      if (!granted) {
        _append("[ENGINE] Storage permission denied");
        _isScanning = false;
        return;
      }

      final dir = Directory('/storage/emulated/0/Download');
      final files = <String>[];
      final ex = ExclusionService();
      await ex.load();

      try {
        if (await dir.exists()) {
          await for (final entity in dir.list(
              recursive: true, followLinks: false)) {
            if (entity is File) {
              final path = entity.path;
              if (ex.skipFolder(path)) continue;
              final ext = _ext(path);
              final size = await entity.length();
              if (_isRapidAllowed(ext, size)) {
                files.add(path);
              }
            }
          }
        }
      } catch (e) {
        _append("[ERROR] Directory access failed: $e");
      }

      if (files.isEmpty) {
        _append("[ENGINE] No readable files found.");
        _isScanning = false;
        return;
      }

      _append("[ENGINE] Files enumerated: ${files.length}");
      await _scanFiles(files, useCloud);
    } finally {
      _isScanning = false;
    }
  }

  Future<void> _runSingleScan(bool useCloud) async {
    _isScanning = true;
    try {
      final res = await FilePicker.platform.pickFiles();
      if (res == null || res.files.isEmpty) {
        _append("[SCAN] Single scan cancelled");
        _isScanning = false;
        return;
      }

      final file = res.files.single;
      final path = file.path;
      if (path == null) {
        _append("[SCAN] Invalid file selection");
        _isScanning = false;
        return;
      }

      _append("[SCAN INIT] Single-file → $path");

      bool infectedFlag = false;

      try {
        final bytes = await File(path).readAsBytes();
        final md5h = md5.convert(bytes).toString();
        final sha = sha256.convert(bytes).toString();

        if (useCloud && _cloudScanner != null) {
          _append("[CLOUD] Sending MD5=$md5h and SHA256=$sha to cloud");
          final hits = await _cloudScanner!.checkBatch([md5h, sha]);
          if (hits.isNotEmpty) {
            infectedFlag = true;
          }
        }

        if (!infectedFlag) {
          final bridge = AntivirusBridge();
          final raw = bridge.scanFile(path);
          final decoded = jsonDecode(raw);
          final hits = decoded['hits'] as Map?;
          infectedFlag = hits != null && hits.isNotEmpty;
        }
      } catch (e) {
        _append("[ERROR] Scan failed: $e");
        _isScanning = false;
        return;
      }

      if (infectedFlag) {
        try {
          await QuarantineService.quarantineFile(path);
          _append("[THREAT] Quarantined ${file.name}");
        } catch (_) {
          _append("[THREAT] Detected but quarantine failed");
        }
        _append("[RESULT] Suspicious item detected");
      } else {
        _append("[RESULT] No threats found");
      }
    } finally {
      _isScanning = false;
    }
  }

  Future<void> _runFolderScan(String folderPath, bool useCloud) async {
    _isScanning = true;
    try {
      final granted = await _ensureStorageAccess();
      if (!granted) {
        _append("[ENGINE] Storage permission denied");
        return;
      }

      final dir = Directory(folderPath);
      if (!await dir.exists()) {
        _append("[SCAN] Folder does not exist");
        return;
      }

      final files = <String>[];
      final ex = ExclusionService();
      await ex.load();

      try {
        await for (final entity in dir.list(
            recursive: true, followLinks: false)) {
          if (entity is File) {
            final path = entity.path;
            if (ex.skipFolder(path)) continue;
            final ext = _ext(path);
            final size = await entity.length();
            if (!_isSmartAllowed(ext, size)) continue;
            files.add(path);
          }
        }
      } catch (_) {
        _append("[ENGINE] Failed to enumerate folder");
        return;
      }

      if (files.isEmpty) {
        _append("[ENGINE] No files found in folder");
        return;
      }

      files.sort((a, b) {
        try {
          return File(a).lengthSync().compareTo(File(b).lengthSync());
        } catch (_) {
          return 0;
        }
      });

      _append(
        useCloud
            ? "[SCAN] Folder scan (${files.length} files) with cloud"
            : "[SCAN] Folder scan (${files.length} files)",
      );

      await _scanFiles(files, useCloud);
    } finally {
      _isScanning = false;
    }
  }

  Future<void> _scanFiles(List<String> files, bool useCloud) async {
    final bridge = AntivirusBridge();
    final ex = ExclusionService();
    await ex.load();

    final infected = <String>[];
    final clean = <String>[];

    Map<String, Map<String, String>> fileHashes = {};
    Set<String> cloudDetected = {};

    if (useCloud && _cloudScanner != null) {
      _append("[STAGE 1] Resolving file hashes (cached)...");

      final dir = await getApplicationDocumentsDirectory();
      final hashWorker = await HashCacheWorker.spawn(
        '${dir.path}/hashcache.bin',
      );

      final hashesByPath = await hashWorker.hashBatch(files);
      final allHashes = <String>[];

      for (final entry in hashesByPath.entries) {
        final path = entry.key;
        final hashes = entry.value;

        final sha = hashes['sha'] ?? '';
        if (ex.skipSha(sha)) continue;

        fileHashes[path] = hashes;

        final md5h = hashes['md5'] ?? '';
        if (md5h.isNotEmpty) allHashes.add(md5h);
        if (sha.isNotEmpty) allHashes.add(sha);

        _append("[HASH] ${path
            .split('/')
            .last}");
      }

      await hashWorker.flush();

      _append("[STAGE 2] Sending batch hash list to cloud...");
      try {
        final cloudResp = await _cloudScanner!.checkBatch(allHashes);
        cloudDetected = cloudResp.toSet();
        _append("[CLOUD] Cloud flagged ${cloudDetected.length} hash matches.");
      } catch (e) {
        _append("[CLOUD] Cloud check failed: $e");
        cloudDetected = {};
      }

      _append("[STAGE 2] Sending batch hash list to cloud...");
      try {
        final cloudResp = await _cloudScanner!.checkBatch(allHashes);
        cloudDetected = cloudResp.toSet();
        _append("[CLOUD] Cloud flagged ${cloudDetected.length} hash matches.");
      } catch (e) {
        _append("[CLOUD] Cloud check failed: $e");
        cloudDetected = {};
      }
    }

    _append(useCloud
        ? "[STAGE 3] Local scanning files..."
        : "[STAGE 1] Local scanning files...");

    for (final path in files) {
      final name = path
          .split('/')
          .last;
      bool infectedFlag = false;

      if (useCloud && fileHashes.containsKey(path) &&
          cloudDetected.isNotEmpty) {
        final hashes = fileHashes[path]!;
        final md5h = hashes['md5'] ?? '';
        final sha = hashes['sha'] ?? '';
        if (cloudDetected.contains(md5h) || cloudDetected.contains(sha)) {
          infectedFlag = true;
          _append("[CLOUD HIT] $name");
          infected.add(path);
          await QuarantineService.quarantineFile(path);
          continue;
        }
      }

      if (!infectedFlag) {
        try {
          final raw = bridge.scanFile(path);
          final decoded = jsonDecode(raw);
          final hits = decoded['hits'] as Map?;
          infectedFlag = hits != null && hits.isNotEmpty;
        } catch (_) {
          infectedFlag = false;
        }
      }

      if (infectedFlag) {
        infected.add(path);
        try {
          await QuarantineService.quarantineFile(path);
          _append("[THREAT] Quarantined $name");
        } catch (_) {
          _append("[THREAT] Detected in $name");
        }
      } else {
        clean.add(path);
        _append("[CLEAN] $name");
      }
    }

    _append("[SUMMARY] ${infected.length} suspicious • ${clean.length} clean");
  }

  String _ext(String path) {
    final name = path
        .split('/')
        .last;
    final dot = name.lastIndexOf('.');
    if (dot <= 0) return '';
    return name.substring(dot + 1).toLowerCase();
  }

  bool _isSmartAllowed(String ext, int size) {
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

  bool _isRapidAllowed(String ext, int size) {
    if (ext != 'apk') return false;
    if (size > 200 * 1024 * 1024) return false;
    return true;
  }

  Future<void> _runCloudStatus() async {
    if (_cloudScanner == null) {
      _append("[CLOUD] Not initialised");
      return;
    }

    _append("[CLOUD] Checking cloud connectivity...");

    try {
      const testHash =
          "2b4f33ba1a1e392ab3c79bb6dc848d5440239323220498ad84dd5f124d510484";
      final res = await _cloudScanner!.checkBatch([testHash]);

      if (res.isNotEmpty) {
        _append("[CLOUD] Online");
      } else {
        _append("[CLOUD] Reachable but no response");
      }
    } catch (_) {
      _append("[CLOUD] Offline or unreachable");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Terminal"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: theme.brightness == Brightness.dark
                  ? Colors.black
                  : Colors.grey.shade200,
              child: ListView.builder(
                controller: _scroll,
                itemCount: _log.length,
                itemBuilder: (context, index) {
                  return Text(
                    _log[index],
                    style: text.bodySmall?.copyWith(
                      fontFamily: "monospace",
                      color: theme.colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: theme.scaffoldBackgroundColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: text.bodyMedium?.copyWith(fontFamily: "monospace"),
                    decoration: const InputDecoration(
                      hintText: "Enter command…",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (value) {
                      final v = value.trim();
                      if (v.isNotEmpty) {
                        _runCommand(v);
                        _controller.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  onPressed: () {
                    final v = _controller.text.trim();
                    if (v.isNotEmpty) {
                      _runCommand(v);
                      _controller.clear();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}