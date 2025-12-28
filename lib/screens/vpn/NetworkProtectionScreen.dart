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
  bool rtpEnabled = false;
  bool networkEnabled = false;
  bool vpnConflict = false;
  bool _pressed = false;

  Future<bool> _isAnotherVpnActive() async {
    const chan = MethodChannel("cs_vpn_state");
    try {
      return await chan.invokeMethod<bool>("isAnotherVpnActive") ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _requestVpnPermission() async {
    const chan = MethodChannel("cs_vpn_permission");
    final ok = await chan.invokeMethod<bool>("prepareVpn");
    return ok == true;
  }

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final rtp = prefs.getBool('protectionEnabled') ?? false;
    final net = prefs.getBool('networkProtectionEnabled') ?? false;

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

    await AvServiceManager.startVpn();
    await prefs.setBool('networkProtectionEnabled', true);

    setState(() {
      networkEnabled = true;
      vpnConflict = false;
    });
  }

  double _ringValue() {
    if (!rtpEnabled || !networkEnabled) return 0.0;
    return 0.999;
  }

  Color _accent() {
    if (!rtpEnabled || !networkEnabled) return Colors.redAccent;
    return Colors.greenAccent;
  }

  IconData _icon() {
    if (!rtpEnabled || !networkEnabled) return Icons.wifi_off;
    return Icons.wifi;
  }

  String _line1() {
    if (!rtpEnabled) return 'Protection is off';
    if (vpnConflict) return 'Network protection unavailable';
    if (!networkEnabled) return 'Network protection is off';
    return 'Network is protected';
  }

  String _line2() {
    if (vpnConflict) return 'Another VPN is active';
    if (!networkEnabled) return 'Tap to enable';
    return 'Tap to disable';
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
                'CS Security does not collect any data..',
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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Network Protection'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTapDown: (_) => setState(() => _pressed = true),
                  onTapUp: (_) => setState(() => _pressed = false),
                  onTapCancel: () => setState(() => _pressed = false),
                  onTap: _toggleNetwork,
                  child: AnimatedScale(
                    scale: _pressed ? 0.97 : 1.0,
                    duration: const Duration(milliseconds: 120),
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(180, 180),
                            painter: RingPainter(
                              color: _accent(),
                              thickness: 12,
                              backgroundOpacity: isDark ? 0.14 : 0.10,
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(useMaterial3: false),
                            child: Icon(
                              _icon(),
                              size: 46,
                              color: _accent(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  _line1(),
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  _line2(),
                  style: text.bodySmall?.copyWith(
                    color: text.bodySmall?.color?.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                _infoBox(theme, text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
