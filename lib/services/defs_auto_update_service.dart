import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'update_service.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/antivirus_bridge.dart';

class DefsAutoUpdateService {
  static const _enabledKey = 'defs_auto_update_enabled';
  static const _lastCheckKey = 'defs_last_update_check';

  static const Duration checkInterval = Duration(hours: 24);

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? false;
  }

  static Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);
  }

  static Future<void> maybeRun() async {
    final prefs = await SharedPreferences.getInstance();

    final enabled = prefs.getBool(_enabledKey) ?? false;
    if (!enabled) {
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final lastCheck = prefs.getInt(_lastCheckKey) ?? 0;

    if (now - lastCheck < checkInterval.inMilliseconds) {
      return;
    }

    await prefs.setInt(_lastCheckKey, now);

    final server = await UpdateService.checkServerVersion();
    if (server == null) {
      debugPrint('[DefsUpdate] Server version check failed');
      return;
    }

    final serverVersion = server['version']?.toString();
    if (serverVersion == null || serverVersion.isEmpty) {
      debugPrint('[DefsUpdate] Server version missing/invalid');
      return;
    }

    final localVersion = await UpdateService.getLocalVersion();

    debugPrint('[DefsUpdate] Auto-check: local=$localVersion server=$serverVersion');

    if (_isNewer(serverVersion, localVersion)) {
      debugPrint('[DefsUpdate] Update available, downloading...');

      final ok = await UpdateService.downloadDatabase(
        onProgress: (_) {},
      );

      if (!ok) {
        debugPrint('[DefsUpdate] Download failed');
        return;
      }

      await UpdateService.setLocalVersion(serverVersion);

      final dir = await getApplicationDocumentsDirectory();
      final defsPath = '${dir.path}/defs.vxpack';
      final keyPath = '${dir.path}/defs_key.bin';

      try {
        final rc = AntivirusBridge().reload(defsPath, keyPath);
        debugPrint('[DefsUpdate] Engine reload rc=$rc');
      } catch (e) {
        debugPrint('[DefsUpdate] Engine reload failed: $e');
      }

      try {
        AntivirusBridge().initNetIoc(defsPath);
      } catch (_) {}

      debugPrint(
        '[DefsUpdate] Database updated to v$serverVersion at ${DateTime.now().toIso8601String()}',
      );
    } else {
      debugPrint('[DefsUpdate] No update needed');
    }
  }

  static bool _isNewer(String a, String b) {
    List<int> pa(String v) =>
        v.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final av = pa(a);
    final bv = pa(b);

    for (int i = 0; i < 3; i++) {
      if (av[i] > bv[i]) return true;
      if (av[i] < bv[i]) return false;
    }
    return false;
  }
}
