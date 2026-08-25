import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import '../../../services/scan api/headless_scan.dart';
import '../../../services/scan api/scan_types.dart';
import '../../../widgets/antivirus_bridge.dart';

class ScanWorker {
  final ReceivePort _receive;
  final SendPort sendPort;
  final Isolate _iso;

  ScanWorker._(this._receive, this.sendPort, this._iso);

  static Future<ScanWorker> spawn() async {
    final receive = ReceivePort();
    final iso = await Isolate.spawn(_entry, receive.sendPort);
    final send = await receive.first as SendPort;
    return ScanWorker._(receive, send, iso);
  }

  static void _entry(SendPort root) {
    final port = ReceivePort();
    root.send(port.sendPort);
    AntivirusBridge? bridge;
    try {
      bridge = AntivirusBridge(enableScanLogs: false);
    } catch (_) {
      bridge = null;
    }
    var closing = false;
    var busy = false;

    void maybeExit() {
      if (!closing) return;
      if (busy) return;
      try {
        port.close();
      } catch (_) {}
      Isolate.exit();
    }

    port.listen((msg) async {
      if (msg is Map && msg['t'] == 'close') {
        closing = true;
        maybeExit();
        return;
      }
      if (msg is! List || msg.length < 2) return;
      final send = msg[0] as SendPort;
      final path = msg[1] as String;
      if (bridge == null) {
        send.send(false);
        return;
      }
      busy = true;
      try {
        final raw = bridge!.scanFile(path);
        final decoded = jsonDecode(raw);
        final hits = decoded['hits'] as Map?;
        if (hits == null || hits.isEmpty) {
          send.send(null);
          return;
        }
        final signals = <String>[];
        for (final v in hits.values) {
          if (v is List) {
            for (final s in v) {
              if (s is String) signals.add(s);
            }
          }
        }
        String label = 'Suspicious.Item';
        double confidence = 0.0;
        if (isHashSignal(signals)) {
          label = structuredHashLabel(path);
          confidence = 1.0;
        } else {
          final signature = signals.firstWhere(
                (s) =>
            !s.startsWith('ML_Detection(') &&
                s != 'HashMatch' &&
                !s.startsWith('SignerMatch('),
            orElse: () => '',
          );

          if (signature.isNotEmpty) {
            confidence = 0.95;
            label = structuredSignatureLabel(signature);
          } else if (isMlSignal(signals)) {
            label = 'Android.MUniverse.Gen';
            confidence = 0.80;
          } else {
            label = 'Suspicious.Item';
            confidence = 0.70;
          }
        }
        send.send({
          'label': label,
          'confidence': confidence,
          'signals': signals,
        });
      } catch (_) {
        send.send(false);
      } finally {
        busy = false;
        maybeExit();
      }
    });
  }

  Future<dynamic> scan(String path) async {
    final port = ReceivePort();
    sendPort.send([port.sendPort, path]);
    return await port.first;
  }

  void requestClose() {
    try {
      sendPort.send({'t': 'close'});
    } catch (_) {}
    try {
      _receive.close();
    } catch (_) {}
  }
}
