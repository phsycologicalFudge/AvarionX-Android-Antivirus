import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DefsManager {
  static Future<String> ensureLiteDefinitions() async {
    final dir = await getApplicationDocumentsDirectory();
    final defsPath = '${dir.path}/defs.cs';

    if (!File(defsPath).existsSync()) {
      final liteData = await rootBundle.load('assets/defs/defs.cs');
      await File(defsPath).writeAsBytes(liteData.buffer.asUint8List());
    }

    return defsPath;
  }
}