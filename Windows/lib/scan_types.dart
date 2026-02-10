enum ScanMode { smart, single, custom, pc }
enum ScanState { idle, scanning, result }

class DetectionResult {
  final String name;
  final String label;
  final double confidence;
  final List<String> signals;

  DetectionResult({
    required this.name,
    required this.label,
    required this.confidence,
    required this.signals,
  });
}
