import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import '../bckground/scan_worker.dart';

class ScheduledScanScheduler {
  static Future<void> enableFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final rtpOn = prefs.getBool('protectionEnabled') ?? false;
    if (!rtpOn) {
      await disable();
      return;
    }

    final enabled = prefs.getBool('scheduled_scan_enabled') ?? true;
    if (!enabled) {
      await disable();
      return;
    }

    final hours = prefs.getInt('scheduled_scan_hours') ?? 168;
    final pluggedOnly = prefs.getBool('scheduled_scan_plugged_only') ?? false;
    final useTime = prefs.getBool('scheduled_scan_use_time') ?? false;
    final timeH = prefs.getInt('scheduled_scan_time_h') ?? 9;
    final timeM = prefs.getInt('scheduled_scan_time_m') ?? 0;
    final mode = prefs.getString('scheduled_scan_mode') ?? 'smart';

    Duration? initialDelay;
    if (useTime) {
      final now = DateTime.now();
      var next = DateTime(now.year, now.month, now.day, timeH, timeM);
      if (!next.isAfter(now)) {
        next = next.add(const Duration(days: 1));
      }
      initialDelay = next.difference(now);
    }

    await Workmanager().registerPeriodicTask(
      scheduledScanTask,
      scheduledScanTask,
      frequency: Duration(hours: hours),
      initialDelay: initialDelay,
      inputData: {
        'mode': mode,
      },
      constraints: Constraints(
        requiresCharging: pluggedOnly,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }

  static Future<void> disable() async {
    await Workmanager().cancelByUniqueName(scheduledScanTask);
  }
}
