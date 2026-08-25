import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'apk_analyser_controller.dart';
import 'apk_export_service.dart';

import '../../translations/app_localizations.dart';
class ApkReportScreen extends StatefulWidget {
  final ApkReport report;

  const ApkReportScreen({super.key, required this.report});

  @override
  State<ApkReportScreen> createState() => _ApkReportScreenState();
}

class _ApkReportScreenState extends State<ApkReportScreen> {

  List<_ReportTab> _buildTabs() {
    final report = widget.report;
    final tabs = <_ReportTab>[];

    tabs.add(_ReportTab(
      title: AppLocalizations.of(context)!.apkReportSummary,
      content: _buildSummaryContent(context),
    ));

    tabs.add(_ReportTab(
      title: AppLocalizations.of(context)!.apkReportPermissions,
      content: _buildPermissionsContent(context),
    ));

    if (report.unusualItems.isNotEmpty || report.unverifiedItems.isNotEmpty) {
      tabs.add(_ReportTab(
        title: AppLocalizations.of(context)!.apkReportExtraFlags,
        content: _buildFlagsContent(context),
      ));
    }

    final hasMalware = report.riskScore != null || report.riskLabel != null;
    if (hasMalware && (report.contributingSignals.isNotEmpty || report.dampeningFactors.isNotEmpty)) {
      tabs.add(_ReportTab(
        title: AppLocalizations.of(context)!.apkReportRiskSignals,
        content: _buildSignalsContent(context),
      ));
    }

    if (report.sources.isNotEmpty || report.sourceNotes.isNotEmpty) {
      tabs.add(_ReportTab(
        title: AppLocalizations.of(context)!.apkReportSources,
        content: _buildSourcesContent(context),
      ));
    }

    tabs.add(_ReportTab(
      title: AppLocalizations.of(context)!.apkReportMetadata,
      content: _buildMetadataContent(context),
    ));

    return tabs;
  }

  Color _riskColor(String? label) {
    switch (label?.toLowerCase()) {
      case 'critical':
        return const Color(0xFFE53935);
      case 'high':
        return const Color(0xFFF4511E);
      case 'moderate':
        return const Color(0xFFFB8C00);
      default:
        return const Color(0xFF43A047);
    }
  }

  void _showExportOptions(BuildContext context) {
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
              ListTile(
                leading: const Icon(Icons.copy_rounded),
                title:  Text(AppLocalizations.of(context)!.apkReportCopyReport),
                onTap: () async {
                  Navigator.pop(ctx);
                  await Clipboard.setData(
                    ClipboardData(text: _buildClipboardReport(widget.report)),
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text(AppLocalizations.of(context)!.apkReportReportCopiedToClipboard)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_rounded),
                title:  Text(AppLocalizations.of(context)!.apkReportExportAsPDF),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    await ApkExportService.exportToPdf(widget.report, AppLocalizations.of(context)!);
                  } catch (_) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(AppLocalizations.of(context)!.apkReportFailedToExportPDF)),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_chart_rounded),
                title:  Text(AppLocalizations.of(context)!.apkReportExportAsCSV),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    await ApkExportService.exportToCsv(widget.report, AppLocalizations.of(context)!);
                  } catch (_) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(AppLocalizations.of(context)!.apkReportFailedToExportCSV)),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _buildClipboardReport(ApkReport report) {
    final l10n = AppLocalizations.of(context)!;
    final buffer = StringBuffer();

    buffer.writeln(l10n.apkClipboardReportTitle);
    buffer.writeln();
    buffer.writeln(l10n.apkClipboardAppName(report.name));
    buffer.writeln(l10n.apkClipboardPackageId(report.packageName));
    buffer.writeln(l10n.apkClipboardVersion(report.versionLabel));
    buffer.writeln(l10n.apkClipboardFileSize(report.fileSizeLabel));
    buffer.writeln(l10n.apkClipboardMinSdk(report.minSdkLabel));
    buffer.writeln(l10n.apkClipboardTargetSdk(report.targetSdkLabel));
    buffer.writeln(l10n.apkClipboardSignature(report.signatureLabel));

    if (report.riskScore != null || report.riskLabel != null) {
      buffer.writeln();
      buffer.writeln(l10n.apkClipboardMalwareRisk(report.riskScore ?? 'N/A'));
      buffer.writeln(l10n.apkClipboardRiskLabel(report.riskLabel ?? 'N/A'));
      buffer.writeln(l10n.apkClipboardHashVerdict(report.hashVerdict ?? 'N/A'));
      if (report.scoreRationale != null && report.scoreRationale!.isNotEmpty) {
        buffer.writeln(l10n.apkClipboardRationale(report.scoreRationale!));
      }
    }

    buffer.writeln();
    buffer.writeln(l10n.apkReportSummary);
    buffer.writeln(report.summary);

    if (report.permissions.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(l10n.apkReportPermissions);
      for (final permission in report.permissions) {
        buffer.writeln(permission);
      }
    }

    if (report.unusualItems.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(l10n.apkReportUnusualFlags);
      for (final item in report.unusualItems) {
        buffer.writeln(item);
      }
    }

    if (report.unverifiedItems.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(l10n.apkReportUnverifiedItems);
      for (final item in report.unverifiedItems) {
        buffer.writeln(item);
      }
    }

    return buffer.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final report = widget.report;
    final hasMalware = report.riskScore != null || report.riskLabel != null;

    final currentTabs = _buildTabs();

    return DefaultTabController(
      length: currentTabs.length,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          scrolledUnderElevation: 0,
          title: Text(
            AppLocalizations.of(context)!.apkReportAnalysisReport,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.ios_share_rounded),
              onPressed: () => _showExportOptions(context),
            ),
          ],
        ),
        body: Column(
          children: [
            if (hasMalware)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _buildMalwareVerdictHeader(context),
              ),
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: theme.colorScheme.onSurface,
              indicatorWeight: 2,
              dividerColor: theme.colorScheme.onSurface.withOpacity(0.05),
              labelColor: theme.colorScheme.onSurface,
              unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.4),
              labelStyle: text.titleSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.2),
              unselectedLabelStyle: text.titleSmall?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.2),
              tabs: currentTabs.map((t) => Tab(text: t.title)).toList(),
            ),
            Expanded(
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                children: currentTabs.map((t) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: t.content,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMalwareVerdictHeader(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final report = widget.report;
    final score = report.riskScore ?? 0;
    final label = report.riskLabel ?? AppLocalizations.of(context)!.genericUnknownAppName;
    final color = _riskColor(label);
    final verdict = report.hashVerdict;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: score / 100,
                      strokeWidth: 6,
                      backgroundColor: theme.colorScheme.onSurface.withOpacity(0.04),
                      valueColor: AlwaysStoppedAnimation(color),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    '$score',
                    style: text.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: color,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.apkReportMalwareRisk,
                    style: text.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label.toUpperCase(),
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: color,
                    ),
                  ),
                  if (verdict != null && verdict.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _buildHashVerdictText(context, verdict),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (report.scoreRationale != null && report.scoreRationale!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            report.scoreRationale!,
            style: text.bodyMedium?.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHashVerdictText(BuildContext context, String verdict) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    IconData icon;
    Color color;
    String label;

    switch (verdict.toLowerCase()) {
      case 'known_malware':
        icon = Icons.dangerous_rounded;
        color = const Color(0xFFE53935);
        label = AppLocalizations.of(context)!.apkReportKnownMalware;
        break;
      case 'suspicious':
        icon = Icons.warning_amber_rounded;
        color = const Color(0xFFF4511E);
        label = AppLocalizations.of(context)!.apkReportSuspiciousHash;
        break;
      case 'clean':
        icon = Icons.verified_rounded;
        color = const Color(0xFF43A047);
        label = AppLocalizations.of(context)!.apkReportCleanHash;
        break;
      default:
        icon = Icons.help_outline_rounded;
        color = theme.colorScheme.onSurface.withOpacity(0.4);
        label = verdict == 'not_checked' ? AppLocalizations.of(context)!.apkReportHashNotChecked : AppLocalizations.of(context)!.apkReportHashUnknown;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: text.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryContent(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    final normalized = widget.report.summary
        .replaceAll(r'\r\n', '\n')
        .replaceAll(r'\n', '\n')
        .replaceAll('\r\n', '\n')
        .trim();

    List<String> paragraphs = normalized
        .split(RegExp(r'\n\s*\n+'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    if (paragraphs.length <= 1 && normalized.contains('\n')) {
      paragraphs = normalized
          .split('\n')
          .map((p) => p.trim())
          .where((p) => p.isNotEmpty)
          .toList();
    }

    if (paragraphs.isEmpty) {
      return Text(
        normalized.isEmpty ? AppLocalizations.of(context)!.apkReportNoSummaryGenerated : normalized,
        style: text.bodyMedium?.copyWith(
          height: 1.5,
          color: theme.colorScheme.onSurface.withOpacity(0.75),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < paragraphs.length; i++) ...[
          Text(
            paragraphs[i],
            style: text.bodyMedium?.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurface.withOpacity(0.75),
            ),
          ),
          if (i != paragraphs.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildPermissionsContent(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    if (widget.report.permissions.isEmpty) {
      return Text(
        AppLocalizations.of(context)!.apkReportNoRequestedPermissionsExtracted,
        style: text.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.report.permissions.map((p) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.shield_outlined, size: 22, color: theme.colorScheme.onSurface.withOpacity(0.4)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  p,
                  style: text.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFlagsContent(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widget.report.unusualItems.map((f) => _flagRow(
          context,
          f,
          Icons.warning_amber_rounded,
          Colors.orange,
          text.bodyMedium?.copyWith(
            height: 1.4,
            fontWeight: FontWeight.w600,
            color: text.bodyMedium?.color?.withOpacity(0.85),
          ),
        )),
        ...widget.report.unverifiedItems.map((f) => _flagRow(
          context,
          f,
          Icons.help_outline_rounded,
          Colors.grey,
          text.bodyMedium?.copyWith(
            height: 1.4,
            color: text.bodyMedium?.color?.withOpacity(0.65),
            fontStyle: FontStyle.italic,
          ),
        )),
      ],
    );
  }

  Widget _flagRow(BuildContext context, String text, IconData icon, Color iconColor, TextStyle? style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: style)),
        ],
      ),
    );
  }

  Widget _buildSignalsContent(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.report.contributingSignals.isNotEmpty) ...[
          Text(
            AppLocalizations.of(context)!.apkReportContributing,
            style: text.labelMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              color: theme.colorScheme.onSurface.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 12),
          ...widget.report.contributingSignals.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.arrow_upward_rounded, size: 22, color: const Color(0xFFF4511E)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    s,
                    style: text.bodyMedium?.copyWith(
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
        if (widget.report.dampeningFactors.isNotEmpty) ...[
          if (widget.report.contributingSignals.isNotEmpty) const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.apkReportDampening,
            style: text.labelMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              color: theme.colorScheme.onSurface.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 12),
          ...widget.report.dampeningFactors.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.arrow_downward_rounded, size: 22, color: const Color(0xFF43A047)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    s,
                    style: text.bodyMedium?.copyWith(
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ],
    );
  }

  Widget _buildSourcesContent(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widget.report.sources.entries.map((e) => _infoRow(context, e.key, e.value)),
        if (widget.report.sourceNotes.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...widget.report.sourceNotes.map((n) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 22, color: Colors.amber),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    n,
                    style: text.bodyMedium?.copyWith(
                      height: 1.4,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ],
    );
  }

  Widget _buildMetadataContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        _infoRow(context, AppLocalizations.of(context)!.apkMetadataPackage, widget.report.name),
        _infoRow(context, AppLocalizations.of(context)!.apkMetadataPackageId, widget.report.packageName),
        _infoRow(context, AppLocalizations.of(context)!.apkMetadataEngine, widget.report.engineLabel),
        _infoRow(context, AppLocalizations.of(context)!.apkMetadataSize, widget.report.fileSizeLabel),
        _infoRow(context, AppLocalizations.of(context)!.apkMetadataMinSdk, widget.report.minSdkLabel),
        _infoRow(context, AppLocalizations.of(context)!.apkMetadataTargetSdk, widget.report.targetSdkLabel),
        _infoRow(context, AppLocalizations.of(context)!.apkMetadataSignature, widget.report.signatureLabel),
        _infoRow(context, l10n.metaPassVersion, widget.report.versionLabel),
      ],
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: text.bodyMedium?.copyWith(
                color: text.bodyMedium?.color?.withOpacity(0.4),
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: text.bodyMedium?.copyWith(
                height: 1.4,
                color: theme.colorScheme.onSurface.withOpacity(0.85),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportTab {
  final String title;
  final Widget content;

  _ReportTab({required this.title, required this.content});
}