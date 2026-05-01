# VX-TITANIUM Android SDK (Kotlin)

Kotlin Android library wrapping the VX-TITANIUM native scanner runtime via JNA.

## License

VX-TITANIUM is proprietary software. See LICENSE for terms.

## Install via Git

In your root `settings.gradle`:

```groovy
dependencyResolutionManagement {
    repositories {
        // ...
    }
}
// Include the cloned repo as a local module, or use git submodules:
include ':vxtitanium'
project(':vxtitanium').projectDir = new File('../vx_titanium_android_kotlin/vxtitanium')
```

In your app `build.gradle`:

```groovy
dependencies {
    implementation project(':vxtitanium')
}
```

## Basic usage

```kotlin
import com.colourswift.vxtitanium.VxTitanium

val scanner = VxTitanium()

val initCode = scanner.init(
    defsDir = "/path/to/defs",
    keyPath = "/path/to/key"
)

val resultJson = scanner.scanFile("/path/to/file.apk")

scanner.dispose()
```

## Notes

`scanFile` returns a JSON string from the native scanner, or null on failure.

VXPack files are stored in app support storage. The SDK can check the public AVDatabase releases and refresh definitions through VxTitaniumDefs.ensureReady().
