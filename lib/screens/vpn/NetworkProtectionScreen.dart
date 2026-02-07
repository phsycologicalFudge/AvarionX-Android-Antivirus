import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/service_manager.dart';
import '../../translations/app_localizations.dart';
import 'AdvancedNetworkProtection_screen.dart';

class NetworkProtectionScreen extends StatefulWidget {
  const NetworkProtectionScreen({super.key});

  @override
  State<NetworkProtectionScreen> createState() => _NetworkProtectionScreenState();
}

class RingPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double backgroundOpacity;

  RingPainter({
    required this.color,
    required this.thickness,
    required this.backgroundOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - thickness / 2;

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..color = color.withOpacity(backgroundOpacity);

    final fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..color = color;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawCircle(center, radius, fgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NetworkProtectionScreenState extends State<NetworkProtectionScreen> {
  static const _vpnGrantedKey = 'vpn_permission_granted';

  static const _prefRtpEnabled = 'protectionEnabled';
  static const _prefVpnEnabled = 'networkProtectionEnabled';
  static const _prefVpnMode = 'networkProtectionMode';
  static const _prefBasicDnsMode = 'networkDnsMode';

  static const _prefCloudEnabled = 'dns_cloud_enabled';

  bool rtpEnabled = false;

  bool vpnEnabled = false;
  String vpnMode = 'off';

  bool vpnConflict = false;

  String basicDnsMode = 'malware';

  bool cloudEnabled = false;

  Future<bool> _isAnotherVpnActive() async {
    const chan = MethodChannel("cs_vpn_state");
    try {
      return await chan.invokeMethod<bool>("isAnotherVpnActive") ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _requestVpnPermission() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_vpnGrantedKey) == true) {
      return true;
    }

    const chan = MethodChannel("cs_vpn_permission");
    final ok = await chan.invokeMethod<bool>("prepareVpn") == true;

    if (ok) {
      await prefs.setBool(_vpnGrantedKey, true);
    }

    return ok;
  }

  void _vpnLog(String msg) {
    debugPrint('[CS VPN] $msg');
  }

  @override
  void initState() {
    super.initState();
    _vpnLog('NetworkProtectionScreen initState');
    _loadState();
  }

  Future<void> _loadState() async {
    _vpnLog('Loading VPN/network state from SharedPreferences');
    final prefs = await SharedPreferences.getInstance();

    final rtp = prefs.getBool(_prefRtpEnabled) ?? false;
    final vpn = prefs.getBool(_prefVpnEnabled) ?? false;
    final mode = prefs.getString(_prefVpnMode) ?? 'off';
    final basicMode = prefs.getString(_prefBasicDnsMode) ?? 'malware';
    final ce = prefs.getBool(_prefCloudEnabled) ?? false;

    bool conflict = false;
    if (rtp && vpn) {
      conflict = await _isAnotherVpnActive();
      _vpnLog('Checked for other VPN: conflict=$conflict');
      if (conflict) {
        _vpnLog('Conflict detected, stopping internal VPN');
        await AvServiceManager.stopVpn();
      }
    }

    if (!mounted) return;

    setState(() {
      rtpEnabled = rtp;

      cloudEnabled = ce;

      vpnEnabled = rtp && vpn && !conflict;
      vpnMode = vpnEnabled ? mode : 'off';
      vpnConflict = conflict;

      basicDnsMode = basicMode;
    });

    _vpnLog('State after load: vpnEnabled=$vpnEnabled vpnMode=$vpnMode vpnConflict=$vpnConflict cloudEnabled=$cloudEnabled');
  }

  Future<void> _setVpnModeOff() async {
    final prefs = await SharedPreferences.getInstance();
    await AvServiceManager.stopVpn();
    await prefs.setBool(_prefVpnEnabled, false);
    await prefs.setString(_prefVpnMode, 'off');
    await prefs.setBool(_prefCloudEnabled, false);

    if (!mounted) return;
    setState(() {
      vpnEnabled = false;
      vpnMode = 'off';
      cloudEnabled = false;
      vpnConflict = false;
    });
  }

  Future<void> _toggleBasicVpn() async {
    if (cloudEnabled) {
      _vpnLog('Basic VPN toggle ignored because cloudEnabled=true');
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    if (!rtpEnabled) {
      _vpnLog('RTP not enabled, starting protection before enabling basic VPN');
      await AvServiceManager.startProtection();
      await prefs.setBool(_prefRtpEnabled, true);
      rtpEnabled = true;
    }

    final conflict = await _isAnotherVpnActive();
    _vpnLog('Basic VPN toggle, conflict check result: $conflict');
    if (conflict) {
      if (!mounted) return;
      setState(() {
        vpnConflict = true;
        vpnEnabled = false;
        vpnMode = 'off';
      });
      _vpnLog('Another VPN active, basic VPN not started');
      return;
    }

    if (vpnEnabled && vpnMode == 'basic') {
      _vpnLog('Basic VPN currently enabled, turning off');
      await _setVpnModeOff();
      return;
    }

    _vpnLog('Requesting VPN permission for basic mode');
    final ok = await _requestVpnPermission();
    _vpnLog('VPN permission result for basic mode: $ok');
    if (!ok) return;

    await prefs.setString(_prefVpnMode, 'basic');
    await prefs.setBool(_prefCloudEnabled, false);
    await prefs.setBool(_prefVpnEnabled, true);

    _vpnLog('Starting VPN in basic mode with dnsMode=$basicDnsMode');
    await AvServiceManager.startVpn(dnsMode: basicDnsMode);

    if (!mounted) return;
    setState(() {
      vpnEnabled = true;
      vpnMode = 'basic';
      cloudEnabled = false;
      vpnConflict = false;
    });

    _vpnLog('Basic VPN enabled: vpnEnabled=$vpnEnabled vpnMode=$vpnMode');
  }

  Future<void> _setBasicDnsMode(String mode) async {
    if (!(vpnEnabled && vpnMode == 'basic')) {
      _vpnLog('Ignoring _setBasicDnsMode("$mode") because vpnEnabled=$vpnEnabled vpnMode=$vpnMode');
      return;
    }
    _vpnLog('Changing basic DNS mode to "$mode" and restarting VPN');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefBasicDnsMode, mode);

    await AvServiceManager.stopVpn();
    await AvServiceManager.startVpn(dnsMode: mode);

    if (!mounted) return;
    setState(() {
      basicDnsMode = mode;
    });
  }

  Future<void> _toggleCloudMode() async {
    final prefs = await SharedPreferences.getInstance();

    if (!rtpEnabled) {
      _vpnLog('RTP not enabled, starting protection before enabling cloud VPN');
      await AvServiceManager.startProtection();
      await prefs.setBool(_prefRtpEnabled, true);
      rtpEnabled = true;
    }

    if (!cloudEnabled) {
      final conflict = await _isAnotherVpnActive();
      _vpnLog('Cloud mode conflict check: $conflict');
      if (conflict) {
        if (!mounted) return;
        setState(() {
          vpnConflict = true;
          cloudEnabled = false;
          vpnEnabled = false;
          vpnMode = 'off';
        });
        _vpnLog('Another VPN active, cloud mode not started');
        return;
      }

      _vpnLog('Requesting VPN permission for cloud mode');
      final ok = await _requestVpnPermission();
      _vpnLog('VPN permission result for cloud mode: $ok');
      if (!ok) return;

      await prefs.setString(_prefVpnMode, 'cloud');
      await prefs.setBool(_prefCloudEnabled, true);
      await prefs.setBool(_prefVpnEnabled, true);

      _vpnLog('Starting VPN in cloud mode');
      await AvServiceManager.startVpn(dnsMode: 'cloud');

      if (!mounted) return;
      setState(() {
        cloudEnabled = true;
        vpnEnabled = true;
        vpnMode = 'cloud';
        vpnConflict = false;
      });

      return;
    }

    _vpnLog('Cloud mode toggle: disabling, calling _setVpnModeOff');
    await _setVpnModeOff();
  }

  Color _accent() {
    if (vpnConflict) return Colors.orangeAccent;
    if (!vpnEnabled) return Colors.redAccent;
    return Colors.greenAccent;
  }

  IconData _icon() {
    if (vpnConflict) return Icons.warning_amber_rounded;
    if (!vpnEnabled) return Icons.wifi_off;
    return Icons.wifi;
  }

  Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  Widget _bigToggleCard(ThemeData theme, TextTheme text, AppLocalizations l10n) {
    String statusText;
    if (vpnConflict) {
      statusText = l10n.networkStatusVpnConflict;
    } else if (!vpnEnabled) {
      statusText = l10n.networkStatusOff;
    } else {
      if (vpnMode == 'cloud') {
        statusText = 'Connected, cloud protection mode';
      } else {
        final dns = basicDnsMode == 'malware' ? '1.1.1.2' : '1.1.1.3';
        statusText = l10n.networkStatusConnected(dns);
      }
    }

    final basicSwitchDisabled = cloudEnabled;

    return _card(
      Row(
        children: [
          SizedBox(
            width: 54,
            height: 54,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(54, 54),
                  painter: RingPainter(
                    color: _accent(),
                    thickness: 6,
                    backgroundOpacity: theme.brightness == Brightness.dark ? 0.14 : 0.10,
                  ),
                ),
                Icon(
                  _icon(),
                  size: 18,
                  color: _accent(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.networkProtectionTitle,
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: text.bodySmall?.copyWith(
                    color: text.bodySmall?.color?.withOpacity(0.85),
                    height: 1.25,
                  ),
                ),
                if (basicSwitchDisabled)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Basic mode is locked while cloud mode is enabled.',
                      style: text.bodySmall?.copyWith(
                        color: text.bodySmall?.color?.withOpacity(0.75),
                        height: 1.25,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: vpnEnabled && vpnMode == 'basic',
            onChanged: basicSwitchDisabled ? null : (_) => _toggleBasicVpn(),
          ),
        ],
      ),
    );
  }

  Widget _dnsToggle({
    required String title,
    required String subtitle,
    required String description,
    required bool selected,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: ListTile(
        onTap: enabled ? onTap : null,
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11,
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
        trailing: Switch(
          value: selected,
          onChanged: enabled ? (_) => onTap() : null,
        ),
      ),
    );
  }

  Widget _infoBox(ThemeData theme, TextTheme text, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.networkInfoTitle,
            style: text.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.networkInfoBody,
            style: text.bodySmall?.copyWith(
              color: text.bodySmall?.color?.withOpacity(0.8),
              height: 1.35,
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
    final l10n = AppLocalizations.of(context)!;

    final basicEnabled = vpnEnabled && vpnMode == 'basic';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.networkProtectionTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Advanced network settings',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NetworkAdvancedScreen()),
              );
              await _loadState();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bigToggleCard(theme, text, l10n),
              const SizedBox(height: 12),
              _dnsToggle(
                title: l10n.networkModeMalwareTitle,
                subtitle: l10n.networkModeMalwareSubtitle,
                description: l10n.networkModeMalwareDescription,
                selected: basicDnsMode == 'malware',
                enabled: basicEnabled,
                onTap: () => _setBasicDnsMode('malware'),
              ),
              _dnsToggle(
                title: l10n.networkModeAdultTitle,
                subtitle: l10n.networkModeAdultSubtitle,
                description: l10n.networkModeAdultDescription,
                selected: basicDnsMode == 'adult',
                enabled: basicEnabled,
                onTap: () => _setBasicDnsMode('adult'),
              ),
              _infoBox(theme, text, l10n),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
