import 'dart:async';
import 'dart:convert';
import 'dart:io';

sealed class ScanEvent {
  const ScanEvent();
}

class ScanProgress extends ScanEvent {
  final int scanned;
  final int total;
  const ScanProgress({required this.scanned, required this.total});
}

class ScanLog extends ScanEvent {
  final String message;
  const ScanLog(this.message);
}

class ScanCompleted extends ScanEvent {
  final Map<String, dynamic>? result;
  const ScanCompleted(this.result);
}

class ScanFailed extends ScanEvent {
  final String message;
  const ScanFailed(this.message);
}

class HeadlessScanSession {
  final Stream<ScanEvent> events;
  final Future<Map<String, dynamic>?> result;
  final void Function() cancel;

  const HeadlessScanSession({
    required this.events,
    required this.result,
    required this.cancel,
  });
}

class HeadlessScanner {
  static Future<HeadlessScanSession> start(String targetPath) async {
    final events = StreamController<ScanEvent>.broadcast();
    final done = Completer<Map<String, dynamic>?>();
    final appDir = File(Platform.resolvedExecutable).parent;

    final exePath = _join(appDir.path, 'csav.exe');

    final defsDir = _join(appDir.path, 'assets', 'defs');
    final defsVxpack = _join(defsDir, 'defs.vxpack');
    final defsKey = _join(defsDir, 'defs_key.bin');

    String defsPath;
    if (File(defsVxpack).existsSync()) {
      defsPath = defsVxpack;
    } else {
      defsPath = defsDir;
    }

    if (!File(exePath).existsSync()) {
      events.add(ScanFailed('csav.exe not found: $exePath'));
      await events.close();
      done.complete(null);
      return HeadlessScanSession(events: events.stream, result: done.future, cancel: () {});
    }

    if (targetPath.isEmpty) {
      events.add(const ScanFailed('Invalid target'));
      await events.close();
      done.complete(null);
      return HeadlessScanSession(events: events.stream, result: done.future, cancel: () {});
    }

    if (!Directory(defsDir).existsSync()) {
      events.add(ScanFailed('defs folder not found: $defsDir'));
      await events.close();
      done.complete(null);
      return HeadlessScanSession(events: events.stream, result: done.future, cancel: () {});
    }

    if (!File(defsKey).existsSync()) {
      events.add(ScanFailed('defs_key.bin not found: $defsKey'));
      await events.close();
      done.complete(null);
      return HeadlessScanSession(events: events.stream, result: done.future, cancel: () {});
    }

    Process? proc;
    var cancelled = false;
    var finished = false;

    StreamSubscription? outSub;
    StreamSubscription? errSub;

    final rawLines = <String>[];
    final jsonCandidates = <Map<String, dynamic>>[];

    var scannedByLog = 0;
    var totalHint = 0;

    void emitProgress() {
      if (events.isClosed) return;
      events.add(ScanProgress(scanned: scannedByLog, total: totalHint));
    }

    Future<void> computeTotalHint() async {
      try {
        if (FileSystemEntity.isDirectorySync(targetPath)) {
          var count = 0;
          await for (final ent in Directory(targetPath).list(recursive: true, followLinks: false)) {
            if (ent is File) count++;
          }
          totalHint = count;
          emitProgress();
          return;
        }

        if (FileSystemEntity.isFileSync(targetPath)) {
          totalHint = 1;
          emitProgress();
        }
      } catch (_) {}
    }

    bool isNoiseLine(String s) {
      final t = s.trimLeft();
      if (t.isEmpty) return true;
      if (t.startsWith('HASH CHECK ')) return true;
      if (t.startsWith('HASH BLOOM ')) return true;
      if (t.startsWith('HASH HIT:')) return true;
      if (t.startsWith('HASH CHECK RESULT:')) return true;
      if (t.startsWith('[REP]')) return true;
      if (t.startsWith('[REP][')) return true;
      if (t.startsWith('IOC SELFTEST')) return true;
      if (t.startsWith('Bloom ')) return true;
      if (t.startsWith('Reputation bloom')) return true;
      if (t.startsWith('YARA: loaded')) return true;
      if (t.startsWith('YARA-LITE:')) return true;
      if (t.startsWith('VX_BYTES matched:')) return true;
      if (t.startsWith('ColourSwiftAV: Loaded')) return true;
      if (t.startsWith('ML: Model')) return true;
      if (t.startsWith('allocator purged')) return true;
      if (t.startsWith('[ML DEBUG]')) return true;
      return false;
    }

    void maybeEmitNiceLog(String s) {
      final t = s.trimRight();
      if (t.isEmpty) return;
      if (isNoiseLine(t)) return;

      if (t.startsWith('Scanning file: ')) {
        events.add(ScanLog(t));
        return;
      }

      if (t.startsWith('Scanning ')) {
        events.add(ScanLog(t));
        return;
      }

      if (t.startsWith('Failed to open ')) {
        events.add(ScanLog(t));
        return;
      }

      if (t.startsWith('Read error for ')) {
        events.add(ScanLog(t));
        return;
      }

      if (t.startsWith('No data read for ')) {
        events.add(ScanLog(t));
        return;
      }

      if (t.startsWith('ML: probability = ')) {
        events.add(ScanLog(t));
        return;
      }
    }

    void handleLine(String line) {
      final s = line.trimRight();
      if (s.isEmpty) return;

      rawLines.add(s);

      if (s.startsWith('{')) {
        try {
          final j = jsonDecode(s);
          if (j is Map) {
            final m = Map<String, dynamic>.from(j);
            final ev = m['event'];

            if (ev == 'dir_progress') {
              final scanned = (m['scanned'] as num?)?.toInt() ?? 0;
              final total = (m['total'] as num?)?.toInt() ?? 0;

              if (scanned > scannedByLog) scannedByLog = scanned;
              if (total > totalHint) totalHint = total;

              emitProgress();
              return;
            }

            if (ev == 'scan') {
              return;
            }

            jsonCandidates.add(m);
            return;
          }
        } catch (_) {}
      }

      if (s.startsWith('Scanning file: ')) {
        scannedByLog += 1;
        emitProgress();
      }

      maybeEmitNiceLog(s);
    }

    Map<String, dynamic>? pickFinalJson() {
      for (var i = jsonCandidates.length - 1; i >= 0; i--) {
        final m = jsonCandidates[i];
        if (m.containsKey('hits') && m.containsKey('scanned')) {
          return m;
        }
      }

      for (var i = rawLines.length - 1; i >= 0; i--) {
        final s = rawLines[i].trim();
        if (!s.startsWith('{')) continue;
        try {
          final j = jsonDecode(s);
          if (j is Map) {
            final m = Map<String, dynamic>.from(j);
            if (m.containsKey('hits') && m.containsKey('scanned')) {
              return m;
            }
          }
        } catch (_) {}
      }

      return null;
    }

    Future<void> finishOk(Map<String, dynamic>? r) async {
      if (finished) return;
      finished = true;
      if (!done.isCompleted) done.complete(r);
      if (!events.isClosed) events.add(ScanCompleted(r));
      try {
        await outSub?.cancel();
      } catch (_) {}
      try {
        await errSub?.cancel();
      } catch (_) {}
      try {
        await events.close();
      } catch (_) {}
    }

    Future<void> finishFail(String m) async {
      if (finished) return;
      finished = true;
      if (!done.isCompleted) done.complete(null);
      if (!events.isClosed) events.add(ScanFailed(m));
      try {
        await outSub?.cancel();
      } catch (_) {}
      try {
        await errSub?.cancel();
      } catch (_) {}
      try {
        await events.close();
      } catch (_) {}
    }

    void cancel() {
      if (cancelled) return;
      cancelled = true;
      try {
        proc?.kill(ProcessSignal.sigkill);
      } catch (_) {}
      if (!done.isCompleted) done.complete(null);
      if (!events.isClosed) {
        events.add(const ScanFailed('Cancelled'));
        events.close();
      }
    }

    Future<void>(() async {
      try {
        events.add(ScanLog('Starting scan...'));
        unawaited(computeTotalHint());

        proc = await Process.start(
          exePath,
          [defsPath, targetPath, '--key', defsKey],
          workingDirectory: appDir.path,
          runInShell: false,
        );

        outSub = proc!.stdout
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen((line) {
          if (cancelled) return;
          handleLine(line);
        });

        errSub = proc!.stderr
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen((line) {
          if (cancelled) return;
          handleLine(line);
        });

        final code = await proc!.exitCode;

        if (cancelled) {
          await finishFail('Cancelled');
          return;
        }

        final finalJson = pickFinalJson();

        if (code != 0) {
          final tail = rawLines.isEmpty
              ? ''
              : rawLines.skip(rawLines.length > 14 ? rawLines.length - 14 : 0).join('\n');
          await finishFail('csav.exe failed ($code)\n$tail');
          return;
        }

        if (finalJson != null) {
          await finishOk(finalJson);
          return;
        }

        final joined = rawLines.join('\n').trim();
        if (joined.isEmpty) {
          await finishFail('No output from csav.exe');
          return;
        }

        await finishOk({'raw': joined});
      } catch (e) {
        if (cancelled) {
          await finishFail('Cancelled');
        } else {
          await finishFail(e.toString());
        }
      }
    });

    return HeadlessScanSession(
      events: events.stream,
      result: done.future,
      cancel: cancel,
    );
  }

  static String _join(String a, [String? b, String? c, String? d]) {
    final sep = Platform.pathSeparator;
    var out = a;
    void add(String s) {
      if (s.isEmpty) return;
      if (out.endsWith(sep)) {
        out = out + s;
      } else {
        out = out + sep + s;
      }
    }
    if (b != null) add(b);
    if (c != null) add(c);
    if (d != null) add(d);
    return out;
  }
}
