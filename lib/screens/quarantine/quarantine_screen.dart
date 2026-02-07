import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/quarantine_service.dart';
import '../../translations/app_localizations.dart';

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
    final data = await QuarantineService.listAll();
    if (!mounted) return;
    setState(() {
      items = data;
      selected.clear();
      loading = false;
    });
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
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final body = loading
        ? const Center(child: CircularProgressIndicator())
        : items.isEmpty
        ? Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 44,
              color: scheme.onSurface.withOpacity(0.55),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.quarantineEmptyTitle,
              style: text.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.quarantineEmptyBody,
              style: text.bodySmall?.copyWith(
                color: scheme.onSurface.withOpacity(0.65),
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    )
        : ListView.separated(
      padding: const EdgeInsets.fromLTRB(4, 14, 8, 18),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
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
          color: scheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
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
              padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: sel,
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
                          ),
                        ),
                        if (orig.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            orig,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall?.copyWith(
                              color: scheme.onSurface.withOpacity(0.7),
                              height: 1.25,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 6,
                          children: [
                            _chip(
                              context,
                              Icons.data_usage_rounded,
                              _fmtSize(size),
                            ),
                            if (dt != null)
                              _chip(
                                context,
                                Icons.schedule_rounded,
                                DateFormat.yMMMd().add_jm().format(dt),
                              ),
                          ],
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

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(l10n.quarantineTitle),
            actions: [
              IconButton(
                tooltip: l10n.quarantineSelectAll,
                icon: const Icon(Icons.select_all_rounded),
                onPressed: items.isEmpty ? null : _toggleAll,
              ),
              IconButton(
                tooltip: l10n.quarantineRefresh,
                icon: const Icon(Icons.refresh_rounded),
                onPressed: _reload,
              ),
            ],
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: body,
          ),
          bottomNavigationBar: items.isEmpty
              ? null
              : SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: selected.isEmpty ? null : _restore,
                      icon: const Icon(Icons.restore_rounded),
                      label: Text(l10n.quarantineRestore),
                    ),
                  ),
                  const SizedBox(width: 12),
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

  Widget _chip(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: scheme.onSurface.withOpacity(0.7)),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.78),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
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
