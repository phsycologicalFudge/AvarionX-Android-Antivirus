import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/service_manager.dart';

class NetworkProtectionScreen extends StatefulWidget {
  const NetworkProtectionScreen({super.key});

  @override
  State<NetworkProtectionScreen> createState() =>
      _NetworkProtectionScreenState();
}

class _NetworkProtectionScreenState extends State<NetworkProtectionScreen> {
  bool vpnEnabled = false;
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

  Future<void> _toggleVpn() async {
    if (vpnEnabled) {
      await AvServiceManager.stopVpn();
      setState(() {
        vpnEnabled = false;
        vpnConflict = false;
      });
      return;
    }

    final ok = await _requestVpnPermission();
    if (!ok) return;

    final conflict = await _isAnotherVpnActive();

    if (!conflict) {
      await AvServiceManager.startVpn();
    }

    setState(() {
      vpnEnabled = true;
      vpnConflict = conflict;
    });
  }

  double _ringValue() {
    if (!vpnEnabled) return 0.0;
    if (vpnConflict) return 0.6;
    return 1.0;
  }

  Color _accent() {
    if (!vpnEnabled) return Colors.redAccent;
    if (vpnConflict) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  IconData _icon() {
    if (!vpnEnabled) return Icons.wifi_off_rounded;
    if (vpnConflict) return Icons.wifi_lock_rounded;
    return Icons.wifi_rounded;
  }

  String _line1() {
    if (!vpnEnabled) return 'Network protection is off';
    if (vpnConflict) return 'Partial protection';
    return 'Network is protected';
  }

  String _line2() {
    if (!vpnEnabled) return 'Tap to turn on';
    if (vpnConflict) return 'Another VPN is active';
    return 'Tap to turn off';
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
                  onTap: _toggleVpn,
                  child: AnimatedScale(
                    scale: _pressed ? 0.97 : 1.0,
                    duration: const Duration(milliseconds: 120),
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: _ringValue(),
                            strokeWidth: 12,
                            backgroundColor: theme.colorScheme.onSurface
                                .withOpacity(isDark ? 0.14 : 0.10),
                            valueColor:
                            AlwaysStoppedAnimation(_accent()),
                          ),
                          Icon(
                            _icon(),
                            size: 46,
                            color: _accent(),
                          ),
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
                const SizedBox(height: 28),

                _infoCard(
                  context,
                  title: 'What is Network Protection?',
                  description:
                  'CS Security protects your device from network threats by blocking '
                      'suspicious domains and IP addresses system-wide before they can '
                      'communicate with malicious servers.',
                ),

                const SizedBox(height: 14),

                _infoCard(
                  context,
                  title: 'Does this affect my privacy?',
                  description:
                  'No. All filtering happens locally on your device. CS Security does '
                      'not log, inspect, or transmit your network traffic.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _infoCard(
      BuildContext context, {
        required String title,
        required String description,
      }) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withOpacity(
          isDark ? 0.35 : 0.6,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: text.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: text.bodySmall?.copyWith(
              height: 1.4,
              color: text.bodySmall?.color?.withOpacity(0.75),
            ),
          ),
        ],
      ),
    );
  }

}
