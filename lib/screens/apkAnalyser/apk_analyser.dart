import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../pro/pro_screen.dart';
import 'apk_analyser_controller.dart';
import 'apk_report_screen.dart';
import 'apk_export_service.dart';

class ApkAnalyserScreen extends StatefulWidget {
  const ApkAnalyserScreen({super.key});

  @override
  State<ApkAnalyserScreen> createState() => _ApkAnalyserScreenState();
}

class _ApkAnalyserScreenState extends State<ApkAnalyserScreen> with SingleTickerProviderStateMixin {
  late final ApkAnalyserController _controller;
  late final AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _controller = ApkAnalyserController()..init();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _spinController.dispose();
    super.dispose();
  }

  void _showHistoryOptions() {
    final currentReport = _controller.report;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (currentReport != null) ...[
                ListTile(
                  leading: const Icon(Icons.copy_rounded),
                  title: const Text('Copy Current Report'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await Clipboard.setData(
                      ClipboardData(text: _buildClipboardReport(currentReport)),
                    );
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Report copied to clipboard')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf_rounded),
                  title: const Text('Export Current as PDF'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    try {
                      await ApkExportService.exportToPdf(currentReport);
                    } catch (_) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to export PDF')),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.table_chart_rounded),
                  title: const Text('Export Current as CSV'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    try {
                      await ApkExportService.exportToCsv(currentReport);
                    } catch (_) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to export CSV')),
                      );
                    }
                  },
                ),
                const Divider(),
              ],
              ListTile(
                leading: const Icon(Icons.history_rounded),
                title: const Text('View Saved Reports'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showSavedReportsSheet();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
                title: const Text('Clear History', style: TextStyle(color: Colors.redAccent)),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _controller.clearSavedReports();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report history cleared')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSavedReportsSheet() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Saved Reports',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _controller.savedReports.isEmpty
                        ? Center(
                      child: Text(
                        'No saved reports found.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    )
                        : ListView.builder(
                      controller: scrollController,
                      itemCount: _controller.savedReports.length,
                      itemBuilder: (ctx, i) {
                        final r = _controller.savedReports[i];
                        final date = DateTime.fromMillisecondsSinceEpoch(r.savedAt);
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.android_rounded, color: theme.colorScheme.primary),
                          ),
                          title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${r.packageName}\n${date.toString().split('.')[0]}'),
                          isThreeLine: true,
                          onTap: () {
                            Navigator.pop(ctx);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ApkReportScreen(report: r)),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _buildClipboardReport(ApkReport report) {
    final buffer = StringBuffer();

    buffer.writeln('VTTI Cloud - APK Analysis Report');
    buffer.writeln();
    buffer.writeln('App Name: ${report.name}');
    buffer.writeln('Package ID: ${report.packageName}');
    buffer.writeln('Version: ${report.versionLabel}');
    buffer.writeln('File Size: ${report.fileSizeLabel}');
    buffer.writeln('Min SDK: ${report.minSdkLabel}');
    buffer.writeln('Target SDK: ${report.targetSdkLabel}');
    buffer.writeln('Signature: ${report.signatureLabel}');

    if (report.riskScore != null || report.riskLabel != null) {
      buffer.writeln();
      buffer.writeln('Malware Risk: ${report.riskScore ?? "N/A"}');
      buffer.writeln('Risk Label: ${report.riskLabel ?? "N/A"}');
      buffer.writeln('Hash Verdict: ${report.hashVerdict ?? "N/A"}');
      if (report.scoreRationale != null && report.scoreRationale!.isNotEmpty) {
        buffer.writeln('Rationale: ${report.scoreRationale!}');
      }
    }

    buffer.writeln();
    buffer.writeln('Summary');
    buffer.writeln(report.summary);

    if (report.permissions.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Permissions');
      for (final permission in report.permissions) {
        buffer.writeln(permission);
      }
    }

    if (report.unusualItems.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Unusual Flags');
      for (final item in report.unusualItems) {
        buffer.writeln(item);
      }
    }

    if (report.unverifiedItems.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Unverified Items');
      for (final item in report.unverifiedItems) {
        buffer.writeln(item);
      }
    }

    return buffer.toString().trim();
  }

  void _showTargetPickerDialog() {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        backgroundColor: theme.colorScheme.surfaceContainerHigh,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Target',
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                'Select a source to analyse with VTTI Cloud.',
                style: text.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.55),
                ),
              ),
              const SizedBox(height: 16),
              _dialogOption(
                ctx,
                icon: Icons.folder_open_rounded,
                label: 'APK File',
                subtitle: 'Pick an .apk from storage',
                onTap: () {
                  Navigator.pop(ctx);
                  _controller.pickApk();
                },
              ),
              const SizedBox(height: 8),
              _dialogOption(
                ctx,
                icon: Icons.apps_rounded,
                label: 'Installed App',
                subtitle: 'Choose from apps on this device',
                onTap: () {
                  Navigator.pop(ctx);
                  _showInstalledAppSheet();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogOption(
      BuildContext ctx, {
        required IconData icon,
        required String label,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: theme.colorScheme.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w800)),
                  Text(
                    subtitle,
                    style: text.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.55),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withOpacity(0.35)),
          ],
        ),
      ),
    );
  }

  void _showInstalledAppSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _InstalledAppSheet(
        onSelected: (path, name) {
          _controller.selectTarget(path, name);
        },
      ),
    );
  }

  Widget _buildFancyLoader(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                RotationTransition(
                  turns: _spinController,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.1),
                          theme.colorScheme.primary,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                ),
                Icon(Icons.analytics_rounded, size: 40, color: theme.colorScheme.primary),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            _controller.loadingStage,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => _controller.cancelAnalysis(),
            child: Text('Cancel', style: TextStyle(color: theme.colorScheme.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetArea(ThemeData theme) {
    final text = theme.textTheme;
    final hasTarget = _controller.selectedApkPath.isNotEmpty;

    if (!hasTarget) {
      return GestureDetector(
        onTap: _controller.isLoggedIn ? _showTargetPickerDialog : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _controller.isLoggedIn
                  ? theme.colorScheme.primary.withOpacity(0.35)
                  : theme.colorScheme.onSurface.withOpacity(0.12),
              width: 1.5,
            ),
            color: theme.colorScheme.primary.withOpacity(
              _controller.isLoggedIn ? 0.04 : 0.02,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                size: 36,
                color: _controller.isLoggedIn
                    ? theme.colorScheme.primary.withOpacity(0.7)
                    : theme.colorScheme.onSurface.withOpacity(0.25),
              ),
              const SizedBox(height: 12),
              Text(
                'Choose Target',
                style: text.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: _controller.isLoggedIn
                      ? theme.colorScheme.primary.withOpacity(0.85)
                      : theme.colorScheme.onSurface.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'APK file or installed app',
                style: text.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(
                    _controller.isLoggedIn ? 0.45 : 0.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.android_rounded, color: theme.colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _controller.selectedApkName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(
                  'Ready to analyse',
                  style: text.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _controller.selectTarget('', ''),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.08),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(
                Icons.close_rounded,
                size: 18,
                color: theme.colorScheme.onSurface.withOpacity(0.55),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surface,
            title: const Text('APK Analyser'),
            actions: [
              IconButton(
                icon: const Icon(Icons.history_rounded),
                onPressed: _showHistoryOptions,
              ),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Analyse',
                            style: text.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onSurface.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Upload metadata directly to VTTI Cloud for advanced threat analysis.',
                            style: text.bodySmall?.copyWith(
                              height: 1.35,
                              color: text.bodySmall?.color?.withOpacity(0.75),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildTargetArea(theme),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: (_controller.isLoggedIn &&
                                _controller.selectedApkPath.isNotEmpty &&
                                !_controller.analysing &&
                                !(_controller.usageFetched &&
                                    _controller.remainingGenerations != null &&
                                    _controller.remainingGenerations! <= 0))
                                ? () {
                              _controller.analyseApk(context, () {
                                if (_controller.report != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ApkReportScreen(report: _controller.report!),
                                    ),
                                  );
                                }
                              });
                            }
                                : null,
                            icon: const Icon(Icons.cloud_upload_rounded, size: 18),
                            label: const Text('Analyse Selected Target'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (!_controller.isLoggedIn)
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Center(
                                child: Text(
                                  'Please sign in via Settings to enable Cloud Analysis.',
                                  style: text.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 10),
                            child: Text(
                              'ADVANCED OPTIONS',
                              style: text.labelSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ),
                          Card(
                            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                            elevation: 0,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (!_controller.isPro) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const ProScreen()),
                                  ).then((_) => _controller.checkAuthAndPro());
                                } else if (_controller.authResolved) {
                                  _controller.setAdvancedMode(!_controller.advancedModeEnabled);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Deep analysis mode',
                                            style: text.titleSmall?.copyWith(
                                              fontWeight: FontWeight.w800,
                                              color: theme.colorScheme.onSurface.withOpacity(0.9),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _controller.isPro
                                                ? 'A more complex analysis using global data sources'
                                                : 'Requires Pro to unlock deeper analysis',
                                            style: text.bodySmall?.copyWith(
                                              color: !_controller.isPro
                                                  ? theme.colorScheme.primary
                                                  : text.bodySmall?.color?.withOpacity(0.7),
                                              fontWeight: !_controller.isPro ? FontWeight.w600 : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Switch(
                                      value: _controller.isPro && _controller.advancedModeEnabled,
                                      onChanged: (!_controller.isPro || !_controller.authResolved)
                                          ? null
                                          : (value) async {
                                        await _controller.setAdvancedMode(value);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      children: [
                        if (_controller.isLoggedIn && _controller.usageFetched)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              _controller.remainingGenerations != null
                                  ? 'Daily Limit: ${_controller.remainingGenerations} / ${_controller.dailyLimit}'
                                  : 'Daily Limit Data Unavailable',
                              style: text.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ),
                        Text(
                          'Powered by VTTI Cloud',
                          style: text.bodySmall?.copyWith(
                            fontSize: 11,
                            letterSpacing: 0.6,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface.withOpacity(0.32),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_controller.analysing)
                Positioned.fill(
                  child: Container(
                    color: theme.colorScheme.surface.withOpacity(0.88),
                    child: _buildFancyLoader(theme),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _InstalledAppSheet extends StatefulWidget {
  final void Function(String path, String name) onSelected;

  const _InstalledAppSheet({required this.onSelected});

  @override
  State<_InstalledAppSheet> createState() => _InstalledAppSheetState();
}

class _InstalledAppSheetState extends State<_InstalledAppSheet> {
  static const _fastAppsChannel = MethodChannel('cs.fastapps');

  late Future<List<Map<String, String>>> _appsFuture;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _appsFuture = _loadApps();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, String>>> _loadApps() async {
    final raw = await _fastAppsChannel.invokeMethod<List>('listUserApps');
    if (raw == null) return [];
    return raw
        .whereType<Map>()
        .map((m) => {
      'name': m['name']?.toString() ?? '',
      'package': m['package']?.toString() ?? '',
      'path': m['path']?.toString() ?? '',
    })
        .where((m) => m['path']!.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Installed Apps',
                      style: text.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Search apps...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHigh,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Map<String, String>>>(
                  future: _appsFuture,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError || !snapshot.hasData) {
                      return Center(
                        child: Text(
                          'Failed to load apps.',
                          style: text.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      );
                    }

                    final apps = snapshot.data!.where((app) {
                      if (_query.isEmpty) return true;
                      return app['name']!.toLowerCase().contains(_query) ||
                          app['package']!.toLowerCase().contains(_query);
                    }).toList();

                    if (apps.isEmpty) {
                      return Center(
                        child: Text(
                          'No apps found.',
                          style: text.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      itemCount: apps.length,
                      itemBuilder: (ctx, i) {
                        final app = apps[i];
                        return _AppListTile(
                          name: app['name']!,
                          package: app['package']!,
                          path: app['path']!,
                          onTap: () {
                            Navigator.pop(context);
                            widget.onSelected(app['path']!, app['name']!);
                          },
                        );
                      },
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

class _AppListTile extends StatefulWidget {
  final String name;
  final String package;
  final String path;
  final VoidCallback onTap;

  const _AppListTile({
    required this.name,
    required this.package,
    required this.path,
    required this.onTap,
  });

  @override
  State<_AppListTile> createState() => _AppListTileState();
}

class _AppListTileState extends State<_AppListTile> {
  static const _fastAppsChannel = MethodChannel('cs.fastapps');
  Uint8List? _iconBytes;
  bool _iconLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadIcon();
  }

  Future<void> _loadIcon() async {
    try {
      final bytes = await _fastAppsChannel.invokeMethod<Uint8List>(
        'getAppIconPng',
        {'package': widget.package},
      );
      if (mounted) {
        setState(() {
          _iconBytes = bytes;
          _iconLoaded = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _iconLoaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 42,
                height: 42,
                child: _iconBytes != null
                    ? Image.memory(_iconBytes!, fit: BoxFit.cover)
                    : Container(
                  color: theme.colorScheme.surfaceContainerHigh,
                  child: Icon(
                    Icons.android_rounded,
                    size: 24,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
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
                    widget.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    widget.package,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.45),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}