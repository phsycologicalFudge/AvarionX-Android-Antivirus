import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      name: (m['name'] as String?) ?? 'Unknown',
      packageName: (m['package'] as String?) ?? '',
      path: (m['path'] as String?) ?? '',
    );
  }
}

class _NetworkAppControlScreenState extends State<NetworkAppControlScreen> {
  static const MethodChannel _chan = MethodChannel('cs.fastapps');

  static const _prefWifiBlockedSet = 'dns_wifi_blocked_apps';

  final TextEditingController _searchCtrl = TextEditingController();
  final Map<String, Future<Uint8List?>> _iconFutures = {};

  List<_AppRow> _all = const [];
  List<_AppRow> _filtered = const [];
  bool _loading = true;

  Set<String> _wifiBlocked = <String>{};

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_applyFilter);
    _loadPrefs().then((_) => _load());
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_applyFilter);
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefWifiBlockedSet) ?? const <String>[];
    if (!mounted) return;
    setState(() {
      _wifiBlocked = list.toSet();
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefWifiBlockedSet, _wifiBlocked.toList()..sort());
  }

  Future<void> _setWifiBlocked(String pkg, bool blocked) async {
    if (!mounted) return;

    setState(() {
      if (blocked) {
        _wifiBlocked.add(pkg);
      } else {
        _wifiBlocked.remove(pkg);
      }
    });

    await _savePrefs();

    try {
      await _chan.invokeMethod('setAppWifiBlock', {'package': pkg, 'blocked': blocked});
    } catch (_) {}
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
        return Uint8List.fromList((bytes as Uint8List));
      } catch (_) {
        return null;
      }
    }();

    _iconFutures[pkg] = f;
    return f;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('App control'),
        actions: [
          IconButton(
            onPressed: _loading ? null : () => _load(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search apps',
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
                  'No apps found.',
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
                        a.name,
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
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          showDragHandle: true,
                          builder: (_) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.name,
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(a.packageName, style: theme.textTheme.bodySmall),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Block on WiFi',
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ),
                                      Switch(
                                        value: blocked,
                                        onChanged: (v) => _setWifiBlocked(a.packageName, v),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            );
                          },
                        );
                      },
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
