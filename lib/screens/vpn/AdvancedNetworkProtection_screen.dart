import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/dnsService/auth_service.dart';
import '../../services/service_manager.dart';
import '../../translations/app_localizations.dart';
import 'Network_app_control_screen.dart';
import 'Network_speed_test_screen.dart';

class NetworkAdvancedScreen extends StatefulWidget {
  const NetworkAdvancedScreen({super.key});

  @override
  State<NetworkAdvancedScreen> createState() => _NetworkAdvancedScreenState();
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

class _NetworkAdvancedScreenState extends State<NetworkAdvancedScreen> with WidgetsBindingObserver {
  static const _deviceIdKey = 'dns_device_id';

  static const _prefCloudEnabled = 'dns_cloud_enabled';
  static const _prefCloudAdult = 'dns_cloud_adult';
  static const _prefCloudListMalware = 'dns_cloud_list_malware';
  static const _prefCloudListAds = 'dns_cloud_list_ads';
  static const _prefCloudListTrackers = 'dns_cloud_list_trackers';
  static const _prefCloudResolverChoice = 'dns_cloud_resolver_choice';
  static const _prefCloudResolverCustom = 'dns_cloud_resolver_custom';

  static const _dnsEventChannel = EventChannel('cs_dns_events');

  static const List<_UpstreamPreset> _presets = [
    _UpstreamPreset(key: 'cloudflare', title: 'Cloudflare', subtitle: '1.1.1.1', ip: '1.1.1.1'),
    _UpstreamPreset(key: 'cloudflare_alt', title: 'Cloudflare (alt)', subtitle: '1.0.0.1', ip: '1.0.0.1'),
    _UpstreamPreset(key: 'google', title: 'Google', subtitle: '8.8.8.8', ip: '8.8.8.8'),
    _UpstreamPreset(key: 'google_alt', title: 'Google (alt)', subtitle: '8.8.4.4', ip: '8.8.4.4'),
    _UpstreamPreset(key: 'quad9', title: 'Quad9', subtitle: '9.9.9.9', ip: '9.9.9.9'),
    _UpstreamPreset(key: 'quad9_alt', title: 'Quad9 (alt)', subtitle: '149.112.112.112', ip: '149.112.112.112'),
    _UpstreamPreset(key: 'adguard', title: 'AdGuard', subtitle: '94.140.14.14', ip: '94.140.14.14'),
    _UpstreamPreset(key: 'adguard_alt', title: 'AdGuard (alt)', subtitle: '94.140.15.15', ip: '94.140.15.15'),
    _UpstreamPreset(key: 'custom', title: 'Custom', subtitle: 'Enter your own resolver', ip: ''),
  ];

  bool proBusy = false;
  bool isPro = false;

  bool cloudEnabled = false;
  bool cloudAdult = false;
  bool cloudMalware = true;
  bool cloudAds = true;
  bool cloudTrackers = true;

  String resolverChoice = 'cloudflare';
  String resolverCustom = '';

  bool hasDeviceId = false;

  StreamSubscription<dynamic>? _dnsSub;
  final List<_DnsEvent> _dnsEvents = [];

  final TextEditingController _customResolverCtrl = TextEditingController();
  final ValueNotifier<int> _uiTick = ValueNotifier<int>(0);

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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dnsSub?.cancel();
    _customResolverCtrl.dispose();
    _uiTick.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _recheckProAndPushIfNeeded();
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

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();

    final ce = prefs.getBool(_prefCloudEnabled) ?? false;
    final ca = prefs.getBool(_prefCloudAdult) ?? false;
    final cm = prefs.getBool(_prefCloudListMalware) ?? true;
    final cad = prefs.getBool(_prefCloudListAds) ?? true;
    final ct = prefs.getBool(_prefCloudListTrackers) ?? true;
    final rc = prefs.getString(_prefCloudResolverChoice) ?? 'cloudflare';
    final rcustom = prefs.getString(_prefCloudResolverCustom) ?? '';

    final did = prefs.getString(_deviceIdKey);
    final didOk = did != null && did.trim().isNotEmpty;

    final pro = await ProEntitlementService.isPro();

    if (!mounted) return;

    _customResolverCtrl.text = rcustom;

    setState(() {
      cloudEnabled = ce;
      cloudAdult = ca;
      cloudMalware = cm;
      cloudAds = cad;
      cloudTrackers = ct;
      resolverChoice = rc;
      resolverCustom = rcustom;
      hasDeviceId = didOk;
      isPro = pro;
    });
    _bumpUi();

    if (cloudEnabled && hasDeviceId) {
      await _pushCloudSettingsToVpn();
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
    await prefs.setBool(_prefCloudAdult, cloudAdult);
    await prefs.setBool(_prefCloudListMalware, cloudMalware);
    await prefs.setBool(_prefCloudListAds, cloudAds);
    await prefs.setBool(_prefCloudListTrackers, cloudTrackers);
    await prefs.setString(_prefCloudResolverChoice, resolverChoice);
    await prefs.setString(_prefCloudResolverCustom, resolverCustom);
  }

  Future<void> _setCloudEnabled(bool v) async {
    final prefs = await SharedPreferences.getInstance();

    if (v) {
      await ProEntitlementService.clearCache();
      final pro = await ProEntitlementService.isPro();
      final clientId = await _ensureDeviceId();

      await prefs.setBool(_prefCloudEnabled, true);
      await prefs.setBool('networkProtectionEnabled', true);
      await prefs.setString('networkProtectionMode', 'cloud');

      await AvServiceManager.startVpn(dnsMode: 'cloud');

      if (!mounted) return;
      setState(() {
        cloudEnabled = true;
        isPro = pro;
        hasDeviceId = clientId.trim().isNotEmpty;
      });

      await _pushCloudSettingsToVpn();
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
    });
    _bumpUi();
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
    final enabledLists = <String>[];

    if (cloudMalware) enabledLists.add('malicious');
    if (isPro && cloudAds) enabledLists.add('oisd');

    final resolver = cloudAdult ? '1.1.1.3' : _resolverIpForChoice();

    return {
      'enabled_lists': enabledLists,
      'resolver': resolver,
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
    } catch (_) {} finally {
      if (!mounted) return;
      setState(() => proBusy = false);
      _bumpUi();
    }
  }

  Future<void> _connectOrRefresh() async {
    if (proBusy) return;
    if (!mounted) return;
    setState(() => proBusy = true);
    _bumpUi();

    try {
      await ProEntitlementService.clearCache();
      final pro = await ProEntitlementService.isPro();
      final clientId = await _ensureDeviceId();

      cloudEnabled = true;
      await _saveCloudPrefs();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefCloudEnabled, true);
      await prefs.setBool('networkProtectionEnabled', true);
      await prefs.setString('networkProtectionMode', 'cloud');

      await AvServiceManager.startVpn(dnsMode: 'cloud');

      if (!mounted) return;
      setState(() {
        cloudEnabled = true;
        isPro = pro;
        hasDeviceId = clientId.trim().isNotEmpty;
      });
      _bumpUi();

      await _pushCloudSettingsToVpn();
    } catch (_) {} finally {
      if (!mounted) return;
      setState(() => proBusy = false);
      _bumpUi();
    }
  }

  Widget _pagePadding(Widget child) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: child,
    );
  }

  Widget _connectionTab(TextTheme text) {
    return _pagePadding(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionCard(
            title: 'Cloud protection mode',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        cloudEnabled ? 'Enabled' : 'Disabled',
                        style: text.bodySmall?.copyWith(
                          color: text.bodySmall?.color?.withOpacity(0.8),
                        ),
                      ),
                    ),
                    Switch(
                      value: cloudEnabled,
                      onChanged: proBusy ? null : (v) async => _setCloudEnabled(v),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Routes all DNS queries to the cloud engine, enabling live blocklist updates, domain reputation checking, and more.',
                  style: text.bodySmall?.copyWith(
                    color: text.bodySmall?.color?.withOpacity(0.78),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            title: 'Refresh pro status',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isPro ? 'Pro active' : 'Free plan',
                        style: text.bodySmall?.copyWith(
                          color: text.bodySmall?.color?.withOpacity(0.8),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: proBusy ? null : () async => _recheckProAndPushIfNeeded(),
                      icon: proBusy
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Icon(Icons.refresh),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Checks your entitlement and syncs it with cloud features. Pro unlocks system wide ad blocking.',
                  style: text.bodySmall?.copyWith(
                    color: text.bodySmall?.color?.withOpacity(0.78),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _blocklistsTab(TextTheme text) {
    final unlocked = cloudEnabled && isPro;
    final opacity = unlocked ? 1.0 : 0.45;

    return _pagePadding(
      Opacity(
        opacity: opacity,
        child: _sectionCard(
          title: 'Blocklists',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: cloudMalware,
                onChanged: unlocked
                    ? (v) async {
                  setState(() => cloudMalware = v);
                  _bumpUi();
                  await _pushCloudSettingsToVpn();
                }
                    : null,
                title: const Text('Malware protection'),
                subtitle: const Text('Blocks known malicious domains'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: cloudTrackers,
                onChanged: unlocked
                    ? (v) async {
                  setState(() => cloudTrackers = v);
                  _bumpUi();
                  await _pushCloudSettingsToVpn();
                }
                    : null,
                title: const Text('Tracker protection'),
                subtitle: const Text('Reduces tracking domains'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: cloudAds,
                onChanged: unlocked
                    ? (v) async {
                  setState(() => cloudAds = v);
                  _bumpUi();
                  await _pushCloudSettingsToVpn();
                }
                    : null,
                title: const Text('Ad protection'),
                subtitle: const Text('Blocks common ad domains'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: cloudAdult,
                onChanged: unlocked
                    ? (v) async {
                  setState(() => cloudAdult = v);
                  _bumpUi();
                  await _pushCloudSettingsToVpn();
                }
                    : null,
                title: const Text('Adult filter'),
                subtitle: const Text('Uses 1.1.1.3 upstream'),
              ),
              if (!unlocked)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Locked until Pro is active and cloud mode is enabled.',
                    style: text.bodySmall?.copyWith(
                      color: text.bodySmall?.color?.withOpacity(0.75),
                      height: 1.35,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _upstreamTab(TextTheme text) {
    final unlocked = cloudEnabled && isPro;
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

    return _pagePadding(
      Opacity(
        opacity: opacity,
        child: _sectionCard(
          title: 'Resolver',
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
                    decoration: const InputDecoration(
                      labelText: 'Resolver IP',
                      hintText: 'Example: 1.1.1.1',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) async {
                      resolverCustom = v;
                      _bumpUi();
                      await _pushCloudSettingsToVpn();
                    },
                  ),
                ),
              if (!unlocked)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Locked until Pro is active and cloud mode is enabled.',
                    style: text.bodySmall?.copyWith(
                      color: text.bodySmall?.color?.withOpacity(0.75),
                      height: 1.35,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logsTab(TextTheme text) {
    final preview = _dnsEvents.toList();

    return _pagePadding(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionCard(
            title: 'Logs',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live DNS events from the VPN layer.',
                  style: text.bodySmall?.copyWith(
                    color: text.bodySmall?.color?.withOpacity(0.85),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                if (preview.isEmpty)
                  Text(
                    'No requests yet.',
                    style: text.bodySmall?.copyWith(
                      color: text.bodySmall?.color?.withOpacity(0.75),
                    ),
                  )
                else
                  Column(
                    children: preview.map((e) {
                      final ts = DateTime.fromMillisecondsSinceEpoch(e.tsMs);
                      final hh = ts.hour.toString().padLeft(2, '0');
                      final mm = ts.minute.toString().padLeft(2, '0');
                      final ss = ts.second.toString().padLeft(2, '0');
                      final left = '$hh:$mm:$ss';
                      final right = e.blocked ? 'Blocked' : 'Allowed';

                      final meta = <String>[];
                      if (e.upstream != null && e.upstream!.trim().isNotEmpty) meta.add(e.upstream!);
                      if (e.latencyMs != null) meta.add('${e.latencyMs}ms');
                      if (e.matchList != null && e.matchType != null) meta.add('${e.matchList}:${e.matchType}');
                      final sub = meta.isEmpty ? e.plan : '${e.plan}  •  ${meta.join('  •  ')}';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 72,
                                child: Text(
                                  left,
                                  style: text.bodySmall?.copyWith(
                                    color: text.bodySmall?.color?.withOpacity(0.8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.qname,
                                      style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
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
                              const SizedBox(width: 10),
                              Text(
                                right,
                                style: text.bodySmall?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _speedTab(TextTheme text) {
    return _pagePadding(
      _sectionCard(
        title: 'Speed test',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Runs a DNS speed tester using your current settings.',
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
                child: const Text('Run speed test'),
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

  Widget _homeCard({
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final connectionStatus = cloudEnabled ? 'Enabled' : 'Disabled';
    final blocklistsStatus = (cloudEnabled && isPro) ? 'Available' : 'Locked';
    final upstreamStatus = (cloudEnabled && isPro)
        ? (resolverChoice == 'custom'
        ? 'Custom'
        : _presets.firstWhere((p) => p.key == resolverChoice, orElse: () => _presets.first).title)
        : 'Locked';
    final appsStatus = (cloudEnabled && isPro) ? 'Available' : 'Available';
    final logsStatus = _dnsEvents.isEmpty ? 'No activity' : '${min(_dnsEvents.length, 800)} recent';
    final speedStatus = 'Ready';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.networkProtectionTitle ?? 'Advanced'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.08,
                children: [
                  _homeCard(
                    icon: Icons.public,
                    title: 'DNS',
                    subtitle: 'Cloud DNS mode',
                    status: connectionStatus,
                    onTap: () => _openSection('Connection', () => _connectionTab(Theme.of(context).textTheme)),
                  ),
                  _homeCard(
                    icon: Icons.shield_outlined,
                    title: 'Blocklists',
                    subtitle: 'Filtering controls',
                    status: blocklistsStatus,
                    onTap: () => _openSection('Blocklists', () => _blocklistsTab(Theme.of(context).textTheme)),
                    enabled: true,
                  ),
                  _homeCard(
                    icon: Icons.dns_outlined,
                    title: 'Upstream',
                    subtitle: 'Resolver selection',
                    status: upstreamStatus,
                    onTap: () => _openSection('Resolver', () => _upstreamTab(Theme.of(context).textTheme)),
                    enabled: true,
                  ),
                  _homeCard(
                    icon: Icons.apps,
                    title: 'Apps',
                    subtitle: 'Block apps on WiFi',
                    status: appsStatus,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NetworkAppControlScreen()),
                      );
                    },
                    enabled: true,
                  ),
                  _homeCard(
                    icon: Icons.subject,
                    title: 'Logs',
                    subtitle: 'Live DNS events',
                    status: logsStatus,
                    onTap: () async => _openLiveLogs(),
                  ),
                  _homeCard(
                    icon: Icons.speed,
                    title: 'Speed',
                    subtitle: 'DNS test',
                    status: speedStatus,
                    onTap: () => _openSection('Speed test', () => _speedTab(Theme.of(context).textTheme)),
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

    return Scaffold(
      appBar: AppBar(title: const Text('Live logs')),
      body: SafeArea(
        child: _dnsEvents.isEmpty
            ? Center(child: Text('No requests yet.', style: text.bodyMedium))
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
                      e.blocked ? 'Blocked' : 'Allowed',
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
