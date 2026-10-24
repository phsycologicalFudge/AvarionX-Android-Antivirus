import 'dart:io';
import 'package:flutter/material.dart';
import '../services/scan api/headless_scan.dart';
import '../translations/app_localizations.dart';

Future<String?> showAvFolderPicker(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const _AvFolderPicker(),
  );
}

class _AvFolderPicker extends StatefulWidget {
  const _AvFolderPicker();

  @override
  State<_AvFolderPicker> createState() => _AvFolderPickerState();
}

class _AvFolderPickerState extends State<_AvFolderPicker> {
  List<StorageRoot> _roots = [];
  String? _current;
  List<_Entry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load(null);
  }

  Future<void> _load(String? path) async {
    setState(() => _loading = true);
    if (_roots.isEmpty) _roots = await listStorageRoots();
    final entries = <_Entry>[];
    if (path == null) {
      for (final r in _roots) {
        entries.add(_Entry(r.path, r.label.isNotEmpty ? r.label : r.path.split('/').last, r.removable));
      }
    } else {
      try {
        await for (final e in Directory(path).list(followLinks: false)) {
          if (e is Directory) entries.add(_Entry(e.path, e.path.split('/').last, false));
        }
      } catch (_) {}
      entries.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }
    if (!mounted) return;
    setState(() {
      _current = path;
      _entries = entries;
      _loading = false;
    });
  }

  void _up() {
    final c = _current;
    if (c == null) return;
    if (_roots.any((r) => r.path == c)) {
      _load(null);
    } else {
      _load(Directory(c).parent.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;
    final current = _current;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      backgroundColor: scheme.surfaceContainerHigh,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (current != null)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: _up,
                    )
                  else
                    const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.folderPickerTitle,
                          style: text.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        if (current != null)
                          Text(
                            current,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall?.copyWith(color: scheme.onSurface.withOpacity(0.55)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Flexible(
                child: _loading
                    ? const Padding(
                        padding: EdgeInsets.all(28),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _entries.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(28),
                            child: Center(
                              child: Text(
                                l10n.folderPickerEmpty,
                                style: text.bodySmall?.copyWith(color: scheme.onSurface.withOpacity(0.55)),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: _entries.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 6),
                            itemBuilder: (_, i) {
                              final e = _entries[i];
                              return InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => _load(e.path),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: scheme.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        current == null
                                            ? (e.removable ? Icons.sd_card_rounded : Icons.smartphone_rounded)
                                            : Icons.folder_rounded,
                                        size: 22,
                                        color: scheme.primary,
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          e.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: scheme.onSurface.withOpacity(0.35),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: current == null ? null : () => Navigator.pop(context, current),
                    child: Text(l10n.folderPickerSelect),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Entry {
  final String path;
  final String name;
  final bool removable;

  const _Entry(this.path, this.name, this.removable);
}
