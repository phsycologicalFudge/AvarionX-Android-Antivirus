import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../utils/exclusions_store.dart';

class QuarantineService {
  static final _algo = AesGcm.with256bits();

  static SecretKey? _key;
  static Directory? _qDir;
  static File? _keyFile;
  static Box? _box;

  static Future<void> init() async {
    if (!Hive.isBoxOpen('quarantine')) {
      await Hive.initFlutter();
      _box = await Hive.openBox('quarantine');
    } else {
      _box = Hive.box('quarantine');
    }

    final support = await getApplicationSupportDirectory();

    _keyFile = File(p.join(support.path, 'qs_key.bin'));
    _qDir = Directory(p.join(support.path, 'quarantine'));

    if (!await _qDir!.exists()) {
      await _qDir!.create(recursive: true);
    }

    _key ??= await _loadOrCreateKey();
    await ExclusionsStore.instance.init();
  }

  static Future<SecretKey> _loadOrCreateKey() async {
    if (await _keyFile!.exists()) {
      final raw = await _keyFile!.readAsBytes();
      return SecretKey(raw);
    }

    final sk = await _algo.newSecretKey();
    final raw = await sk.extractBytes();

    await _keyFile!.writeAsBytes(
      raw,
      flush: true,
    );

    return SecretKey(raw);
  }

  static Future<List<int>> getRawKey() async {
    await init();
    return await _key!.extractBytes();
  }

  static String _id() {
    final r = Random.secure();
    final a = r.nextInt(1 << 32);
    final b = r.nextInt(1 << 32);
    final c = DateTime.now().millisecondsSinceEpoch;
    return '${c.toRadixString(16)}_${a.toRadixString(16)}_${b.toRadixString(16)}';
  }

  static Future<Map<String, dynamic>> quarantineFile(
      String srcPath, {
        String? label,
        double? confidence,
      }) async {
    await init();

    final f = File(srcPath);
    if (!await f.exists()) {
      throw Exception('Source not found');
    }

    final data = await f.readAsBytes();

    final nonce = _algo.newNonce();
    final box = await _algo.encrypt(
      data,
      secretKey: _key!,
      nonce: nonce,
    );

    final out = BytesBuilder();
    out.add(box.nonce);
    out.add(box.cipherText);
    out.add(box.mac.bytes);

    final id = _id();
    final qName = '$id.vqsafe';
    final qPath = p.join(_qDir!.path, qName);

    await File(qPath).writeAsBytes(out.toBytes(), flush: true);

    final meta = <String, dynamic>{
      'id': id,
      'qPath': qPath,
      'name': p.basename(srcPath),
      'originalPath': srcPath,
      'size': data.length,
      'date': DateTime.now().toIso8601String(),
      if (label != null) 'label': label,
      if (confidence != null) 'confidence': confidence,
    };

    try {
      await f.delete();
      if (await f.exists()) {
        meta['deleteFailed'] = true;
      }
    } catch (_) {
      meta['deleteFailed'] = true;
    }

    await _box!.put(id, meta);
    return meta;
  }

  static Future<void> restore(String id) async {
    await init();

    final meta = Map<String, dynamic>.from(_box!.get(id));
    final qFile = File(meta['qPath']);

    if (!await qFile.exists()) {
      throw Exception('Quarantine file missing');
    }

    final all = await qFile.readAsBytes();
    if (all.length < 12 + 16) {
      throw Exception('Corrupt quarantine package');
    }

    final nonce = all.sublist(0, 12);
    final mac = Mac(all.sublist(all.length - 16));
    final cipher = all.sublist(12, all.length - 16);

    final plain = await _algo.decrypt(
      SecretBox(cipher, nonce: nonce, mac: mac),
      secretKey: _key!,
    );

    final orig = meta['originalPath'] as String;
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

    await File(outPath).writeAsBytes(plain, flush: true);
    await qFile.delete();
    await _box!.delete(id);

    await ExclusionsStore.instance.addTemporary(
      outPath,
      const Duration(hours: 24),
    );
  }

  static Future<void> deleteForever(String id) async {
    await init();

    final meta = Map<String, dynamic>.from(_box!.get(id));
    final qFile = File(meta['qPath']);

    if (await qFile.exists()) {
      await qFile.delete();
    }

    await _box!.delete(id);
  }

  static Future<List<Map<String, dynamic>>> listAll() async {
    await init();

    final keys = _box!.keys.toList();
    final out = <Map<String, dynamic>>[];

    for (final k in keys) {
      final v = _box!.get(k);
      if (v != null) {
        out.add(Map<String, dynamic>.from(v));
      }
    }

    out.sort(
          (a, b) => DateTime.parse(b['date'])
          .compareTo(DateTime.parse(a['date'])),
    );

    return out;
  }

  static Future<int> totalSize() async {
    await init();
    final list = await listAll();
    return list.fold<int>(0, (s, e) => s + (e['size'] as int));
  }

  static Future<void> purgeOlderThan(Duration age) async {
    await init();

    final now = DateTime.now();
    final list = await listAll();

    for (final m in list) {
      final t = DateTime.parse(m['date']);
      if (now.difference(t) > age) {
        await deleteForever(m['id']);
      }
    }
  }

  static Future<List<String>> restoreManyIsolated(
      Iterable<String> ids,
      ) async {
    await init();

    final metas = ids
        .map((id) => _box!.get(id))
        .whereType<Map>()
        .map((m) => Map<String, dynamic>.from(m))
        .toList();

    final keyBytes = await getRawKey();

    final result = await compute(
      _restoreWorker,
      {
        'metas': metas,
        'key': keyBytes,
      },
    );

    for (final r in result) {
      final id = r['id'] as String;
      final outPath = r['outPath'] as String;

      await _box!.delete(id);
      await ExclusionsStore.instance.addTemporary(
        outPath,
        const Duration(hours: 24),
      );
    }

    return result
        .map<String>((e) => e['outPath'] as String)
        .toList();
  }
}

Future<List<Map<String, dynamic>>> _restoreWorker(Map args) async {
  final algo = AesGcm.with256bits();
  final metas = List<Map<String, dynamic>>.from(args['metas']);
  final key = SecretKey(List<int>.from(args['key']));

  final out = <Map<String, dynamic>>[];

  for (final m in metas) {
    final qPath = m['qPath'] as String;
    final orig = m['originalPath'] as String;

    final qFile = File(qPath);
    if (!await qFile.exists()) continue;

    final all = await qFile.readAsBytes();
    if (all.length < 12 + 16) continue;

    final nonce = all.sublist(0, 12);
    final mac = Mac(all.sublist(all.length - 16));
    final cipher = all.sublist(12, all.length - 16);

    final plain = await algo.decrypt(
      SecretBox(cipher, nonce: nonce, mac: mac),
      secretKey: key,
    );

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

    await File(outPath).writeAsBytes(plain, flush: true);
    await qFile.delete();

    out.add({'id': m['id'], 'outPath': outPath});
  }

  return out;
}
