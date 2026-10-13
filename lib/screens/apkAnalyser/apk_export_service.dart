import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';

import 'apk_analyser_controller.dart';
import '../../translations/app_localizations.dart';

class ApkExportService {

  static Future<void> exportToCsv(ApkReport report, AppLocalizations l10n) async {
    List<List<dynamic>> rows = [
      [l10n.apkClipboardReportTitle],
      [],
      [l10n.apkExportOverview],
      [l10n.apkMetadataAppName, report.name],
      [l10n.apkMetadataPackageId, report.packageName],
      [l10n.metaPassVersion, report.versionLabel],
      [l10n.apkMetadataFileSize, report.fileSizeLabel],
      [l10n.apkMetadataMinSdk, report.minSdkLabel],
      [l10n.apkMetadataTargetSdk, report.targetSdkLabel],
      [l10n.apkMetadataSignature, report.signatureLabel],
      [],
      [l10n.apkExportMalwareAssessment],
      [l10n.apkExportRiskScore, report.riskScore ?? 'N/A'],
      [l10n.apkExportRiskLabel, report.riskLabel ?? 'N/A'],
      [l10n.apkExportHashVerdict, report.hashVerdict ?? 'N/A'],
      [l10n.apkExportScoreRationale, report.scoreRationale ?? ''],
      [],
      [l10n.apkExportContributingSignals],
      ...report.contributingSignals.map((s) => [s]),
      [],
      [l10n.apkExportDampeningFactors],
      ...report.dampeningFactors.map((s) => [s]),
      [],
      [l10n.apkReportSummary],
      [report.summary],
      [],
      [l10n.apkExportPermissionsRequested],
      ...report.permissions.map((p) => [p]),
      [],
      [l10n.apkExportExtraFlagsUnusual],
      ...report.unusualItems.map((u) => [u]),
      [],
      [l10n.apkExportExtraFlagsUnverified],
      ...report.unverifiedItems.map((u) => [u]),
      [],
      [l10n.apkExportDiscoveredSources],
      ...report.sources.entries.map((e) => [e.key, e.value]),
    ];

    String csvData = const ListToCsvConverter().convert(rows);

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/${report.name}_analysis.csv');
    await file.writeAsString(csvData);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: l10n.apkExportCsvShareText(report.name),
    );
  }

  static Future<void> exportToPdf(ApkReport report, AppLocalizations l10n) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                l10n.apkExportPdfTitle,
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 10),

            _buildPdfSectionTitle(l10n.apkReportMetadata),
            _buildPdfRow(l10n.apkMetadataAppName, report.name),
            _buildPdfRow(l10n.apkMetadataPackageId, report.packageName),
            _buildPdfRow(l10n.metaPassVersion, report.versionLabel),
            _buildPdfRow(l10n.apkMetadataSize, report.fileSizeLabel),
            _buildPdfRow(l10n.apkMetadataMinSdk, report.minSdkLabel),
            _buildPdfRow(l10n.apkMetadataTargetSdk, report.targetSdkLabel),
            _buildPdfRow(l10n.apkMetadataSignature, report.signatureLabel),
            pw.SizedBox(height: 20),

            if (report.riskScore != null || report.riskLabel != null) ...[
              _buildPdfSectionTitle(l10n.apkExportMalwareAssessment),
              _buildPdfRow(l10n.apkExportRiskScore, '${report.riskScore ?? "N/A"} / 100'),
              _buildPdfRow(l10n.apkExportRiskLabel, report.riskLabel ?? 'N/A'),
              _buildPdfRow(l10n.apkExportHashVerdict, report.hashVerdict ?? 'N/A'),
              if (report.scoreRationale != null && report.scoreRationale!.isNotEmpty)
                _buildPdfRow(l10n.apkExportRationale, report.scoreRationale!),
              pw.SizedBox(height: 10),
              if (report.contributingSignals.isNotEmpty) ...[
                pw.Text(
                  l10n.apkExportContributingSignals,
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                ...report.contributingSignals.map(
                      (s) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 3),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('+ ', style: const pw.TextStyle(fontSize: 11)),
                        pw.Expanded(child: pw.Text(s, style: const pw.TextStyle(fontSize: 11))),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(height: 8),
              ],
              if (report.dampeningFactors.isNotEmpty) ...[
                pw.Text(
                  l10n.apkExportDampeningFactors,
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                ...report.dampeningFactors.map(
                      (s) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 3),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('- ', style: const pw.TextStyle(fontSize: 11)),
                        pw.Expanded(child: pw.Text(s, style: const pw.TextStyle(fontSize: 11))),
                      ],
                    ),
                  ),
                ),
              ],
              pw.SizedBox(height: 20),
            ],

            _buildPdfSectionTitle(l10n.apkReportSummary),
            pw.Text(report.summary, style: const pw.TextStyle(fontSize: 12, lineSpacing: 1.5)),
            pw.SizedBox(height: 20),

            if (report.permissions.isNotEmpty) ...[
              _buildPdfSectionTitle(l10n.apkExportRequestedPermissions),
              pw.Bullet(text: report.permissions.join('\n')),
              pw.SizedBox(height: 20),
            ],

            if (report.unusualItems.isNotEmpty) ...[
              _buildPdfSectionTitle(l10n.apkReportUnusualFlags),
              pw.Bullet(text: report.unusualItems.join('\n')),
              pw.SizedBox(height: 20),
            ],

            if (report.sources.isNotEmpty) ...[
              _buildPdfSectionTitle(l10n.apkExportDiscoveredSources),
              ...report.sources.entries.map((e) => _buildPdfRow(e.key, e.value)),
            ],
          ];
        },
      ),
    );

    final bytes = await pdf.save();
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/${report.name}_analysis.pdf');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: l10n.apkExportPdfShareText(report.name),
    );
  }

  static pw.Widget _buildPdfSectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blueGrey800,
        ),
      ),
    );
  }

  static pw.Widget _buildPdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 110,
            child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }
}