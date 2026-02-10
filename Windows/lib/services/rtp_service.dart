import 'dart:io';

class RtpService {
  static Process? _proc;
  static bool _running = false;

  static bool get isRunning => _running;

  static Future<bool> refreshRunning() async {
    if (!Platform.isWindows) {
      _running = _proc != null;
      return _running;
    }

    try {
      final r = await Process.run(
        'tasklist',
        ['/FI', 'IMAGENAME eq rtpModule.exe', '/FO', 'CSV', '/NH'],
        runInShell: false,
      );
      final out = (r.stdout ?? '').toString().trim();
      if (out.isEmpty) {
        _running = false;
        return _running;
      }
      if (out.startsWith('INFO:')) {
        _running = false;
        return _running;
      }
      _running = out.toLowerCase().contains('rtpmodule.exe');
      return _running;
    } catch (_) {
      _running = _proc != null;
      return _running;
    }
  }

  static Future<void> start() async {
    if (await refreshRunning()) return;

    final exeDir = File(Platform.resolvedExecutable).parent.path;
    final rtpPath = _join(exeDir, 'rtpModule.exe');

    if (!File(rtpPath).existsSync()) {
      throw Exception('rtpModule.exe not found at $rtpPath');
    }

    _proc = await Process.start(
      rtpPath,
      const [],
      runInShell: false,
      workingDirectory: exeDir,
    );

    _proc!.exitCode.then((_) {
      _proc = null;
      _running = false;
    });

    await Future.delayed(const Duration(milliseconds: 200));
    await refreshRunning();
  }

  static Future<void> stop() async {
    if (!Platform.isWindows) {
      final p = _proc;
      if (p != null) {
        try {
          p.kill();
        } catch (_) {}
      }
      _proc = null;
      _running = false;
      return;
    }

    try {
      await Process.run(
        'taskkill',
        ['/IM', 'rtpModule.exe', '/F', '/T'],
        runInShell: false,
      );
    } catch (_) {}

    _proc = null;
    await Future.delayed(const Duration(milliseconds: 200));
    await refreshRunning();
  }

  static String _join(String a, String b) {
    final sep = Platform.pathSeparator;
    if (a.endsWith(sep)) return '$a$b';
    return '$a$sep$b';
  }
}
