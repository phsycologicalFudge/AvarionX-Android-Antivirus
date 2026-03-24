import 'package:flutter/foundation.dart';

class ScanSessionService extends ChangeNotifier {
  ScanSessionService._();
  static final ScanSessionService instance = ScanSessionService._();

  bool isScanning = false;
  bool cancelling = false;

  String modeName = 'none';
  String stateName = 'idle';

  int scanned = 0;
  int total = 0;
  int fullCleanCount = 0;
  String currentFile = '';
  bool? singleResult;

  List<String> clean = <String>[];
  List<Map<String, dynamic>> infected = <Map<String, dynamic>>[];

  void start({
    required String modeName,
  }) {
    isScanning = true;
    cancelling = false;
    this.modeName = modeName;
    stateName = 'scanning';
    scanned = 0;
    total = 0;
    fullCleanCount = 0;
    currentFile = '';
    singleResult = null;
    clean = <String>[];
    infected = <Map<String, dynamic>>[];
    notifyListeners();
  }

  void update({
    String? modeName,
    String? stateName,
    int? scanned,
    int? total,
    int? fullCleanCount,
    String? currentFile,
    List<String>? clean,
    List<Map<String, dynamic>>? infected,
    bool? singleResult,
    bool? isScanning,
    bool? cancelling,
  }) {
    if (modeName != null) this.modeName = modeName;
    if (stateName != null) this.stateName = stateName;
    if (scanned != null) this.scanned = scanned;
    if (total != null) this.total = total;
    if (fullCleanCount != null) this.fullCleanCount = fullCleanCount;
    if (currentFile != null) this.currentFile = currentFile;
    if (clean != null) this.clean = List<String>.from(clean);
    if (infected != null) {
      this.infected = infected
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    if (singleResult != null) this.singleResult = singleResult;
    if (isScanning != null) this.isScanning = isScanning;
    if (cancelling != null) this.cancelling = cancelling;
    notifyListeners();
  }

  void clear() {
    isScanning = false;
    cancelling = false;
    modeName = 'none';
    stateName = 'idle';
    scanned = 0;
    total = 0;
    fullCleanCount = 0;
    currentFile = '';
    singleResult = null;
    clean = <String>[];
    infected = <Map<String, dynamic>>[];
    notifyListeners();
  }
}