import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../services/quarantine_service.dart';
import '../../translations/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../services/theme/theme_manager.dart';
import '../../widgets/mesh_background.dart';

class QuarantineScreen extends StatefulWidget {
  const QuarantineScreen({super.key});

  @override
  State<QuarantineScreen> createState() => _QuarantineScreenState();
}

class _QuarantineScreenState extends State<QuarantineScreen> {
  List<Map<String, dynamic>> _apps = [];
  List<Map<String, dynamic>> _files = [];
  final Set<String> selected = {};
  bool loading = true;
  bool restoring = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() => loading = true);

    try {
      final data = await QuarantineService.listAll()
          .timeout(const Duration(seconds: 5));

      if (!mounted) return;

      setState(() {
        _apps = data.where((e) => e['type'] == 'app').toList();
        _files = data.where((e) => e['type'] != 'app').toList();
        selected.clear();
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _apps = [];
        _files = [];
        selected.clear();
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(AppLocalizations.of(context)!.quarantineScreenQuarantineDataCorruptedResetting)),
      );
    }
  }

  void _toggleAll() {
    setState(() {
      if (_files.isEmpty) return;
      final fileIds = _files.map((e) => e['id'] as String).toSet();
      if (selected.containsAll(fileIds)) {
        selected.removeAll(fileIds);
      } else {
        selected.addAll(fileIds);
      }
    });
  }

  Future<void> _restore() async {
    if (selected.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => restoring = true);
    try {
      await QuarantineService.restoreManyIsolated(selected);
      await _reload();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.quarantineSnackRestored)),
        );
      }
    } finally {
      if (mounted) setState(() => restoring = false);
    }
  }

  Future<void> _delete() async {
    if (selected.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.quarantineDeleteDialogTitle),
          content: Text(
            l10n.quarantineDeleteDialogBody(
              selected.length.toString(),
              selected.length == 1 ? '' : 's',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.quarantineDelete),
            ),
          ],
        );
      },
    );

    if (ok != true) return;

    await QuarantineService.deleteMany(selected);
    await _reload();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.quarantineSnackDeleted)),
      );
    }
  }

  Future<void> _uninstallApp(Map<String, dynamic> m) async {
    final packageName = m['packageName'] as String? ?? '';
    final appName = m['appName'] as String? ?? packageName;
    final id = m['id'] as String;

    if (packageName.isEmpty) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text(AppLocalizations.of(context)!.quarantineScreenUninstallApp),
          content: Text(AppLocalizations.of(context)!.quarantineScreenUninstall(appName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child:  Text(AppLocalizations.of(context)!.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child:  Text(AppLocalizations.of(context)!.quarantineScreenUninstall2),
            ),
          ],
        );
      },
    );

    if (ok != true) return;

    try {
      await QuarantineService.uninstallApp(packageName);
      await QuarantineService.deleteAppEntry(id);
      await _reload();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(AppLocalizations.of(context)!.quarantineScreenFailedToLaunchUninstall)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    final bool empty = _apps.isEmpty && _files.isEmpty;

    Widget body;

    if (loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (empty) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inbox_rounded,
                size: 42,
                color: scheme.onSurface.withOpacity(0.42),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.quarantineEmptyTitle,
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                AppLocalizations.of(context)!.quarantineEmptyBody,
                style: text.bodySmall?.copyWith(
                  color: scheme.onSurface.withOpacity(0.58),
                  height: 1.35,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      final items = <Widget>[];

      if (_apps.isNotEmpty) {
        items.add(_sectionHeader(AppLocalizations.of(context)!.networkCardAppsTitle, scheme, text));
        for (final m in _apps) {
          items.add(_AppCard(
            meta: m,
            theme: theme,
            onUninstall: () => _uninstallApp(m),
          ));
          items.add(const SizedBox(height: 8));
        }
      }

      if (_files.isNotEmpty) {
        items.add(_sectionHeader(AppLocalizations.of(context)!.quarantineScreenFiles, scheme, text));
        for (final m in _files) {
          items.add(_FileCard(
            meta: m,
            selected: selected.contains(m['id'] as String),
            theme: theme,
            onToggle: () {
              setState(() {
                final id = m['id'] as String;
                if (selected.contains(id)) {
                  selected.remove(id);
                } else {
                  selected.add(id);
                }
              });
            },
          ));
          items.add(const SizedBox(height: 8));
        }
      }

      body = ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
        children: items,
      );
    }

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          body: MeshBackground(
            blobs: themeManager.meshBlobs,
            base: scheme.surface,
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.cardTheme.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_rounded),
                            color: scheme.onSurface.withOpacity(0.78),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.quarantineTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: text.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: scheme.onSurface.withOpacity(0.92),
                              ),
                            ),
                          ),
                          if (_files.isNotEmpty)
                            IconButton(
                              tooltip: AppLocalizations.of(context)!.quarantineSelectAll,
                              icon: const Icon(Icons.select_all_rounded),
                              color: scheme.onSurface.withOpacity(0.72),
                              onPressed: _toggleAll,
                            ),
                          IconButton(
                            tooltip: AppLocalizations.of(context)!.quarantineRefresh,
                            icon: const Icon(Icons.refresh_rounded),
                            color: scheme.onSurface.withOpacity(0.72),
                            onPressed: _reload,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: body,
                    ),
                  ),
                  if (_files.isNotEmpty)
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: selected.isEmpty ? null : _restore,
                                icon: const Icon(Icons.restore_rounded),
                                label: Text(AppLocalizations.of(context)!.quarantineRestore),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: selected.isEmpty ? null : _delete,
                                style: FilledButton.styleFrom(
                                  backgroundColor: scheme.error,
                                  foregroundColor: scheme.onError,
                                ),
                                icon: const Icon(Icons.delete_forever_rounded),
                                label: Text(AppLocalizations.of(context)!.quarantineDelete),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (restoring)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: scheme.scrim.withOpacity(0.55),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
      ],
    );
  }

  Widget _sectionHeader(String label, ColorScheme scheme, TextTheme text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 6),
      child: Text(
        label,
        style: text.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: scheme.onSurface.withOpacity(0.48),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _AppCard extends StatefulWidget {
  final Map<String, dynamic> meta;
  final ThemeData theme;
  final VoidCallback onUninstall;

  const _AppCard({
    required this.meta,
    required this.theme,
    required this.onUninstall,
  });

  @override
  State<_AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<_AppCard> {
  static final _ch = MethodChannel('cs.fastapps');
  Uint8List? _iconBytes;

  @override
  void initState() {
    super.initState();
    _loadIcon();
  }

  Future<void> _loadIcon() async {
    final pkg = (widget.meta['packageName'] as String?) ?? '';
    if (pkg.isEmpty) return;
    try {
      final bytes = await _ch.invokeMethod<Uint8List>('getAppIconPng', {'package': pkg});
      if (mounted) setState(() => _iconBytes = bytes);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    final appName = (widget.meta['appName'] as String?) ?? (widget.meta['name'] as String?) ?? AppLocalizations.of(context)!.quarantineUnknownApp;
    final packageName = (widget.meta['packageName'] as String?) ?? '';
    final dateRaw = (widget.meta['date'] as String?) ?? '';
    final dt = dateRaw.isEmpty ? null : DateTime.tryParse(dateRaw);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: theme.cardTheme.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          children: [
            if (_iconBytes != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  _iconBytes!,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholderIcon(scheme),
                ),
              )
            else
              _placeholderIcon(scheme),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface.withOpacity(0.9),
                    ),
                  ),
                  if (packageName.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      packageName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurface.withOpacity(0.52),
                      ),
                    ),
                  ],
                  if (dt != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      DateFormat.yMMMd().add_jm().format(dt),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurface.withOpacity(0.42),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: widget.onUninstall,
              style: FilledButton.styleFrom(
                backgroundColor: scheme.error,
                foregroundColor: scheme.onError,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: text.labelMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              child:  Text(AppLocalizations.of(context)!.quarantineScreenUninstall2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderIcon(ColorScheme scheme) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: scheme.onSurface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.android_rounded,
        size: 26,
        color: scheme.onSurface.withOpacity(0.38),
      ),
    );
  }
}

class _FileCard extends StatelessWidget {
  final Map<String, dynamic> meta;
  final bool selected;
  final ThemeData theme;
  final VoidCallback onToggle;

  const _FileCard({
    required this.meta,
    required this.selected,
    required this.theme,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final name = (meta['name'] as String?) ?? l10n.genericUnknownFileName;
    final orig = (meta['originalPath'] as String?) ?? '';
    final size = (meta['size'] as int?) ?? 0;
    final dateRaw = (meta['date'] as String?) ?? '';
    final dt = dateRaw.isEmpty ? null : DateTime.tryParse(dateRaw);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: theme.cardTheme.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 12, 12, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: selected,
                visualDensity: VisualDensity.compact,
                onChanged: (_) => onToggle(),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface.withOpacity(0.9),
                      ),
                    ),
                    if (orig.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        orig,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                          color: scheme.onSurface.withOpacity(0.58),
                          height: 1.25,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      dt == null
                          ? _fmtSize(size)
                          : '${_fmtSize(size)} • ${DateFormat.yMMMd().add_jm().format(dt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurface.withOpacity(0.48),
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtSize(int b) {
    const k = 1024;
    if (b < k) return '$b B';
    final kb = b / k;
    if (kb < k) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / k;
    if (mb < k) return '${mb.toStringAsFixed(1)} MB';
    final gb = mb / k;
    return '${gb.toStringAsFixed(1)} GB';
  }
}