import 'package:flutter/material.dart';
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
  List<Map<String, dynamic>> items = [];
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
        items = data;
        selected.clear();
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        items = [];
        selected.clear();
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quarantine data corrupted. Resetting.')),
      );
    }
  }

  void _toggleAll() {
    setState(() {
      if (items.isEmpty) return;
      if (selected.length == items.length) {
        selected.clear();
      } else {
        selected
          ..clear()
          ..addAll(items.map((e) => e['id'] as String));
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

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    Widget body;

    if (loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (items.isEmpty) {
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
                l10n.quarantineEmptyTitle,
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.quarantineEmptyBody,
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
      body = ListView.separated(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final m = items[i];
          final id = m['id'] as String;
          final name = (m['name'] as String?) ?? l10n.genericUnknownFileName;
          final orig = (m['originalPath'] as String?) ?? '';
          final size = (m['size'] as int?) ?? 0;
          final dateRaw = (m['date'] as String?) ?? '';
          final dt = dateRaw.isEmpty ? null : DateTime.tryParse(dateRaw);
          final sel = selected.contains(id);

          return Card(
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            color: theme.cardTheme.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (sel) {
                    selected.remove(id);
                  } else {
                    selected.add(id);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 12, 12, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: sel,
                      visualDensity: VisualDensity.compact,
                      onChanged: (_) {
                        setState(() {
                          if (sel) {
                            selected.remove(id);
                          } else {
                            selected.add(id);
                          }
                        });
                      },
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
        },
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
                              l10n.quarantineTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: text.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: scheme.onSurface.withOpacity(0.92),
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: l10n.quarantineSelectAll,
                            icon: const Icon(Icons.select_all_rounded),
                            color: scheme.onSurface.withOpacity(0.72),
                            onPressed: items.isEmpty ? null : _toggleAll,
                          ),
                          IconButton(
                            tooltip: l10n.quarantineRefresh,
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
                  if (items.isNotEmpty)
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
                                label: Text(l10n.quarantineRestore),
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
                                label: Text(l10n.quarantineDelete),
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
