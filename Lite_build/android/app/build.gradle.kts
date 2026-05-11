plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

import java.io.FileInputStream
        import java.util.Properties
        import org.gradle.api.JavaVersion

val localSigningFile = rootProject.file("local-signing.properties")
val hasLocalSigning = localSigningFile.exists()

val localSigningProps = Properties()
if (hasLocalSigning) {
    localSigningProps.load(FileInputStream(localSigningFile))
}

android {
    namespace = "com.colourswift.cssecurity"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.colourswift.cssecurity"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildFeatures {
        aidl = true
        buildConfig = true
    }

    signingConfigs {
        create("release") {
            if (hasLocalSigning) {
                keyAlias = localSigningProps["keyAlias"] as String
                keyPassword = localSigningProps["keyPassword"] as String
                storeFile = file(localSigningProps["storeFile"] as String)
                storePassword = localSigningProps["storePassword"] as String
            }
        }
    }

    buildTypes {
        getByName("debug") {}

        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            if (hasLocalSigning) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.android.billingclient:billing-ktx:6.2.0")
    implementation("org.bouncycastle:bcprov-jdk15to18:1.78.1")
    implementation("org.bouncycastle:bcpkix-jdk15to18:1.78.1")
    implementation(files("libs/aidl-release.aar"))
    implementation(files("libs/api-release.aar"))
    implementation(files("libs/provider-release.aar"))
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}
