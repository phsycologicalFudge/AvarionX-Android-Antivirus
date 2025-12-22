import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class _DigestCaptureSink implements Sink<Digest> {
  Digest? value;

  @override
  void add(Digest data) {
    value = data;
  }

  @override
  void close() {}
}

class HashCacheWorker {
  final SendPort _send;

  HashCacheWorker._(this._send);

  static Future<HashCacheWorker> spawn(String cachePath) async {
    final ready = ReceivePort();
    await Isolate.spawn(_entry, [ready.sendPort, cachePath]);
    final send = await ready.first as SendPort;
    return HashCacheWorker._(send);
  }

  static Future<void> _entry(List args) async {
    final root = args[0] as SendPort;
    final cachePath = args[1] as String;

    final port = ReceivePort();
    root.send(port.sendPort);

    final cache = _HashCache(cachePath);
    await cache.load();

    await for (final msg in port) {
      final m = msg as List;
      final reply = m[0] as SendPort;
      final op = m[1] as String;

      try {
        if (op == 'hashBatch') {
          final paths = (m[2] as List).cast<String>();
          final out = await cache.hashBatch(paths);
          reply.send(out);
          continue;
        }

        if (op == 'flush') {
          await cache.flush();
          reply.send(true);
          continue;
        }

        if (op == 'close') {
          await cache.flush();
          reply.send(true);
          Isolate.exit();
        }
      } catch (_) {
        reply.send(op == 'hashBatch' ? <String, Map<String, String>>{} : false);
      }
    }
  }

  Future<Map<String, Map<String, String>>> hashBatch(List<String> paths) async {
    final rp = ReceivePort();
    _send.send([rp.sendPort, 'hashBatch', paths]);
    return await rp.first as Map<String, Map<String, String>>;
  }

  Future<void> flush() async {
    final rp = ReceivePort();
    _send.send([rp.sendPort, 'flush']);
    await rp.first;
  }

  Future<void> close() async {
    final rp = ReceivePort();
    _send.send([rp.sendPort, 'close']);
    await rp.first;
  }
}

class _Rec {
  final String path;
  final int size;
  final int mtimeMs;
  final Uint8List md5;
  final Uint8List sha;

  _Rec(this.path, this.size, this.mtimeMs, this.md5, this.sha);
}

class _HashCache {
  final String cachePath;
  final Map<String, _Rec> _map = {};
  bool _dirty = false;

  _HashCache(this.cachePath);

  Future<void> load() async {
    final f = File(cachePath);
    if (!await f.exists()) return;

    final bytes = await f.readAsBytes();
    var o = 0;

    int readU16() {
      final v = (bytes[o] << 8) | bytes[o + 1];
      o += 2;
      return v;
    }

    int readI64() {
      var v = 0;
      for (var i = 0; i < 8; i++) {
        v = (v << 8) | bytes[o + i];
      }
      o += 8;
      return v;
    }

    Uint8List readBytes(int n) {
      final out = Uint8List.sublistView(bytes, o, o + n);
      o += n;
      return Uint8List.fromList(out);
    }

    while (o + 2 <= bytes.length) {
      final pathLen = readU16();
      if (o + pathLen + 8 + 8 + 16 + 32 > bytes.length) break;

      final path = utf8.decode(readBytes(pathLen));
      final size = readI64();
      final mtimeMs = readI64();
      final md5b = readBytes(16);
      final shab = readBytes(32);

      _map[path] = _Rec(path, size, mtimeMs, md5b, shab);
    }
  }

  Future<Map<String, Map<String, String>>> hashBatch(List<String> paths) async {
    final out = <String, Map<String, String>>{};
    for (var i = 0; i < paths.length; i++) {
      final p = paths[i];
      final r = await _hashOne(p);
      if (r != null) out[p] = r;
      if ((i & 31) == 31) await Future<void>.delayed(Duration.zero);
    }
    return out;
  }

  Future<Map<String, String>?> _hashOne(String path) async {
    final f = File(path);
    if (!await f.exists()) return null;

    final st = await f.stat();
    final size = st.size;
    final mtimeMs = st.modified.millisecondsSinceEpoch;

    final existing = _map[path];
    if (existing != null && existing.size == size && existing.mtimeMs == mtimeMs) {
      return {'md5': _hex(existing.md5), 'sha': _hex(existing.sha)};
    }

    final md5Out = _DigestCaptureSink();
    final shaOut = _DigestCaptureSink();

    final md5In = md5.startChunkedConversion(md5Out);
    final shaIn = sha256.startChunkedConversion(shaOut);

    await for (final chunk in f.openRead()) {
      md5In.add(chunk);
      shaIn.add(chunk);
    }

    md5In.close();
    shaIn.close();

    final md = md5Out.value;
    final sh = shaOut.value;
    if (md == null || sh == null) return null;

    final md5Bytes = Uint8List.fromList(md.bytes);
    final shaBytes = Uint8List.fromList(sh.bytes);

    _map[path] = _Rec(path, size, mtimeMs, md5Bytes, shaBytes);
    _dirty = true;

    return {'md5': _hex(md5Bytes), 'sha': _hex(shaBytes)};
  }

  Future<void> flush() async {
    if (!_dirty) return;

    final buf = BytesBuilder(copy: false);

    void writeU16(int v) {
      buf.add([((v >> 8) & 0xFF), (v & 0xFF)]);
    }

    void writeI64(int v) {
      final b = Uint8List(8);
      var x = v;
      for (var i = 7; i >= 0; i--) {
        b[i] = x & 0xFF;
        x >>= 8;
      }
      buf.add(b);
    }

    for (final r in _map.values) {
      final pathBytes = utf8.encode(r.path);
      if (pathBytes.length > 65535) continue;

      writeU16(pathBytes.length);
      buf.add(pathBytes);
      writeI64(r.size);
      writeI64(r.mtimeMs);
      buf.add(r.md5);
      buf.add(r.sha);
    }

    final f = File(cachePath);
    await f.parent.create(recursive: true);
    await f.writeAsBytes(buf.takeBytes(), flush: true);

    _dirty = false;
  }

  String _hex(Uint8List b) {
    final sb = StringBuffer();
    for (final x in b) {
      sb.write(x.toRadixString(16).padLeft(2, '0'));
    }
    return sb.toString();
  }
}
