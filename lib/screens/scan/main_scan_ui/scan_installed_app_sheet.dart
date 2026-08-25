import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_target.dart';

import '../../../translations/app_localizations.dart';
class ScanInstalledAppSheet extends StatefulWidget {
  final List<AppTarget> apps;

  const ScanInstalledAppSheet({required this.apps});

  @override
  State<ScanInstalledAppSheet> createState() => ScanInstalledAppSheetState();
}

class ScanInstalledAppSheetState extends State<ScanInstalledAppSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    final filtered = _query.isEmpty
        ? widget.apps
        : widget.apps.where((a) {
      return a.name.toLowerCase().contains(_query) ||
          a.package.toLowerCase().contains(_query);
    }).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.onSurface.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.scanModeInstalledTitle,
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: scheme.onSurface.withOpacity(0.92),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      style: text.bodyMedium?.copyWith(
                        color: scheme.onSurface.withOpacity(0.88),
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.scanInstalledAppsSearchApps,
                        hintStyle: text.bodyMedium?.copyWith(
                          color: scheme.onSurface.withOpacity(0.38),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: scheme.onSurface.withOpacity(0.45),
                        ),
                        filled: true,
                        fillColor: scheme.surfaceContainerHigh,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                  child: Text(
                    AppLocalizations.of(context)!.scanInstalledAppsNoAppsFound,
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                )
                    : ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) {
                    final app = filtered[i];
                    return ScanAppListTile(
                      key: ValueKey(app.package),
                      app: app,
                      onTap: () => Navigator.pop(context, app),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ScanAppListTile extends StatefulWidget {
  final AppTarget app;
  final VoidCallback onTap;

  const ScanAppListTile({
    super.key,
    required this.app,
    required this.onTap,
  });

  @override
  State<ScanAppListTile> createState() => ScanAppListTileState();
}

class ScanAppListTileState extends State<ScanAppListTile> {
  static const _channel = MethodChannel('cs.fastapps');
  Uint8List? _iconBytes;

  @override
  void initState() {
    super.initState();
    _loadIcon();
  }

  @override
  void didUpdateWidget(covariant ScanAppListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.app.package != widget.app.package) {
      _iconBytes = null;
      _loadIcon();
    }
  }

  Future<void> _loadIcon() async {
    try {
      final bytes = await _channel.invokeMethod<Uint8List>(
        'getAppIconPng',
        {'package': widget.app.package},
      );
      if (mounted) setState(() => _iconBytes = bytes);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 42,
                height: 42,
                child: _iconBytes != null
                    ? Image.memory(_iconBytes!, fit: BoxFit.cover)
                    : Container(
                  color: scheme.surfaceContainerHigh,
                  child: Icon(
                    Icons.android_rounded,
                    size: 24,
                    color: scheme.onSurface.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.app.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface.withOpacity(0.88),
                    ),
                  ),
                  Text(
                    widget.app.package,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: scheme.onSurface.withOpacity(0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
