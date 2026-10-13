import 'dart:io';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import 'cleaner_app_manager_screen.dart';
import 'cleaner_lite_screen.dart';
import 'detail_screen.dart';

import '../../translations/app_localizations.dart';
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

class CleanerProPane extends StatefulWidget {
  const CleanerProPane({super.key});

  @override
  State<CleanerProPane> createState() => _CleanerProPaneState();
}

class _CleanerProPaneState extends State<CleanerProPane> {
  static const _shizukuChannel = MethodChannel('cs.shizuku');

  bool _checking = true;
  bool _binderAlive = false;
  bool _hasPermission = false;
  bool _serviceBound = false;
  bool _cacheBusy = false;
  bool _logScanning = false;

  List<File> _logFiles = [];
  int _logBytes = 0;

  @override
  void initState() {
    super.initState();
    _refreshShizuku();
  }

  Future<void> _refreshShizuku() async {
    setState(() => _checking = true);

    bool alive = false;
    bool permission = false;
    bool bound = false;

    try {
      alive = await _shizukuChannel.invokeMethod<bool>('isBinderAlive') ?? false;
      permission = await _shizukuChannel.invokeMethod<bool>('hasPermission') ?? false;
      bound = await _shizukuChannel.invokeMethod<bool>('isServiceBound') ?? false;
    } catch (_) {}

    if (mounted) {
      setState(() {
        _binderAlive = alive;
        _hasPermission = permission;
        _serviceBound = bound;
        _checking = false;
      });
    }
  }

  Future<void> _requestShizuku() async {
    try {
      await _shizukuChannel.invokeMethod<bool>('requestPermission');
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 700));
    await _refreshShizuku();
  }

  Future<void> _clearAllCaches() async {
    if (_cacheBusy) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title:  Text(AppLocalizations.of(context)!.cleanerProClearAppCaches),
        content:  Text(AppLocalizations.of(context)!.cleanerProThisAsksAndroidToTrimAppCaches),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:  Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:  Text(AppLocalizations.of(context)!.cleanerProClearCaches),
          ),
        ],
      ),
    );

    if (ok != true) return;

    setState(() => _cacheBusy = true);

    bool success = false;
    try {
      success = await _shizukuChannel.invokeMethod<bool>('clearAllCaches') ?? false;
    } catch (_) {}

    if (!mounted) return;

    setState(() => _cacheBusy = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? AppLocalizations.of(context)!.cleanerProCacheTrimRequested : AppLocalizations.of(context)!.cleanerProCacheCleanerFailed),
      ),
    );
  }

  Future<void> _scanLogs() async {
    if (_logScanning) return;

    setState(() {
      _logScanning = true;
      _logFiles = [];
      _logBytes = 0;
    });

    final files = <File>[];
    var bytes = 0;
    final root = Directory('/storage/emulated/0/');
    final queue = <Directory>[];

    if (await root.exists()) queue.add(root);

    while (queue.isNotEmpty && files.length < 15000) {
      final dir = queue.removeLast();

      try {
        await for (final entity in dir.list(followLinks: false)) {
          final lower = entity.path.toLowerCase();

          if (entity is Directory) {
            if (lower.contains('/android/data/') || lower.contains('/android/obb/')) {
              continue;
            }
            queue.add(entity);
          } else if (entity is File) {
            final ext = p.extension(lower);
            if (ext == '.log' || ext == '.trace' || ext == '.crash' || ext == '.dmp') {
              try {
                final stat = entity.statSync();
                files.add(entity);
                bytes += stat.size;
              } catch (_) {}
            }
          }
        }
      } catch (_) {}
    }

    if (!mounted) return;

    setState(() {
      _logFiles = files;
      _logBytes = bytes;
      _logScanning = false;
    });
  }

  void _openLogs() {
    if (_logFiles.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CleanerDetailScreen(title: AppLocalizations.of(context)!.cleanerProLogFiles, files: _logFiles)),
    );
  }

  Future<void> _openAppManager() async {
    final apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: false,
      includeSystemApps: false,
    );

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AppManagerScreen(apps: apps)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ready = _binderAlive && _hasPermission && _serviceBound;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              if (_checking || !ready) ...[
                _shizukuNotice(theme),
                const SizedBox(height: 10),
              ],
              _proCard(
                icon: Icons.cached_rounded,
                title: AppLocalizations.of(context)!.cleanerProCacheCleaner,
                subtitle: _cacheBusy
                    ? AppLocalizations.of(context)!.cleanerProClearingCaches
                    : ready
                        ? AppLocalizations.of(context)!.cleanerProTrimAppCaches
                        : AppLocalizations.of(context)!.cleanerProEnableShizuku,
                trailing: _cacheBusy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
                enabled: ready && !_cacheBusy,
                onTap: _clearAllCaches,
              ),
              const SizedBox(height: 10),
              _proCard(
                icon: Icons.article_rounded,
                title: AppLocalizations.of(context)!.cleanerProLogCleaner,
                subtitle: _logScanning
                    ? AppLocalizations.of(context)!.cleanerProScanningStorage
                    : _logFiles.isEmpty
                        ? AppLocalizations.of(context)!.cleanerProFindLogFiles
                        : AppLocalizations.of(context)!.cleanerProLogFileCount(_logFiles.length, _fmtBytes(_logBytes)),
                trailing: _logScanning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
                enabled: !_logScanning,
                onTap: _logFiles.isEmpty ? _scanLogs : _openLogs,
              ),
              const SizedBox(height: 10),
              _proCard(
                icon: Icons.apps_rounded,
                title: AppLocalizations.of(context)!.cleanerProAppDataManager,
                subtitle: ready
                    ? AppLocalizations.of(context)!.cleanerProAppManagerReady
                    : AppLocalizations.of(context)!.cleanerProAppManagerLimited,
                enabled: true,
                onTap: _openAppManager,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Expanded(child: CleanerLitePane()),
      ],
    );
  }

  Widget _shizukuNotice(ThemeData theme) {
    final text = _checking
        ? AppLocalizations.of(context)!.cleanerProCheckingShizuku
        : !_binderAlive
            ? AppLocalizations.of(context)!.cleanerProShizukuNotRunning
            : !_hasPermission
                ? AppLocalizations.of(context)!.cleanerProShizukuPermissionMissing
                : AppLocalizations.of(context)!.cleanerProShizukuNotBound;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.65),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _proCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool enabled,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    final color = enabled ? theme.colorScheme.primary : theme.disabledColor;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: enabled ? theme.colorScheme.onSurface : theme.disabledColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: enabled
                          ? theme.colorScheme.onSurface.withOpacity(0.55)
                          : theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ),
            trailing ?? Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withOpacity(0.35)),
          ],
        ),
      ),
    );
  }
}
