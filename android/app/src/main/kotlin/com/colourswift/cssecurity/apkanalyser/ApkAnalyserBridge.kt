package com.colourswift.cssecurity.apkanalyser

import android.content.Context
import android.content.pm.ActivityInfo
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.pm.ProviderInfo
import android.content.pm.ServiceInfo
import android.os.Build
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File
import java.io.FileInputStream
import java.security.MessageDigest
import java.util.zip.ZipFile

class ApkAnalyserBridge(
    private val context: Context,
    messenger: BinaryMessenger
) : MethodChannel.MethodCallHandler {
    private val channel = MethodChannel(messenger, "cs_apk_analyser")
    private val scope = CoroutineScope(Dispatchers.Main)

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "extractApkEvidence" -> {
                val apkPath = call.argument<String>("apkPath")?.trim().orEmpty()
                if (apkPath.isEmpty()) {
                    result.error("invalid_args", "apkPath is required", null)
                    return
                }

                scope.launch {
                    try {
                        val evidence = withContext(Dispatchers.IO) {
                            extractApkEvidence(apkPath)
                        }
                        result.success(evidence)
                    } catch (e: Throwable) {
                        result.error("extract_failed", e.message, null)
                    }
                }
            }

            else -> result.notImplemented()
        }
    }

    private fun extractApkEvidence(apkPath: String): Map<String, Any?> {
        val file = File(apkPath)
        if (!file.exists() || !file.isFile) {
            throw IllegalArgumentException("APK file not found")
        }

        val pm = context.packageManager
        val packageInfo = getArchivePackageInfo(pm, apkPath, archiveFlags())
            ?: throw IllegalStateException("Failed to parse APK archive")

        val applicationInfo = packageInfo.applicationInfo?.apply {
            sourceDir = apkPath
            publicSourceDir = apkPath
        }

        val packageName = packageInfo.packageName.orEmpty()
        val appName = loadAppName(pm, applicationInfo)
        val versionName = packageInfo.versionName.orEmpty()
        val versionCode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            packageInfo.longVersionCode
        } else {
            @Suppress("DEPRECATION")
            packageInfo.versionCode.toLong()
        }

        val deepSignals = extractDeepSignals(apkPath)

        return mapOf(
            "app" to mapOf(
                "package_name" to packageName,
                "app_name" to appName,
                "developer_name" to "",
                "version_name" to versionName,
                "version_code" to versionCode.toString()
            ),
            "evidence" to mapOf(
                "requested_permissions" to packageInfo.requestedPermissions?.toList().orEmpty(),
                "permission_flags" to permissionFlags(packageInfo),
                "min_sdk" to (applicationInfo?.minSdkVersion ?: 0),
                "target_sdk" to (applicationInfo?.targetSdkVersion ?: 0),
                "activities" to packageInfo.activities?.map { activityInfoMap(it) }.orEmpty(),
                "services" to packageInfo.services?.map { serviceInfoMap(it) }.orEmpty(),
                "receivers" to packageInfo.receivers?.map { activityInfoMap(it) }.orEmpty(),
                "providers" to packageInfo.providers?.map { providerInfoMap(it) }.orEmpty(),
                "signing_info" to signingInfoMap(packageInfo),
                "file_info" to mapOf(
                    "apk_size_bytes" to file.length(),
                    "sha256" to sha256(file)
                ),
                "raw_android_info" to mapOf(
                    "split_names" to packageInfo.splitNames?.toList().orEmpty(),
                    "shared_user_id" to packageInfo.sharedUserId,
                    "install_location" to packageInfo.installLocation
                ),
                "detected_packages" to deepSignals["detected_packages"].orEmpty(),
                "embedded_endpoints" to deepSignals["embedded_endpoints"].orEmpty()
            )
        )
    }

    private fun extractDeepSignals(apkPath: String): Map<String, List<String>> {
        val interestingStrings = mutableSetOf<String>()
        val packageFrequencies = mutableMapOf<String, Int>()

        try {
            ZipFile(File(apkPath)).use { zipFile ->
                val dexEntries = zipFile.entries().asSequence().filter { it.name.endsWith(".dex") }

                val urlRegex = "https?://[a-zA-Z0-9.-]+(?:/[a-zA-Z0-9&%_./-~-]*)?".toRegex()
                val packageRegex = "(?:com|net|org|io)\\.[a-z0-9_]+\\.[a-z0-9_]+".toRegex()

                for (entry in dexEntries) {
                    zipFile.getInputStream(entry).bufferedReader(Charsets.ISO_8859_1).useLines { lines ->
                        lines.forEach { line ->
                            urlRegex.findAll(line).take(15).forEach {
                                interestingStrings.add(it.value.take(150))
                            }

                            packageRegex.findAll(line).forEach { match ->
                                val pkg = match.value
                                packageFrequencies[pkg] = packageFrequencies.getOrDefault(pkg, 0) + 1
                            }
                        }
                    }
                }
            }
        } catch (e: Throwable) {
        }

        val filteredPackages = packageFrequencies.entries
            .asSequence()
            .filterNot {
                val p = it.key
                p.startsWith("com.android") ||
                        p.startsWith("com.google.android.material") ||
                        p.startsWith("org.json") ||
                        p.startsWith("java.")
            }
            .sortedByDescending { it.value }
            .map { it.key }
            .take(15)
            .toList()

        return mapOf(
            "detected_packages" to filteredPackages,
            "embedded_endpoints" to interestingStrings.toList()
        )
    }

    private fun archiveFlags(): Long {
        var flags = 0L
        flags = flags or PackageManager.GET_PERMISSIONS.toLong()
        flags = flags or PackageManager.GET_ACTIVITIES.toLong()
        flags = flags or PackageManager.GET_SERVICES.toLong()
        flags = flags or PackageManager.GET_RECEIVERS.toLong()
        flags = flags or PackageManager.GET_PROVIDERS.toLong()
        flags = flags or PackageManager.GET_META_DATA.toLong()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            flags = flags or PackageManager.GET_SIGNING_CERTIFICATES.toLong()
        }
        return flags
    }

    private fun getArchivePackageInfo(
        pm: PackageManager,
        apkPath: String,
        flags: Long
    ): PackageInfo? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            pm.getPackageArchiveInfo(apkPath, PackageManager.PackageInfoFlags.of(flags))
        } else {
            @Suppress("DEPRECATION")
            pm.getPackageArchiveInfo(apkPath, flags.toInt())
        }
    }

    private fun loadAppName(pm: PackageManager, appInfo: ApplicationInfo?): String {
        if (appInfo == null) return ""
        return try {
            pm.getApplicationLabel(appInfo)?.toString().orEmpty()
        } catch (_: Throwable) {
            ""
        }
    }

    private fun permissionFlags(packageInfo: PackageInfo): List<Map<String, Any?>> {
        val names = packageInfo.requestedPermissions ?: return emptyList()
        val flags = packageInfo.requestedPermissionsFlags ?: IntArray(names.size)
        return names.mapIndexed { index, name ->
            val value = if (index < flags.size) flags[index] else 0
            mapOf(
                "name" to name,
                "granted" to ((value and PackageInfo.REQUESTED_PERMISSION_GRANTED) != 0),
                "flags" to value
            )
        }
    }

    private fun activityInfoMap(info: ActivityInfo): Map<String, Any?> {
        return mapOf(
            "name" to info.name,
            "package_name" to info.packageName,
            "exported" to info.exported,
            "enabled" to info.enabled,
            "permission" to info.permission,
            "process_name" to info.processName
        )
    }

    private fun serviceInfoMap(info: ServiceInfo): Map<String, Any?> {
        return mapOf(
            "name" to info.name,
            "package_name" to info.packageName,
            "exported" to info.exported,
            "enabled" to info.enabled,
            "permission" to info.permission,
            "process_name" to info.processName
        )
    }

    private fun providerInfoMap(info: ProviderInfo): Map<String, Any?> {
        return mapOf(
            "name" to info.name,
            "package_name" to info.packageName,
            "exported" to info.exported,
            "enabled" to info.enabled,
            "authority" to info.authority,
            "read_permission" to info.readPermission,
            "write_permission" to info.writePermission,
            "process_name" to info.processName
        )
    }

    private fun signingInfoMap(packageInfo: PackageInfo): Map<String, Any?> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P) {
            @Suppress("DEPRECATION")
            val signatures = packageInfo.signatures?.map { sig ->
                mapOf(
                    "sha256" to sha256(sig.toByteArray())
                )
            }.orEmpty()
            return mapOf(
                "has_multiple_signers" to false,
                "certificates" to signatures
            )
        }

        val signingInfo = packageInfo.signingInfo ?: return mapOf(
            "has_multiple_signers" to false,
            "certificates" to emptyList<Map<String, Any?>>()
        )

        val signers = if (signingInfo.hasMultipleSigners()) {
            signingInfo.apkContentsSigners
        } else {
            signingInfo.signingCertificateHistory
        }.orEmpty()

        return mapOf(
            "has_multiple_signers" to signingInfo.hasMultipleSigners(),
            "certificates" to signers.map { sig ->
                mapOf(
                    "sha256" to sha256(sig.toByteArray())
                )
            }
        )
    }

    private fun sha256(file: File): String {
        FileInputStream(file).use { input ->
            val digest = MessageDigest.getInstance("SHA-256")
            val buffer = ByteArray(8192)
            while (true) {
                val read = input.read(buffer)
                if (read <= 0) break
                digest.update(buffer, 0, read)
            }
            return digest.digest().joinToString("") { "%02x".format(it) }
        }
    }

    private fun sha256(bytes: ByteArray): String {
        val digest = MessageDigest.getInstance("SHA-256")
        return digest.digest(bytes).joinToString("") { "%02x".format(it) }
    }
}