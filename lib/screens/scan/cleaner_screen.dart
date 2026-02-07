import 'dart:async';
import 'dart:isolate';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:device_apps/device_apps.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import '../../translations/app_localizations.dart';
import 'detail_screen.dart'; // reuses your existing file-list viewer
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

String _fmtBytes(int bytes) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  double v = bytes.toDouble();
  int i = 0;
  while (v >= 1024 && i < units.length - 1) {
    v /= 1024;
    i++;
  }
  return '${v.toStringAsFixed(v >= 10 || i == 0 ? 0 : 1)} ${units[i]}';
}

class CleanerScreen extends StatefulWidget {
  const CleanerScreen({super.key});

  @override
  State<CleanerScreen> createState() => _CleanerScreenState();
}

class _CleanerScreenState extends State<CleanerScreen> {
  bool scanning = false;
  double progress = 0.0;
  String status = 'Ready';

  List<File> dupFiles = [];
  int dupReclaimBytes = 0;

  List<File> oldPhotos = [];
  int oldPhotosBytes = 0;

  List<File> oldVideos = [];
  int oldVideosBytes = 0;

  List<File> largeFiles = [];
  int largeFilesBytes = 0;

  bool appsLoading = false;
  List<Application> unusedApps = [];

  Future<void> _runCleaner() async {
    if (scanning) return;
    final l10n = AppLocalizations.of(context)!;
    final hasUsagePerm = await UsageStats.checkUsagePermission() ?? false;
    if (!hasUsagePerm) {
      final go = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(l10n.cleanerGrantUsageAccessTitle),
          content: Text(l10n.cleanerGrantUsageAccessBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cleanerCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.cleanerContinue),
            ),
          ],
        ),
      );

      if (go == true) {
        await UsageStats.grantUsagePermission();
        return;
      }
    }
    setState(() {
      scanning = true;
      progress = 0.0;
      status = l10n.cleanerStatusStarting;
      // reset results
      dupFiles.clear();
      dupReclaimBytes = 0;
      oldPhotos.clear();
      oldPhotosBytes = 0;
      oldVideos.clear();
      oldVideosBytes = 0;
      largeFiles.clear();
      largeFilesBytes = 0;

      appsLoading = false;
      unusedApps.clear();
    });

    final rp = ReceivePort();
    Isolate? iso;

    try {
      iso = await Isolate.spawn<_WorkerArgs>(
        _scanWorkerEntry,
        _WorkerArgs(
          port: rp.sendPort,
          rootPath: '/storage/emulated/0/',
          maxFiles: 12000,
          oldDays: 90,
          largeFileMinBytes: 20 * 1024 * 1024, // 20MB
          photoMinBytes: 5 * 1024 * 1024,      // 5MB
          videoMinBytes: 10 * 1024 * 1024,     // 10MB
        ),
        errorsAreFatal: true,
      );

      final completer = Completer<Map<String, dynamic>>();
      final sub = rp.listen((msg) {
        if (msg is Map) {
          final type = msg['type'];
          if (type == 'progress') {
            final double pct = (msg['percent'] as num?)?.toDouble() ?? 0.0;
            final int stage = msg['stage'] as int? ?? 0;
            final String label = msg['label'] as String? ?? 'Scanning…';

            setState(() {
              final stageBase = (stage - 1).clamp(0, 3) * 0.25;
              progress = (stageBase + (pct * 0.25)).clamp(0.0, 0.99);
              status = label;
            });
          } else if (type == 'done') {
            if (!completer.isCompleted) {
              completer.complete((msg['result'] as Map).cast<String, dynamic>());
            }
          }
        }
      });

      final result = await completer.future.timeout(
        const Duration(minutes: 3),
        onTimeout: () => <String, dynamic>{
          'dupFiles': <String>[],
          'dupReclaimBytes': 0,
          'oldPhotos': <String>[],
          'oldPhotosBytes': 0,
          'oldVideos': <String>[],
          'oldVideosBytes': 0,
          'largeFiles': <String>[],
          'largeFilesBytes': 0,
        },
      );

      await sub.cancel();

      // Rehydrate File objects on UI isolate
      setState(() {
        dupFiles = (result['dupFiles'] as List).cast<String>().map((e) => File(e)).toList();
        dupReclaimBytes = (result['dupReclaimBytes'] as num).toInt();

        oldPhotos = (result['oldPhotos'] as List).cast<String>().map((e) => File(e)).toList();
        oldPhotosBytes = (result['oldPhotosBytes'] as num).toInt();

        oldVideos = (result['oldVideos'] as List).cast<String>().map((e) => File(e)).toList();
        oldVideosBytes = (result['oldVideosBytes'] as num).toInt();

        largeFiles = (result['largeFiles'] as List).cast<String>().map((e) => File(e)).toList();
        largeFilesBytes = (result['largeFilesBytes'] as num).toInt();

        progress = 1.0;
        status = l10n.cleanerStatusFilesScanned;
        scanning = false;
      });

      setState(() {
        appsLoading = true;
        status = l10n.cleanerStatusFindingUnusedApps;
      });

      final apps = await _scanUnusedApps();

      setState(() {
        unusedApps = apps;
        appsLoading = false;
        status = l10n.cleanerStatusComplete;
      });
    } catch (e) {
      setState(() {
        scanning = false;
        appsLoading = false;
        status = l10n.cleanerStatusScanError;
      });
      debugPrint('Cleaner: scan error $e');
    } finally {
      rp.close();
      iso?.kill(priority: Isolate.immediate);
    }
  }

  Future<bool> ensureStoragePermission(BuildContext context) async {
    bool granted = false;

    if (Platform.isAndroid) {
      final sdk = (await DeviceInfoPlugin().androidInfo).version.sdkInt;

      if (sdk >= 30) {
        // Android 11+ → MANAGE_EXTERNAL_STORAGE
        final status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          try {
            const channel = MethodChannel('colourswift/permissions');
            await channel.invokeMethod('openManageAllFilesSettings');
          } catch (_) {
            await openAppSettings();
          }
        }
        granted = await Permission.manageExternalStorage.request().isGranted;
      } else {
        // Android 10 and below → regular storage permission
        final status = await Permission.storage.status;
        if (!status.isGranted) {
          final result = await Permission.storage.request();
          granted = result.isGranted;
        } else {
          granted = true;
        }
      }
    } else {
      granted = true;
    }

    return granted;
  }


  Future<List<Application>> _scanUnusedApps() async {
    try {
      final has = await UsageStats.checkUsagePermission() ?? false;
      if (!has) {
        return [];
      }
      final stats = await UsageStats.queryUsageStats(
        DateTime.now().subtract(const Duration(days: 30)),
        DateTime.now(),
      );
      if (stats.isEmpty) return [];

      final usedPkgs = stats.map((e) => e.packageName).toSet();
      final apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: false,
        includeSystemApps: false,
      );
      return apps.where((a) => !usedPkgs.contains(a.packageName)).toList();
    } catch (_) {
      return [];
    }
  }

  // Navigation helpers
  void _openFiles(String title, List<File> files) {
    if (files.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CleanerDetailScreen(title: title, files: files)),
    );
  }

  void _openUnusedApps() {
    if (unusedApps.isEmpty) return;
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => UnusedAppsScreen(apps: unusedApps),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final muted = text.bodySmall?.color?.withOpacity(0.7);

    final filesScanning = scanning;
    final appsBusy = appsLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cleanerTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Header + button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.cleanerReadyToScan,
                  style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                FilledButton.icon(
                  onPressed: filesScanning || appsBusy
                      ? null
                      : () async {
                    final ok = await ensureStoragePermission(context);
                    if (ok) {
                      await _runCleaner();
                    }
                  },
                  icon: const Icon(Icons.bolt_rounded),
                  label: Text(filesScanning || appsBusy ? l10n.cleanerScanning : l10n.cleanerScan),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (filesScanning || appsBusy) ? progress : 1.0,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                (filesScanning || appsBusy) ? status : l10n.cleanerReady,
                style: TextStyle(color: muted),
              ),
            ),
            const SizedBox(height: 16),

            // Cards
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _card(
                    id: 'duplicates',
                    title: l10n.cleanerDuplicates,
                    enabled: !filesScanning,
                    subtitle: dupFiles.isEmpty
                        ? l10n.cleanerDuplicatesNone
                        : l10n.cleanerDuplicatesSubtitle(
                      dupFiles.length.toString(),
                      _fmtBytes(dupReclaimBytes),
                    ),
                    trailing: dupReclaimBytes > 0 ? Text(_fmtBytes(dupReclaimBytes)) : null,
                    onTap: () => _openFiles(l10n.cleanerDuplicates, dupFiles),
                  ),
                  const SizedBox(height: 12),
                  _card(
                    id: 'oldPhotos',
                    title: l10n.cleanerOldPhotos,
                    enabled: !filesScanning,
                    subtitle: oldPhotos.isEmpty
                        ? l10n.cleanerOldPhotosNone('90')
                        : l10n.cleanerOldPhotosSubtitle(
                      oldPhotos.length.toString(),
                      _fmtBytes(oldPhotosBytes),
                    ),
                    trailing: oldPhotosBytes > 0 ? Text(_fmtBytes(oldPhotosBytes)) : null,
                    onTap: () => _openFiles(l10n.cleanerOldPhotos, oldPhotos),
                  ),
                  const SizedBox(height: 12),
                  _card(
                    id: 'oldVideos',
                    title: l10n.cleanerOldVideos,
                    enabled: !filesScanning,
                    subtitle: oldVideos.isEmpty
                        ? l10n.cleanerOldVideosNone('90')
                        : l10n.cleanerOldVideosSubtitle(
                      oldVideos.length.toString(),
                      _fmtBytes(oldVideosBytes),
                    ),
                    trailing: oldVideosBytes > 0 ? Text(_fmtBytes(oldVideosBytes)) : null,
                    onTap: () => _openFiles(l10n.cleanerOldVideos, oldVideos),
                  ),
                  const SizedBox(height: 12),
                  _card(
                    id: 'largeFiles',
                    title: l10n.cleanerLargeFiles,
                    enabled: !filesScanning,
                    subtitle: largeFiles.isEmpty
                        ? l10n.cleanerLargeFilesNone(_fmtBytes(20 * 1024 * 1024))
                        : l10n.cleanerLargeFilesSubtitle(
                      largeFiles.length.toString(),
                      _fmtBytes(largeFilesBytes),
                    ),
                    trailing: largeFilesBytes > 0 ? Text(_fmtBytes(largeFilesBytes)) : null,
                    onTap: () => _openFiles(l10n.cleanerLargeFiles, largeFiles),
                  ),
                  const SizedBox(height: 12),
                  _card(
                    id: 'unusedApps',
                    title: l10n.cleanerUnusedApps,
                    enabled: !(filesScanning || appsBusy),
                    subtitle: appsBusy
                        ? l10n.cleanerStatusScanningApps
                        : (unusedApps.isEmpty
                        ? l10n.cleanerUnusedAppsNone('30')
                        : l10n.cleanerUnusedAppsCount(unusedApps.length.toString())),
                    trailing: unusedApps.isNotEmpty ? Text('${unusedApps.length}') : null,
                    onTap: _openUnusedApps,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({
    required String id,
    required String title,
    required bool enabled,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    IconData innerIcon;
    switch (id) {
      case 'duplicates':
        innerIcon = Icons.copy_rounded;
        break;
      case 'oldPhotos':
        innerIcon = Icons.photo_rounded;
        break;
      case 'oldVideos':
        innerIcon = Icons.play_arrow_rounded;
        break;
      case 'largeFiles':
        innerIcon = Icons.description_rounded;
        break;
      case 'unusedApps':
        innerIcon = Icons.apps_rounded;
        break;
      default:
        innerIcon = Icons.insert_drive_file_rounded;
    }

    final folderColor =
    enabled ? theme.colorScheme.primary : theme.disabledColor;

    return InkWell(
      onTap: enabled && onTap != null ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.folder_rounded,
                    size: 40,
                    color: folderColor.withOpacity(enabled ? 0.9 : 0.5)),
                Icon(innerIcon,
                    size: 18,
                    color: Colors.white.withOpacity(enabled ? 0.95 : 0.4)),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: enabled
                          ? text.titleMedium?.color
                          : theme.disabledColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(
                      color: enabled
                          ? text.bodySmall?.color
                          : theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              DefaultTextStyle(
                style: text.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: enabled
                      ? text.bodyLarge?.color
                      : theme.disabledColor,
                ) ??
                    const TextStyle(),
                child: trailing,
              ),
            ],
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded,
                color: enabled ? theme.iconTheme.color : theme.disabledColor),
          ],
        ),
      ),
    );
  }
}

// ===== WORKER (Isolate) =====

class _WorkerArgs {
  final SendPort port;
  final String rootPath;
  final int maxFiles;
  final int oldDays;
  final int largeFileMinBytes;
  final int photoMinBytes;
  final int videoMinBytes;

  _WorkerArgs({
    required this.port,
    required this.rootPath,
    required this.maxFiles,
    required this.oldDays,
    required this.largeFileMinBytes,
    required this.photoMinBytes,
    required this.videoMinBytes,
  });
}

void _scanWorkerEntry(_WorkerArgs args) async {
  final send = args.port;
  final now = DateTime.now();

  // Buckets (paths-only)
  final dupGroups = <String, List<String>>{}; // key -> list of paths (duplicates)
  int dupReclaimBytes = 0;

  final oldPhotos = <String>[];
  int oldPhotosBytes = 0;

  final oldVideos = <String>[];
  int oldVideosBytes = 0;

  final largeFiles = <String>[];
  int largeFilesBytes = 0;

  int _size(File f) {
    try { return f.lengthSync(); } catch (_) { return 0; }
  }

  Future<void> _walk(
      Directory dir, {
        required void Function(File f) onFile,
        required int cap,
        required void Function(int processed, int totalGuess)? onProgress,
      }) async {
    int processed = 0;
    const totalGuess = 4000;
    final q = <Directory>[];

    const trashMarkers = [
      '/.trash',
      '/.trash-',
      '/.recyclebin',
      '/.recycle_bin',
      '/.recycle/',
      '/.thumbnails',
      '/.temp/',
      '/.cache/',
      '/trash/',
      '/recycle/',
      '/recycler/',
      '/.deleted/',
      '/.GalleryTrash/',
      '/Android/data/com.android.gallery3d/files/.trash/',
    ];

    if (await dir.exists()) q.add(dir);

    while (q.isNotEmpty) {
      final d = q.removeLast();
      try {
        await for (final e in d.list(followLinks: false)) {
          if (processed >= cap) break;

          if (e is Directory) {
            // skip restricted and trash dirs
            final lower = e.path.toLowerCase();
            if (lower.contains('/android/')) continue;
            if (trashMarkers.any((t) => lower.contains(t))) continue;
            q.add(e);
          } else if (e is File) {
            final path = e.path.toLowerCase();
            if (trashMarkers.any((t) => path.contains(t))) continue;

            onFile(e);
            processed++;
            if (processed % 150 == 0 && onProgress != null) {
              onProgress(processed, totalGuess);
            }
          }
        }
      } catch (_) {
      }
      if (processed >= cap) break;
    }
    if (onProgress != null) onProgress(processed, totalGuess);
  }

  Future<void> _stage(
      int stageNum,
      String labelStart,
      Future<void> Function() body,
      ) async {
    send.send({'type': 'progress', 'stage': stageNum, 'percent': 0.02, 'label': labelStart});
    await body();
    send.send({'type': 'progress', 'stage': stageNum, 'percent': 1.0, 'label': '$labelStart Done'});
  }

  await _stage(1, 'Scanning duplicates…', () async {
    final root = Directory(args.rootPath);

    Future<String?> _fingerprint(File f) async {
      try {
        final raf = f.openSync(mode: FileMode.read);
        final len = raf.lengthSync();
        final toRead = len < 32768 ? len : 32768;
        final bytes = raf.readSync(toRead);
        raf.closeSync();
        final h = bytes.fold<int>(0, (a, b) => (a * 131 + b) & 0x7fffffff);
        return '${len}_$h';
      } catch (_) {
        return null;
      }
    }

    await _walk(
      root,
      onFile: (f) {
        final ext = p.extension(f.path).toLowerCase();
        const ok = {
          '.jpg', '.jpeg', '.png', '.gif',
          '.mp4', '.mov', '.mkv',
          '.mp3', '.wav', '.flac',
          '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.zip', '.7z', '.rar',
        };
        if (!ok.contains(ext)) return;
      },
      cap: args.maxFiles,
      onProgress: (processed, total) async {
        send.send({'type': 'progress', 'stage': 1, 'percent': (processed / total).clamp(0.05, 0.98), 'label': 'Scanning duplicates…'});
      },
    );

    int processed = 0;
    await _walk(
      Directory(args.rootPath),
      onFile: (f) async {
        final ext = p.extension(f.path).toLowerCase();
        const ok = {
          '.jpg', '.jpeg', '.png', '.gif',
          '.mp4', '.mov', '.mkv',
          '.mp3', '.wav', '.flac',
          '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.zip', '.7z', '.rar',
        };
        if (!ok.contains(ext)) return;

        final fp = await _fingerprint(f);
        if (fp == null) return;
        (dupGroups[fp] ??= <String>[]).add(f.path);

        processed++;
        if (processed % 200 == 0) {
          send.send({'type': 'progress', 'stage': 1, 'percent': 0.6, 'label': 'Grouping duplicates…'});
        }
      },
      cap: args.maxFiles,
      onProgress: null,
    );

    final dupFiles = <String>[];
    dupReclaimBytes = 0;
    dupGroups.forEach((_, paths) {
      if (paths.length >= 2) {
        final pairs = <MapEntry<int, String>>[];
        for (final pth in paths) {
          pairs.add(MapEntry(_size(File(pth)), pth));
        }

        pairs.sort((a, b) => a.key.compareTo(b.key));

        for (var i = 0; i < pairs.length - 1; i++) {
          dupFiles.add(pairs[i].value);
        }

        if (pairs.isNotEmpty) {
          final total = pairs.fold<int>(0, (a, b) => a + b.key);
          final keep = pairs.last.key;
          dupReclaimBytes += (total - keep);
        }
      }
    });

    _stageStore['dupFiles'] = dupFiles;
    _stageStore['dupReclaimBytes'] = dupReclaimBytes;
  });

  await _stage(2, 'Scanning old photos…', () async {
    final root = Directory(args.rootPath);
    final photosExt = {'.jpg', '.jpeg', '.png', '.gif', '.webp', '.heic'};

    await _walk(
      root,
      onFile: (f) {
        final ext = p.extension(f.path).toLowerCase();
        if (!photosExt.contains(ext)) return;

        try {
          final st = f.statSync();
          final ageDays = now.difference(st.modified).inDays;
          if (ageDays >= args.oldDays && st.size >= args.photoMinBytes) {
            oldPhotos.add(f.path);
            oldPhotosBytes += st.size;
          }
        } catch (_) {}
      },
      cap: args.maxFiles,
      onProgress: (processed, total) {
        send.send({
          'type': 'progress',
          'stage': 2,
          'percent': (processed / total).clamp(0.05, 0.98),
          'label': 'Old photos: ${oldPhotos.length} • ${_fmtBytes(oldPhotosBytes)}',
        });
      },
    );
  });

  await _stage(3, 'Scanning old videos…', () async {
    final root = Directory(args.rootPath);
    final videoExt = {'.mp4', '.mov', '.mkv', '.avi', '.webm'};

    await _walk(
      root,
      onFile: (f) {
        final ext = p.extension(f.path).toLowerCase();
        if (!videoExt.contains(ext)) return;

        try {
          final st = f.statSync();
          final ageDays = now.difference(st.modified).inDays;
          if (ageDays >= args.oldDays && st.size >= args.videoMinBytes) {
            oldVideos.add(f.path);
            oldVideosBytes += st.size;
          }
        } catch (_) {}
      },
      cap: args.maxFiles,
      onProgress: (processed, total) {
        send.send({
          'type': 'progress',
          'stage': 3,
          'percent': (processed / total).clamp(0.05, 0.98),
          'label': 'Old videos: ${oldVideos.length} • ${_fmtBytes(oldVideosBytes)}',
        });
      },
    );
  });

  await _stage(4, 'Scanning large files…', () async {
    final root = Directory(args.rootPath);
    final photosExt = {'.jpg', '.jpeg', '.png', '.gif', '.webp', '.heic'};
    final videoExt = {'.mp4', '.mov', '.mkv', '.avi', '.webm'};

    await _walk(
      root,
      onFile: (f) {
        try {
          final st = f.statSync();
          if (st.size >= args.largeFileMinBytes) {
            final ext = p.extension(f.path).toLowerCase();
            if (!photosExt.contains(ext) && !videoExt.contains(ext)) {
              largeFiles.add(f.path);
              largeFilesBytes += st.size;
            }
          }
        } catch (_) {}
      },
      cap: args.maxFiles,
      onProgress: (processed, total) {
        send.send({
          'type': 'progress',
          'stage': 4,
          'percent': (processed / total).clamp(0.05, 0.98),
          'label': 'Large files: ${largeFiles.length} • ${_fmtBytes(largeFilesBytes)}',
        });
      },
    );
  });

  send.send({
    'type': 'done',
    'result': {
      'dupFiles': (_stageStore['dupFiles'] as List<String>? ?? const <String>[]),
      'dupReclaimBytes': _stageStore['dupReclaimBytes'] ?? 0,
      'oldPhotos': oldPhotos,
      'oldPhotosBytes': oldPhotosBytes,
      'oldVideos': oldVideos,
      'oldVideosBytes': oldVideosBytes,
      'largeFiles': largeFiles,
      'largeFilesBytes': largeFilesBytes,
    }
  });
}

final Map<String, Object> _stageStore = {};

class UnusedAppsScreen extends StatelessWidget {
  final List<Application> apps;
  const UnusedAppsScreen({super.key, required this.apps});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.unusedAppsTitle)),
      body: apps.isEmpty
          ? Center(child: Text(l10n.unusedAppsEmpty('30')))
          : ListView.separated(
        itemCount: apps.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final a = apps[i];
          return ListTile(
            leading: const Icon(Icons.apps_rounded),
            title: Text(a.appName),
            subtitle: Text(a.packageName, overflow: TextOverflow.ellipsis),
            trailing: IconButton(
              icon: const Icon(Icons.open_in_new_rounded),
              onPressed: () {
                try { DeviceApps.openApp(a.packageName); } catch (_) {}
              },
            ),
            onLongPress: () {
              try { DeviceApps.uninstallApp(a.packageName); } catch (_) {}
            },
          );
        },
      ),
    );
  }
}
