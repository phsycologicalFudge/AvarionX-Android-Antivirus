import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ExclusionService {
  static const _key = 'cs_exclusions_v1';

  List<String> folders = [];
  List<String> shas = [];
  DateTime? _loadedAt;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.reload();
    } catch (_) {}
    _loadedAt = DateTime.now();
    final raw = prefs.getString(_key);

    if (raw == null || raw.isEmpty) {
      folders = [];
      shas = [];
      return;
    }

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final f = decoded['folders'] as List<dynamic>? ?? [];
      final s = decoded['shas'] as List<dynamic>? ?? [];

      folders = f.map((e) => e.toString()).toList();
      shas = s.map((e) => e.toString()).toList();
    } catch (_) {
      folders = [];
      shas = [];
    }
  }

  Future<void> refreshIfStale([Duration maxAge = const Duration(seconds: 3)]) async {
    final t = _loadedAt;
    if (t != null && DateTime.now().difference(t) < maxAge) return;
    await load();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = <String, dynamic>{
      'folders': folders,
      'shas': shas,
    };
    await prefs.setString(_key, jsonEncode(data));
  }

  Future<void> addFolder(String path) async {
    if (!folders.contains(path)) {
      folders.add(path);
      await save();
    }
  }

  Future<void> addSha(String sha) async {
    if (!shas.contains(sha)) {
      shas.add(sha);
      await save();
    }
  }

  static final _slashes = RegExp(r'/{2,}');

  bool skipFolder(String filePath) {
    final path = filePath.replaceAll(_slashes, '/');
    for (final f in folders) {
      var base = f.replaceAll(_slashes, '/');
      if (base.endsWith('/')) base = base.substring(0, base.length - 1);
      if (base.isEmpty) continue;
      if (path == base || path.startsWith('$base/')) return true;
    }
    return false;
  }

  bool skipSha(String sha) {
    return shas.contains(sha);
  }
}
