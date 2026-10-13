import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/build_flags.dart';
import '../../services/dnsService/auth_service.dart';
import '../../services/service_manager.dart';
import '../../translations/app_localizations.dart';
import 'Network_app_control_screen.dart';
import 'Network_speed_test_screen.dart';

class NetworkProtectionScreen extends StatefulWidget {
  const NetworkProtectionScreen({super.key});

  @override
  State<NetworkProtectionScreen> createState() => _NetworkAdvancedScreenState();
}

class _DnsEvent {
  final int tsMs;
  final String qname;
  final bool blocked;
  final String plan;
  final String? upstream;
  final int? latencyMs;
  final String? matchList;
  final String? matchType;

  _DnsEvent({
    required this.tsMs,
    required this.qname,
    required this.blocked,
    required this.plan,
    required this.upstream,
    required this.latencyMs,
    required this.matchList,
    required this.matchType,
  });

  factory _DnsEvent.fromMap(Map<dynamic, dynamic> m) {
    final decision = (m['decision'] is Map) ? (m['decision'] as Map) : null;
    final match = (decision != null && decision['match'] is Map) ? (decision['match'] as Map) : null;
    return _DnsEvent(
      tsMs: (m['ts_ms'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
      qname: (m['qname'] as String?) ?? 'unknown',
      blocked: (m['blocked'] as bool?) ?? false,
      plan: (m['plan'] as String?) ?? 'free',
      upstream: (m['upstream'] as String?),
      latencyMs: (m['latency_ms'] as int?),
      matchList: (match != null ? (match['list'] as String?) : null),
      matchType: (match != null ? (match['type'] as String?) : null),
    );
  }
}

class _UpstreamPreset {
  final String key;
  final String title;
  final String subtitle;
  final String ip;

  const _UpstreamPreset({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.ip,
  });
}

class _NetworkAdvancedScreenState extends State<NetworkProtectionScreen> with WidgetsBindingObserver {
  static const _deviceIdKey = 'dns_device_id';
  static const _prefCloudEnabled = 'dns_cloud_enabled';

  static const _prefRecCsMalware = 'dns_cloud_rec_cs_malware';
  static const _prefRecCsAds = 'dns_cloud_rec_cs_ads';
  static const _prefMalware = 'dns_cloud_list_malware';
  static const _prefAds = 'dns_cloud_list_ads';
  static const _prefTrackers = 'dns_cloud_list_trackers';
  static const _prefAdult = 'dns_cloud_list_adult';
  static const _prefGambling = 'dns_cloud_list_gambling';
  static const _prefSocial = 'dns_cloud_list_social';

  static const _prefCloudResolverChoice = 'dns_cloud_resolver_choice';
  static const _prefCloudResolverCustom = 'dns_cloud_resolver_custom';

  static const _dnsEventChannel = EventChannel('cs_dns_events');

  static const int _freeUsageLimit = 300000;

  static const String _githubUrl = 'https://github.com/phsycologicalFudge/ColourSwift_AV?tab=readme-ov-file#network-protection';

  static  List<_UpstreamPreset> _presets = [
    _UpstreamPreset(key: 'cloudflare', title: 'Cloudflare', subtitle: '1.1.1.1', ip: '1.1.1.1'),
    _UpstreamPreset(key: 'cloudflare_alt', title: 'Cloudflare (alt)', subtitle: '1.0.0.1', ip: '1.0.0.1'),
    _UpstreamPreset(key: 'google', title: 'Google', subtitle: '8.8.8.8', ip: '8.8.8.8'),
    _UpstreamPreset(key: 'google_alt', title: 'Google (alt)', subtitle: '8.8.4.4', ip: '8.8.4.4'),
    _UpstreamPreset(key: 'quad9', title: 'Quad9', subtitle: '9.9.9.9', ip: '9.9.9.9'),
    _UpstreamPreset(key: 'quad9_alt', title: 'Quad9 (alt)', subtitle: '149.112.112.112', ip: '149.112.112.112'),
    _UpstreamPreset(key: 'adguard', title: 'AdGuard', subtitle: '94.140.14.14', ip: '94.140.14.14'),
    _UpstreamPreset(key: 'adguard_alt', title: 'AdGuard (alt)', subtitle: '94.140.15.15', ip: '94.140.15.15'),
    _UpstreamPreset(key: 'custom', title: AppLocalizations.of(context)!.networkCardStatusCustom, subtitle: AppLocalizations.of(context)!.networkProtectionEnterYourOwnResolver, ip: ''),
  ];

  bool get canUseAdsBlocklists => !kEnableAds || isPro;
  bool get canUseCsAds => !kEnableAds || isPro;

  bool proBusy = false;
  bool isPro = false;

  bool cloudEnabled = false;
  bool vpnConflict = false;

  bool recCsMalware = false;
  bool recCsAds = false;
  bool listMalware = false;
  bool listAds = false;
  bool listTrackers = false;
  bool listAdult = false;
  bool listGambling = false;
  bool listSocial = false;

  String resolverChoice = 'cloudflare';
  String resolverCustom = '';

  bool hasDeviceId = false;

  StreamSubscription<dynamic>? _dnsSub;
  final List<_DnsEvent> _dnsEvents = [];

  final TextEditingController _customResolverCtrl = TextEditingController();
  final ValueNotifier<int> _uiTick = ValueNotifier<int>(0);

  double _usageFrac = 0.0;
  double _usageFracPrev = 0.0;
  int? _usageUsed;
  int? _usageLimit;
  int? _usageResetMs;
  String? _usagePlan;
  bool _usageLoading = false;
  DateTime? _usageLastUpdated;
  bool _devForceFree = false;

  Timer? _usageTimer;

  void _vpnLog(String msg) {
    debugPrint('[CS VPN] $msg');
  }

  void _bumpUi() {
    _uiTick.value++;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadState();
    _startDnsLogListener();
    _startUsageRefreshLoop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dnsSub?.cancel();
    _customResolverCtrl.dispose();
    _uiTick.dispose();
    _usageTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _recheckProAndPushIfNeeded();
      _loadUsage();
    }
  }

  void _startDnsLogListener() {
    if (_dnsSub != null) return;
    _dnsSub = _dnsEventChannel.receiveBroadcastStream().listen((event) {
      if (!mounted) return;
      if (event is Map) {
        final e = _DnsEvent.fromMap(event);
        setState(() {
          _dnsEvents.insert(0, e);
          if (_dnsEvents.length > 800) {
            _dnsEvents.removeRange(800, _dnsEvents.length);
          }
        });
        _bumpUi();
      }
    }, onError: (err) {
      _vpnLog('DNS event stream error: $err');
    });
  }

  void _startUsageRefreshLoop() {
    _usageTimer?.cancel();
    _usageTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!mounted) return;
      if (!cloudEnabled) return;
      _loadUsage();
    });
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();

    final ce = prefs.getBool(_prefCloudEnabled) ?? false;

    final r1 = prefs.getBool(_prefRecCsMalware) ?? false;
    final r2 = prefs.getBool(_prefRecCsAds) ?? false;

    final m = prefs.getBool(_prefMalware) ?? false;
    final a = prefs.getBool(_prefAds) ?? false;
    final t = prefs.getBool(_prefTrackers) ?? false;
    final ad = prefs.getBool(_prefAdult) ?? false;
    final g = prefs.getBool(_prefGambling) ?? false;
    final s = prefs.getBool(_prefSocial) ?? false;

    final rc = prefs.getString(_prefCloudResolverChoice) ?? 'cloudflare';
    final rcustom = prefs.getString(_prefCloudResolverCustom) ?? '';

    final did = prefs.getString(_deviceIdKey);
    final didOk = did != null && did.trim().isNotEmpty;

    final pro = await ProEntitlementService.isPro();

    if (!mounted) return;

    _customResolverCtrl.text = rcustom;

    setState(() {
      cloudEnabled = ce;

      recCsMalware = r1;
      recCsAds = r2;

      listMalware = m;
      listAds = a;
      listTrackers = t;
      listAdult = ad;
      listGambling = g;
      listSocial = s;

      resolverChoice = rc;
      resolverCustom = rcustom;
      hasDeviceId = didOk;
      isPro = pro;
    });
    _bumpUi();

    if (cloudEnabled && hasDeviceId) {
      await _pushCloudSettingsToVpn();
      await _loadUsage();
    } else {
      await _loadUsage();
    }
  }

  Future<String> _ensureDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_deviceIdKey);
    if (existing != null && existing.trim().isNotEmpty) return existing.trim();

    final rnd = Random.secure();
    final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
    final id = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

    await prefs.setString(_deviceIdKey, id);
    return id;
  }

  Future<void> _saveCloudPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_prefCloudEnabled, cloudEnabled);

    await prefs.setBool(_prefRecCsMalware, recCsMalware);
    await prefs.setBool(_prefRecCsAds, recCsAds);

    await prefs.setBool(_prefMalware, listMalware);
    await prefs.setBool(_prefAds, listAds);
    await prefs.setBool(_prefTrackers, listTrackers);
    await prefs.setBool(_prefAdult, listAdult);
    await prefs.setBool(_prefGambling, listGambling);
    await prefs.setBool(_prefSocial, listSocial);

    await prefs.setString(_prefCloudResolverChoice, resolverChoice);
    await prefs.setString(_prefCloudResolverCustom, resolverCustom);
  }

  Future<bool> _isAnotherVpnActive() async {
    const chan = MethodChannel('cs_vpn_state');
    try {
      return await chan.invokeMethod<bool>('isAnotherVpnActive') ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _requestVpnPermission() async {
    const chan = MethodChannel('cs_vpn_permission');
    try {
      return await chan.invokeMethod<bool>('prepareVpn') == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _setCloudEnabled(bool v) async {
    final prefs = await SharedPreferences.getInstance();

    if (v) {
      final notif = await Permission.notification.request();
      if (!notif.isGranted) return;

      final ok = await _requestVpnPermission();
      if (!ok) return;

      final conflict = await _isAnotherVpnActive();
      if (conflict) {
        if (!mounted) return;
        setState(() {
          vpnConflict = true;
          cloudEnabled = false;
        });
        _bumpUi();
        return;
      }

      await ProEntitlementService.clearCache();
      final pro = await ProEntitlementService.isPro();
      final clientId = await _ensureDeviceId();

      await prefs.setBool('protectionEnabled', true);
      await prefs.setBool(_prefCloudEnabled, true);
      await prefs.setBool('networkProtectionEnabled', true);
      await prefs.setString('networkProtectionMode', 'cloud');

      try {
        await AvServiceManager.startProtection();
        await AvServiceManager.startVpn(dnsMode: 'cloud');
      } catch (_) {
        await prefs.setBool(_prefCloudEnabled, false);
        await prefs.setBool('networkProtectionEnabled', false);
        await prefs.setString('networkProtectionMode', 'off');
        try {
          await AvServiceManager.stopVpn();
        } catch (_) {}

        if (!mounted) return;
        setState(() {
          cloudEnabled = false;
          vpnConflict = false;
        });
        _bumpUi();
        await _loadUsage();
        return;
      }

      if (!mounted) return;
      setState(() {
        cloudEnabled = true;
        isPro = pro;
        hasDeviceId = clientId.trim().isNotEmpty;
        vpnConflict = false;
      });

      await _pushCloudSettingsToVpn();
      await _loadUsage();
      _bumpUi();
      return;
    }

    await prefs.setBool(_prefCloudEnabled, false);
    await prefs.setBool('networkProtectionEnabled', false);
    await prefs.setString('networkProtectionMode', 'off');

    await AvServiceManager.stopVpn();

    if (!mounted) return;
    setState(() {
      cloudEnabled = false;
      vpnConflict = false;
    });
    _bumpUi();

    await _loadUsage();
  }

  String _resolverIpForChoice() {
    if (resolverChoice == 'custom') {
      final s = resolverCustom.trim();
      return s.isEmpty ? '1.1.1.1' : s;
    }
    for (final p in _presets) {
      if (p.key == resolverChoice) {
        return p.ip.isEmpty ? '1.1.1.1' : p.ip;
      }
    }
    return '1.1.1.1';
  }

  Map<String, dynamic> _cloudSettingsPayload(String clientId) {
    final enabled = <String>{};

    if (recCsMalware) {
      enabled.add('romain');
    }

    if (canUseCsAds && recCsAds) {
      enabled.add('oisd');
      enabled.add('trackers');
    }

    if (listMalware) {
      enabled.add('malware');
    }

    if (listTrackers) {
      enabled.add('trackers');
    }

    if (canUseAdsBlocklists && listAds) {
      enabled.add('ads');
    }

    if (listAdult) enabled.add('adult');
    if (listGambling) enabled.add('gambling');
    if (listSocial) enabled.add('social');

    return {
      'enabled_lists': enabled.toList(),
      'resolver': _resolverIpForChoice(),
      'plan': isPro ? 'pro' : 'free',
      'client_id': clientId,
      'cloud_url': 'https://dns.colourswift.com/resolve',
    };
  }

  Future<void> _pushCloudSettingsToVpn() async {
    await _saveCloudPrefs();
    if (!cloudEnabled) return;

    final clientId = await _ensureDeviceId();
    const chan = MethodChannel('cs_dns_settings');
    final payload = _cloudSettingsPayload(clientId);
    try {
      await chan.invokeMethod('setCloudSettings', payload);
      if (!mounted) return;
      setState(() => hasDeviceId = true);
      _bumpUi();
    } catch (e) {
      _vpnLog('Error pushing cloud settings to VPN: $e');
    }
  }

  Future<void> _recheckProAndPushIfNeeded() async {
    if (proBusy) return;
    if (!mounted) return;
    setState(() => proBusy = true);
    _bumpUi();

    try {
      final pro = await ProEntitlementService.isPro();

      if (!mounted) return;
      setState(() {
        isPro = pro;
      });
      _bumpUi();

      if (cloudEnabled && hasDeviceId) {
        await _pushCloudSettingsToVpn();
      }
      await _loadUsage();
    } catch (_) {} finally {
      if (!mounted) return;
      setState(() => proBusy = false);
      _bumpUi();
    }
  }

  Future<void> _loadUsage() async {
    if (_usageLoading) return;

    if (!cloudEnabled) {
      if (!mounted) return;
      setState(() {
        _usageUsed = null;
        _usageLimit = null;
        _usageResetMs = null;
        _usagePlan = null;
        _usageLoading = false;
        _usageFracPrev = _usageFrac;
        _usageFrac = 0.0;
        _usageLastUpdated = null;
      });
      _bumpUi();
      return;
    }

    if (!mounted) return;
    setState(() => _usageLoading = true);
    _bumpUi();

    try {
      const chan = MethodChannel('cs_dns_usage');
      final res = await chan.invokeMethod<dynamic>('getUsage');
      if (res is Map) {
        final used = (res['used'] as int?) ?? (res['count'] as int?) ?? 0;
        final plan = (res['plan'] as String?) ?? (isPro ? 'pro' : 'free');

        int? limit = (res['limit'] as int?) ?? (res['max'] as int?);
        if (plan.toLowerCase() != 'pro') {
          limit = (limit == null || limit <= 0) ? _freeUsageLimit : limit;
        } else {
          limit = null;
        }

        final resetMs = (res['reset_ms'] as int?) ?? (res['resetMs'] as int?);
        final frac = (limit == null || limit <= 0) ? 0.0 : (used / limit).clamp(0.0, 1.0);

        if (!mounted) return;
        setState(() {
          _usageUsed = used;
          _usageLimit = limit;
          _usageResetMs = resetMs;
          _usagePlan = plan;
          _usageFracPrev = _usageFrac;
          _usageFrac = frac;
          _usageLastUpdated = DateTime.now();
        });
      }
    } catch (_) {
    } finally {
      if (!mounted) return;
      setState(() => _usageLoading = false);
      _bumpUi();
    }
  }

  String _fmtInt(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      b.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) b.write(',');
    }
    return b.toString();
  }

  String _usageResetLine(AppLocalizations l10n) {
    if (!cloudEnabled) return '';
    if (_usageResetMs == null) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(_usageResetMs!);
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return l10n.networkUsageResetsOn(y, m, d);
  }

  Widget _pagePadding(Widget child) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: child,
    );
  }

  Widget _blocklistsTab(TextTheme text) {
    final baseUnlocked = cloudEnabled;
    final proUnlocked = cloudEnabled && canUseAdsBlocklists;

    Future<void> _apply() async {
      _bumpUi();
      await _pushCloudSettingsToVpn();
    }

    Future<void> toggleRecCsMalware(bool v) async {
      if (!baseUnlocked) return;
      setState(() {
        recCsMalware = v;
        if (v) {
          listMalware = false;
        }
      });
      await _apply();
    }

    Future<void> toggleRecCsAds(bool v) async {
      if (!canUseCsAds) return;
      setState(() {
        recCsAds = v;
        if (v) {
          listAds = false;
        }
      });
      await _apply();
    }

    Future<void> toggleMalware(bool v) async {
      if (!baseUnlocked) return;
      setState(() {
        listMalware = v;
        if (v) {
          recCsMalware = false;
        }
      });
      await _apply();
    }

    Future<void> toggleAds(bool v) async {
      if (!(cloudEnabled && canUseAdsBlocklists)) return;
      setState(() {
        listAds = v;
        if (v) {
          recCsAds = false;
        }
      });
      await _apply();
    }

    Future<void> toggleTrackers(bool v) async {
      if (!baseUnlocked) return;
      setState(() => listTrackers = v);
      await _apply();
    }

    Future<void> toggleAdult(bool v) async {
      if (!baseUnlocked) return;
      setState(() => listAdult = v);
      await _apply();
    }

    Future<void> toggleGambling(bool v) async {
      if (!baseUnlocked) return;
      setState(() => listGambling = v);
      await _apply();
    }

    Future<void> toggleSocial(bool v) async {
      if (!baseUnlocked) return;
      setState(() => listSocial = v);
      await _apply();
    }

    Widget _catDivider() {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Divider(
          height: 1,
          thickness: 1,
        ),
      );
    }

    Widget proTag() {
      final l10n = AppLocalizations.of(context)!;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          l10n.proBadge,
          style: text.labelSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
      );
    }

    final l10n = AppLocalizations.of(context)!;

    return _pagePadding(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionCard(
            title: l10n.networkBlocklistsRecommendedTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: recCsMalware,
                  onChanged: baseUnlocked ? (v) async => toggleRecCsMalware(v) : null,
                  title: Text(l10n.networkBlocklistsCsMalwareTitle),
                  subtitle: Text(l10n.networkBlocklistsSeeGithub),
                ),
                Opacity(
                  opacity: canUseCsAds ? 1.0 : 0.45,
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: recCsAds,
                    onChanged: canUseCsAds ? (v) async => toggleRecCsAds(v) : null,
                    title: Row(
                      children: [
                        Expanded(child: Text(l10n.networkBlocklistsCsAdsTitle)),
                        if (kEnableAds) proTag(),
                      ],
                    ),
                    subtitle: Text(l10n.networkBlocklistsSeeGithub),
                  ),
                ),
              ],
            ),
          ),
          _catDivider(),
          _sectionCard(
            title: l10n.networkBlocklistsMalwareSection,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: listMalware,
              onChanged: baseUnlocked ? (v) async => toggleMalware(v) : null,
              title: Text(l10n.networkBlocklistsMalwareTitle),
              subtitle: Text(l10n.networkBlocklistsMalwareSources),
            ),
          ),
          _catDivider(),
          Opacity(
            opacity: proUnlocked ? 1.0 : 0.45,
            child: _sectionCard(
              title: l10n.networkBlocklistsAdsSection,
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: listAds,
                onChanged: proUnlocked ? (v) async => toggleAds(v) : null,
                title: Row(
                  children: [
                    Expanded(child: Text(l10n.networkBlocklistsAdsTitle)),
                    proTag(),
                  ],
                ),
                subtitle: Text(l10n.networkBlocklistsAdsSources),
              ),
            ),
          ),
          _catDivider(),
          _sectionCard(
            title: l10n.networkBlocklistsTrackersSection,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: listTrackers,
              onChanged: baseUnlocked ? (v) async => toggleTrackers(v) : null,
              title: Text(l10n.networkBlocklistsTrackersTitle),
              subtitle: Text(l10n.networkBlocklistsTrackersSources),
            ),
          ),
          _catDivider(),
          _sectionCard(
            title: l10n.networkBlocklistsGamblingSection,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: listGambling,
              onChanged: baseUnlocked ? (v) async => toggleGambling(v) : null,
              title: Text(l10n.networkBlocklistsGamblingTitle),
              subtitle: Text(l10n.networkBlocklistsGamblingSources),
            ),
          ),
          _catDivider(),
          _sectionCard(
            title: l10n.networkBlocklistsSocialSection,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: listSocial,
              onChanged: baseUnlocked ? (v) async => toggleSocial(v) : null,
              title: Text(l10n.networkBlocklistsSocialTitle),
              subtitle: Text(l10n.networkBlocklistsSocialSources),
            ),
          ),
          _catDivider(),
          _sectionCard(
            title: l10n.networkBlocklistsAdultSection,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: listAdult,
              onChanged: baseUnlocked ? (v) async => toggleAdult(v) : null,
              title: Text(l10n.networkBlocklistsAdultTitle),
              subtitle: Text(l10n.networkBlocklistsAdultSources),
            ),
          ),
        ],
      ),
    );
  }

  Widget _upstreamTab(TextTheme text) {
    final unlocked = cloudEnabled;
    final opacity = unlocked ? 1.0 : 0.45;

    Widget presetTile(_UpstreamPreset p) {
      return RadioListTile<String>(
        contentPadding: EdgeInsets.zero,
        value: p.key,
        groupValue: resolverChoice,
        onChanged: unlocked
            ? (v) async {
          if (v == null) return;
          setState(() => resolverChoice = v);
          _bumpUi();
          await _pushCloudSettingsToVpn();
        }
            : null,
        title: Text(p.title),
        subtitle: Text(p.subtitle),
      );
    }

    final l10n = AppLocalizations.of(context)!;

    return _pagePadding(
      Opacity(
        opacity: opacity,
        child: _sectionCard(
          title: l10n.networkResolverTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              for (final p in _presets) presetTile(p),
              if (resolverChoice == 'custom')
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextField(
                    controller: _customResolverCtrl,
                    enabled: unlocked,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      labelText: l10n.networkResolverIpLabel,
                      hintText: l10n.networkResolverIpHint,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (v) async {
                      resolverCustom = v;
                      _bumpUi();
                      await _pushCloudSettingsToVpn();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _speedTab(TextTheme text) {
    final l10n = AppLocalizations.of(context)!;

    return _pagePadding(
      _sectionCard(
        title: l10n.networkSpeedTestTitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.networkSpeedTestBody,
              style: text.bodySmall?.copyWith(
                color: text.bodySmall?.color?.withOpacity(0.85),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NetworkSpeedTestScreen()),
                  );
                },
                child: Text(l10n.networkSpeedTestRun),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Future<void> _openLiveLogs() async {
    await _dnsSub?.cancel();
    _dnsSub = null;

    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const NetworkLiveLogsScreen()),
    );

    if (!mounted) return;
    _startDnsLogListener();
  }

  void _openSection(String title, Widget Function() builder) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: ValueListenableBuilder<int>(
            valueListenable: _uiTick,
            builder: (context, _, __) => SafeArea(child: builder()),
          ),
        ),
      ),
    );
  }

  Widget _vpnCard(TextTheme text) {
    final l10n = AppLocalizations.of(context)!;

    String status;

    if (vpnConflict || !cloudEnabled) {
      status = l10n.networkStatusDisconnected;
    } else {
      status = proBusy ? l10n.networkStatusConnecting : l10n.networkStatusConnected;
    }

    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                status,
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Switch(
              value: cloudEnabled,
              onChanged: proBusy ? null : (v) async => _setCloudEnabled(v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _usageCard(TextTheme text) {
    final l10n = AppLocalizations.of(context)!;

    final effectivePlan = _devForceFree
        ? 'free'
        : (_usagePlan ?? (isPro ? 'pro' : 'free')).toLowerCase();
    final resetLine = _usageResetLine(l10n);
    final lastLine = _usageLastUpdated == null
        ? ''
        : l10n.networkUsageUpdatedAt(
      _usageLastUpdated!.hour.toString().padLeft(2, '0'),
      _usageLastUpdated!.minute.toString().padLeft(2, '0'),
    );

    final showBar = (cloudEnabled || _devForceFree) && effectivePlan != 'pro';
    final realUsed = _usageUsed ?? 0;
    final limit = _usageLimit ?? _freeUsageLimit;

    final used = _devForceFree ? (limit * 0.62).toInt() : realUsed;
    final frac = _devForceFree
        ? 0.62
        : _usageFrac;
    final line = !cloudEnabled
        ? l10n.networkUsageEnableVpnToView
        : (effectivePlan == 'pro'
        ? l10n.networkUsageUnlimited
        : l10n.networkUsageUsedOf(_fmtInt(used), _fmtInt(limit)));
    final theme = Theme.of(context);

    return _sectionCard(
      title: l10n.networkUsageTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  line,
                  style: text.bodySmall?.copyWith(
                    color: text.bodySmall?.color?.withOpacity(0.85),
                  ),
                ),
              ),
              if (cloudEnabled && effectivePlan == 'pro')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: theme.colorScheme.tertiary.withOpacity(0.45), width: 1),
                  ),
                  child: Text(
                    l10n.networkUsageUnlimited,
                    style: text.labelSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                )
              else
                IconButton(
                  onPressed: _usageLoading ? null : () => _loadUsage(),
                  icon: _usageLoading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.refresh),
                ),
            ],
          ),
          if (showBar) ...[
            const SizedBox(height: 8),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: _usageFracPrev, end: frac),
              duration: const Duration(milliseconds: 650),
              builder: (context, v, _) {
                final vv = v.isNaN ? 0.0 : v.clamp(0.0, 1.0);
                return ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: vv,
                    minHeight: 10,
                    backgroundColor: Colors.white10,
                  ),
                );
              },
            ),
          ],
          if ((resetLine.isNotEmpty || lastLine.isNotEmpty) && cloudEnabled) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (resetLine.isNotEmpty)
                  Expanded(
                    child: Text(
                      resetLine,
                      style: text.bodySmall?.copyWith(
                        color: text.bodySmall?.color?.withOpacity(0.75),
                        height: 1.25,
                      ),
                    ),
                  ),
                if (lastLine.isNotEmpty)
                  Text(
                    lastLine,
                    style: text.bodySmall?.copyWith(
                      color: text.bodySmall?.color?.withOpacity(0.70),
                      height: 1.25,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _navCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: Card(
        elevation: 0,
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 22),
                const SizedBox(height: 12),
                Text(title, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: text.bodySmall?.copyWith(
                    color: text.bodySmall?.color?.withOpacity(0.78),
                    height: 1.25,
                  ),
                ),
                const Spacer(),
                Text(status, style: text.bodySmall?.copyWith(fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openGithub() async {
    final uri = Uri.parse(_githubUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final blocklistsStatus = cloudEnabled ? l10n.networkCardStatusAvailable : l10n.networkCardStatusDisabled;
    final upstreamStatus = cloudEnabled
        ? (resolverChoice == 'custom'
        ? l10n.networkCardStatusCustom
        : _presets.firstWhere((p) => p.key == resolverChoice, orElse: () => _presets.first).title)
        : l10n.networkCardStatusDisabled;
    final logsStatus = _dnsEvents.isEmpty ? l10n.networkLogsStatusNoActivity : l10n.networkLogsStatusRecent(min(_dnsEvents.length, 800).toString());
    final speedStatus = l10n.networkCardStatusReady;
    final aboutStatus = l10n.networkCardStatusOpen;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.networkProtectionTitle),
        actions: [
          if (kDebugMode)
            IconButton(
              icon: Icon(_devForceFree ? Icons.lock_open : Icons.lock),
              onPressed: () {
                setState(() {
                  _devForceFree = !_devForceFree;
                });
              },
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _vpnCard(Theme.of(context).textTheme),
              const SizedBox(height: 12),
              _usageCard(Theme.of(context).textTheme),
              const SizedBox(height: 14),
              Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).dividerColor.withOpacity(0.35),
              ),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.08,
                children: [
                  _navCard(
                    icon: Icons.shield_outlined,
                    title: l10n.networkCardBlocklistsTitle,
                    subtitle: l10n.networkCardBlocklistsSubtitle,
                    status: blocklistsStatus,
                    onTap: () => _openSection(l10n.networkCardBlocklistsTitle, () => _blocklistsTab(Theme.of(context).textTheme)),
                    enabled: true,
                  ),
                  _navCard(
                    icon: Icons.dns_outlined,
                    title: l10n.networkCardUpstreamTitle,
                    subtitle: l10n.networkCardUpstreamSubtitle,
                    status: upstreamStatus,
                    onTap: () => _openSection(l10n.networkResolverTitle, () => _upstreamTab(Theme.of(context).textTheme)),
                    enabled: true,
                  ),
                  _navCard(
                    icon: Icons.apps,
                    title: l10n.networkCardAppsTitle,
                    subtitle: l10n.networkCardAppsSubtitle,
                    status: l10n.networkCardStatusComingSoon,
                    onTap: () {},
                    enabled: false,
                  ),
                  _navCard(
                    icon: Icons.subject,
                    title: l10n.networkCardLogsTitle,
                    subtitle: l10n.networkCardLogsSubtitle,
                    status: logsStatus,
                    onTap: () async => _openLiveLogs(),
                  ),
                  _navCard(
                    icon: Icons.speed,
                    title: l10n.networkCardSpeedTitle,
                    subtitle: l10n.networkCardSpeedSubtitle,
                    status: speedStatus,
                    onTap: () => _openSection(l10n.networkSpeedTestTitle, () => _speedTab(Theme.of(context).textTheme)),
                  ),
                  _navCard(
                    icon: Icons.info_outline,
                    title: l10n.networkCardAboutTitle,
                    subtitle: l10n.networkCardAboutSubtitle,
                    status: aboutStatus,
                    onTap: () => _openGithub(),
                    enabled: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkLiveLogsScreen extends StatefulWidget {
  const NetworkLiveLogsScreen({super.key});

  @override
  State<NetworkLiveLogsScreen> createState() => _NetworkLiveLogsScreenState();
}

class _NetworkLiveLogsScreenState extends State<NetworkLiveLogsScreen> {
  static const _dnsEventChannel = EventChannel('cs_dns_events');

  StreamSubscription<dynamic>? _dnsSub;
  final List<_DnsEvent> _dnsEvents = [];

  void _vpnLog(String msg) {
    debugPrint('[CS VPN] $msg');
  }

  @override
  void initState() {
    super.initState();
    _dnsSub = _dnsEventChannel.receiveBroadcastStream().listen((event) {
      if (!mounted) return;
      if (event is Map) {
        final e = _DnsEvent.fromMap(event);
        setState(() {
          _dnsEvents.insert(0, e);
          if (_dnsEvents.length > 800) {
            _dnsEvents.removeRange(800, _dnsEvents.length);
          }
        });
      }
    }, onError: (err) {
      _vpnLog('DNS event stream error: $err');
    });
  }

  @override
  void dispose() {
    _dnsSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.networkLiveLogsTitle)),
      body: SafeArea(
        child: _dnsEvents.isEmpty
            ? Center(child: Text(l10n.networkLiveLogsEmpty, style: text.bodyMedium))
            : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: _dnsEvents.length,
          itemBuilder: (context, i) {
            final e = _dnsEvents[i];
            final ts = DateTime.fromMillisecondsSinceEpoch(e.tsMs);
            final hh = ts.hour.toString().padLeft(2, '0');
            final mm = ts.minute.toString().padLeft(2, '0');
            final ss = ts.second.toString().padLeft(2, '0');
            final time = '$hh:$mm:$ss';

            final meta = <String>[];
            if (e.upstream != null && e.upstream!.trim().isNotEmpty) meta.add(e.upstream!);
            if (e.latencyMs != null) meta.add('${e.latencyMs}ms');
            if (e.matchList != null && e.matchType != null) meta.add('${e.matchList}:${e.matchType}');
            final sub = meta.isEmpty ? e.plan : '${e.plan}  •  ${meta.join('  •  ')}';

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 76,
                      child: Text(
                        time,
                        style: text.bodySmall?.copyWith(color: text.bodySmall?.color?.withOpacity(0.8)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.qname,
                            style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          if (sub.isNotEmpty)
                            Text(
                              sub,
                              style: text.bodySmall?.copyWith(
                                color: text.bodySmall?.color?.withOpacity(0.75),
                                height: 1.25,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      e.blocked ? l10n.networkLiveLogsBlocked : l10n.networkLiveLogsAllowed,
                      style: text.bodySmall?.copyWith(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}