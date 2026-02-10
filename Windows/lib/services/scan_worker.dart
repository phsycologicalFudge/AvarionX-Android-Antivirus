import 'dart:isolate';
import '../core/antivirus_bridge.dart';

class ScanParams {
  final String path;
  ScanParams(this.path);
}

void scanWorker(SendPort sendPort) async {
  final bridge = AntivirusBridge();
  final receive = ReceivePort();
  sendPort.send(receive.sendPort);

  await for (final message in receive) {
    if (message is ScanParams) {
      try {
        final result = bridge.scanFile(message.path);
        sendPort.send(result);
      } catch (_) {
        sendPort.send(null);
      }
    }
  }
}
