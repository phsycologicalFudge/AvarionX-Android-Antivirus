import 'package:shared_preferences/shared_preferences.dart';
import '../screens/scan_ui_screen.dart';
import '../services/quarantine_service.dart';
import '../services/scan api/headless_scan.dart';

const String scheduledScanTask = 'scheduled_scan_task';

const String _kEngineBusy = 'engine_busy';
const String _kWorkerRunning = 'scheduled_scan_worker_running';
const String _kBusyUntilMs = 'engine_busy_until_ms';

Future<bool> runScheduledScanTask() async {
  final prefs = await SharedPreferences.getInstance();

  final rtpOn = prefs.getBool('protectionEnabled') ?? false;
  if (!rtpOn) return true;

  final enabled = prefs.getBool('scheduled_scan_enabled') ?? true;
  if (!enabled) return true;

  final running = prefs.getBool(_kWorkerRunning) ?? false;
  if (running) return true;

  await prefs.setBool(_kWorkerRunning, true);
  await prefs.reload();

  try {
    final intervalHours = prefs.getInt('scheduled_scan_hours') ?? 168;
    final lastRunMs = prefs.getInt('scheduled_scan_last_run_ms') ?? 0;

    final now = DateTime.now();
    final nowMs = now.millisecondsSinceEpoch;
    final intervalMs = intervalHours * 3600 * 1000;

    if (lastRunMs != 0 && (nowMs - lastRunMs) < intervalMs) {
      return true;
    }

    final useTime = prefs.getBool('scheduled_scan_use_time') ?? false;
    if (useTime) {
      final h = prefs.getInt('scheduled_scan_time_h') ?? 9;
      final m = prefs.getInt('scheduled_scan_time_m') ?? 0;

      final targetMin = (h * 60) + m;
      final nowMin = (now.hour * 60) + now.minute;

      var diff = (nowMin - targetMin).abs();
      if (diff > 720) diff = 1440 - diff;

      if (diff > 180) {
        return true;
      }
    }

    await prefs.setBool(_kEngineBusy, true);
    await prefs.setInt(_kBusyUntilMs, nowMs + (2 * 60 * 60 * 1000));
    await prefs.reload();

    try {
      final useCloud = prefs.getBool('useCloudScan') ?? false;

      final rawMode = (prefs.getString('scheduled_scan_mode') ?? 'smart').toLowerCase();
      final ScanMode mode = () {
        switch (rawMode) {
          case 'full':
            return ScanMode.full;
          case 'installed':
            return ScanMode.installed;
          case 'rapid':
            return ScanMode.rapid;
          case 'single':
            return ScanMode.single;
          default:
            return ScanMode.smart;
        }
      }();

      int quarantined = 0;
      int quarantineFailed = 0;

      await runHeadlessScan(
        mode: mode,
        useCloud: useCloud,
        quarantine: false,
        token: null,
        isCancelled: () => false,
        onEvent: (e) async {
          if (e.type == 'hit') {
            final path = e.path;
            if (path == null || path.isEmpty) return;
            try {
              await QuarantineService.quarantineFile(path);
              quarantined++;
            } catch (_) {
              quarantineFailed++;
            }
          }
        },
      );

      await prefs.setInt('scheduled_scan_last_run_ms', nowMs);
      await prefs.setInt('scheduled_scan_last_quarantined', quarantined);
      await prefs.setInt('scheduled_scan_last_quarantine_failed', quarantineFailed);
      await prefs.reload();

      return true;
    } finally {
      await prefs.setBool(_kEngineBusy, false);
      await prefs.setInt(_kBusyUntilMs, 0);
      await prefs.reload();
    }
  } finally {
    await prefs.setBool(_kWorkerRunning, false);
    await prefs.reload();
  }
}
