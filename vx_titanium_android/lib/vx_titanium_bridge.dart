import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

typedef _InitNative = Int32 Function(Pointer<Utf8> defsDir, Pointer<Utf8> keyPath);
typedef _InitDart = int Function(Pointer<Utf8> defsDir, Pointer<Utf8> keyPath);

typedef _ReloadNative = Int32 Function(Pointer<Utf8> defsDir, Pointer<Utf8> keyPath);
typedef _ReloadDart = int Function(Pointer<Utf8> defsDir, Pointer<Utf8> keyPath);

typedef _ScanNative = Pointer<Utf8> Function(Pointer<Utf8> path);
typedef _ScanDart = Pointer<Utf8> Function(Pointer<Utf8> path);

typedef _FreeStringNative = Void Function(Pointer<Utf8> ptr);
typedef _FreeStringDart = void Function(Pointer<Utf8> ptr);

typedef _VersionNative = Pointer<Utf8> Function();
typedef _VersionDart = Pointer<Utf8> Function();

class VxTitaniumBridge {
  VxTitaniumBridge({DynamicLibrary? library})
      : _lib = library ?? DynamicLibrary.open(_libraryName) {
    _init = _lib.lookupFunction<_InitNative, _InitDart>('vx_init');
    _reload = _lib.lookupFunction<_ReloadNative, _ReloadDart>('vx_reload');
    _scanFile = _lib.lookupFunction<_ScanNative, _ScanDart>('vx_scan_file');
    _freeString = _lib.lookupFunction<_FreeStringNative, _FreeStringDart>('vx_free_string');
    _version = _lib.lookupFunction<_VersionNative, _VersionDart>('vx_version');
  }

  final DynamicLibrary _lib;

  late final _InitDart _init;
  late final _ReloadDart _reload;
  late final _ScanDart _scanFile;
  late final _FreeStringDart _freeString;
  late final _VersionDart _version;

  static String get _libraryName {
    if (Platform.isAndroid) {
      return 'libcolourswift_av.so';
    }

    if (Platform.isLinux) {
      return 'libcolourswift_av.so';
    }

    throw UnsupportedError('VX-TITANIUM only supports Android and Linux.');
  }

  int init({
    required String defsDir,
    required String keyPath,
  }) {
    final defsPtr = defsDir.toNativeUtf8();
    final keyPtr = keyPath.toNativeUtf8();

    try {
      return _init(defsPtr, keyPtr);
    } finally {
      calloc.free(defsPtr);
      calloc.free(keyPtr);
    }
  }

  int reload({
    required String defsDir,
    required String keyPath,
  }) {
    final defsPtr = defsDir.toNativeUtf8();
    final keyPtr = keyPath.toNativeUtf8();

    try {
      return _reload(defsPtr, keyPtr);
    } finally {
      calloc.free(defsPtr);
      calloc.free(keyPtr);
    }
  }

  String scanFile(String path) {
    final pathPtr = path.toNativeUtf8();

    try {
      final resultPtr = _scanFile(pathPtr);

      if (resultPtr == nullptr) {
        return '{}';
      }

      try {
        return resultPtr.toDartString();
      } finally {
        _freeString(resultPtr);
      }
    } finally {
      calloc.free(pathPtr);
    }
  }

  String version() {
    final resultPtr = _version();

    if (resultPtr == nullptr) {
      return 'unknown';
    }

    try {
      return resultPtr.toDartString();
    } finally {
      _freeString(resultPtr);
    }
  }

  void dispose() {}
}