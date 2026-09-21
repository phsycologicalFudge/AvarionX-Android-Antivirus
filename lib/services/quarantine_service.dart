import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class QuarantineService {
  static final _storage = const FlutterSecureStorage();
  static final _algo = AesGcm.with256bits();
  static SecretKey? _key;
  static Directory? _qDir;
  static Future<void>? _migration;

  static const _magic = [0x51, 0x53, 0x56, 0x31];
  static const _ext = 'vqsafe';
  static const _metaExt = 'qmeta';

  static Future<void> init() async {
    _qDir ??= await _ensureQuarantineDir();
    await (_migration ??= _runLegacyMigration());
  }

  static Future<Directory> _ensureQuarantineDir() async {
    final base = await getApplicationSupportDirectory();
    final d = Directory(p.join(base.path, 'quarantine'));
    if (!await d.exists()) {
      await d.create(recursive: true);
    }
    return d;
  }

  static Future<void> _runLegacyMigration() async {
    final marker = File(p.join(_qDir!.path, '.hive_migrated'));
    if (await marker.exists()) return;
    try {
      if (!Hive.isBoxOpen('quarantine')) {
        await Hive.initFlutter();
      }
      final box = Hive.isBoxOpen('quarantine')
          ? Hive.box('quarantine')
          : await Hive.openBox('quarantine');
      for (final k in box.keys.toList()) {
        final raw = box.get(k);
        if (raw is! Map) continue;
        final meta = Map<String, dynamic>.from(raw);
        meta.remove('iconBytes');
        final id = meta['id'];
        if (id is! String || id.isEmpty) continue;
        if (await _metaFile(id).exists()) continue;
        try {
          await _writeMeta(meta);
        } catch (_) {}
      }
      await box.close();
      await marker.create();
    } catch (_) {}
  }

  static File _metaFile(String id) => File(p.join(_qDir!.path, '$id.$_metaExt'));

  static Future<void> _writeMeta(Map<String, dynamic> meta) async {
    final id = meta['id'] as String;
    final target = _metaFile(id);
    final tmp = File('${target.path}.tmp');
    await tmp.writeAsString(jsonEncode(meta), flush: true);
    await tmp.rename(target.path);
  }

  static Future<Map<String, dynamic>?> _getMeta(String id) async {
    final f = _metaFile(id);
    if (!await f.exists()) return null;
    try {
      final d = jsonDecode(await f.readAsString());
      if (d is Map) return Map<String, dynamic>.from(d);
    } catch (_) {}
    return null;
  }

  static Future<void> _deleteMeta(String id) async {
    try {
      final f = _metaFile(id);
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }

  static String _id() {
    final r = Random.secure();
    final a = r.nextInt(1 << 32);
    final b = r.nextInt(1 << 32);
    final c = DateTime.now().millisecondsSinceEpoch;
    return '${c.toRadixString(16)}_${a.toRadixString(16)}_${b.toRadixString(16)}';
  }

  static Future<SecretKey> _loadOrCreateKey() async {
    final k = await _storage.read(key: 'qs_aes256_key');
    if (k != null) {
      final raw = base64Decode(k);
      return SecretKey(raw);
    }
    final sk = await _algo.newSecretKey();
    final raw = await sk.extractBytes();
    await _storage.write(key: 'qs_aes256_key', value: base64Encode(raw));
    return SecretKey(raw);
  }

  static Future<List<int>> getRawKey() async {
    await init();
    _key ??= await _loadOrCreateKey();
    return await _key!.extractBytes();
  }

  static bool canQuarantinePath(String srcPath) {
    final normalized = srcPath.replaceAll('\\', '/').toLowerCase();
    final name = p.basename(normalized);

    if (name == 'base.apk' || name == 'base.apks') {
      return false;
    }

    if (normalized.contains('/data/app/') ||
        normalized.contains('/data/app-private/')) {
      return false;
    }

    return true;
  }

  static Future<Map<String, dynamic>> quarantineFile(String srcPath) async {
    await init();

    if (!canQuarantinePath(srcPath)) {
      throw Exception('Installed package files cannot be quarantined');
    }

    final f = File(srcPath);
    if (!await f.exists()) {
      throw Exception('Source not found');
    }

    final data = await f.readAsBytes();

    final id = _id();
    final qName = '$id.$_ext';
    final qPath = p.join(_qDir!.path, qName);

    final tmpPath = '$qPath.tmp';
    final out = BytesBuilder();
    out.add(_magic);
    out.add(data);

    await File(tmpPath).writeAsBytes(out.toBytes(), flush: true);
    await File(tmpPath).rename(qPath);

    final meta = <String, dynamic>{
      'id': id,
      'qPath': qPath,
      'name': p.basename(srcPath),
      'originalPath': srcPath,
      'size': data.length,
      'date': DateTime.now().toIso8601String(),
      'fmt': 1,
    };

    await _writeMeta(meta);

    try {
      await f.delete();
      if (await f.exists()) {
        try {
          await f.delete(recursive: true);
        } catch (_) {}
        if (await f.exists()) {
          meta['deleteFailed'] = true;
        }
      }
    } catch (_) {
      meta['deleteFailed'] = true;
    }

    if (meta['deleteFailed'] == true) {
      await _writeMeta(meta);
    }

    return meta;
  }

  static bool _startsWithMagic(Uint8List bytes) {
    if (bytes.length < 4) return false;
    return bytes[0] == _magic[0] &&
        bytes[1] == _magic[1] &&
        bytes[2] == _magic[2] &&
        bytes[3] == _magic[3];
  }

  static Future<Uint8List> _readPlainOrDecryptLegacy(Uint8List all) async {
    if (_startsWithMagic(all)) {
      return Uint8List.fromList(all.sublist(4));
    }

    if (all.length < 12 + 16) {
      throw Exception('Corrupt package');
    }

    _key ??= await _loadOrCreateKey();

    final nonce = all.sublist(0, 12);
    final mac = Mac(all.sublist(all.length - 16));
    final cipher = all.sublist(12, all.length - 16);
    final plain = await _algo.decrypt(
      SecretBox(cipher, nonce: nonce, mac: mac),
      secretKey: _key!,
    );
    return Uint8List.fromList(plain);
  }

  static Future<Uint8List> readQuarantinedBytes(String qPath) async {
    await init();
    final file = File(qPath);
    if (!await file.exists()) {
      throw Exception('Quarantine file missing');
    }
    final all = await file.readAsBytes();
    return _readPlainOrDecryptLegacy(Uint8List.fromList(all));
  }

  static Future<void> restore(String id) async {
    await init();

    final meta = await _getMeta(id);
    if (meta == null) {
      await _deleteMeta(id);
      throw Exception('Quarantine entry missing');
    }

    final qPath = meta['qPath'];
    final orig = meta['originalPath'];

    if (qPath is! String || orig is! String || qPath.isEmpty || orig.isEmpty) {
      await _deleteMeta(id);
      throw Exception('Quarantine entry invalid');
    }

    final qFile = File(qPath);
    if (!await qFile.exists()) {
      await _deleteMeta(id);
      throw Exception('Quarantine file missing');
    }

    final all = await qFile.readAsBytes();
    final plain = await _readPlainOrDecryptLegacy(Uint8List.fromList(all));

    final parent = Directory(p.dirname(orig));
    if (!await parent.exists()) {
      await parent.create(recursive: true);
    }

    var outPath = orig;
    if (await File(outPath).exists()) {
      final dir = p.dirname(orig);
      final base = p.basenameWithoutExtension(orig);
      final ext = p.extension(orig);
      outPath = p.join(dir, '${base}_restored$ext');
    }

    final tmpOut = '$outPath.tmp';
    await File(tmpOut).writeAsBytes(plain, flush: true);
    await File(tmpOut).rename(outPath);

    try {
      await qFile.delete();
    } catch (_) {}

    await _deleteMeta(id);
  }

  static Future<void> deleteForever(String id) async {
    await init();
    final meta = await _getMeta(id);
    if (meta != null) {
      final qPath = meta['qPath'];
      if (qPath is String && qPath.isNotEmpty) {
        final qFile = File(qPath);
        if (await qFile.exists()) {
          try {
            await qFile.delete();
          } catch (_) {}
        }
      }
    }
    await _deleteMeta(id);
  }

  static Future<List<Map<String, dynamic>>> listAll() async {
    await init();

    final out = <Map<String, dynamic>>[];
    final suffix = '.$_metaExt';

    final entries = await _qDir!.list(followLinks: false).toList();

    for (final e in entries) {
      if (e is! File || !e.path.endsWith(suffix)) continue;

      Map<String, dynamic>? v;
      try {
        final d = jsonDecode(await e.readAsString());
        if (d is Map) v = Map<String, dynamic>.from(d);
      } catch (_) {}

      if (v == null) {
        try {
          await e.delete();
        } catch (_) {}
        continue;
      }

      final id = v['id'];
      final date = v['date'];
      final qPath = v['qPath'];
      final orig = v['originalPath'];

      if (id is! String || id.isEmpty || date is! String || date.isEmpty) {
        try {
          await e.delete();
        } catch (_) {}
        continue;
      }

      final isApp = v['type'] == 'app';

      if (!isApp && (qPath is! String || qPath.isEmpty || orig is! String || orig.isEmpty)) {
        try {
          await e.delete();
        } catch (_) {}
        continue;
      }

      out.add(v);
    }

    out.sort((a, b) {
      try {
        return DateTime.parse(b['date']).compareTo(DateTime.parse(a['date']));
      } catch (_) {
        return 0;
      }
    });

    return out;
  }

  static Future<void> restoreMany(Iterable<String> ids) async {
    for (final id in ids) {
      await restore(id);
    }
  }

  static Future<void> deleteMany(Iterable<String> ids) async {
    for (final id in ids) {
      await deleteForever(id);
    }
  }

  static Future<int> totalSize() async {
    final list = await listAll();
    return list.fold<int>(0, (s, e) => s + ((e['size'] as int?) ?? 0));
  }

  static Future<void> purgeOlderThan(Duration age) async {
    final now = DateTime.now();
    final list = await listAll();
    for (final m in list) {
      try {
        final t = DateTime.parse(m['date']);
        if (now.difference(t) > age) {
          await deleteForever(m['id']);
        }
      } catch (_) {}
    }
  }

  static Future<List<Map<String, dynamic>>> _metasForIds(Iterable<String> ids) async {
    await init();
    final out = <Map<String, dynamic>>[];
    for (final id in ids) {
      final v = await _getMeta(id);
      if (v != null) out.add(v);
    }
    return out;
  }

  static Future<List<String>> restoreManyIsolated(Iterable<String> ids) async {
    await init();
    final metas = await _metasForIds(ids);
    final keyBytes = await getRawKey();
    final result = await compute(_restoreWorker, {'metas': metas, 'key': keyBytes});
    for (final r in result) {
      await _deleteMeta(r['id'] as String);
    }
    return result.map<String>((e) => e['outPath'] as String).toList();
  }

  static Future<Map<String, dynamic>> quarantineApp({
    required String packageName,
    required String appName,
    required String apkPath,
  }) async {
    await init();

    final existing = await listAll();
    for (final m in existing) {
      if (m['type'] == 'app' && m['packageName'] == packageName) {
        return m;
      }
    }

    final meta = <String, dynamic>{
      'id': 'app_$packageName',
      'type': 'app',
      'packageName': packageName,
      'appName': appName,
      'name': appName,
      'originalPath': apkPath,
      'iconBytes': null,
      'size': 0,
      'date': DateTime.now().toIso8601String(),
      'fmt': 1,
      'qPath': '',
    };

    await _writeMeta(meta);
    return meta;
  }

  static Future<void> uninstallApp(String packageName) async {
    const ch = MethodChannel('cs.quarantine');
    await ch.invokeMethod('uninstallApp', {'package': packageName});
  }

  static Future<void> deleteAppEntry(String id) async {
    await init();
    await _deleteMeta(id);
  }
}

Future<List<Map<String, dynamic>>> _restoreWorker(Map args) async {
  final algo = AesGcm.with256bits();
  final metas = List<Map<String, dynamic>>.from(args['metas']);
  final key = SecretKey(List<int>.from(args['key']));
  final out = <Map<String, dynamic>>[];

  bool startsWithMagic(Uint8List bytes) {
    if (bytes.length < 4) return false;
    return bytes[0] == 0x51 && bytes[1] == 0x53 && bytes[2] == 0x56 && bytes[3] == 0x31;
  }

  for (final m in metas) {
    final qPath = m['qPath'];
    final orig = m['originalPath'];
    final id = m['id'];

    if (qPath is! String || orig is! String || id is! String) continue;

    final qFile = File(qPath);
    if (!await qFile.exists()) continue;

    final all = Uint8List.fromList(await qFile.readAsBytes());

    Uint8List plain;
    try {
      if (startsWithMagic(all)) {
        plain = Uint8List.fromList(all.sublist(4));
      } else {
        if (all.length < 12 + 16) continue;
        final nonce = all.sublist(0, 12);
        final mac = Mac(all.sublist(all.length - 16));
        final cipher = all.sublist(12, all.length - 16);
        final ptxt = await algo.decrypt(SecretBox(cipher, nonce: nonce, mac: mac), secretKey: key);
        plain = Uint8List.fromList(ptxt);
      }
    } catch (_) {
      continue;
    }

    final parent = Directory(p.dirname(orig));
    if (!await parent.exists()) {
      await parent.create(recursive: true);
    }

    var outPath = orig;
    if (await File(outPath).exists()) {
      final dir = p.dirname(orig);
      final base = p.basenameWithoutExtension(orig);
      final ext = p.extension(orig);
      outPath = p.join(dir, '${base}_restored$ext');
    }

    final tmpOut = '$outPath.tmp';
    await File(tmpOut).writeAsBytes(plain, flush: true);
    await File(tmpOut).rename(outPath);

    try {
      await qFile.delete();
    } catch (_) {}

    out.add({'id': id, 'outPath': outPath});
  }

  return out;
}
