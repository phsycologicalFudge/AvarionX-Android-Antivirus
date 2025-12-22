import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef ScanLogFn = void Function(String msg);
ScanLogFn? scanLogSink;

typedef AvInitNative = Int32 Function(Pointer<Utf8>, Pointer<Utf8>);
typedef AvScanNative = Pointer<Utf8> Function(Pointer<Utf8>);
typedef AvFreeNative = Int32 Function();

typedef AvInitDart = int Function(Pointer<Utf8>, Pointer<Utf8>);
typedef AvScanDart = Pointer<Utf8> Function(Pointer<Utf8>);
typedef AvFreeDart = int Function();

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

typedef ScanCbNative = Void Function(Pointer<Utf8>);
typedef SetScanCbNative = Void Function(
    Pointer<NativeFunction<ScanCbNative>>,
    );
typedef SetScanCbDart = void Function(
    Pointer<NativeFunction<ScanCbNative>>,
    );

@pragma('vm:entry-point')
void _scanLogCallback(Pointer<Utf8> msgPtr) {
  final msg = msgPtr.toDartString();
  scanLogSink?.call(msg);
}

final Pointer<NativeFunction<ScanCbNative>> _scanLogPtr =
Pointer.fromFunction<ScanCbNative>(_scanLogCallback);

class AntivirusBridge {
  late DynamicLibrary _lib;
  late final AvInitDart _init;
  late final AvScanDart _scan;
  late final AvFreeDart _free;
  late final PwGenDart _pwGen;
  late final PwFreeDart _pwFree;
  late final NetIocInitDart _netInit;
  late final NetCheckDart _netCheck;
  late final SetScanCbDart _setScanCallback;

  AntivirusBridge() {
    if (Platform.isAndroid) {
      _lib = DynamicLibrary.open("libcolourswift_av.so");
    } else if (Platform.isWindows) {
      _lib = DynamicLibrary.open("colourswift_av.dll");
    } else {
      throw UnsupportedError("Unsupported platform");
    }

    _init = _lib.lookupFunction<AvInitNative, AvInitDart>('av_init');
    _scan = _lib.lookupFunction<AvScanNative, AvScanDart>('av_scan');
    _free = _lib.lookupFunction<AvFreeNative, AvFreeDart>('av_free');
    _pwGen =
        _lib.lookupFunction<PwGenNative, PwGenDart>('generate_password');
    _pwFree =
        _lib.lookupFunction<PwFreeNative, PwFreeDart>('free_password');
    _netInit =
        _lib.lookupFunction<NetIocInitNative, NetIocInitDart>('cs_net_ioc_init');
    _netCheck =
        _lib.lookupFunction<NetCheckNative, NetCheckDart>('cs_net_check');
    _setScanCallback = _lib.lookupFunction<
        SetScanCbNative,
        SetScanCbDart>('set_scan_callback');
    try {
      _setScanCallback(_scanLogPtr);
    } catch (_) {
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
    _free();
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

  void free() {
    _free();
  }
}
