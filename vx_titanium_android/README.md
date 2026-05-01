# VX-TITANIUM Android SDK

Flutter Android wrapper for the VX-TITANIUM native scanner runtime.

## License

VX-TITANIUM is proprietary software.

You may use this SDK as a dependency inside your own apps, including commercial
apps, but you may not modify, reverse engineer, resell, repackage, or distribute
the scanner engine as a standalone product.

## Install

```yaml
dependencies:
  vx_titanium_android: ^8.0.1
```

## Quick start

The SDK has two parts:

- `VxTitaniumDefs`, which downloads and stores VXPack definitions.
- `VxTitaniumBridge`, which loads the native engine and scans files.

```dart
import 'package:vx_titanium_android/vx_titanium_android.dart';

final defs = await VxTitaniumDefs.ensureReady();

final scanner = VxTitaniumBridge();

final initCode = scanner.init(
  defsDir: defs.defsDir,
  keyPath: defs.keyPath,
);

final resultJson = scanner.scanFile('/path/to/file.apk');

scanner.dispose();
```

## VXPack storage and updates

`VxTitaniumDefs.ensureReady()` prepares the scanner definitions before scanning.

It will:

1. Create a VX-TITANIUM storage folder inside app support storage.
2. Check whether `defs.vxpack` and `defs_key.bin` already exist.
3. Check the latest public AVDatabase release when the update interval has passed.
4. Download `defs.vxpack`, `defs_key.bin`, and `version.json` if definitions are missing or newer.
5. Reuse the cached local definitions if no update is needed.
6. Return local paths for the native engine.

The default local layout is:

```text
app_support/
  vx_titanium/
    last_check.txt
    defs/
      defs.vxpack
      defs_key.bin
      version.json
```

The default update interval is 48 hours.

You can override the config:

```dart
final defs = await VxTitaniumDefs.ensureReady(
  config: const VxTitaniumDefsConfig(
    checkInterval: Duration(hours: 24),
    forceCheck: false,
    githubOwner: 'phsycologicalFudge',
    githubRepo: 'AVDatabase',
  ),
);
```

If the update check fails but local definitions already exist, the SDK keeps using the cached VXPack.

If no local definitions exist and the download fails, `ensureReady()` throws an exception.

## Notes

`scanFile` returns a JSON string from the native scanner.

Definition files are stored and updated by `VxTitaniumDefs.ensureReady()`. The native scanner only receives the local `defsDir` and `keyPath`.
