import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';

import 'apk_analyser_controller.dart';

class ApkExportService {

  static Future<void> exportToCsv(ApkReport report) async {
    List<List<dynamic>> rows = [
      ['VTTI Cloud - APK Analysis Report'],
      [],
      ['Overview'],
      ['App Name', report.name],
      ['Package ID', report.packageName],
      ['Version', report.versionLabel],
      ['File Size', report.fileSizeLabel],
      ['Min SDK', report.minSdkLabel],
      ['Target SDK', report.targetSdkLabel],
      ['Signature', report.signatureLabel],
      [],
      ['Malware Assessment'],
      ['Risk Score', report.riskScore ?? 'N/A'],
      ['Risk Label', report.riskLabel ?? 'N/A'],
      ['Hash Verdict', report.hashVerdict ?? 'N/A'],
      ['Score Rationale', report.scoreRationale ?? ''],
      [],
      ['Contributing Signals'],
      ...report.contributingSignals.map((s) => [s]),
      [],
      ['Dampening Factors'],
      ...report.dampeningFactors.map((s) => [s]),
      [],
      ['Summary'],
      [report.summary],
      [],
      ['Permissions Requested'],
      ...report.permissions.map((p) => [p]),
      [],
      ['Extra Flags (Unusual)'],
      ...report.unusualItems.map((u) => [u]),
      [],
      ['Extra Flags (Unverified)'],
      ...report.unverifiedItems.map((u) => [u]),
      [],
      ['Discovered Sources'],
      ...report.sources.entries.map((e) => [e.key, e.value]),
    ];

    String csvData = const ListToCsvConverter().convert(rows);

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/${report.name}_analysis.csv');
    await file.writeAsString(csvData);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'APK Analysis CSV for ${report.name}',
    );
  }

  static Future<void> exportToPdf(ApkReport report) async {
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
                'VTTI Cloud - APK Analysis',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 10),

            _buildPdfSectionTitle('Metadata'),
            _buildPdfRow('App Name', report.name),
            _buildPdfRow('Package ID', report.packageName),
            _buildPdfRow('Version', report.versionLabel),
            _buildPdfRow('Size', report.fileSizeLabel),
            _buildPdfRow('Min SDK', report.minSdkLabel),
            _buildPdfRow('Target SDK', report.targetSdkLabel),
            _buildPdfRow('Signature', report.signatureLabel),
            pw.SizedBox(height: 20),

            if (report.riskScore != null || report.riskLabel != null) ...[
              _buildPdfSectionTitle('Malware Assessment'),
              _buildPdfRow('Risk Score', '${report.riskScore ?? "N/A"} / 100'),
              _buildPdfRow('Risk Label', report.riskLabel ?? 'N/A'),
              _buildPdfRow('Hash Verdict', report.hashVerdict ?? 'N/A'),
              if (report.scoreRationale != null && report.scoreRationale!.isNotEmpty)
                _buildPdfRow('Rationale', report.scoreRationale!),
              pw.SizedBox(height: 10),
              if (report.contributingSignals.isNotEmpty) ...[
                pw.Text(
                  'Contributing Signals',
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
                  'Dampening Factors',
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

            _buildPdfSectionTitle('Summary'),
            pw.Text(report.summary, style: const pw.TextStyle(fontSize: 12, lineSpacing: 1.5)),
            pw.SizedBox(height: 20),

            if (report.permissions.isNotEmpty) ...[
              _buildPdfSectionTitle('Requested Permissions'),
              pw.Bullet(text: report.permissions.join('\n')),
              pw.SizedBox(height: 20),
            ],

            if (report.unusualItems.isNotEmpty) ...[
              _buildPdfSectionTitle('Unusual Flags'),
              pw.Bullet(text: report.unusualItems.join('\n')),
              pw.SizedBox(height: 20),
            ],

            if (report.sources.isNotEmpty) ...[
              _buildPdfSectionTitle('Discovered Sources'),
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
      text: 'APK Analysis PDF for ${report.name}',
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