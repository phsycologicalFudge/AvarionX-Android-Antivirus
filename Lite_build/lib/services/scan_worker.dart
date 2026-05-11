import 'dart:isolate';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/antivirus_bridge.dart';

class ScanParams {
  final String dirPath;
  ScanParams(this.dirPath);
}

class ScanResult {
  final String path;
  final String result;
  ScanResult(this.path, this.result);
}

const String _engineBusyKey = 'engine_busy';

Future<void> _setEngineBusy(bool v) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_engineBusyKey, v);
}

void scanWorker(SendPort sendPort) async {
  final bridge = AntivirusBridge();
  final receive = ReceivePort();
  sendPort.send(receive.sendPort);

  await for (final message in receive) {
    if (message is ScanParams) {
      await _setEngineBusy(true);
      try {
        final dir = Directory(message.dirPath);
        if (dir.existsSync()) {
          for (final f in dir.listSync(recursive: false)) {
            if (f is File) {
              final res = bridge.scanFile(f.path);
              sendPort.send(ScanResult(f.path, res));
            }
          }
        }
      } finally {
        await _setEngineBusy(false);
      }

      sendPort.send('done');
    }
  }
}
