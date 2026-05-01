import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../../services/pro_temp_service.dart';
import '../../services/purchase_service.dart';

class ApkReport {
  final String path;
  final String name;
  final String packageName;
  final bool extracted;
  final String engineLabel;
  final String fileSizeLabel;
  final String minSdkLabel;
  final String targetSdkLabel;
  final String signatureLabel;
  final String versionLabel;
  final List<String> permissions;
  final String summary;
  final List<String> unusualItems;
  final List<String> unverifiedItems;
  final Map<String, String> sources;
  final List<String> sourceNotes;
  final int? riskScore;
  final String? riskLabel;
  final String? hashVerdict;
  final String? scoreRationale;
  final List<String> contributingSignals;
  final List<String> dampeningFactors;
  final int savedAt;

  ApkReport({
    required this.path,
    required this.name,
    required this.packageName,
    required this.extracted,
    required this.engineLabel,
    required this.fileSizeLabel,
    required this.minSdkLabel,
    required this.targetSdkLabel,
    required this.signatureLabel,
    required this.versionLabel,
    required this.permissions,
    required this.summary,
    required this.unusualItems,
    required this.unverifiedItems,
    required this.sources,
    required this.sourceNotes,
    this.riskScore,
    this.riskLabel,
    this.hashVerdict,
    this.scoreRationale,
    this.contributingSignals = const [],
    this.dampeningFactors = const [],
    int? savedAt,
  }) : savedAt = savedAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'name': name,
      'packageName': packageName,
      'extracted': extracted,
      'engineLabel': engineLabel,
      'fileSizeLabel': fileSizeLabel,
      'minSdkLabel': minSdkLabel,
      'targetSdkLabel': targetSdkLabel,
      'signatureLabel': signatureLabel,
      'versionLabel': versionLabel,
      'permissions': permissions,
      'summary': summary,
      'unusualItems': unusualItems,
      'unverifiedItems': unverifiedItems,
      'sources': sources,
      'sourceNotes': sourceNotes,
      'riskScore': riskScore,
      'riskLabel': riskLabel,
      'hashVerdict': hashVerdict,
      'scoreRationale': scoreRationale,
      'contributingSignals': contributingSignals,
      'dampeningFactors': dampeningFactors,
      'savedAt': savedAt,
    };
  }

  factory ApkReport.fromJson(Map<String, dynamic> json) {
    return ApkReport(
      path: (json['path'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      packageName: (json['packageName'] ?? '').toString(),
      extracted: json['extracted'] == true,
      engineLabel: (json['engineLabel'] ?? '').toString(),
      fileSizeLabel: (json['fileSizeLabel'] ?? '').toString(),
      minSdkLabel: (json['minSdkLabel'] ?? '').toString(),
      targetSdkLabel: (json['targetSdkLabel'] ?? '').toString(),
      signatureLabel: (json['signatureLabel'] ?? '').toString(),
      versionLabel: (json['versionLabel'] ?? '').toString(),
      permissions: json['permissions'] is List
          ? (json['permissions'] as List).map((e) => e.toString()).toList()
          : <String>[],
      summary: (json['summary'] ?? '').toString(),
      unusualItems: json['unusualItems'] is List
          ? (json['unusualItems'] as List).map((e) => e.toString()).toList()
          : <String>[],
      unverifiedItems: json['unverifiedItems'] is List
          ? (json['unverifiedItems'] as List).map((e) => e.toString()).toList()
          : <String>[],
      sources: json['sources'] is Map
          ? (json['sources'] as Map).map((k, v) => MapEntry(k.toString(), v.toString()))
          : <String, String>{},
      sourceNotes: json['sourceNotes'] is List
          ? (json['sourceNotes'] as List).map((e) => e.toString()).toList()
          : <String>[],
      riskScore: json['riskScore'] is int ? json['riskScore'] as int : int.tryParse('${json['riskScore']}'),
      riskLabel: (json['riskLabel'] ?? '').toString().isNotEmpty ? json['riskLabel'].toString() : null,
      hashVerdict: (json['hashVerdict'] ?? '').toString().isNotEmpty ? json['hashVerdict'].toString() : null,
      scoreRationale: (json['scoreRationale'] ?? '').toString().isNotEmpty ? json['scoreRationale'].toString() : null,
      contributingSignals: json['contributingSignals'] is List
          ? (json['contributingSignals'] as List).map((e) => e.toString()).toList()
          : <String>[],
      dampeningFactors: json['dampeningFactors'] is List
          ? (json['dampeningFactors'] as List).map((e) => e.toString()).toList()
          : <String>[],
      savedAt: json['savedAt'] is int ? json['savedAt'] as int : int.tryParse('${json['savedAt']}'),
    );
  }
}

class ApkAnalyserController extends ChangeNotifier {
  static const String _apiUrl = 'https://api.colourswift.com/vtti/analyze';
  static const String _usageUrl = 'https://api.colourswift.com/vtti/usage';

  static const MethodChannel _apkChannel = MethodChannel('cs_apk_analyser');

  bool isLoggedIn = false;
  bool isPro = false;
  bool advancedModeEnabled = false;
  bool authResolved = false;
  bool analysing = false;

  String selectedApkPath = '';
  String selectedApkName = '';

  int? remainingGenerations;
  int? dailyLimit;
  bool usageFetched = false;

  ApkReport? report;
  List<ApkReport> savedReports = [];
  String loadingStage = '';

  Future<File> _getReportsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/apk_reports_history.json');
  }

  Future<void> _loadSavedReports() async {
    try {
      final file = await _getReportsFile();
      if (!await file.exists()) {
        savedReports = [];
        return;
      }

      final raw = await file.readAsString();
      final decoded = jsonDecode(raw);

      if (decoded is! List) {
        savedReports = [];
        return;
      }

      savedReports = decoded
          .whereType<Map>()
          .map((e) => ApkReport.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      savedReports.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    } catch (_) {
      savedReports = [];
    }
  }

  Future<void> _persistSavedReports() async {
    try {
      final file = await _getReportsFile();
      final data = savedReports.map((e) => e.toJson()).toList();
      await file.writeAsString(jsonEncode(data), flush: true);
    } catch (_) {}
  }

  Future<void> saveReportToHistory(ApkReport value) async {
    savedReports.removeWhere((r) =>
    r.packageName == value.packageName &&
        r.versionLabel == value.versionLabel &&
        r.summary == value.summary);

    savedReports.insert(0, value);

    if (savedReports.length > 100) {
      savedReports = savedReports.take(100).toList();
    }

    await _persistSavedReports();
    notifyListeners();
  }

  Future<void> clearSavedReports() async {
    savedReports = [];
    final file = await _getReportsFile();
    if (await file.exists()) {
      await file.delete();
    }
    notifyListeners();
  }

  HttpClientRequest? _activeRequest;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final userToken = (prefs.getString('cs_auth_token') ?? '').trim();
    final savedAdvancedMode = prefs.getBool('vtti_advanced_mode_enabled') ?? false;

    final cachedBillingPro = prefs.getBool('billing_is_pro') ?? false;
    final cachedServerSignedIn = prefs.getBool('billing_server_session_signed_in') ?? false;
    final cachedServerPro = prefs.getBool('billing_server_session_pro') ?? false;

    isLoggedIn = userToken.isNotEmpty;
    advancedModeEnabled = savedAdvancedMode;
    isPro = cachedBillingPro || (cachedServerSignedIn && cachedServerPro);
    authResolved = false;

    await _loadSavedReports();

    notifyListeners();

    await checkAuthAndPro();
  }

  Future<void> checkAuthAndPro() async {
    final prefs = await SharedPreferences.getInstance();
    final userToken = (prefs.getString('cs_auth_token') ?? '').trim();

    await PurchaseService.restore();
    final billingPro = await PurchaseService.hasPro();
    final gatePro = await ProGate.sync();

    final effectivePro = billingPro || gatePro;

    isLoggedIn = userToken.isNotEmpty;
    isPro = effectivePro;
    authResolved = true;

    if (!effectivePro) {
      advancedModeEnabled = false;
      await prefs.setBool('vtti_advanced_mode_enabled', false);
    }

    notifyListeners();

    if (userToken.isNotEmpty) {
      await _fetchUsage(userToken);
    }
  }

  Future<void> setAdvancedMode(bool value) async {
    if (!isPro) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vtti_advanced_mode_enabled', value);
    advancedModeEnabled = value;
    notifyListeners();
  }

  Future<void> _fetchUsage(String token) async {
    HttpClient? client;
    try {
      client = HttpClient();
      final request = await client.getUrl(Uri.parse(_usageUrl));
      request.headers.set('authorization', 'Bearer $token');
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        if (data['ok'] == true) {
          final usage = data['usage'];
          if (usage != null) {
            remainingGenerations = usage['remainingToday'];
            dailyLimit = usage['limit'];
          }
        }
      }
    } catch (_) {
    } finally {
      usageFetched = true;
      notifyListeners();
      client?.close();
    }
  }

  Future<void> pickApk() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: const ['apk'],
        withData: false,
      );

      if (result == null || result.files.isEmpty) return;

      final picked = result.files.first;
      final path = picked.path?.trim() ?? '';
      if (path.isNotEmpty) {
        selectedApkPath = path;
        selectedApkName = picked.name.isNotEmpty ? picked.name : _extractName(path);
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> pickInstalledApp() async {
    try {
      final String? path = await _apkChannel.invokeMethod('pickInstalledApp');
      if (path != null && path.isNotEmpty) {
        selectedApkPath = path;
        selectedApkName = _extractName(path);
        notifyListeners();
      }
    } catch (_) {}
  }

  String _extractName(String input) {
    final cleaned = input.trim();
    if (cleaned.isEmpty) return '';
    final normalized = cleaned.replaceAll('\\', '/');
    final parts = normalized.split('/');
    return parts.isEmpty ? cleaned : parts.last;
  }

  void cancelAnalysis() {
    _activeRequest?.abort();
    _activeRequest = null;
    analysing = false;
    report = null;
    notifyListeners();
  }

  void selectTarget(String path, String name) {
    selectedApkPath = path;
    selectedApkName = name;
    notifyListeners();
  }

  Future<void> analyseApk(BuildContext context, VoidCallback onSuccess) async {
    if (analysing || selectedApkPath.isEmpty) return;

    analysing = true;
    report = null;
    loadingStage = 'Deconstructing APK';
    notifyListeners();

    HttpClient? client;

    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      final payload = await _apkChannel.invokeMethod('extractApkEvidence', {'apkPath': selectedApkPath});
      if (!analysing) return;

      loadingStage = 'Analysing content';
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!analysing) return;

      await checkAuthAndPro();
      final normalizedPayload = _normalizePayload(payload);

      final prefs = await SharedPreferences.getInstance();
      final userToken = (prefs.getString('cs_auth_token') ?? '').trim();

      if (userToken.isEmpty) {
        throw PlatformException(code: 'UNAUTHORIZED', message: 'Please sign in via Settings to use Cloud Analysis.');
      }

      loadingStage = 'Checking VTTI Cloud';
      notifyListeners();
      if (!analysing) return;

      client = HttpClient();
      _activeRequest = await client.postUrl(Uri.parse(_apiUrl));
      _activeRequest!.headers.set('content-type', 'application/json');
      _activeRequest!.headers.set('authorization', 'Bearer $userToken');
      _activeRequest!.add(utf8.encode(jsonEncode(normalizedPayload)));

      final response = await _activeRequest!.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (!analysing) return;
      _activeRequest = null;
      final cloudResponse = jsonDecode(responseBody);

      if (response.statusCode == 429) {
        final limit = cloudResponse['limit'];
        remainingGenerations = 0;
        dailyLimit = limit;
        notifyListeners();
        throw PlatformException(code: 'RATE_LIMIT', message: 'You have reached your daily limit of $limit analyses.');
      }

      if (response.statusCode != 200 || cloudResponse['ok'] != true) {
        throw PlatformException(code: 'CLOUD_ERROR', message: cloudResponse['error'] ?? 'Cloud analysis failed');
      }

      final usage = cloudResponse['usage'];
      if (usage != null && usage['remainingToday'] != null) {
        remainingGenerations = usage['remainingToday'] as int?;
        dailyLimit = usage['limit'] as int?;
      }

      loadingStage = 'Generating report';
      notifyListeners();
      if (!analysing) return;

      final cloudOuter = cloudResponse['result'] is Map
          ? cloudResponse['result'] as Map<dynamic, dynamic>
          : <dynamic, dynamic>{};

      report = _buildReportFromCloud(selectedApkPath, normalizedPayload, cloudOuter);
      await saveReportToHistory(report!);

      analysing = false;
      notifyListeners();

      onSuccess();

    } catch (e) {
      if (!analysing) return;
      analysing = false;
      report = null;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e is PlatformException ? (e.message ?? 'Error') : 'Failed to process APK analysis')),
        );
      }
    } finally {
      client?.close();
      _activeRequest = null;
    }
  }

  List<String> _extractHashes(Map<dynamic, dynamic> evidenceRaw) {
    final hashes = <String>{};

    void addIfNotEmpty(Object? value) {
      if (value is String && value.trim().isNotEmpty) {
        hashes.add(value.trim().toLowerCase());
      }
    }

    final fileInfo = evidenceRaw['file_info'];
    if (fileInfo is Map) {
      addIfNotEmpty(fileInfo['sha256']);
      addIfNotEmpty(fileInfo['md5']);
    }

    final signingInfo = evidenceRaw['signing_info'];
    if (signingInfo is Map) {
      final certs = signingInfo['certificates'];
      if (certs is List) {
        for (final cert in certs) {
          if (cert is Map) {
            addIfNotEmpty(cert['sha256']);
            addIfNotEmpty(cert['md5']);
          }
        }
      }
    }

    return hashes.toList();
  }

  Map<String, dynamic> _normalizePayload(dynamic payload) {
    final root = payload is Map ? payload.cast<dynamic, dynamic>() : <dynamic, dynamic>{};
    final appRaw = root['app'] is Map ? (root['app'] as Map).cast<dynamic, dynamic>() : <dynamic, dynamic>{};
    final evidenceRaw = root['evidence'] is Map ? (root['evidence'] as Map).cast<dynamic, dynamic>() : <dynamic, dynamic>{};

    final hashes = _extractHashes(evidenceRaw);

    return {
      'advanced_mode': isPro && advancedModeEnabled,
      'app': {
        'package_name': (appRaw['package_name'] ?? '').toString(),
        'app_name': (appRaw['app_name'] ?? '').toString(),
        'developer_name': (appRaw['developer_name'] ?? '').toString(),
        'version_name': (appRaw['version_name'] ?? '').toString(),
        'version_code': (appRaw['version_code'] ?? '').toString(),
      },
      'evidence': Map<String, dynamic>.from(
        evidenceRaw.map((key, value) => MapEntry(key.toString(), value)),
      ),
      if (hashes.isNotEmpty) 'hashes': hashes,
    };
  }

  ApkReport _buildReportFromCloud(
      String path,
      Map<String, dynamic> localPayload,
      Map<dynamic, dynamic> cloudOuter,
      ) {
    final aiResult = (cloudOuter['result'] as Map?)?.cast<dynamic, dynamic>() ?? <dynamic, dynamic>{};
    final sourcesData = (cloudOuter['discovered_sources'] as Map?)?.cast<dynamic, dynamic>() ?? <dynamic, dynamic>{};

    final app = (aiResult['app'] as Map?)?.cast<dynamic, dynamic>()
        ?? (localPayload['app'] as Map).cast<dynamic, dynamic>();
    final evidence = (aiResult['evidence'] as Map?)?.cast<dynamic, dynamic>()
        ?? (localPayload['evidence'] as Map).cast<dynamic, dynamic>();

    final requestedPermissionsRaw = evidence['requested_permissions'];
    final requestedPermissions = requestedPermissionsRaw is List
        ? requestedPermissionsRaw.map((e) => e.toString()).toList()
        : <String>[];

    final signingInfo = (evidence['signing_info'] as Map?)?.cast<dynamic, dynamic>() ?? <dynamic, dynamic>{};
    final certsRaw = signingInfo['certificates'];
    final certs = certsRaw is List ? certsRaw : const [];

    final Map<String, String> sources = {};
    final playUrl = (sourcesData['play_listing_url'] ?? '').toString();
    final webUrl = (sourcesData['official_website_url'] ?? '').toString();
    if (playUrl.isNotEmpty) sources['Google Play'] = playUrl;
    if (webUrl.isNotEmpty) sources['Official Website'] = webUrl;

    final malwareRaw = (aiResult['malware_assessment'] as Map?)?.cast<dynamic, dynamic>() ?? <dynamic, dynamic>{};
    final riskScore = malwareRaw['risk_score'] as int?;
    final riskLabel = (malwareRaw['risk_label'] ?? '').toString().isNotEmpty
        ? malwareRaw['risk_label'].toString()
        : null;
    final hashVerdict = (malwareRaw['hash_verdict'] ?? '').toString().isNotEmpty
        ? malwareRaw['hash_verdict'].toString()
        : null;
    final scoreRationale = (malwareRaw['score_rationale'] ?? '').toString().isNotEmpty
        ? malwareRaw['score_rationale'].toString()
        : null;
    final contributingSignals = malwareRaw['contributing_signals'] is List
        ? (malwareRaw['contributing_signals'] as List).map((e) => e.toString()).toList()
        : <String>[];
    final dampeningFactors = malwareRaw['dampening_factors'] is List
        ? (malwareRaw['dampening_factors'] as List).map((e) => e.toString()).toList()
        : <String>[];

    return ApkReport(
      path: path,
      name: (app['app_name'] ?? '').toString().isNotEmpty
          ? app['app_name'].toString()
          : _extractName(path),
      packageName: (app['package_name'] ?? '').toString(),
      extracted: true,
      engineLabel: 'VTTI Cloud Engine',
      fileSizeLabel: _formatBytes(
        ((evidence['file_info'] as Map?)?.cast<dynamic, dynamic>() ?? {})['apk_size_bytes'] as int? ?? 0,
      ),
      minSdkLabel: (evidence['min_sdk'] ?? 'Unknown').toString(),
      targetSdkLabel: (evidence['target_sdk'] ?? 'Unknown').toString(),
      signatureLabel: certs.isNotEmpty ? 'Certificate detected' : 'No certificate data',
      versionLabel: (app['version_name'] ?? 'Unknown').toString(),
      permissions: requestedPermissions,
      summary: (aiResult['summary'] ?? 'No summary generated.').toString(),
      unusualItems: aiResult['odd_or_unusual_items'] is List
          ? (aiResult['odd_or_unusual_items'] as List).map((e) => e.toString()).toList()
          : [],
      unverifiedItems: aiResult['unverified_items'] is List
          ? (aiResult['unverified_items'] as List).map((e) => e.toString()).toList()
          : [],
      sources: sources,
      sourceNotes: sourcesData['notes'] is List
          ? (sourcesData['notes'] as List).map((e) => e.toString()).toList()
          : [],
      riskScore: riskScore,
      riskLabel: riskLabel,
      hashVerdict: hashVerdict,
      scoreRationale: scoreRationale,
      contributingSignals: contributingSignals,
      dampeningFactors: dampeningFactors,
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return 'Unknown';
    const units = ['B', 'KB', 'MB', 'GB'];
    double size = bytes.toDouble();
    int unitIndex = 0;
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    return '${size.toStringAsFixed(size >= 100 || unitIndex == 0 ? 0 : 1)} ${units[unitIndex]}';
  }
}