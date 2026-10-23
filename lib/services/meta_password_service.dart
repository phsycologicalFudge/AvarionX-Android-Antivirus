import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MetaPasswordService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      sharedPreferencesName: 'cs_meta_store',
      preferencesKeyPrefix: 'cs_meta_',
    ),
  );
  static const _legacy = FlutterSecureStorage();
  static const _key = 'meta_password';

  static Future<String?> getMeta() async {
    try {
      final current = await _storage.read(key: _key);
      if (current != null && current.isNotEmpty) return current;
    } catch (_) {}
    try {
      final old = await _legacy.read(key: _key);
      if (old != null && old.isNotEmpty) {
        await _storage.write(key: _key, value: old);
        return old;
      }
    } catch (_) {}
    return null;
  }

  static Future<void> setMeta(String value) {
    return _storage.write(key: _key, value: value);
  }

  static Future<void> clearMeta() async {
    await _storage.delete(key: _key);
    try {
      await _legacy.delete(key: _key);
    } catch (_) {}
  }
}