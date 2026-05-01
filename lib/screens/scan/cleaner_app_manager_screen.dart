import 'dart:typed_data';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../translations/app_localizations.dart';

class UnusedAppsScreen extends AppManagerScreen {
  const UnusedAppsScreen({super.key, required super.apps});
}

class AppManagerScreen extends StatefulWidget {
  final List<Application> apps;
  const AppManagerScreen({super.key, required this.apps});

  @override
  State<AppManagerScreen> createState() => _AppManagerScreenState();
}

class _AppManagerScreenState extends State<AppManagerScreen> {
  static const _channel = MethodChannel('cs.fastapps');
  static const _shizukuChannel = MethodChannel('cs.shizuku');

  final Map<String, Uint8List?> _iconCache = {};
  final Set<String> _selected = {};
  late List<Application> _apps;

  bool _uninstalling = false;
  int _uninstallDone = 0;
  int _uninstallTotal = 0;

  @override
  void initState() {
    super.initState();
    _apps = List<Application>.from(widget.apps);
    _prefetchIcons();
  }

  Future<void> _prefetchIcons() async {
    for (final app in _apps) {
      try {
        final bytes = await _channel.invokeMethod<Uint8List>(
          'getAppIconPng',
          {'package': app.packageName},
        );
        if (mounted) setState(() => _iconCache[app.packageName] = bytes);
      } catch (_) {
        if (mounted) setState(() => _iconCache[app.packageName] = null);
      }
    }
  }

  void _toggleSelection(String pkg) {
    setState(() => _selected.contains(pkg)
        ? _selected.remove(pkg)
        : _selected.add(pkg));
  }

  Future<void> _batchUninstall() async {
    if (_selected.isEmpty || _uninstalling) return;

    bool hasShizuku = false;
    try {
      hasShizuku =
          await _shizukuChannel.invokeMethod<bool>('hasPermission') ?? false;
    } catch (_) {}

    if (!hasShizuku) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Shizuku not available'),
          content: const Text(
            'Without Shizuku each app requires a separate system confirmation. Continue?',
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Continue')),
          ],
        ),
      );
      if (proceed != true) return;
    }

    final pkgs = List<String>.from(_selected);
    setState(() {
      _uninstalling = true;
      _uninstallDone = 0;
      _uninstallTotal = pkgs.length;
      _selected.clear();
    });

    int failed = 0;

    for (final pkg in pkgs) {
      if (!mounted) break;
      bool ok = false;

      if (hasShizuku) {
        try {
          ok = await _shizukuChannel.invokeMethod<bool>(
              'uninstallPackage', {'package': pkg}) ??
              false;
        } catch (_) {}
      } else {
        try {
          DeviceApps.uninstallApp(pkg);
          ok = true;
        } catch (_) {}
      }

      if (mounted) {
        setState(() {
          if (ok) {
            _apps.removeWhere((a) => a.packageName == pkg);
            _iconCache.remove(pkg);
          } else {
            failed++;
          }
          _uninstallDone++;
        });
      }
    }

    if (mounted) {
      setState(() => _uninstalling = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failed == 0
              ? '${pkgs.length - failed} apps uninstalled'
              : '${pkgs.length - failed} uninstalled, $failed failed'),
        ),
      );
    }
  }

  Future<bool> _runShizukuAction(String method, String pkg) async {
    try {
      final hasPermission = await _shizukuChannel.invokeMethod<bool>('hasPermission') ?? false;
      if (!hasPermission) return false;
      return await _shizukuChannel.invokeMethod<bool>(method, {'package': pkg}) ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _forceStopApp(Application app) async {
    final ok = await _runShizukuAction('forceStop', app.packageName);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? '${app.appName} stopped' : 'Force stop failed')),
    );
  }

  Future<void> _clearAppData(Application app) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear app data'),
        content: Text('Reset ${app.appName}? This clears its accounts, settings, files and cache.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear data'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final success = await _runShizukuAction('clearData', app.packageName);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? '${app.appName} reset' : 'Clear data failed')),
    );
  }

  void _showAppActions(BuildContext context, Application app) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _appIcon(app.packageName),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          app.appName,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          app.packageName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.open_in_new_rounded),
                title: const Text('Open app'),
                onTap: () {
                  Navigator.pop(context);
                  try {
                    DeviceApps.openApp(app.packageName);
                  } catch (_) {}
                },
              ),
              ListTile(
                leading: const Icon(Icons.pause_circle_outline_rounded),
                title: const Text('Force stop'),
                onTap: () {
                  Navigator.pop(context);
                  _forceStopApp(app);
                },
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt_rounded),
                title: const Text('Clear app data'),
                onTap: () {
                  Navigator.pop(context);
                  _clearAppData(app);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline_rounded,
                    color: theme.colorScheme.error),
                title: Text('Uninstall',
                    style: TextStyle(color: theme.colorScheme.error)),
                onTap: () {
                  Navigator.pop(context);
                  try {
                    DeviceApps.uninstallApp(app.packageName);
                  } catch (_) {}
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appIcon(String packageName) {
    if (!_iconCache.containsKey(packageName)) {
      return const SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    final bytes = _iconCache[packageName];
    if (bytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(bytes, width: 40, height: 40, fit: BoxFit.cover),
      );
    }
    return const Icon(Icons.apps_rounded, size: 40);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final inSelectMode = _selected.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(inSelectMode
            ? '${_selected.length} selected'
            : 'App Manager'),
        actions: [
          if (inSelectMode)
            TextButton(
              onPressed: () {
                setState(() {
                  if (_selected.length == _apps.length) {
                    _selected.clear();
                  } else {
                    _selected
                      ..clear()
                      ..addAll(_apps.map((a) => a.packageName));
                  }
                });
              },
              child: Text(_selected.length == _apps.length
                  ? 'Deselect all'
                  : 'Select all'),
            ),
        ],
      ),
      body: Stack(
        children: [
          _apps.isEmpty
              ? Center(child: Text(l10n.unusedAppsEmpty('30')))
              : ListView.separated(
            padding: EdgeInsets.only(
                bottom: (inSelectMode || _uninstalling) ? 88 : 0),
            itemCount: _apps.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final a = _apps[i];
              final selected = _selected.contains(a.packageName);
              return ListTile(
                leading: selected
                    ? Icon(Icons.check_circle_rounded,
                    color: theme.colorScheme.primary, size: 40)
                    : _appIcon(a.packageName),
                title: Text(a.appName),
                subtitle: Text(a.packageName,
                    overflow: TextOverflow.ellipsis),
                trailing: inSelectMode
                    ? null
                    : const Icon(Icons.chevron_right_rounded, size: 20),
                onTap: inSelectMode
                    ? () => _toggleSelection(a.packageName)
                    : () => _showAppActions(context, a),
                onLongPress: () => _toggleSelection(a.packageName),
              );
            },
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            bottom: (inSelectMode || _uninstalling) ? 0 : -100,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _uninstalling
                          ? 'Uninstalling $_uninstallDone / $_uninstallTotal…'
                          : '${_selected.length} selected',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (_uninstalling)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  else
                    FilledButton.icon(
                      onPressed:
                      _selected.isNotEmpty ? _batchUninstall : null,
                      icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                      label: Text('Uninstall ${_selected.length}'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}