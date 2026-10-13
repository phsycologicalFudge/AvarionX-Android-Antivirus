import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateService {
  static const String versionUrl =
      'https://github.com/phsycologicalfudge/AVDatabase/releases/latest/download/version.json';
  static const String defsUrl =
      'https://github.com/phsycologicalfudge/AVDatabase/releases/latest/download/defs.cs';

  static const String _lastServerCheckKey = 'defs_last_server_check_ms';

  static Future<Map<String, dynamic>?> checkServerVersion() async {
    try {
      final response = await http.get(
        Uri.parse(versionUrl),
        headers: {
          'User-Agent': 'ColourSwiftAV/1.0 (Flutter; Android)',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (_) {}
    return null;
  }

  static Future<String> getLocalVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('defs_version') ?? '0.0.0';
  }

  static Future<void> setLocalVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('defs_version', version);
  }

  static Future<bool> hasLocalDatabaseFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final defsFile = File('${dir.path}/defs.cs');
    return await defsFile.exists();
  }

  static Future<Map<String, String>> getLocalPaths() async {
    final dir = await getApplicationDocumentsDirectory();
    return {
      'defsPath': '${dir.path}/defs.cs',
    };
  }

  static Future<Map<String, dynamic>> ensureDatabaseReady({
    bool forceServerCheck = false,
    Duration minCheckInterval = const Duration(minutes: 30),
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final hasFiles = await hasLocalDatabaseFiles();
    final localVersion = await getLocalVersion();
    final now = DateTime.now().millisecondsSinceEpoch;
    final lastCheck = prefs.getInt(_lastServerCheckKey) ?? 0;

    final shouldCheckServer = forceServerCheck ||
        !hasFiles ||
        localVersion == '0.0.0' ||
        now - lastCheck >= minCheckInterval.inMilliseconds;

    if (!shouldCheckServer) {
      return {
        'checked': false,
        'downloaded': false,
        'hasFiles': hasFiles,
        'localVersion': localVersion,
        'remoteVersion': null,
      };
    }

    await prefs.setInt(_lastServerCheckKey, now);

    final remote = await checkServerVersion();
    final remoteVersion = (remote?['version'] ?? '0.0.0').toString();
    final needsDownload =
        !hasFiles || localVersion == '0.0.0' || localVersion != remoteVersion;

    if (!needsDownload) {
      return {
        'checked': true,
        'downloaded': false,
        'hasFiles': hasFiles,
        'localVersion': localVersion,
        'remoteVersion': remoteVersion,
      };
    }

    final ok = await downloadDatabase(
      onProgress: (_) {},
    );

    if (!ok) {
      return {
        'checked': true,
        'downloaded': false,
        'hasFiles': hasFiles,
        'localVersion': localVersion,
        'remoteVersion': remoteVersion,
      };
    }

    if (remoteVersion != '0.0.0') {
      await setLocalVersion(remoteVersion);
    }

    return {
      'checked': true,
      'downloaded': true,
      'hasFiles': true,
      'localVersion': remoteVersion != '0.0.0' ? remoteVersion : localVersion,
      'remoteVersion': remoteVersion,
    };
  }

  static Future<bool> downloadDatabase({
    required void Function(double) onProgress,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final defsPath = '${dir.path}/defs.cs';
      final client = http.Client();

      for (final entry in [
        {'url': defsUrl, 'path': defsPath},
      ]) {
        final uri = Uri.parse(
          '${entry['url']}?t=${DateTime.now().millisecondsSinceEpoch}',
        );
        final res = await client.get(uri);
        if (res.statusCode != 200) throw 'HTTP ${res.statusCode}';

        final bytes = res.bodyBytes;
        final file = File(entry['path']!);
        final sink = file.openWrite();
        final total = bytes.length;
        int written = 0;
        const chunkSize = 64 * 1024;

        while (written < total) {
          final end = (written + chunkSize).clamp(0, total);
          sink.add(bytes.sublist(written, end));
          written = end;
          onProgress(written / total);
          await Future.delayed(const Duration(milliseconds: 16));
        }

        await sink.close();
        onProgress(1.0);
      }

      client.close();
      return true;
    } catch (_) {
      return false;
    }
  }
}