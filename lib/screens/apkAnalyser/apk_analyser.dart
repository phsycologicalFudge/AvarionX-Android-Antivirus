import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/pro_temp_service.dart';
import '../../services/purchase_service.dart';
import '../pro/pro_screen.dart';

class ApkAnalyserScreen extends StatefulWidget {
  const ApkAnalyserScreen({super.key});

  @override
  State<ApkAnalyserScreen> createState() => _ApkAnalyserScreenState();
}

class _ApkAnalyserScreenState extends State<ApkAnalyserScreen> with SingleTickerProviderStateMixin {
  static const String _apiUrl = 'https://api.colourswift.com/vtti/analyze';
  static const String _usageUrl = 'https://api.colourswift.com/vtti/usage';

  static const MethodChannel _apkChannel = MethodChannel('cs_apk_analyser');

  late final TabController _tabs;

  static bool _isLoggedIn = false;
  static bool _isPro = false;
  static bool _advancedModeEnabled = false;
  static bool _authResolved = false;
  static bool _analysing = false;
  static bool _reportUnlocked = false;

  static String _selectedApkPath = '';
  static String _selectedApkName = '';

  static int? _remainingGenerations;
  static int? _dailyLimit;
  static bool _usageFetched = false;

  static _ApkReport? _report;

  HttpClientRequest? _activeRequest;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(
      length: 2,
      vsync: this,
      initialIndex: _reportUnlocked ? 1 : 0,
    );
    _restoreLocalStateThenCheckAuth();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _restoreLocalStateThenCheckAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final userToken = (prefs.getString('cs_auth_token') ?? '').trim();
    final savedAdvancedMode = prefs.getBool('vtti_advanced_mode_enabled') ?? false;

    final cachedBillingPro = prefs.getBool('billing_is_pro') ?? false;
    final cachedServerSignedIn = prefs.getBool('billing_server_session_signed_in') ?? false;
    final cachedServerPro = prefs.getBool('billing_server_session_pro') ?? false;

    final cachedEffective = cachedBillingPro || (cachedServerSignedIn && cachedServerPro);

    if (!mounted) return;
    setState(() {
      _isLoggedIn = userToken.isNotEmpty;
      _advancedModeEnabled = savedAdvancedMode;
      _isPro = cachedEffective;
      _authResolved = false;
    });

    await _checkAuthAndPro();
  }

  Future<void> _setAdvancedMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vtti_advanced_mode_enabled', value);

    if (!mounted) return;
    setState(() {
      _advancedModeEnabled = value;
    });
  }

  Future<void> _fetchUsage(String token) async {
    HttpClient? client;
    try {
      client = HttpClient();
      final request = await client.getUrl(Uri.parse(_usageUrl));
      request.headers.set('authorization', 'Bearer $token');
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) {
        debugPrint('Usage Fetch Failed: ${response.statusCode} - $responseBody');
        if (mounted) {
          setState(() {
            _usageFetched = true;
          });
        }
        return;
      }

      final data = jsonDecode(responseBody);
      if (data['ok'] == true) {
        final usage = data['usage'];
        if (usage != null && mounted) {
          setState(() {
            _remainingGenerations = usage['remainingToday'];
            _dailyLimit = usage['limit'];
            _usageFetched = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Usage Fetch Error: $e');
      if (mounted) {
        setState(() {
          _usageFetched = true;
        });
      }
    } finally {
      client?.close();
    }
  }

  Future<void> _checkAuthAndPro() async {
    final prefs = await SharedPreferences.getInstance();
    final userToken = (prefs.getString('cs_auth_token') ?? '').trim();

    await PurchaseService.restore();
    final billingPro = await PurchaseService.hasPro();
    final gatePro = await ProGate.sync();
    final effectivePro = billingPro || gatePro;

    if (!mounted) return;
    setState(() {
      _isLoggedIn = userToken.isNotEmpty;
      _isPro = effectivePro;
      _authResolved = true;
      if (!effectivePro) {
        _advancedModeEnabled = false;
      }
    });

    if (!effectivePro) {
      await prefs.setBool('vtti_advanced_mode_enabled', false);
    }

    if (userToken.isNotEmpty) {
      await _fetchUsage(userToken);
    }
  }

  Future<void> _showUpgradeDialog() async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProScreen()),
    );
    await _checkAuthAndPro();
  }

  void _tryOpenViewTab(int index) {
    _tabs.animateTo(index);
  }

  Future<void> _mockPickApk() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: const ['apk'],
        withData: false,
      );

      if (!mounted || result == null || result.files.isEmpty) return;

      final picked = result.files.first;
      final path = picked.path?.trim() ?? '';
      if (path.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not read selected APK path')),
        );
        return;
      }

      setState(() {
        _selectedApkPath = path;
        _selectedApkName = picked.name.isNotEmpty ? picked.name : _extractName(path);
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to open file picker')),
      );
    }
  }

  String _extractName(String input) {
    final cleaned = input.trim();
    if (cleaned.isEmpty) return '';
    final normalized = cleaned.replaceAll('\\', '/');
    final parts = normalized.split('/');
    return parts.isEmpty ? cleaned : parts.last;
  }

  _ApkReport _buildReportFromCloud(String path, Map<String, dynamic> localPayload, Map<dynamic, dynamic> cloudOuter) {
    final aiResult = (cloudOuter['result'] as Map?)?.cast<dynamic, dynamic>() ?? <dynamic, dynamic>{};
    final sourcesData = (cloudOuter['discovered_sources'] as Map?)?.cast<dynamic, dynamic>() ?? <dynamic, dynamic>{};

    final app = (aiResult['app'] as Map?)?.cast<dynamic, dynamic>() ?? (localPayload['app'] as Map).cast<dynamic, dynamic>();
    final evidence = (aiResult['evidence'] as Map?)?.cast<dynamic, dynamic>() ?? (localPayload['evidence'] as Map).cast<dynamic, dynamic>();

    final packageName = (app['package_name'] ?? '').toString();
    final appName = (app['app_name'] ?? '').toString();
    final versionName = (app['version_name'] ?? '').toString();

    final requestedPermissionsRaw = evidence['requested_permissions'];
    final requestedPermissions = requestedPermissionsRaw is List
        ? requestedPermissionsRaw.map((e) => e.toString()).toList()
        : <String>[];

    final signingInfo = (evidence['signing_info'] as Map?)?.cast<dynamic, dynamic>() ?? <dynamic, dynamic>{};
    final fileInfo = (evidence['file_info'] as Map?)?.cast<dynamic, dynamic>() ?? <dynamic, dynamic>{};

    final minSdk = (evidence['min_sdk'] ?? '').toString();
    final targetSdk = (evidence['target_sdk'] ?? '').toString();
    final fileSizeBytes = (fileInfo['apk_size_bytes'] as num?)?.toInt() ?? 0;
    final certsRaw = signingInfo['certificates'];
    final certs = certsRaw is List ? certsRaw : const [];

    final hasSignature = certs.isNotEmpty;

    final summary = (aiResult['summary'] ?? '').toString();

    final oddRaw = aiResult['odd_or_unusual_items'];
    final unusualItems = oddRaw is List ? oddRaw.map((e) => e.toString()).toList() : <String>[];

    final unverifiedRaw = aiResult['unverified_items'];
    final unverifiedItems = unverifiedRaw is List ? unverifiedRaw.map((e) => e.toString()).toList() : <String>[];

    final sourceNotesRaw = sourcesData['notes'];
    final sourceNotes = sourceNotesRaw is List ? sourceNotesRaw.map((e) => e.toString()).toList() : <String>[];

    final Map<String, String> sources = {};
    final playUrl = (sourcesData['play_listing_url'] ?? '').toString();
    final webUrl = (sourcesData['official_website_url'] ?? '').toString();
    final privacyUrl = (sourcesData['privacy_policy_url'] ?? '').toString();
    final repoUrl = (sourcesData['official_repo_url'] ?? '').toString();

    if (playUrl.isNotEmpty) sources['Google Play'] = playUrl;
    if (webUrl.isNotEmpty) sources['Official Website'] = webUrl;
    if (privacyUrl.isNotEmpty) sources['Privacy Policy'] = privacyUrl;
    if (repoUrl.isNotEmpty) sources['Repository'] = repoUrl;

    return _ApkReport(
      path: path,
      name: appName.isNotEmpty ? appName : _extractName(path),
      packageName: packageName.isNotEmpty ? packageName : 'unknown.package',
      extracted: true,
      engineLabel: 'VTTI Cloud Engine',
      fileSizeLabel: _formatBytes(fileSizeBytes),
      minSdkLabel: minSdk.isEmpty ? 'Unknown' : minSdk,
      targetSdkLabel: targetSdk.isEmpty ? 'Unknown' : targetSdk,
      signatureLabel: hasSignature ? 'Certificate detected' : 'No certificate data',
      versionLabel: versionName.isEmpty ? 'Unknown' : versionName,
      permissions: requestedPermissions,
      summary: summary.isNotEmpty ? summary : 'No summary generated.',
      unusualItems: unusualItems,
      unverifiedItems: unverifiedItems,
      sources: sources,
      sourceNotes: sourceNotes,
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

  Map<String, dynamic> _normalizePayload(dynamic payload) {
    final root = payload is Map ? payload.cast<dynamic, dynamic>() : <dynamic, dynamic>{};

    final appRaw = root['app'] is Map
        ? (root['app'] as Map).cast<dynamic, dynamic>()
        : <dynamic, dynamic>{};

    final evidenceRaw = root['evidence'] is Map
        ? (root['evidence'] as Map).cast<dynamic, dynamic>()
        : <dynamic, dynamic>{};

    return {
      'advanced_mode': _isPro && _advancedModeEnabled,
      'app': {
        'package_name': (appRaw['package_name'] ?? '').toString(),
        'app_name': (appRaw['app_name'] ?? '').toString(),
        'developer_name': (appRaw['developer_name'] ?? '').toString(),
        'version_name': (appRaw['version_name'] ?? '').toString(),
        'version_code': (appRaw['version_code'] ?? '').toString(),
      },
      'evidence': Map<String, dynamic>.from(
        evidenceRaw.map(
              (key, value) => MapEntry(key.toString(), value),
        ),
      ),
    };
  }

  void _cancelAnalysis() {
    _activeRequest?.abort();
    _activeRequest = null;
    if (mounted) {
      setState(() {
        _analysing = false;
        _report = null;
        _reportUnlocked = false;
      });
    }
  }

  Future<void> _analyseApk() async {
    if (_analysing) return;
    if (_selectedApkPath.isEmpty) return;

    setState(() {
      _analysing = true;
      _report = null;
      _reportUnlocked = false;
    });

    bool dialogOpen = true;
    final ValueNotifier<String> loadingStage = ValueNotifier('Deconstructing APK');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Analysing APK', style: TextStyle(fontWeight: FontWeight.bold)),
        content: ValueListenableBuilder<String>(
          valueListenable: loadingStage,
          builder: (context, stageText, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                Text(
                  stageText,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This will take a few minutes. Feel free to run this in the background while AvarionX completes the analysis.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _cancelAnalysis();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Run in Background'),
          ),
        ],
      ),
    ).then((_) {
      dialogOpen = false;
      loadingStage.dispose();
    });

    HttpClient? client;

    try {
      await Future.delayed(const Duration(milliseconds: 1200));

      final payload = await _apkChannel.invokeMethod(
        'extractApkEvidence',
        {'apkPath': _selectedApkPath},
      );

      if (!_analysing) return;

      loadingStage.value = 'Analysing content';
      await Future.delayed(const Duration(milliseconds: 1500));

      if (!_analysing) return;

      await _checkAuthAndPro();
      final normalizedPayload = _normalizePayload(payload);

      final prefs = await SharedPreferences.getInstance();
      final userToken = (prefs.getString('cs_auth_token') ?? '').trim();

      if (userToken.isEmpty) {
        throw PlatformException(
          code: 'UNAUTHORIZED',
          message: 'Please sign in via Settings to use Cloud Analysis.',
        );
      }

      loadingStage.value = 'Checking VTTI Cloud';
      await Future.delayed(const Duration(milliseconds: 800));

      if (!_analysing) return;

      client = HttpClient();
      _activeRequest = await client.postUrl(Uri.parse(_apiUrl));
      _activeRequest!.headers.set('content-type', 'application/json');
      _activeRequest!.headers.set('authorization', 'Bearer $userToken');
      _activeRequest!.add(utf8.encode(jsonEncode(normalizedPayload)));

      final response = await _activeRequest!.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (!_analysing) return;

      _activeRequest = null;
      final cloudResponse = jsonDecode(responseBody);

      if (response.statusCode == 429) {
        final used = cloudResponse['usedToday'];
        final limit = cloudResponse['limit'];
        if (mounted) {
          setState(() {
            _remainingGenerations = 0;
            _dailyLimit = limit;
          });
        }
        throw PlatformException(
          code: 'RATE_LIMIT',
          message: limit != null ? 'You have reached your daily limit of $limit free analyses. Upgrade to Pro for unlimited access.' : 'You have reached your daily limit.',
        );
      }

      if (response.statusCode != 200 || cloudResponse['ok'] != true) {
        String errorMsg = cloudResponse['error'] ?? 'Cloud analysis failed';

        if (cloudResponse['upstream'] != null) {
          errorMsg += ' - ${jsonEncode(cloudResponse['upstream'])}';
        }
        throw PlatformException(
          code: 'CLOUD_ERROR',
          message: errorMsg,
        );
      }

      final usage = cloudResponse['usage'];
      if (usage != null && usage['remainingToday'] != null) {
        _remainingGenerations = usage['remainingToday'] as int?;
        _dailyLimit = usage['limit'] as int?;
      }

      final cloudOuter = cloudResponse['result'] is Map
          ? cloudResponse['result'] as Map<dynamic, dynamic>
          : <dynamic, dynamic>{};

      loadingStage.value = 'Generating report';
      await Future.delayed(const Duration(milliseconds: 1200));

      if (!_analysing) return;

      final report = _buildReportFromCloud(
        _selectedApkPath,
        normalizedPayload,
        cloudOuter,
      );

      if (!mounted) return;

      setState(() {
        _analysing = false;
        _report = report;
        _reportUnlocked = true;
      });

      if (dialogOpen) {
        Navigator.of(context).pop();
      }

      _tryOpenViewTab(1);

    } on PlatformException catch (e) {
      if (!_analysing || !mounted) return;
      setState(() {
        _analysing = false;
        _report = null;
        _reportUnlocked = false;
      });

      if (dialogOpen) {
        Navigator.of(context).pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to complete cloud analysis')),
      );
    } catch (e) {
      if (!_analysing || !mounted) return;
      setState(() {
        _analysing = false;
        _report = null;
        _reportUnlocked = false;
      });

      if (dialogOpen) {
        Navigator.of(context).pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to process APK analysis')),
      );
    } finally {
      client?.close();
      _activeRequest = null;
    }
  }

  Widget _analyseTab(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    String title = _analysing ? 'Analysing APK' : 'Ready to analyse';
    String detail = _analysing
        ? 'Processing package securely in the background.'
        : 'Select an APK to run VTTI Cloud analysis.';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Analyse',
                  style: text.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Upload metadata directly to VTTI Cloud for advanced threat analysis.',
                  style: text.bodySmall?.copyWith(
                    height: 1.35,
                    color: text.bodySmall?.color?.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: (_analysing || !_isLoggedIn) ? null : _mockPickApk,
                        icon: const Icon(Icons.folder_open_rounded, size: 18),
                        label: const Text('Choose APK'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: (_analysing || !_isLoggedIn || _selectedApkPath.isEmpty || (_usageFetched && _remainingGenerations != null && _remainingGenerations! <= 0)) ? null : _analyseApk,
                        icon: Icon(
                          _analysing ? Icons.cloud_sync_rounded : Icons.cloud_upload_rounded,
                          size: 18,
                        ),
                        label: Text(_analysing ? 'Analysing' : 'Analyse APK'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!_isLoggedIn)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Center(
                      child: Text(
                        'Please sign in via Settings to enable Cloud Analysis.',
                        style: text.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Card(
                  color: theme.colorScheme.surfaceContainerHigh,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: _analysing
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          detail,
                          style: text.bodySmall?.copyWith(
                            height: 1.35,
                            color: text.bodySmall?.color?.withOpacity(0.75),
                          ),
                        ),
                        if (_selectedApkName.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              _selectedApkName,
                              style: text.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface.withOpacity(0.88),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 10),
                  child: Text(
                    'ADVANCED OPTIONS',
                    style: text.labelSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
                Card(
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (!_isPro && !_analysing) {
                        _showUpgradeDialog();
                      } else if (_isPro && !_analysing && _authResolved) {
                        _setAdvancedMode(!_advancedModeEnabled);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Deep analysis mode',
                                  style: text.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: theme.colorScheme.onSurface.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _isPro
                                      ? 'A more complex analysis using global data sources'
                                      : 'Requires Pro to unlock deeper analysis',
                                  style: text.bodySmall?.copyWith(
                                    color: !_isPro
                                        ? theme.colorScheme.primary
                                        : text.bodySmall?.color?.withOpacity(0.7),
                                    fontWeight: !_isPro ? FontWeight.w600 : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isPro && _advancedModeEnabled,
                            onChanged: (!_isPro || _analysing || !_authResolved)
                                ? null
                                : (value) async {
                              await _setAdvancedMode(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Powered by VTTI Cloud',
            style: text.bodySmall?.copyWith(
              fontSize: 11,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.32),
            ),
          ),
        ),
      ],
    );
  }

  Widget _reportTab(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final report = _report;

    if (!_reportUnlocked || report == null) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report',
              style: text.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Analyse an APK first to unlock the cloud report.',
              style: text.bodySmall?.copyWith(
                height: 1.35,
                color: text.bodySmall?.color?.withOpacity(0.75),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analysis Results',
            style: text.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            color: theme.colorScheme.surfaceContainerHigh,
            elevation: 10,
            shadowColor: Colors.black.withOpacity(0.25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._buildReportParagraphs(
                    report.summary,
                    text.bodyMedium?.copyWith(
                      height: 1.5,
                      color: theme.colorScheme.onSurface.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (report.sources.isNotEmpty || report.sourceNotes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Card(
              color: theme.colorScheme.surfaceContainerHigh,
              elevation: 10,
              shadowColor: Colors.black.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discovered Sources',
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'External URLs and claims verified by the cloud engine.',
                      style: text.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...report.sources.entries.map((e) => _infoRow(context, e.key, e.value)),
                    if (report.sourceNotes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ...report.sourceNotes.map((n) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline_rounded, size: 16, color: Colors.amber),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  n,
                                  style: text.bodySmall?.copyWith(
                                    height: 1.35,
                                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Card(
            color: theme.colorScheme.surfaceContainerHigh,
            elevation: 10,
            shadowColor: Colors.black.withOpacity(0.25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  'Permissions',
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface.withOpacity(0.9),
                  ),
                ),
                subtitle: Text(
                  'Requested capabilities extracted from the manifest.',
                  style: text.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        if (report.permissions.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              'No requested permissions extracted.',
                              style: text.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          )
                        else
                          ...report.permissions.map((p) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  p,
                                  style: text.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface.withOpacity(0.85),
                                  ),
                                ),
                              ),
                            );
                          }),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (report.unusualItems.isNotEmpty || report.unverifiedItems.isNotEmpty) ...[
            const SizedBox(height: 12),
            Card(
              color: theme.colorScheme.surfaceContainerHigh,
              elevation: 10,
              shadowColor: Colors.black.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Extra Flags',
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Additional warnings or unverified claims flagged by the AI.',
                      style: text.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...report.unusualItems.map((f) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 18, color: Colors.orange),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                f,
                                style: text.bodySmall?.copyWith(
                                  height: 1.35,
                                  color: text.bodySmall?.color?.withOpacity(0.85),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    ...report.unverifiedItems.map((f) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.help_outline_rounded, size: 18, color: Colors.grey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                f,
                                style: text.bodySmall?.copyWith(
                                  height: 1.35,
                                  color: text.bodySmall?.color?.withOpacity(0.75),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Card(
            color: theme.colorScheme.surfaceContainerHigh,
            elevation: 10,
            shadowColor: Colors.black.withOpacity(0.25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cloud Metadata',
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Raw technical data extracted directly from the package binary.',
                    style: text.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _infoRow(context, 'Package', report.name),
                  _infoRow(context, 'Package ID', report.packageName),
                  _infoRow(context, 'Engine', report.engineLabel),
                  _infoRow(context, 'Size', report.fileSizeLabel),
                  _infoRow(context, 'Min SDK', report.minSdkLabel),
                  _infoRow(context, 'Target SDK', report.targetSdkLabel),
                  _infoRow(context, 'Signature', report.signatureLabel),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildReportParagraphs(String text, TextStyle? style) {
    final normalized = text.replaceAll('\r\n', '\n').trim();

    if (normalized.isEmpty) {
      return [
        Text(
          'No summary generated.',
          style: style,
        ),
      ];
    }

    final paragraphs = normalized
        .split(RegExp(r'\n\s*\n'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    if (paragraphs.isEmpty) {
      return [
        Text(
          normalized,
          style: style,
        ),
      ];
    }

    final widgets = <Widget>[];

    for (int i = 0; i < paragraphs.length; i++) {
      widgets.add(
        Text(
          paragraphs[i],
          textAlign: TextAlign.start,
          style: style,
        ),
      );

      if (i != paragraphs.length - 1) {
        widgets.add(const SizedBox(height: 14));
      }
    }

    return widgets;
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: text.bodySmall?.copyWith(
                color: text.bodySmall?.color?.withOpacity(0.58),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: text.bodySmall?.copyWith(
                height: 1.35,
                color: theme.colorScheme.onSurface.withOpacity(0.84),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final reportTabOpacity = (_report != null) ? 1.0 : 0.45;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: const Text('APK Analyser'),
        actions: [
          if (_isLoggedIn)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_queue_rounded, size: 14, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                      const SizedBox(width: 6),
                      if (!_usageFetched)
                        SizedBox(
                          height: 12,
                          width: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        )
                      else if (_remainingGenerations == null)
                        Text(
                          'Unlimited',
                          style: text.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.primary,
                          ),
                        )
                      else
                        Text(
                          '$_remainingGenerations / $_dailyLimit',
                          style: text.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: _remainingGenerations! > 0
                                ? theme.colorScheme.primary
                                : theme.colorScheme.error,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabs,
          onTap: _tryOpenViewTab,
          tabs: [
            const Tab(text: 'Analyse'),
            Tab(
              child: Opacity(
                opacity: reportTabOpacity,
                child: const Text('Report'),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _analyseTab(context),
          _reportTab(context),
        ],
      ),
    );
  }
}

class _ApkReport {
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

  _ApkReport({
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
  });
}