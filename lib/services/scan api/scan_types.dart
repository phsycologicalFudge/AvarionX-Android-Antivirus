enum ScanMode { none, smart, single, rapid, installed, full }

enum ScanState { idle, scanning, result, empty }

class DetectionResult {
  final String name;
  final String label;
  final double confidence;
  final List<String> signals;
  final String? path;
  final String? quarantinePath;
  final int? apkSize;

  DetectionResult({
    required this.name,
    required this.label,
    required this.confidence,
    required this.signals,
    this.path,
    this.quarantinePath,
    this.apkSize,
  });
}

DetectionResult detectionFromRes({
  required String name,
  required dynamic res,
}) {
  if (res == null || res is! Map) {
    return DetectionResult(
      name: name,
      label: 'Suspicious.Item',
      confidence: 0.0,
      signals: const [],
    );
  }
  final map = Map<String, dynamic>.from(res);
  return DetectionResult(
    name: name,
    label: map['label']?.toString() ?? 'Suspicious.Item',
    confidence: map['confidence'] is num ? (map['confidence'] as num).toDouble() : 0.0,
    signals: List<String>.from(map['signals'] ?? const <String>[]),
  );
}

bool isApkPath(String path) => path.toLowerCase().endsWith('.apk');

bool isHashSignal(List<String> signals) {
  return signals.contains('HashMatch') ||
      signals.any((s) => s.startsWith('SignerMatch('));
}

bool isMlSignal(List<String> signals) {
  return signals.any((s) => s.startsWith('ML_Detection('));
}

String structuredHashLabel(String path) {
  if (isApkPath(path)) return 'Android.KnownMalware.HashMatch';
  return 'Generic.KnownMalware.HashMatch';
}

String structuredSignatureLabel(String raw) {
  return parseSigName(raw);
}

bool isAllowedScanFile(String ext, int size) {
  const allowed = {
    'apk', 'zip', 'pdf', 'md', 'exe', 'js', 'dex', 'html', 'jar',
  };
  if (!allowed.contains(ext)) return false;
  if (size > 100 * 1024 * 1024) return false;
  return true;
}

const _redundantPlatformTokens = {'android'};

List<String> _dropRedundantPlatform(List<String> parts) {
  if (parts.isNotEmpty && _redundantPlatformTokens.contains(parts.first.toLowerCase())) {
    return parts.sublist(1);
  }
  return parts;
}

String parseSigName(String raw) {
  if (raw.isEmpty) return 'Suspicious.Item';

  final parts = raw.split('.');
  const noise = {'androidos', 'and', 'byte', 'simple', 'complex'};

  if (parts.length >= 3 &&
      parts[0].toLowerCase() == 'androidos' &&
      parts[2].toLowerCase() == 'origin') {
    return 'Andr/${parts[1]}.Origin';
  }

  if (parts.length >= 4 && parts[2].toLowerCase() == 'androidos') {
    final keep = <String>[];
    for (final p in parts) {
      final lo = p.toLowerCase();
      if (noise.contains(lo)) continue;
      if (RegExp(r'^\d+$').hasMatch(p)) continue;
      keep.add(p);
    }
    final trimmed = _dropRedundantPlatform(keep);
    return trimmed.isNotEmpty ? trimmed.join('.') : raw;
  }

  if (parts.length >= 3 && parts[2].toLowerCase() == 'byte') {
    final platform = parts[0];
    final categoryRaw = parts[1];
    final categoryParts = categoryRaw.split('_');
    final keep = _dropRedundantPlatform(<String>[platform, ...categoryParts]);
    return keep.isNotEmpty ? keep.join('.') : raw;
  }

  final keep = <String>[];
  for (final p in parts) {
    final lo = p.toLowerCase();
    if (noise.contains(lo)) continue;
    if (RegExp(r'^\d+$').hasMatch(p)) continue;
    keep.add(p);
  }
  final trimmed = _dropRedundantPlatform(keep);
  return trimmed.isNotEmpty ? trimmed.join('.') : raw;
}