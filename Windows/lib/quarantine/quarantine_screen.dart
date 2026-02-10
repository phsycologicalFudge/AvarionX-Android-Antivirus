import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/quarantine_service.dart';
import '../../services/exclusion_service.dart';

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
    setState(() {
      items = data;
      selected.clear();
      loading = false;
    });
  }

  void _toggleSelect(String id) {
    setState(() {
      if (selected.contains(id)) {
        selected.remove(id);
      } else {
        selected.add(id);
      }
    });
  }

  void _selectAll() {
    setState(() {
      if (selected.length == items.length) {
        selected.clear();
      } else {
        selected
          ..clear()
          ..addAll(items.map((e) => e['id'] as String));
      }
    });
  }

  Future<void> _restoreSelected() async {
    if (selected.isEmpty) return;
    setState(() => restoring = true);
    try {
      await QuarantineService.restoreManyIsolated(selected);
      await _reload();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Files restored')),
        );
      }
    } finally {
      if (mounted) setState(() => restoring = false);
    }
  }

  Future<void> _deleteSelected() async {
    if (selected.isEmpty) return;

    for (final id in selected) {
      await QuarantineService.deleteForever(id);
    }

    await _reload();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Files permanently deleted')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quarantine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.select_all_rounded),
            tooltip: 'Select all',
            onPressed: items.isEmpty ? null : _selectAll,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: _reload,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (items.isEmpty)
            Center(
              child: Text(
                'Quarantine is empty',
                style: text.bodyMedium?.copyWith(
                  color: text.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildHeader(theme),
                  const Divider(height: 1),
                  Expanded(child: _buildTable(theme)),
                ],
              ),
            ),
          if (restoring)
            Positioned.fill(
              child: AbsorbPointer(
                child: Container(
                  color: Colors.black.withOpacity(0.45),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: items.isEmpty
          ? null
          : Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: selected.isEmpty ? null : _restoreSelected,
                icon: const Icon(Icons.restore_rounded),
                label: const Text('Restore'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: selected.isEmpty ? null : _deleteSelected,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.delete_forever_rounded),
                label: const Text('Delete'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: const [
          SizedBox(width: 40),
          Expanded(flex: 3, child: Text('Name', style: TextStyle(fontWeight: FontWeight.w700))),
          Expanded(flex: 4, child: Text('Original location', style: TextStyle(fontWeight: FontWeight.w700))),
          Expanded(flex: 2, child: Text('Size', style: TextStyle(fontWeight: FontWeight.w700))),
          Expanded(flex: 3, child: Text('Date', style: TextStyle(fontWeight: FontWeight.w700))),
          SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildTable(ThemeData theme) {
    final df = DateFormat.yMMMd().add_jm();

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final m = items[i];
        final id = m['id'] as String;
        final sel = selected.contains(id);

        return InkWell(
          onTap: () => _toggleSelect(id),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: sel ? theme.colorScheme.primary.withOpacity(0.08) : null,
            child: Row(
              children: [
                Checkbox(
                  value: sel,
                  onChanged: (_) => _toggleSelect(id),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m['name'] ?? 'Unknown',
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (m['label'] != null)
                        Text(
                          m['label'],
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.orangeAccent,
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    m['originalPath'] ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.textTheme.bodySmall?.color),
                  ),
                ),
                Expanded(flex: 2, child: Text(_fmtSize(m['size'] as int))),
                Expanded(flex: 3, child: Text(df.format(DateTime.parse(m['date'])))),
                IconButton(
                  tooltip: 'Exclude hash',
                  icon: const Icon(Icons.block, color: Colors.orange),
                  onPressed: () async {
                    final sha = m['sha256'] as String?;
                    if (sha == null) return;
                    final x = ExclusionService();
                    await x.load();
                    await x.addSha(sha);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to exclusions')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
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
