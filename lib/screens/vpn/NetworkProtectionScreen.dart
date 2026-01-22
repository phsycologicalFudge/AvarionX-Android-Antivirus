import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/service_manager.dart';

class NetworkProtectionScreen extends StatefulWidget {
  const NetworkProtectionScreen({super.key});

  @override
  State<NetworkProtectionScreen> createState() =>
      _NetworkProtectionScreenState();
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

  bool rtpEnabled = false;
  bool networkEnabled = false;
  bool vpnConflict = false;
  bool _pressed = false;

  String dnsMode = 'malware';

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

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final rtp = prefs.getBool('protectionEnabled') ?? false;
    final net = prefs.getBool('networkProtectionEnabled') ?? false;
    final mode = prefs.getString('networkDnsMode') ?? 'malware';

    bool conflict = false;
    if (rtp && net) {
      conflict = await _isAnotherVpnActive();
      if (conflict) {
        await AvServiceManager.stopVpn();
      }
    }

    setState(() {
      rtpEnabled = rtp;
      networkEnabled = rtp && net && !conflict;
      vpnConflict = conflict;
      dnsMode = mode;
    });
  }

  Future<void> _toggleNetwork() async {
    final prefs = await SharedPreferences.getInstance();

    if (!rtpEnabled) {
      await AvServiceManager.startProtection();
      await prefs.setBool('protectionEnabled', true);
      rtpEnabled = true;
    }

    final conflict = await _isAnotherVpnActive();
    if (conflict) {
      setState(() {
        vpnConflict = true;
        networkEnabled = false;
      });
      return;
    }

    if (networkEnabled) {
      await AvServiceManager.stopVpn();
      await prefs.setBool('networkProtectionEnabled', false);

      setState(() {
        networkEnabled = false;
        vpnConflict = false;
      });
      return;
    }

    final ok = await _requestVpnPermission();
    if (!ok) return;

    await AvServiceManager.startVpn(
      dnsMode: dnsMode,
    );

    await prefs.setBool('networkProtectionEnabled', true);

    setState(() {
      networkEnabled = true;
      vpnConflict = false;
    });
  }

  Future<void> _setDnsMode(String mode) async {
    if (!networkEnabled) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('networkDnsMode', mode);

    await AvServiceManager.stopVpn();
    await AvServiceManager.startVpn(dnsMode: mode);

    setState(() {
      dnsMode = mode;
    });
  }

  Color _accent() {
    if (!networkEnabled) return Colors.redAccent;
    return Colors.greenAccent;
  }

  IconData _icon() {
    if (!networkEnabled) return Icons.wifi_off;
    return Icons.wifi;
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
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withOpacity(0.7),
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

  Widget _infoBox(ThemeData theme, TextTheme text) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What is Network Protection?',
            style: text.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Some threats work by connecting to '
                'malicious servers or redirecting internet traffic.\n'
                'Network Protection blocks known dangerous domains & common ads by using '
                'a local VPN.\n\n'
                'CS Security does not collect any data.',
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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Protection'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              GestureDetector(
                onTapDown: (_) => setState(() => _pressed = true),
                onTapUp: (_) => setState(() => _pressed = false),
                onTapCancel: () => setState(() => _pressed = false),
                onTap: _toggleNetwork,
                child: AnimatedScale(
                  scale: _pressed ? 0.97 : 1.0,
                  duration: const Duration(milliseconds: 120),
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(140, 140),
                          painter: RingPainter(
                            color: _accent(),
                            thickness: 10,
                            backgroundOpacity: isDark ? 0.14 : 0.10,
                          ),
                        ),
                        Icon(
                          _icon(),
                          size: 38,
                          color: _accent(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                networkEnabled
                    ? 'Connected to ${dnsMode == 'malware' ? '1.1.1.2' : '1.1.1.3'}'
                    : vpnConflict
                    ? 'Another VPN is active'
                    : 'Network protection is off',
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _dnsToggle(
                title: 'Malware Blocking Only',
                subtitle: 'Uses 1.1.1.2',
                description:
                'Combines CS Security’s local malware database with Cloudflare’s online threat intelligence '
                    'for maximum malware protection.',
                selected: dnsMode == 'malware',
                enabled: networkEnabled,
                onTap: () => _setDnsMode('malware'),
              ),
              _dnsToggle(
                title: 'Malware & Adult Content',
                subtitle: 'Uses 1.1.1.3',
                description:
                'Uses CS Security’s offline malware database and adds adult content filtering. '
                    'Cloud-based malware intelligence is disabled in this mode.',
                selected: dnsMode == 'adult',
                enabled: networkEnabled,
                onTap: () => _setDnsMode('adult'),
              ),
              _infoBox(theme, text),
            ],
          ),
        ),
      ),
    );
  }
}
