import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/theme/theme_manager.dart';
import '../../widgets/mesh_background.dart';
import '../settings/widgets/settings_section_header.dart';

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

  String get homeLabel {
    if (activeRiskCount == 0) return 'No device risks found';
    if (activeRiskCount == 1) return '1 device check needs attention';
    return '$activeRiskCount device checks need attention';
  }
}

class DeviceSecurityScreen extends StatefulWidget {
  const DeviceSecurityScreen({super.key});

  static Future<DeviceSecuritySummary> loadSummary() async {
    final signals = await DeviceSecuritySignalLoader.loadSignals();
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
    final signals = await DeviceSecuritySignalLoader.loadSignals();

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
          'Device Security',
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
                  const SettingsSectionHeader(title: 'Device health status'),
                  const SizedBox(height: 6),
                  const _SectionDescription(
                    text: 'These settings directly affect your device posture.',
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
                  const SettingsSectionHeader(
                    title: 'Device security recommendations',
                  ),
                  const SizedBox(height: 6),
                  const _SectionDescription(
                    text: 'These settings are common security good practice.',
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
          _signal.title,
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
                                _signal.title,
                                style: text.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: scheme.onSurface.withOpacity(0.92),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _signal.statusText,
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
                  _signal.ignored ? 'Stop ignoring' : 'Ignore check',
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

  String get statusText {
    if (!available) return 'Signal unavailable';
    if (active && ignored) return 'Ignored by you';
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

  static Future<List<DeviceSecuritySignal>> loadSignals() async {
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
        title: 'No Screen Lock',
        activeLabel: 'Unsafe, no secure screen lock is set',
        inactiveLabel: 'Screen lock is active',
        description: 'A missing secure lock makes local access easier.',
        detail:
        'A secure screen lock protects your device if it is lost, stolen, or left unattended. Without a PIN, password, pattern, fingerprint, or face unlock backed by a secure lock method, anyone with physical access can open the device more easily.',
        manualHelp: 'Open Android security settings and set a secure screen lock.',
        primaryActionLabel: 'Check setting',
        active: value('screenLockMissing'),
        ignored: prefs.getBool('device_security_ignore_screen_lock') ?? false,
        available: available('screenLockMissing'),
      ),
      DeviceSecuritySignal(
        id: 'privileged_access',
        category: DeviceSecurityCategory.health,
        riskLevel: DeviceSecurityRiskLevel.danger,
        title: 'Root/Shizuku Active',
        activeLabel: 'Privileged access detected',
        inactiveLabel: 'No privileged access detected',
        description: 'Root or Shizuku can grant powerful device control.',
        detail:
        'Root and Shizuku can be useful for advanced users, but they also increase the impact of a malicious app if access is abused. Apps with privileged access may be able to perform actions that normal Android apps cannot.',
        manualHelp: 'Review your root, Magisk, or Shizuku settings manually.',
        primaryActionLabel: 'Review setting',
        active: privilegedAccess,
        ignored:
        prefs.getBool('device_security_ignore_privileged_access') ?? false,
        available: available('privilegedAccess') || shizukuEnabled,
      ),
      DeviceSecuritySignal(
        id: 'app_verification',
        category: DeviceSecurityCategory.health,
        riskLevel: DeviceSecurityRiskLevel.danger,
        title: 'Disabled App Verification',
        activeLabel: 'Unsafe, app verification appears disabled',
        inactiveLabel: 'App verification appears enabled',
        description: 'App verification helps detect harmful installs.',
        detail:
        'Android app verification helps check apps before or after installation. If this protection is disabled or unavailable, harmful apps may be less likely to be blocked before they run.',
        manualHelp: 'Open Android security settings and review app verification.',
        primaryActionLabel: 'Check setting',
        active: value('appVerificationDisabled'),
        ignored:
        prefs.getBool('device_security_ignore_app_verification') ?? false,
        available: available('appVerificationDisabled'),
      ),
      DeviceSecuritySignal(
        id: 'security_patch',
        category: DeviceSecurityCategory.health,
        riskLevel: DeviceSecurityRiskLevel.caution,
        title: 'Old Android Security Patch',
        activeLabel: 'Security patch level is outdated',
        inactiveLabel: 'Security patch level is current',
        description: 'Older patch levels may leave known issues unpatched.',
        detail:
        'Android security patches fix known platform and vendor issues. If the patch level is old, the device may be exposed to vulnerabilities that have already been fixed on newer builds.',
        manualHelp: 'Open Android system update settings and check for updates.',
        primaryActionLabel: 'Check updates',
        active: value('oldSecurityPatch'),
        ignored: prefs.getBool('device_security_ignore_security_patch') ?? false,
        available: available('oldSecurityPatch'),
      ),
      DeviceSecuritySignal(
        id: 'developer_mode',
        category: DeviceSecurityCategory.recommendations,
        riskLevel: DeviceSecurityRiskLevel.caution,
        title: 'Developer Mode',
        activeLabel: 'Developer options are enabled',
        inactiveLabel: 'Developer options are disabled',
        description: 'Developer options expose advanced device controls.',
        detail:
        'Developer Mode is normal for developers and testers, but it exposes advanced settings that can reduce device security if changed accidentally or abused by someone with access to the device.',
        manualHelp: 'Open Developer Options and turn off settings you do not need.',
        primaryActionLabel: 'Check setting',
        active: value('developerMode'),
        ignored: prefs.getBool('device_security_ignore_developer_mode') ?? false,
        available: available('developerMode'),
      ),
      DeviceSecuritySignal(
        id: 'usb_debugging',
        category: DeviceSecurityCategory.recommendations,
        riskLevel: DeviceSecurityRiskLevel.danger,
        title: 'USB Debugging',
        activeLabel: 'Unsafe, USB debugging is turned on',
        inactiveLabel: 'USB debugging is turned off',
        description: 'USB debugging allows ADB control from trusted computers.',
        detail:
        'USB debugging allows a connected computer to interact with your device through Android Debug Bridge. If left enabled, it increases the risk of unauthorised access when connected to an untrusted machine.',
        manualHelp: 'Open Developer Options and turn USB debugging off.',
        primaryActionLabel: 'Check setting',
        active: value('usbDebugging'),
        ignored: prefs.getBool('device_security_ignore_usb_debugging') ?? false,
        available: available('usbDebugging'),
      ),
      DeviceSecuritySignal(
        id: 'unknown_sources',
        category: DeviceSecurityCategory.recommendations,
        riskLevel: DeviceSecurityRiskLevel.caution,
        title: 'Unknown Sources',
        activeLabel: 'Installing unknown apps is allowed',
        inactiveLabel: 'Installing unknown apps is restricted',
        description: 'Sideloading can bypass normal app store checks.',
        detail:
        'Allowing unknown app installs can be useful for trusted APKs, but it also increases the chance of installing apps from unsafe sources. Only allow this for apps and stores you trust.',
        manualHelp: 'Open Android settings and review install unknown apps access.',
        primaryActionLabel: 'Check setting',
        active: value('unknownSources'),
        ignored:
        prefs.getBool('device_security_ignore_unknown_sources') ?? false,
        available: available('unknownSources'),
      ),
      DeviceSecuritySignal(
        id: 'accessibility_risk',
        category: DeviceSecurityCategory.recommendations,
        riskLevel: DeviceSecurityRiskLevel.caution,
        title: 'Accessibility Abuse Risk',
        activeLabel: 'Third-party accessibility service enabled',
        inactiveLabel: 'No risky accessibility services found',
        description: 'Accessibility services can read and control screen actions.',
        detail:
        'Accessibility services are powerful because they can observe screen content and perform actions on behalf of the user. This is useful for legitimate tools, but it is also commonly abused by malicious apps.',
        manualHelp: 'Open Accessibility settings and review enabled services.',
        primaryActionLabel: 'Check setting',
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

    if (loading) {
      title = 'Checking device security';
      subtitle = 'Reading device posture signals...';
    } else if (hasRisk) {
      title = activeRisks == 1
          ? '1 check needs attention'
          : '$activeRisks checks need attention';
      subtitle = ignoredRisks == 0
          ? 'Review the active signals below.'
          : '$ignoredRisks active check${ignoredRisks == 1 ? '' : 's'} ignored by you.';
    } else {
      title = 'No device risks found';
      subtitle = ignoredRisks == 0
          ? 'Your device posture checks look normal.'
          : '$ignoredRisks active check${ignoredRisks == 1 ? '' : 's'} ignored by you.';
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
                        signal.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurface.withOpacity(0.92),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        signal.statusText,
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