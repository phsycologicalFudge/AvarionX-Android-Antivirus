import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../translations/app_localizations.dart';
class SecurityReportScreen extends StatefulWidget {
  const SecurityReportScreen({super.key});

  @override
  State<SecurityReportScreen> createState() => _SecurityReportScreenState();
}

class _SecurityReportScreenState extends State<SecurityReportScreen> {
  late Future<_SecurityReportSnapshot> _future;
  Timer? _refreshTimer;
  bool _exportingPdf = false;
  bool _exportingCsv = false;

  @override
  void initState() {
    super.initState();
    _future = _SecurityReportSnapshot.load();

    _refreshTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      setState(() {
        _future = _SecurityReportSnapshot.load();
      });
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _SecurityReportSnapshot.load();
    });

    await _future;
  }

  Future<void> _exportPdf(_SecurityReportSnapshot data) async {
    if (_exportingPdf) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _exportingPdf = true);

    try {
      final report = data.reportText(l10n);
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Text(
              l10n.securityReportAvarionxSecurityReport,
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Text(report),
          ],
        ),
      );

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/avarionx_security_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );

      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)],
        text: l10n.securityReportSharePdfTitle,
      );
    } finally {
      if (mounted) {
        setState(() => _exportingPdf = false);
      }
    }
  }

  Future<void> _exportCsv(_SecurityReportSnapshot data) async {
    if (_exportingCsv) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _exportingCsv = true);

    try {
      final rows = [
        [l10n.securityReportCsvField, l10n.securityReportCsvValue],
        [l10n.securityReportGeneratedAt, data.generatedAtLabel],
        [l10n.securityReportOverallStatus, data.statusLabel(l10n)],
        [l10n.securityReportManualScans, data.manualScans],
        [l10n.securityReportRealtimeChecks, data.rtpScans],
        [l10n.securityReportTotalFilesScanned, data.filesScanned],
        [l10n.securityReportThreatsFound, data.threats],
        [l10n.securityReportLastManualScan, data.formatOptionalTime(data.lastManualScanAt, l10n)],
        [l10n.securityReportLastRealtimeEvent, data.formatOptionalTime(data.lastRtpEventAt, l10n)],
        [l10n.securityReportLastScheduledScan, data.formatOptionalTime(data.lastScheduledScanAt, l10n)],
      ];

      final csv = const ListToCsvConverter().convert(rows);
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/avarionx_security_report_${DateTime.now().millisecondsSinceEpoch}.csv',
      );

      await file.writeAsString(csv);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: l10n.securityReportShareCsvTitle,
      );
    } finally {
      if (mounted) {
        setState(() => _exportingCsv = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title:  Text(
          AppLocalizations.of(context)!.securityReportSecurityReport,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: FutureBuilder<_SecurityReportSnapshot>(
        future: _future,
        builder: (context, snapshot) {
          final data = snapshot.data ?? _SecurityReportSnapshot.empty();

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              children: [
                _ReportHeroCard(data: data),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _ReportMetricCard(
                        label: AppLocalizations.of(context)!.securityReportManualScans,
                        value: data.manualScans.toString(),
                        icon: Icons.manage_search_rounded,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ReportMetricCard(
                        label: AppLocalizations.of(context)!.securityReportRealtimeChecks,
                        value: data.rtpScans.toString(),
                        icon: Icons.visibility_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _ReportMetricCard(
                        label: AppLocalizations.of(context)!.securityReportTotalFilesScanned,
                        value: data.filesScanned.toString(),
                        icon: Icons.insert_drive_file_rounded,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ReportMetricCard(
                        label: AppLocalizations.of(context)!.securityReportThreatsFound,
                        value: data.threats.toString(),
                        icon: Icons.bug_report_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  AppLocalizations.of(context)!.securityReportGenerateReport,
                  style: text.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 10),
                _GeneratedReportCard(
                  data: data,
                  exportingPdf: _exportingPdf,
                  exportingCsv: _exportingCsv,
                  onExportPdf: () => _exportPdf(data),
                  onExportCsv: () => _exportCsv(data),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ReportHeroCard extends StatelessWidget {
  final _SecurityReportSnapshot data;

  const _ReportHeroCard({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;
    final hasThreats = data.threats > 0;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(
          theme.brightness == Brightness.dark ? 0.72 : 0.84,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              theme.brightness == Brightness.dark ? 0.16 : 0.06,
            ),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: (hasThreats ? Colors.orangeAccent : scheme.primary)
                    .withOpacity(0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                hasThreats
                    ? Icons.warning_amber_rounded
                    : Icons.verified_user_rounded,
                color: hasThreats ? Colors.orangeAccent : scheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.statusLabel(l10n),
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: scheme.onSurface.withOpacity(0.94),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    data.latestLabel(l10n),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(0.52),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ReportMetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 13),
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(
          theme.brightness == Brightness.dark ? 0.66 : 0.82,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              theme.brightness == Brightness.dark ? 0.12 : 0.045,
            ),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: scheme.primary.withOpacity(0.9),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: scheme.onSurface.withOpacity(0.94),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.bodySmall?.copyWith(
              height: 1.2,
              color: scheme.onSurface.withOpacity(0.52),
            ),
          ),
        ],
      ),
    );
  }
}

class _GeneratedReportCard extends StatelessWidget {
  final _SecurityReportSnapshot data;
  final bool exportingPdf;
  final bool exportingCsv;
  final VoidCallback onExportPdf;
  final VoidCallback onExportCsv;

  const _GeneratedReportCard({
    required this.data,
    required this.exportingPdf,
    required this.exportingCsv,
    required this.onExportPdf,
    required this.onExportCsv,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(
          theme.brightness == Brightness.dark ? 0.70 : 0.84,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              theme.brightness == Brightness.dark ? 0.14 : 0.055,
            ),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.securityReportLiveReport,
              style: text.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: scheme.onSurface.withOpacity(0.92),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.securityReportThisBoxUpdatesAsScanServicesWrite,
              style: text.bodySmall?.copyWith(
                height: 1.35,
                color: scheme.onSurface.withOpacity(0.52),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withOpacity(
                  theme.brightness == Brightness.dark ? 0.34 : 0.48,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                data.reportText(l10n),
                style: text.bodySmall?.copyWith(
                  height: 1.45,
                  color: scheme.onSurface.withOpacity(0.76),
                  fontFeatures: const [
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: exportingPdf ? null : onExportPdf,
                    icon: exportingPdf
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Icon(Icons.picture_as_pdf_rounded, size: 18),
                    label:  Text(AppLocalizations.of(context)!.securityReportExportPDF),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: exportingCsv ? null : onExportCsv,
                    icon: exportingCsv
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Icon(Icons.table_chart_rounded, size: 18),
                    label:  Text(AppLocalizations.of(context)!.securityReportExportCSV),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityReportSnapshot {
  final int manualScans;
  final int rtpScans;
  final int scheduledScans;
  final int filesScanned;
  final int threats;
  final int? lastManualScanAt;
  final int? lastRtpEventAt;
  final int? lastScheduledScanAt;
  final DateTime generatedAt;

  const _SecurityReportSnapshot({
    required this.manualScans,
    required this.rtpScans,
    required this.scheduledScans,
    required this.filesScanned,
    required this.threats,
    required this.lastManualScanAt,
    required this.lastRtpEventAt,
    required this.lastScheduledScanAt,
    required this.generatedAt,
  });

  _SecurityReportSnapshot.empty()
      : manualScans = 0,
        rtpScans = 0,
        scheduledScans = 0,
        filesScanned = 0,
        threats = 0,
        lastManualScanAt = null,
        lastRtpEventAt = null,
        lastScheduledScanAt = null,
        generatedAt = DateTime.fromMillisecondsSinceEpoch(0);

  static Future<_SecurityReportSnapshot> load() async {
    final prefs = await SharedPreferences.getInstance();

    return _SecurityReportSnapshot(
      manualScans: prefs.getInt('security_report_manual_scans_total') ?? 0,
      rtpScans: prefs.getInt('security_report_rtp_scans_total') ?? 0,
      scheduledScans: prefs.getInt('security_report_scheduled_scans_total') ?? 0,
      filesScanned: prefs.getInt('security_report_files_scanned_total') ?? 0,
      threats: prefs.getInt('security_report_threats_total') ?? 0,
      lastManualScanAt: prefs.getInt('security_report_last_manual_scan_at'),
      lastRtpEventAt: prefs.getInt('security_report_last_rtp_event_at'),
      lastScheduledScanAt: prefs.getInt('security_report_last_scheduled_scan_at'),
      generatedAt: DateTime.now(),
    );
  }

  String statusLabel(AppLocalizations l10n) {
    if (threats > 0) return l10n.securityReportReviewRecommended;
    return l10n.securityReportNoKnownThreatDetected;
  }

  String latestLabel(AppLocalizations l10n) {
    final latest = [
      lastManualScanAt,
      lastRtpEventAt,
      lastScheduledScanAt,
    ].whereType<int>().fold<int?>(null, (prev, value) {
      if (prev == null) return value;
      return value > prev ? value : prev;
    });

    if (latest == null) return l10n.securityNoReportDataYet;
    return l10n.securityLastActivity(_relativeTime(latest, l10n));
  }

  String get generatedAtLabel {
    final d = generatedAt;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  String reportText(AppLocalizations l10n) {
    return [
      l10n.securityReportAvarionxSecurityReport,
      l10n.securityReportGeneratedLine(generatedAtLabel),
      '',
      l10n.securityReportStatusLine(statusLabel(l10n)),
      l10n.securityReportLatestActivityLine(latestLabel(l10n)),
      '',
      l10n.securityReportManualScansLine(manualScans),
      l10n.securityReportRealtimeChecksLine(rtpScans),
      l10n.securityReportTotalFilesScannedLine(filesScanned),
      l10n.securityReportThreatsFoundLine(threats),
      '',
      l10n.securityReportLastManualScanLine(formatOptionalTime(lastManualScanAt, l10n)),
      l10n.securityReportLastRealtimeEventLine(formatOptionalTime(lastRtpEventAt, l10n)),
      l10n.securityReportLastScheduledScanLine(formatOptionalTime(lastScheduledScanAt, l10n)),
    ].join('\n');
  }

  String formatOptionalTime(int? millis, AppLocalizations l10n) {
    if (millis == null) return l10n.securityReportNotRecorded;

    final d = DateTime.fromMillisecondsSinceEpoch(millis);

    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  static String _relativeTime(int millis, AppLocalizations l10n) {
    final date = DateTime.fromMillisecondsSinceEpoch(millis);
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) return l10n.timeJustNow;
    if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.timeDaysAgo(diff.inDays);

    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}