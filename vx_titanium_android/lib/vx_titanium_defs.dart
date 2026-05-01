import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

typedef VxTitaniumDefsLog = void Function(String message);
typedef VxTitaniumDefsProgress = void Function(
  String assetName,
  int received,
  int? total,
);

class VxTitaniumDefsConfig {
  const VxTitaniumDefsConfig({
    this.githubOwner = 'phsycologicalFudge',
    this.githubRepo = 'AVDatabase',
    this.checkInterval = const Duration(hours: 48),
    this.forceCheck = false,
    this.userAgent = 'vx-titanium-android-sdk',
    this.storageFolderName = 'vx_titanium',
    this.defsFolderName = 'defs',
    this.vxpackAssetName = 'defs.vxpack',
    this.keyAssetName = 'defs_key.bin',
    this.versionAssetName = 'version.json',
    this.timeout = const Duration(seconds: 45),
  });

  final String githubOwner;
  final String githubRepo;
  final Duration checkInterval;
  final bool forceCheck;
  final String userAgent;
  final String storageFolderName;
  final String defsFolderName;
  final String vxpackAssetName;
  final String keyAssetName;
  final String versionAssetName;
  final Duration timeout;

  String get latestReleaseUrl =>
      'https://api.github.com/repos/$githubOwner/$githubRepo/releases/latest';
}

class VxTitaniumDefsPaths {
  const VxTitaniumDefsPaths({
    required this.baseDir,
    required this.defsDir,
    required this.vxpackPath,
    required this.keyPath,
    required this.versionPath,
    required this.lastCheckPath,
    required this.localVersion,
    required this.updated,
  });

  final String baseDir;
  final String defsDir;
  final String vxpackPath;
  final String keyPath;
  final String versionPath;
  final String lastCheckPath;
  final String localVersion;
  final bool updated;
}

class VxTitaniumDefs {
  const VxTitaniumDefs._();

  static Future<VxTitaniumDefsPaths> ensureReady({
    VxTitaniumDefsConfig config = const VxTitaniumDefsConfig(),
    VxTitaniumDefsLog? onLog,
    VxTitaniumDefsProgress? onProgress,
  }) async {
    final paths = await _paths(config);
    await Directory(paths.defsDir).create(recursive: true);

    final hasRequiredFiles = await _hasRequiredFiles(paths);
    final shouldCheck = config.forceCheck ||
        !hasRequiredFiles ||
        await _isCheckDue(paths.lastCheckPath, config.checkInterval);

    if (!shouldCheck) {
      return paths.copyWith(
        localVersion: await _readLocalVersion(paths.versionPath),
        updated: false,
      );
    }

    final client = http.Client();

    try {
      final release = await _fetchLatestRelease(
        client: client,
        config: config,
      );

      final vxpackUrl = _assetUrl(release, config.vxpackAssetName);
      final keyUrl = _assetUrl(release, config.keyAssetName);
      final versionUrl = _assetUrl(release, config.versionAssetName);

      if (vxpackUrl == null || keyUrl == null || versionUrl == null) {
        throw StateError(
          'Latest release is missing one or more required VXPack assets.',
        );
      }

      final remoteVersionJson = await _fetchText(
        client: client,
        url: versionUrl,
        config: config,
      );

      final remoteVersion = _versionFromJson(remoteVersionJson);
      final localVersion = await _readLocalVersion(paths.versionPath);

      final shouldDownload = config.forceCheck ||
          !hasRequiredFiles ||
          _isNewerVersion(remoteVersion, localVersion);

      if (!shouldDownload) {
        await _writeLastCheck(paths.lastCheckPath);
        onLog?.call('VXPack is up to date: $localVersion');

        return paths.copyWith(
          localVersion: localVersion,
          updated: false,
        );
      }

      onLog?.call('Downloading VXPack $remoteVersion');

      await _downloadToFile(
        client: client,
        url: vxpackUrl,
        outputPath: paths.vxpackPath,
        assetName: config.vxpackAssetName,
        config: config,
        onProgress: onProgress,
      );

      await _downloadToFile(
        client: client,
        url: keyUrl,
        outputPath: paths.keyPath,
        assetName: config.keyAssetName,
        config: config,
        onProgress: onProgress,
      );

      await _writeAtomic(paths.versionPath, utf8.encode(remoteVersionJson));
      await _writeLastCheck(paths.lastCheckPath);

      onLog?.call('VXPack updated to $remoteVersion');

      return paths.copyWith(
        localVersion: remoteVersion,
        updated: true,
      );
    } catch (e) {
      if (await _hasRequiredFiles(paths)) {
        onLog?.call('VXPack update failed, using cached definitions: $e');

        return paths.copyWith(
          localVersion: await _readLocalVersion(paths.versionPath),
          updated: false,
        );
      }

      rethrow;
    } finally {
      client.close();
    }
  }

  static Future<VxTitaniumDefsPaths> currentPaths({
    VxTitaniumDefsConfig config = const VxTitaniumDefsConfig(),
  }) async {
    final paths = await _paths(config);

    return paths.copyWith(
      localVersion: await _readLocalVersion(paths.versionPath),
      updated: false,
    );
  }

  static Future<void> clearCache({
    VxTitaniumDefsConfig config = const VxTitaniumDefsConfig(),
  }) async {
    final paths = await _paths(config);
    final dir = Directory(paths.baseDir);

    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  static Future<VxTitaniumDefsPaths> _paths(
    VxTitaniumDefsConfig config,
  ) async {
    final supportDir = await getApplicationSupportDirectory();
    final baseDir = p.join(supportDir.path, config.storageFolderName);
    final defsDir = p.join(baseDir, config.defsFolderName);

    return VxTitaniumDefsPaths(
      baseDir: baseDir,
      defsDir: defsDir,
      vxpackPath: p.join(defsDir, config.vxpackAssetName),
      keyPath: p.join(defsDir, config.keyAssetName),
      versionPath: p.join(defsDir, config.versionAssetName),
      lastCheckPath: p.join(baseDir, 'last_check.txt'),
      localVersion: '0.0.0',
      updated: false,
    );
  }

  static Future<bool> _hasRequiredFiles(VxTitaniumDefsPaths paths) async {
    final hasVxpack = await File(paths.vxpackPath).exists();
    final hasKey = await File(paths.keyPath).exists();

    return hasVxpack && hasKey;
  }

  static Future<bool> _isCheckDue(
    String lastCheckPath,
    Duration interval,
  ) async {
    final file = File(lastCheckPath);

    if (!await file.exists()) {
      return true;
    }

    final raw = (await file.readAsString()).trim();
    final last = DateTime.tryParse(raw);

    if (last == null) {
      return true;
    }

    return DateTime.now().toUtc().difference(last.toUtc()) >= interval;
  }

  static Future<void> _writeLastCheck(String path) async {
    await File(path).parent.create(recursive: true);
    await File(path).writeAsString(
      DateTime.now().toUtc().toIso8601String(),
      flush: true,
    );
  }

  static Future<Map<String, dynamic>> _fetchLatestRelease({
    required http.Client client,
    required VxTitaniumDefsConfig config,
  }) async {
    final uri = Uri.parse(config.latestReleaseUrl);

    final response = await client
        .get(uri, headers: _headers(config))
        .timeout(config.timeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'GitHub release request failed with HTTP ${response.statusCode}',
        uri: uri,
      );
    }

    final decoded = json.decode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid GitHub release response.');
    }

    return decoded;
  }

  static String? _assetUrl(Map<String, dynamic> release, String assetName) {
    final assets = release['assets'];

    if (assets is! List) {
      return null;
    }

    for (final asset in assets) {
      if (asset is Map<String, dynamic> &&
          asset['name'] == assetName &&
          asset['browser_download_url'] is String) {
        return asset['browser_download_url'] as String;
      }
    }

    return null;
  }

  static Future<String> _fetchText({
    required http.Client client,
    required String url,
    required VxTitaniumDefsConfig config,
  }) async {
    final uri = Uri.parse(url);

    final response = await client
        .get(uri, headers: _headers(config))
        .timeout(config.timeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'Download failed with HTTP ${response.statusCode}',
        uri: uri,
      );
    }

    return response.body;
  }

  static Future<void> _downloadToFile({
    required http.Client client,
    required String url,
    required String outputPath,
    required String assetName,
    required VxTitaniumDefsConfig config,
    VxTitaniumDefsProgress? onProgress,
  }) async {
    final uri = Uri.parse(url);
    final request = http.Request('GET', uri);
    request.headers.addAll(_headers(config));

    final response = await client.send(request).timeout(config.timeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'Download failed with HTTP ${response.statusCode}',
        uri: uri,
      );
    }

    final output = File(outputPath);
    await output.parent.create(recursive: true);

    final tmpPath = '$outputPath.tmp';
    final tmp = File(tmpPath);
    final sink = tmp.openWrite();

    var received = 0;
    final total = response.contentLength;

    try {
      await for (final chunk in response.stream) {
        received += chunk.length;
        sink.add(chunk);
        onProgress?.call(assetName, received, total);
      }
    } finally {
      await sink.close();
    }

    if (await output.exists()) {
      await output.delete();
    }

    await tmp.rename(outputPath);
  }

  static Future<void> _writeAtomic(String path, List<int> bytes) async {
    final output = File(path);
    await output.parent.create(recursive: true);

    final tmp = File('$path.tmp');
    await tmp.writeAsBytes(bytes, flush: true);

    if (await output.exists()) {
      await output.delete();
    }

    await tmp.rename(path);
  }

  static Future<String> _readLocalVersion(String versionPath) async {
    final file = File(versionPath);

    if (!await file.exists()) {
      return '0.0.0';
    }

    try {
      final raw = await file.readAsString();
      return _versionFromJson(raw);
    } catch (_) {
      return '0.0.0';
    }
  }

  static String _versionFromJson(String raw) {
    final decoded = json.decode(raw);

    if (decoded is Map<String, dynamic>) {
      final version = decoded['version']?.toString().trim();

      if (version != null && version.isNotEmpty) {
        return version;
      }
    }

    return '0.0.0';
  }

  static bool _isNewerVersion(String remote, String local) {
    final remoteParts = _parseVersion(remote);
    final localParts = _parseVersion(local);
    final length = remoteParts.length > localParts.length
        ? remoteParts.length
        : localParts.length;

    for (var i = 0; i < length; i++) {
      final a = i < remoteParts.length ? remoteParts[i] : 0;
      final b = i < localParts.length ? localParts[i] : 0;

      if (a > b) {
        return true;
      }

      if (a < b) {
        return false;
      }
    }

    return false;
  }

  static List<int> _parseVersion(String version) {
    return version
        .split('.')
        .map((part) => int.tryParse(part.trim()) ?? 0)
        .toList(growable: false);
  }

  static Map<String, String> _headers(VxTitaniumDefsConfig config) {
    return {
      'Accept': 'application/vnd.github+json',
      'User-Agent': config.userAgent,
    };
  }
}

extension on VxTitaniumDefsPaths {
  VxTitaniumDefsPaths copyWith({
    String? localVersion,
    bool? updated,
  }) {
    return VxTitaniumDefsPaths(
      baseDir: baseDir,
      defsDir: defsDir,
      vxpackPath: vxpackPath,
      keyPath: keyPath,
      versionPath: versionPath,
      lastCheckPath: lastCheckPath,
      localVersion: localVersion ?? this.localVersion,
      updated: updated ?? this.updated,
    );
  }
}
