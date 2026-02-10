import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:ffi/ffi.dart';

typedef ScanLogFn = void Function(String msg);
ScanLogFn? scanLogSink;

typedef AvInitNative = Int32 Function(Pointer<Utf8>, Pointer<Utf8>);
typedef AvScanNative = Pointer<Utf8> Function(Pointer<Utf8>);
typedef AvFreeNative = Int32 Function();
typedef AvReloadNative = Int32 Function(Pointer<Utf8>, Pointer<Utf8>);

typedef AvInitDart = int Function(Pointer<Utf8>, Pointer<Utf8>);
typedef AvScanDart = Pointer<Utf8> Function(Pointer<Utf8>);
typedef AvFreeDart = int Function();
typedef AvReloadDart = int Function(Pointer<Utf8>, Pointer<Utf8>);

typedef NetIocInitNative = Int32 Function(Pointer<Utf8>);
typedef NetIocInitDart = int Function(Pointer<Utf8>);

typedef NetCheckNative = Int32 Function(
    Pointer<Utf8>,
    Pointer<Utf8>,
    Uint16,
    );
typedef NetCheckDart = int Function(
    Pointer<Utf8>,
    Pointer<Utf8>,
    int,
    );

typedef PwGenNative = Pointer<Utf8> Function(
    Pointer<Utf8>,
    Pointer<Utf8>,
    Uint32,
    IntPtr,
    );
typedef PwFreeNative = Void Function(Pointer<Utf8>);
typedef PwGenDart = Pointer<Utf8> Function(
    Pointer<Utf8>,
    Pointer<Utf8>,
    int,
    int,
    );
typedef PwFreeDart = void Function(Pointer<Utf8>);

typedef FreeStrNative = Void Function(Pointer<Utf8>);
typedef FreeStrDart = void Function(Pointer<Utf8>);

typedef RestoreEncodeNative = Pointer<Utf8> Function(
    Pointer<Utf8>,
    Pointer<Utf8>,
    );

typedef RestoreEncodeDart = Pointer<Utf8> Function(
    Pointer<Utf8>,
    Pointer<Utf8>,
    );

typedef RestoreDecodeNative = Pointer<Utf8> Function(
    Pointer<Utf8>,
    Pointer<Utf8>,
    );

typedef RestoreDecodeDart = Pointer<Utf8> Function(
    Pointer<Utf8>,
    Pointer<Utf8>,
    );

typedef ScanCbNative = Void Function(Pointer<Utf8>);
typedef SetScanCbNative = Void Function(
    Pointer<NativeFunction<ScanCbNative>>,
    );
typedef SetScanCbDart = void Function(
    Pointer<NativeFunction<ScanCbNative>>,
    );

NativeCallable<ScanCbNative>? _scanCb;
Pointer<NativeFunction<ScanCbNative>>? _scanCbPtr;

void _ensureScanCallbackInstalled() {
  if (_scanCbPtr != null) return;
  _scanCb = NativeCallable<ScanCbNative>.listener((Pointer<Utf8> msgPtr) {
    final msg = msgPtr.toDartString();
    scanLogSink?.call(msg);
  });
  _scanCbPtr = _scanCb!.nativeFunction;
}

class AntivirusBridge {
  late DynamicLibrary _lib;
  late final AvInitDart _init;
  late final AvReloadDart _reload;
  late final AvScanDart _scan;
  late final AvFreeDart _free;
  late final PwGenDart _pwGen;
  late final PwFreeDart _pwFree;
  late final FreeStrDart _freeStr;
  late final NetIocInitDart _netInit;
  late final NetCheckDart _netCheck;
  late final SetScanCbDart _setScanCallback;
  late final RestoreEncodeDart _restoreEncode;
  late final RestoreDecodeDart _restoreDecode;

  final bool enableScanLogs;

  AntivirusBridge({this.enableScanLogs = true}) {
    if (Platform.isAndroid) {
      _lib = DynamicLibrary.open("libcolourswift_av.so");
    } else if (Platform.isWindows) {
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      _lib = DynamicLibrary.open('$exeDir\\vx_titanium.dll');
    } else {
      throw UnsupportedError("Unsupported platform");
    }

    _init = _lib.lookupFunction<AvInitNative, AvInitDart>('av_init');
    _reload = _lib.lookupFunction<AvReloadNative, AvReloadDart>('av_reload');
    _scan = _lib.lookupFunction<AvScanNative, AvScanDart>('av_scan');
    _free = _lib.lookupFunction<AvFreeNative, AvFreeDart>('av_free');
    _pwGen = _lib.lookupFunction<PwGenNative, PwGenDart>('generate_password');
    _pwFree = _lib.lookupFunction<PwFreeNative, PwFreeDart>('free_password');
    _freeStr = _lib.lookupFunction<FreeStrNative, FreeStrDart>('free_str');
    _restoreEncode = _lib.lookupFunction<RestoreEncodeNative, RestoreEncodeDart>(
      'generate_restore_code_ffi',
    );
    _restoreDecode = _lib.lookupFunction<RestoreDecodeNative, RestoreDecodeDart>(
      'decode_restore_code_ffi',
    );
    _netInit = _lib.lookupFunction<NetIocInitNative, NetIocInitDart>('cs_net_ioc_init');
    _netCheck = _lib.lookupFunction<NetCheckNative, NetCheckDart>('cs_net_check');
    _setScanCallback =
        _lib.lookupFunction<SetScanCbNative, SetScanCbDart>('set_scan_callback');

    if (enableScanLogs) {
      try {
        _ensureScanCallbackInstalled();
        _setScanCallback(_scanCbPtr!);
      } catch (_) {}
    }
  }

  int init(String defsPath, String keyPath) {
    final defs = defsPath.toNativeUtf8();
    final key = keyPath.toNativeUtf8();
    final res = _init(defs, key);
    malloc.free(defs);
    malloc.free(key);
    return res;
  }

  int reload(String defsPath, String keyPath) {
    final defs = defsPath.toNativeUtf8();
    final key = keyPath.toNativeUtf8();
    final res = _reload(defs, key);
    malloc.free(defs);
    malloc.free(key);
    return res;
  }

  int initNetIoc(String defsPath) {
    final p = defsPath.toNativeUtf8();
    final res = _netInit(p);
    malloc.free(p);
    return res;
  }

  int checkNetwork(String ip, String sni, int port) {
    final ipPtr = ip.toNativeUtf8();
    final sniPtr = sni.toNativeUtf8();
    final res = _netCheck(ipPtr, sniPtr, port);
    malloc.free(ipPtr);
    malloc.free(sniPtr);
    return res;
  }

  String scanFile(String path) {
    final ptr = path.toNativeUtf8();
    final resultPtr = _scan(ptr);
    malloc.free(ptr);

    if (resultPtr == nullptr) {
      return '{"error":"null result"}';
    }

    final s = resultPtr.toDartString();
    _freeStr(resultPtr);
    return s;
  }

  String generatePassword(
      String meta,
      String label,
      int version,
      int length,
      ) {
    final metaPtr = meta.toNativeUtf8();
    final labelPtr = label.toNativeUtf8();
    final resultPtr = _pwGen(metaPtr, labelPtr, version, length);
    final s = resultPtr.toDartString();
    _pwFree(resultPtr);
    malloc.free(metaPtr);
    malloc.free(labelPtr);
    return s;
  }

  String generateRestoreCode(String meta, String vaultJson) {
    final metaPtr = meta.toNativeUtf8();
    final vaultPtr = vaultJson.toNativeUtf8();

    final outPtr = _restoreEncode(metaPtr, vaultPtr);
    final s = outPtr.toDartString();

    _freeStr(outPtr);
    malloc.free(metaPtr);
    malloc.free(vaultPtr);

    return s;
  }

  String restoreFromCode(String meta, String restoreCode) {
    final metaPtr = meta.toNativeUtf8();
    final codePtr = restoreCode.toNativeUtf8();

    final outPtr = _restoreDecode(metaPtr, codePtr);
    final s = outPtr.toDartString();

    _freeStr(outPtr);
    malloc.free(metaPtr);
    malloc.free(codePtr);

    return s;
  }

  void free() {
    try {
      _scanCb?.close();
    } catch (_) {}
    _scanCb = null;
    _scanCbPtr = null;
    _free();
  }
}
