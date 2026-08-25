import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../translations/app_localizations.dart';
class NetworkAppControlScreen extends StatefulWidget {
  const NetworkAppControlScreen({super.key});

  @override
  State<NetworkAppControlScreen> createState() => _NetworkAppControlScreenState();
}

class _AppRow {
  final String name;
  final String packageName;
  final String path;

  const _AppRow({
    required this.name,
    required this.packageName,
    required this.path,
  });

  factory _AppRow.fromMap(Map<dynamic, dynamic> m) {
    return _AppRow(
      name: (m['name'] as String?) ?? '',
      packageName: (m['package'] as String?) ?? '',
      path: (m['path'] as String?) ?? '',
    );
  }
}

class _NetworkAppControlScreenState extends State<NetworkAppControlScreen> {
  static const MethodChannel _chan = MethodChannel('cs.fastapps');
  static const MethodChannel _lockdownChan = MethodChannel('cs_vpn_lockdown');

  final TextEditingController _searchCtrl = TextEditingController();
  final Map<String, Future<Uint8List?>> _iconFutures = {};

  List<_AppRow> _all = const [];
  List<_AppRow> _filtered = const [];
  bool _loading = true;

  Set<String> _wifiBlocked = <String>{};

  bool _alwaysOn = false;
  bool _lockdown = false;
  String? _alwaysOnPkg;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_applyFilter);
    _refreshAll();
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_applyFilter);
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    await _refreshLockdownState();
    await _loadNativeBlocked();
    await _load();
  }

  Future<void> _refreshLockdownState() async {
    try {
      final res = await _lockdownChan.invokeMethod('getLockdownState');
      final m = (res as Map?) ?? const {};
      if (!mounted) return;
      setState(() {
        _alwaysOn = (m['always_on'] as bool?) ?? false;
        _lockdown = (m['lockdown'] as bool?) ?? false;
        _alwaysOnPkg = m['always_on_pkg']?.toString();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _alwaysOn = false;
        _lockdown = false;
        _alwaysOnPkg = null;
      });
    }
  }

  Future<void> _openVpnSettings() async {
    try {
      await _lockdownChan.invokeMethod('openVpnSettings');
    } catch (_) {}
  }

  bool get _isReadyForBlocking => _alwaysOn && _lockdown;

  Future<void> _showVpnSetupDialog() async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) {
        final other = (_alwaysOnPkg != null && _alwaysOnPkg!.isNotEmpty && _alwaysOnPkg != 'com.colourswift.cssecurity');
        final l10n = AppLocalizations.of(context)!;
        final msg = other
            ? l10n.networkAppControlOtherVpnSetupInstructions
            : l10n.networkAppControlSetupInstructions;

        return AlertDialog(
          title:  Text(AppLocalizations.of(context)!.networkAppControlEnableVPNToggles),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child:  Text(AppLocalizations.of(context)!.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _openVpnSettings();
              },
              child:  Text(AppLocalizations.of(context)!.networkAppControlOpenSettings),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadNativeBlocked() async {
    try {
      final res = await _chan.invokeMethod('getWifiBlockedPkgs');
      final list = (res as List?)?.map((e) => e.toString()).where((s) => s.isNotEmpty).toList() ?? <String>[];
      if (!mounted) return;
      setState(() {
        _wifiBlocked = list.toSet();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _wifiBlocked = <String>{};
      });
    }
  }

  Future<void> _setWifiBlocked(String pkg, bool blocked) async {
    if (!mounted) return;

    await _refreshLockdownState();

    if (!_isReadyForBlocking) {
      await _showVpnSetupDialog();
      return;
    }

    setState(() {
      if (blocked) {
        _wifiBlocked.add(pkg);
      } else {
        _wifiBlocked.remove(pkg);
      }
    });

    try {
      final ok = await _chan.invokeMethod('setAppWifiBlock', {'package': pkg, 'blocked': blocked});
      if (ok != true) {
        throw Exception('setAppWifiBlock failed');
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        if (blocked) {
          _wifiBlocked.remove(pkg);
        } else {
          _wifiBlocked.add(pkg);
        }
      });
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
    });

    try {
      final res = await _chan.invokeMethod('listUserApps');
      final list = (res as List?) ?? [];
      final apps = list.map((e) => _AppRow.fromMap(e as Map)).toList();

      if (!mounted) return;
      setState(() {
        _all = apps;
        _filtered = apps;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _all = const [];
        _filtered = const [];
        _loading = false;
      });
    }
  }

  void _applyFilter() {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _filtered = _all);
      return;
    }
    setState(() {
      _filtered = _all.where((a) {
        return a.name.toLowerCase().contains(q) || a.packageName.toLowerCase().contains(q);
      }).toList();
    });
  }

  Future<Uint8List?> _iconFuture(String pkg) {
    final existing = _iconFutures[pkg];
    if (existing != null) return existing;

    final f = () async {
      try {
        final bytes = await _chan.invokeMethod('getAppIconPng', {'package': pkg});
        if (bytes == null) return null;
        return bytes as Uint8List;
      } catch (_) {
        return null;
      }
    }();

    _iconFutures[pkg] = f;
    return f;
  }

  Widget _statusBanner(ThemeData theme) {
    final ok = _isReadyForBlocking;
    final other = (_alwaysOnPkg != null && _alwaysOnPkg!.isNotEmpty && _alwaysOnPkg != 'com.colourswift.cssecurity');

    final l10n = AppLocalizations.of(context)!;
    final text = ok
        ? l10n.networkAppControlBlockingActive
        : (other
        ? l10n.networkAppControlOtherVpnWarning
        : l10n.networkAppControlSetupWarning);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.40),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(ok ? Icons.verified : Icons.lock, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: 10),
            FilledButton(
              onPressed: _openVpnSettings,
              child:  Text(AppLocalizations.of(context)!.networkCardStatusOpen),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.networkAppControlAppControl),
        actions: [
          IconButton(
            onPressed: _loading
                ? null
                : () async {
              await _refreshAll();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _statusBanner(theme),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.metaPassSearchApps,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : (_filtered.isEmpty
                  ? Center(
                child: Text(
                  AppLocalizations.of(context)!.networkAppControlNoAppsFound,
                  style: theme.textTheme.bodyMedium,
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final a = _filtered[i];
                  final blocked = _wifiBlocked.contains(a.packageName);

                  return Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: FutureBuilder<Uint8List?>(
                        future: _iconFuture(a.packageName),
                        builder: (context, snap) {
                          final b = snap.data;
                          if (b != null && b.isNotEmpty) {
                            return CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.transparent,
                              backgroundImage: MemoryImage(b),
                            );
                          }
                          return const CircleAvatar(
                            radius: 22,
                            child: Icon(Icons.apps),
                          );
                        },
                      ),
                      title: Text(
                        a.name.isEmpty ? AppLocalizations.of(context)!.genericUnknownAppName : a.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      subtitle: Text(
                        a.packageName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.75),
                        ),
                      ),
                      trailing: Switch(
                        value: blocked,
                        onChanged: (v) => _setWifiBlocked(a.packageName, v),
                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
