import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/theme/theme_manager.dart';
import '../../widgets/mesh_background.dart';
import '../settings/widgets/settings_section_header.dart';

import '../../translations/app_localizations.dart';
enum DeviceSecurityCategory {
  health,
  recommendations,
}

enum DeviceSecurityRiskLevel {
  caution,
  danger,
}

class DeviceSecuritySummary {
  final int activeRiskCount;
  final int ignoredRiskCount;

  const DeviceSecuritySummary({
    required this.activeRiskCount,
    required this.ignoredRiskCount,
  });

  const DeviceSecuritySummary.empty()
      : activeRiskCount = 0,
        ignoredRiskCount = 0;

  bool get hasRisk => activeRiskCount > 0;

  String homeLabel(AppLocalizations l10n) {
    if (activeRiskCount == 0) return l10n.deviceSecurityNoRisksFound;
    if (activeRiskCount == 1) return l10n.deviceSecurityOneCheckNeedsAttention;
    return l10n.deviceSecurityChecksNeedAttention(activeRiskCount);
  }
}

class DeviceSecurityScreen extends StatefulWidget {
  const DeviceSecurityScreen({super.key});

  static Future<DeviceSecuritySummary> loadSummary(AppLocalizations l10n) async {
    final signals = await DeviceSecuritySignalLoader.loadSignals(l10n);
    final active = signals.where((s) => s.active && !s.ignored).length;
    final ignored = signals.where((s) => s.active && s.ignored).length;

    return DeviceSecuritySummary(
      activeRiskCount: active,
      ignoredRiskCount: ignored,
    );
  }

  @override
  State<DeviceSecurityScreen> createState() => _DeviceSecurityScreenState();
}

class _DeviceSecurityScreenState extends State<DeviceSecurityScreen> {
  List<DeviceSecuritySignal> _signals = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSignals();
  }

  Future<void> _loadSignals() async {
    final signals = await DeviceSecuritySignalLoader.loadSignals(
      AppLocalizations.of(context)!,
    );

    if (!mounted) return;
    setState(() {
      _signals = signals;
      _loading = false;
    });
  }

  Future<void> _openDetails(DeviceSecuritySignal signal) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DeviceSecurityDetailScreen(signal: signal),
      ),
    );

    if (!mounted) return;
    await _loadSignals();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    final healthSignals = _signals
        .where((s) => s.category == DeviceSecurityCategory.health)
        .toList();

    final recommendationSignals = _signals
        .where((s) => s.category == DeviceSecurityCategory.recommendations)
        .toList();

    final activeRisks = _signals.where((s) => s.active && !s.ignored).length;
    final ignoredRisks = _signals.where((s) => s.active && s.ignored).length;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.deviceSecurityDeviceSecurity,
          style: text.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: MeshBackground(
        blobs: themeManager.meshBlobs,
        base: scheme.surface,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadSignals,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DeviceSecuritySummaryCard(
                    loading: _loading,
                    activeRisks: activeRisks,
                    ignoredRisks: ignoredRisks,
                  ),
                  const SizedBox(height: 18),
                   SettingsSectionHeader(title: AppLocalizations.of(context)!.deviceSecurityDeviceHealthStatus),
                  const SizedBox(height: 6),
                  _SectionDescription(
                    text: AppLocalizations.of(context)!.deviceSecurityHealthSectionBody,
                  ),
                  const SizedBox(height: 10),
                  if (_loading)
                    const _DeviceSecurityLoadingCard()
                  else
                    _DeviceSecuritySection(
                      signals: healthSignals,
                      onTap: _openDetails,
                    ),
                  const SizedBox(height: 20),
                   SettingsSectionHeader(
                    title: AppLocalizations.of(context)!.deviceSecurityDeviceSecurityRecommendations,
                  ),
                  const SizedBox(height: 6),
                  _SectionDescription(
                    text: AppLocalizations.of(context)!.deviceSecurityRecommendationsSectionBody,
                  ),
                  const SizedBox(height: 10),
                  if (_loading)
                    const _DeviceSecurityLoadingCard()
                  else
                    _DeviceSecuritySection(
                      signals: recommendationSignals,
                      onTap: _openDetails,
                    ),
                  const SizedBox(height: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeviceSecurityDetailScreen extends StatefulWidget {
  final DeviceSecuritySignal signal;

  const DeviceSecurityDetailScreen({
    super.key,
    required this.signal,
  });

  @override
  State<DeviceSecurityDetailScreen> createState() =>
      _DeviceSecurityDetailScreenState();
}

class _DeviceSecurityDetailScreenState
    extends State<DeviceSecurityDetailScreen> {
  late DeviceSecuritySignal _signal;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _signal = widget.signal;
  }

  Future<void> _toggleIgnore() async {
    setState(() {
      _saving = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final next = !_signal.ignored;
    await prefs.setBool(_signal.ignoreKey, next);

    if (!mounted) return;
    setState(() {
      _signal = _signal.copyWith(ignored: next);
      _saving = false;
    });

    HapticFeedback.selectionClick();
  }

  Future<void> _checkSetting() async {
    final opened = await DeviceSecuritySignalLoader.openSetting(_signal.id);

    if (!mounted) return;

    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_signal.manualHelp),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final stripeColor = _signal.stripeColor;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(
          _signal.displayTitle,
          style: text.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: MeshBackground(
        blobs: themeManager.meshBlobs,
        base: scheme.surface,
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
            children: [
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                color: theme.cardTheme.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        color: stripeColor,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _signal.displayTitle,
                                style: text.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: scheme.onSurface.withOpacity(0.92),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _signal.statusText(AppLocalizations.of(context)!),
                                style: text.bodyMedium?.copyWith(
                                  height: 1.32,
                                  color: scheme.onSurface.withOpacity(0.62),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                color: theme.cardTheme.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Text(
                    _signal.detail,
                    style: text.bodyMedium?.copyWith(
                      height: 1.45,
                      color: scheme.onSurface.withOpacity(0.68),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _checkSetting,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _signal.primaryActionLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: _saving ? null : _toggleIgnore,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _signal.ignored ? AppLocalizations.of(context)!.deviceSecurityStopIgnoring : AppLocalizations.of(context)!.deviceSecurityIgnoreCheck,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeviceSecuritySignal {
  final String id;
  final DeviceSecurityCategory category;
  final DeviceSecurityRiskLevel riskLevel;
  final String title;
  final String inactiveTitle;
  final String activeLabel;
  final String inactiveLabel;
  final String description;
  final String detail;
  final String manualHelp;
  final String primaryActionLabel;
  final bool active;
  final bool ignored;
  final bool available;

  const DeviceSecuritySignal({
    required this.id,
    required this.category,
    required this.riskLevel,
    required this.title,
    required this.inactiveTitle,
    required this.activeLabel,
    required this.inactiveLabel,
    required this.description,
    required this.detail,
    required this.manualHelp,
    required this.primaryActionLabel,
    required this.active,
    required this.ignored,
    required this.available,
  });

  String get ignoreKey => 'device_security_ignore_$id';

  String get displayTitle {
    if (!available) return title;
    if (active && !ignored) return title;
    return inactiveTitle;
  }

  String statusText(AppLocalizations l10n) {
    if (!available) return l10n.deviceSecuritySignalUnavailable;
    if (active && ignored) return l10n.deviceSecurityIgnoredByYou;
    if (active) return activeLabel;
    return inactiveLabel;
  }

  Color get stripeColor {
    if (!available || ignored) return Colors.grey;
    if (!active) return Colors.green;
    if (riskLevel == DeviceSecurityRiskLevel.danger) return Colors.redAccent;
    return Colors.orange;
  }

  DeviceSecuritySignal copyWith({
    bool? active,
    bool? ignored,
    bool? available,
  }) {
    return DeviceSecuritySignal(
      id: id,
      category: category,
      riskLevel: riskLevel,
      title: title,
      inactiveTitle: inactiveTitle,
      activeLabel: activeLabel,
      inactiveLabel: inactiveLabel,
      description: description,
      detail: detail,
      manualHelp: manualHelp,
      primaryActionLabel: primaryActionLabel,
      active: active ?? this.active,
      ignored: ignored ?? this.ignored,
      available: available ?? this.available,
    );
  }
}

class DeviceSecuritySignalLoader {
  static const MethodChannel _channel = MethodChannel('cs.device_security');

  static Future<List<DeviceSecuritySignal>> loadSignals(AppLocalizations l10n) async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> native = {};
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>('snapshot');
      native = result ?? {};
    } catch (_) {
      native = {};
    }

    bool value(String key) {
      final raw = native[key];
      if (raw is bool) return raw;
      if (raw is int) return raw != 0;
      return false;
    }

    bool available(String key) {
      if (native.isEmpty) return false;
      final raw = native['${key}Available'];
      if (raw is bool) return raw;
      return native.containsKey(key);
    }

    final shizukuEnabled = prefs.getBool('shizuku_enabled') ?? false;
    final privilegedAccess = value('privilegedAccess') || shizukuEnabled;

    return <DeviceSecuritySignal>[
      DeviceSecuritySignal(
        id: 'screen_lock',
        category: DeviceSecurityCategory.health,
        riskLevel: DeviceSecurityRiskLevel.danger,
        title: l10n.deviceSecurityNoScreenLock,
        inactiveTitle: l10n.deviceSecurityScreenLockInactiveTitle,
        activeLabel: l10n.deviceSecurityScreenLockActiveLabel,
        inactiveLabel: l10n.deviceSecurityScreenLockInactiveLabel,
        description: l10n.deviceSecurityAMissingSecureLockMakesLocalAccess,
        detail:
        l10n.deviceSecurityScreenLockDetail,
        manualHelp: l10n.deviceSecurityScreenLockHelp,
        primaryActionLabel: l10n.deviceSecurityCheckSetting,
        active: value('screenLockMissing'),
        ignored: prefs.getBool('device_security_ignore_screen_lock') ?? false,
        available: available('screenLockMissing'),
      ),
      DeviceSecuritySignal(
        id: 'privileged_access',
        category: DeviceSecurityCategory.health,
        riskLevel: DeviceSecurityRiskLevel.danger,
        title: l10n.deviceSecurityRootShizukuActive,
        inactiveTitle: l10n.deviceSecurityPrivilegedInactiveTitle,
        activeLabel: l10n.deviceSecurityPrivilegedActiveLabel,
        inactiveLabel: l10n.deviceSecurityPrivilegedInactiveLabel,
        description: l10n.deviceSecurityRootOrShizukuCanGrantPowerfulDevice,
        detail:
        l10n.deviceSecurityPrivilegedDetail,
        manualHelp: l10n.deviceSecurityPrivilegedHelp,
        primaryActionLabel: l10n.deviceSecurityReviewSetting,
        active: privilegedAccess,
        ignored:
        prefs.getBool('device_security_ignore_privileged_access') ?? false,
        available: available('privilegedAccess') || shizukuEnabled,
      ),
      DeviceSecuritySignal(
        id: 'app_verification',
        category: DeviceSecurityCategory.health,
        riskLevel: DeviceSecurityRiskLevel.danger,
        title: l10n.deviceSecurityDisabledAppVerification,
        inactiveTitle: l10n.deviceSecurityAppVerificationInactiveTitle,
        activeLabel: l10n.deviceSecurityAppVerificationActiveLabel,
        inactiveLabel: l10n.deviceSecurityAppVerificationInactiveLabel,
        description: l10n.deviceSecurityAppVerificationHelpsDetectHarmfulInstalls,
        detail:
        l10n.deviceSecurityAppVerificationDetail,
        manualHelp: l10n.deviceSecurityAppVerificationHelp,
        primaryActionLabel: l10n.deviceSecurityCheckSetting,
        active: value('appVerificationDisabled'),
        ignored:
        prefs.getBool('device_security_ignore_app_verification') ?? false,
        available: available('appVerificationDisabled'),
      ),
      DeviceSecuritySignal(
        id: 'security_patch',
        category: DeviceSecurityCategory.health,
        riskLevel: DeviceSecurityRiskLevel.caution,
        title: l10n.deviceSecurityOldAndroidSecurityPatch,
        inactiveTitle: l10n.deviceSecuritySecurityPatchInactiveTitle,
        activeLabel: l10n.deviceSecuritySecurityPatchActiveLabel,
        inactiveLabel: l10n.deviceSecuritySecurityPatchInactiveLabel,
        description: l10n.deviceSecurityOlderPatchLevelsMayLeaveKnownIssues,
        detail:
        l10n.deviceSecuritySecurityPatchDetail,
        manualHelp: l10n.deviceSecuritySecurityPatchHelp,
        primaryActionLabel: l10n.deviceSecurityCheckUpdates,
        active: value('oldSecurityPatch'),
        ignored: prefs.getBool('device_security_ignore_security_patch') ?? false,
        available: available('oldSecurityPatch'),
      ),
      DeviceSecuritySignal(
        id: 'developer_mode',
        category: DeviceSecurityCategory.recommendations,
        riskLevel: DeviceSecurityRiskLevel.caution,
        title: l10n.deviceSecurityDeveloperModeOn,
        inactiveTitle: l10n.deviceSecurityDeveloperModeInactiveTitle,
        activeLabel: l10n.deviceSecurityDeveloperModeActiveLabel,
        inactiveLabel: l10n.deviceSecurityDeveloperModeInactiveLabel,
        description: l10n.deviceSecurityDeveloperOptionsExposeAdvancedDeviceControls,
        detail:
        l10n.deviceSecurityDeveloperModeDetail,
        manualHelp: l10n.deviceSecurityDeveloperModeHelp,
        primaryActionLabel: l10n.deviceSecurityCheckSetting,
        active: value('developerMode'),
        ignored: prefs.getBool('device_security_ignore_developer_mode') ?? false,
        available: available('developerMode'),
      ),
      DeviceSecuritySignal(
        id: 'usb_debugging',
        category: DeviceSecurityCategory.recommendations,
        riskLevel: DeviceSecurityRiskLevel.danger,
        title: l10n.deviceSecurityUsbDebuggingOn,
        inactiveTitle: l10n.deviceSecurityUsbDebuggingInactiveTitle,
        activeLabel: l10n.deviceSecurityUsbDebuggingActiveLabel,
        inactiveLabel: l10n.deviceSecurityUsbDebuggingInactiveLabel,
        description: l10n.deviceSecurityUsbDebuggingAllowsADBControlFromTrusted,
        detail:
        l10n.deviceSecurityUsbDebuggingDetail,
        manualHelp: l10n.deviceSecurityUsbDebuggingHelp,
        primaryActionLabel: l10n.deviceSecurityCheckSetting,
        active: value('usbDebugging'),
        ignored: prefs.getBool('device_security_ignore_usb_debugging') ?? false,
        available: available('usbDebugging'),
      ),
      DeviceSecuritySignal(
        id: 'unknown_sources',
        category: DeviceSecurityCategory.recommendations,
        riskLevel: DeviceSecurityRiskLevel.caution,
        title: l10n.deviceSecurityUnknownSourcesAllowed,
        inactiveTitle: l10n.deviceSecurityUnknownSourcesInactiveTitle,
        activeLabel: l10n.deviceSecurityUnknownSourcesActiveLabel,
        inactiveLabel: l10n.deviceSecurityUnknownSourcesInactiveLabel,
        description: l10n.deviceSecuritySideloadingCanBypassNormalAppStoreChecks,
        detail:
        l10n.deviceSecurityUnknownSourcesDetail,
        manualHelp: l10n.deviceSecurityUnknownSourcesHelp,
        primaryActionLabel: l10n.deviceSecurityCheckSetting,
        active: value('unknownSources'),
        ignored:
        prefs.getBool('device_security_ignore_unknown_sources') ?? false,
        available: available('unknownSources'),
      ),
      DeviceSecuritySignal(
        id: 'accessibility_risk',
        category: DeviceSecurityCategory.recommendations,
        riskLevel: DeviceSecurityRiskLevel.caution,
        title: l10n.deviceSecurityAccessibilityAbuseRisk,
        inactiveTitle: l10n.deviceSecurityAccessibilityInactiveTitle,
        activeLabel: l10n.deviceSecurityAccessibilityActiveLabel,
        inactiveLabel: l10n.deviceSecurityAccessibilityInactiveLabel,
        description: l10n.deviceSecurityAccessibilityServicesCanReadAndControlScreen,
        detail:
        l10n.deviceSecurityAccessibilityDetail,
        manualHelp: l10n.deviceSecurityAccessibilityHelp,
        primaryActionLabel: l10n.deviceSecurityCheckSetting,
        active: value('accessibilityRisk'),
        ignored:
        prefs.getBool('device_security_ignore_accessibility_risk') ?? false,
        available: available('accessibilityRisk'),
      ),
    ];
  }

  static Future<bool> openSetting(String id) async {
    try {
      final opened = await _channel.invokeMethod<bool>(
        'openSetting',
        <String, dynamic>{'id': id},
      );

      return opened ?? false;
    } catch (_) {
      return false;
    }
  }
}

class _DeviceSecuritySummaryCard extends StatelessWidget {
  final bool loading;
  final int activeRisks;
  final int ignoredRisks;

  const _DeviceSecuritySummaryCard({
    required this.loading,
    required this.activeRisks,
    required this.ignoredRisks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    final hasRisk = activeRisks > 0;
    final color = hasRisk ? Colors.redAccent : Colors.green;

    String title;
    String subtitle;

    final l10n = AppLocalizations.of(context)!;

    if (loading) {
      title = l10n.deviceSecurityChecking;
      subtitle = l10n.deviceSecurityReadingSignals;
    } else if (hasRisk) {
      title = activeRisks == 1
          ? l10n.deviceSecurityOneCheckAttention
          : l10n.deviceSecurityChecksAttention(activeRisks);
      subtitle = ignoredRisks == 0
          ? l10n.deviceSecurityTapSignal
          : l10n.deviceSecurityIgnoredChecks(
              ignoredRisks,
              ignoredRisks == 1 ? '' : 's',
            );
    } else {
      title = l10n.deviceSecurityNoRisksFound;
      subtitle = ignoredRisks == 0
          ? l10n.deviceSecurityPostureNormal
          : l10n.deviceSecurityIgnoredChecks(
              ignoredRisks,
              ignoredRisks == 1 ? '' : 's',
            );
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              color: color,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface.withOpacity(0.92),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: text.bodySmall?.copyWith(
                        height: 1.35,
                        color: scheme.onSurface.withOpacity(0.58),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceSecuritySection extends StatelessWidget {
  final List<DeviceSecuritySignal> signals;
  final ValueChanged<DeviceSecuritySignal> onTap;

  const _DeviceSecuritySection({
    required this.signals,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: signals.map((signal) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _DeviceSecuritySignalRow(
            signal: signal,
            onTap: () => onTap(signal),
          ),
        );
      }).toList(),
    );
  }
}

class _DeviceSecuritySignalRow extends StatelessWidget {
  final DeviceSecuritySignal signal;
  final VoidCallback onTap;

  const _DeviceSecuritySignalRow({
    required this.signal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final stripeColor = signal.stripeColor;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 5,
                color: stripeColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        signal.displayTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurface.withOpacity(0.92),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        signal.statusText(AppLocalizations.of(context)!),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodyMedium?.copyWith(
                          color: scheme.onSurface.withOpacity(0.62),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        signal.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                          color: scheme.onSurface.withOpacity(0.52),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionDescription extends StatelessWidget {
  final String text;

  const _SectionDescription({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          height: 1.25,
          color: theme.colorScheme.onSurface.withOpacity(0.56),
        ),
      ),
    );
  }
}

class _DeviceSecurityLoadingCard extends StatelessWidget {
  const _DeviceSecurityLoadingCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(18, 26, 18, 26),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}