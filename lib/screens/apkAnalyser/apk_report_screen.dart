import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'apk_analyser_controller.dart';
import 'apk_export_service.dart';

class ApkReportScreen extends StatelessWidget {
  final ApkReport report;

  const ApkReportScreen({super.key, required this.report});

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
                title: const Text('Copy Report'),
                onTap: () async {
                  Navigator.pop(ctx);
                  await Clipboard.setData(
                    ClipboardData(text: _buildClipboardReport(report)),
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report copied to clipboard')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_rounded),
                title: const Text('Export as PDF'),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    await ApkExportService.exportToPdf(report);
                  } catch (_) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to export PDF')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_chart_rounded),
                title: const Text('Export as CSV'),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    await ApkExportService.exportToCsv(report);
                  } catch (_) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to export CSV')),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMalware = report.riskScore != null || report.riskLabel != null;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: const Text('Analysis Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () => _showExportOptions(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasMalware) ...[
              _buildMalwareVerdictCard(context),
              const SizedBox(height: 12),
            ],
            _buildSection(
              context,
              title: 'Summary',
              subtitle: 'VTTI Cloud assessment of this package.',
              icon: Icons.description_outlined,
              child: _buildSummaryContent(context),
            ),
            const SizedBox(height: 10),
            _buildSection(
              context,
              title: 'Permissions',
              subtitle: '${report.permissions.length} requested capabilities extracted from the manifest.',
              icon: Icons.security_outlined,
              child: _buildPermissionsContent(context),
            ),
            if (report.unusualItems.isNotEmpty || report.unverifiedItems.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildSection(
                context,
                title: 'Extra Flags',
                subtitle: 'Warnings and unverified claims flagged by the engine.',
                icon: Icons.flag_outlined,
                child: _buildFlagsContent(context),
              ),
            ],
            if (hasMalware && (report.contributingSignals.isNotEmpty || report.dampeningFactors.isNotEmpty)) ...[
              const SizedBox(height: 10),
              _buildSection(
                context,
                title: 'Risk Signals',
                subtitle: 'Factors that contributed to the malware risk score.',
                icon: Icons.radar_rounded,
                child: _buildSignalsContent(context),
              ),
            ],
            if (report.sources.isNotEmpty || report.sourceNotes.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildSection(
                context,
                title: 'Discovered Sources',
                subtitle: 'External URLs and claims verified by the cloud engine.',
                icon: Icons.public_rounded,
                child: _buildSourcesContent(context),
              ),
            ],
            const SizedBox(height: 10),
            _buildSection(
              context,
              title: 'Cloud Metadata',
              subtitle: 'Raw technical data extracted from the package binary.',
              icon: Icons.info_outline_rounded,
              child: _buildMetadataContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMalwareVerdictCard(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final score = report.riskScore ?? 0;
    final label = report.riskLabel ?? 'Unknown';
    final color = _riskColor(label);
    final verdict = report.hashVerdict;

    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 76,
                  height: 76,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: score / 100,
                          strokeWidth: 7,
                          backgroundColor: theme.colorScheme.surfaceContainerLow,
                          valueColor: AlwaysStoppedAnimation(color),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Text(
                        '$score',
                        style: text.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: color,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Malware Risk',
                        style: text.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: color.withOpacity(0.3)),
                        ),
                        child: Text(
                          label,
                          style: text.labelLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: color,
                          ),
                        ),
                      ),
                      if (verdict != null && verdict.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _buildHashVerdictChip(context, verdict),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (report.scoreRationale != null && report.scoreRationale!.isNotEmpty) ...[
              const SizedBox(height: 14),
              Divider(height: 1, color: theme.colorScheme.onSurface.withOpacity(0.07)),
              const SizedBox(height: 12),
              Text(
                report.scoreRationale!,
                style: text.bodySmall?.copyWith(
                  height: 1.5,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHashVerdictChip(BuildContext context, String verdict) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    IconData icon;
    Color color;
    String label;

    switch (verdict.toLowerCase()) {
      case 'known_malware':
        icon = Icons.dangerous_rounded;
        color = const Color(0xFFE53935);
        label = 'Known Malware';
        break;
      case 'suspicious':
        icon = Icons.warning_amber_rounded;
        color = const Color(0xFFF4511E);
        label = 'Suspicious Hash';
        break;
      case 'clean':
        icon = Icons.verified_rounded;
        color = const Color(0xFF43A047);
        label = 'Clean Hash';
        break;
      default:
        icon = Icons.help_outline_rounded;
        color = theme.colorScheme.onSurface.withOpacity(0.4);
        label = verdict == 'not_checked' ? 'Hash Not Checked' : 'Hash Unknown';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          style: text.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Widget child,
      }) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding: EdgeInsets.zero,
          leading: Icon(icon, size: 20, color: theme.colorScheme.onSurface.withOpacity(0.55)),
          title: Text(
            title,
            style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          subtitle: Text(
            subtitle,
            style: text.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          children: [
            Divider(height: 1, color: theme.colorScheme.onSurface.withOpacity(0.07)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryContent(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    final normalized = report.summary
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
        normalized.isEmpty ? 'No summary generated.' : normalized,
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
          if (i != paragraphs.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildPermissionsContent(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    if (report.permissions.isEmpty) {
      return Text(
        'No requested permissions extracted.',
        style: text.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
      );
    }

    return Column(
      children: report.permissions.map((p) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              p,
              style: text.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
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
        ...report.unusualItems.map((f) => _flagRow(
          context,
          f,
          Icons.warning_amber_rounded,
          Colors.orange,
          text.bodySmall?.copyWith(
            height: 1.35,
            color: text.bodySmall?.color?.withOpacity(0.85),
          ),
        )),
        ...report.unverifiedItems.map((f) => _flagRow(
          context,
          f,
          Icons.help_outline_rounded,
          Colors.grey,
          text.bodySmall?.copyWith(
            height: 1.35,
            color: text.bodySmall?.color?.withOpacity(0.65),
            fontStyle: FontStyle.italic,
          ),
        )),
      ],
    );
  }

  Widget _flagRow(BuildContext context, String text, IconData icon, Color iconColor, TextStyle? style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: iconColor),
          const SizedBox(width: 10),
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
        if (report.contributingSignals.isNotEmpty) ...[
          Text(
            'Contributing',
            style: text.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              color: theme.colorScheme.onSurface.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 8),
          ...report.contributingSignals.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.arrow_upward_rounded, size: 14, color: const Color(0xFFF4511E)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s,
                    style: text.bodySmall?.copyWith(
                      height: 1.4,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
        if (report.dampeningFactors.isNotEmpty) ...[
          if (report.contributingSignals.isNotEmpty) const SizedBox(height: 10),
          Text(
            'Dampening',
            style: text.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              color: theme.colorScheme.onSurface.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 8),
          ...report.dampeningFactors.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.arrow_downward_rounded, size: 14, color: const Color(0xFF43A047)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s,
                    style: text.bodySmall?.copyWith(
                      height: 1.4,
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
        ...report.sources.entries.map((e) => _infoRow(context, e.key, e.value)),
        if (report.sourceNotes.isNotEmpty) ...[
          const SizedBox(height: 6),
          ...report.sourceNotes.map((n) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 15, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    n,
                    style: text.bodySmall?.copyWith(
                      height: 1.35,
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
    return Column(
      children: [
        _infoRow(context, 'Package', report.name),
        _infoRow(context, 'Package ID', report.packageName),
        _infoRow(context, 'Engine', report.engineLabel),
        _infoRow(context, 'Size', report.fileSizeLabel),
        _infoRow(context, 'Min SDK', report.minSdkLabel),
        _infoRow(context, 'Target SDK', report.targetSdkLabel),
        _infoRow(context, 'Signature', report.signatureLabel),
        _infoRow(context, 'Version', report.versionLabel),
      ],
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: text.bodySmall?.copyWith(
                color: text.bodySmall?.color?.withOpacity(0.5),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: text.bodySmall?.copyWith(
                height: 1.35,
                color: theme.colorScheme.onSurface.withOpacity(0.84),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}