import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'animated_connecting_route_layer.dart';

class FullVpnServerLocation {
  final String id;
  final String label;
  final LatLng point;

  const FullVpnServerLocation({
    required this.id,
    required this.label,
    required this.point,
  });
}

class FullVpnLocationMapCard extends StatefulWidget {
  final double? lat;
  final double? lon;
  final bool connected;
  final bool isConnecting;
  final String headerText;
  final List<FullVpnServerLocation> servers;
  final String? selectedServerId;
  final ValueChanged<FullVpnServerLocation>? onServerTap;

  const FullVpnLocationMapCard({
    super.key,
    required this.lat,
    required this.lon,
    required this.connected,
    required this.isConnecting,
    required this.headerText,
    this.servers = const [],
    this.selectedServerId,
    this.onServerTap,
  });

  @override
  State<FullVpnLocationMapCard> createState() => _FullVpnLocationMapCardState();
}

class _FullVpnLocationMapCardState extends State<FullVpnLocationMapCard> with TickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _pulseCtrl;
  late final AnimationController _focusCtrl;

  LatLng? _fromCenter;
  LatLng? _toCenter;
  double _fromZoom = 2.0;
  double _toZoom = 2.0;

  String _toastText = "";
  bool _showToast = false;

  static const double _minZoom = 1.2;
  static const double _maxZoom = 7.0;

  bool _focusQueued = false;

  bool get _hasIpPoint {
    final la = widget.lat;
    final lo = widget.lon;
    if (la == null || lo == null) return false;
    if (!la.isFinite || !lo.isFinite) return false;
    return true;
  }

  LatLng _fallbackCenter() => const LatLng(20, 0);

  LatLng _ipCenter() => LatLng(widget.lat!, widget.lon!);

  FullVpnServerLocation? _selectedServer() {
    final id = widget.selectedServerId;
    if (id == null || id.isEmpty) return null;
    for (final s in widget.servers) {
      if (s.id == id) return s;
    }
    return null;
  }

  LatLng _midpoint(LatLng a, LatLng b) {
    return LatLng(
      (a.latitude + b.latitude) / 2.0,
      (a.longitude + b.longitude) / 2.0,
    );
  }

  LatLng _focusCenter() {
    final s = _selectedServer();

    if (widget.isConnecting && _hasIpPoint && s != null) {
      return _midpoint(_ipCenter(), s.point);
    }

    if (widget.connected && s != null) {
      return s.point;
    }

    if (_hasIpPoint) return _ipCenter();

    return _fallbackCenter();
  }

  double _focusZoom() {
    final s = _selectedServer();

    if (widget.isConnecting && _hasIpPoint && s != null) return 2.8;

    if (widget.connected && s != null) return 5.6;

    if (_hasIpPoint) return 3.4;

    return 1.6;
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();
    _focusCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 650))..addListener(_tickFocus);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _queueFocus();
    });
  }

  @override
  void dispose() {
    _focusCtrl.removeListener(_tickFocus);
    _focusCtrl.dispose();
    _pulseCtrl.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _tickFocus() {
    if (_fromCenter == null || _toCenter == null) return;
    final t = Curves.easeInOutCubic.transform(_focusCtrl.value);

    final lat = _lerp(_fromCenter!.latitude, _toCenter!.latitude, t);
    final lon = _lerp(_fromCenter!.longitude, _toCenter!.longitude, t);
    final z = _clampZoom(_lerp(_fromZoom, _toZoom, t));

    _mapController.move(LatLng(lat, lon), z);
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  double _clampZoom(double z) {
    if (z < _minZoom) return _minZoom;
    if (z > _maxZoom) return _maxZoom;
    return z;
  }

  void _queueFocus() {
    if (_focusQueued) return;
    _focusQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusQueued = false;
      if (!mounted) return;
      _animateFocus();
    });
  }

  void _animateFocus() {
    final toC = _focusCenter();
    final toZ = _clampZoom(_focusZoom());

    final cam = _mapController.camera;
    _fromCenter = cam.center;
    _toCenter = toC;
    _fromZoom = cam.zoom;
    _toZoom = toZ;

    _focusCtrl.stop();
    _focusCtrl.value = 0;
    _focusCtrl.forward();
  }

  void _showSelectionToast(String text) {
    setState(() {
      _toastText = text;
      _showToast = true;
    });
  }

  void _hideToast() {
    if (!_showToast) return;
    setState(() => _showToast = false);
  }

  @override
  void didUpdateWidget(covariant FullVpnLocationMapCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final latChanged = oldWidget.lat != widget.lat;
    final lonChanged = oldWidget.lon != widget.lon;
    final connChanged = oldWidget.connected != widget.connected;
    final selChanged = oldWidget.selectedServerId != widget.selectedServerId;
    final connectingChanged = oldWidget.isConnecting != widget.isConnecting;

    if (latChanged || lonChanged || connChanged || selChanged || connectingChanged) {
      _queueFocus();
    }
  }

  Widget _serverDot({
    required ColorScheme scheme,
    required bool selected,
    required bool connected,
    required VoidCallback? onTap,
  }) {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, _) {
        final p = _pulseCtrl.value;
        final pulse = 0.55 + 0.45 * math.sin(p * math.pi * 2);

        final dotColor = selected
            ? (connected ? Colors.greenAccent : scheme.primary)
            : scheme.primary.withOpacity(0.75);

        final ringOpacity = selected ? (0.28 + 0.22 * pulse) : (0.14 + 0.10 * pulse);
        final ringSize = selected ? (38 + 10 * pulse) : (26 + 6 * pulse);
        final coreSize = selected ? 18.0 : 14.0;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: ringSize,
                  height: ringSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor.withOpacity(ringOpacity),
                  ),
                ),
                Container(
                  width: coreSize,
                  height: coreSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.90),
                      width: selected ? 2.2 : 2.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _homeMarker(ColorScheme scheme) {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, _) {
        final p = _pulseCtrl.value;
        final pulse = 0.5 + 0.5 * math.sin(p * math.pi * 2);

        final ringOpacity = 0.10 + 0.16 * pulse;
        final ringSize = 48.0 + 10.0 * pulse;

        final badge = scheme.surfaceContainerHighest.withOpacity(0.92);
        final border = Colors.white.withOpacity(0.18);

        return SizedBox(
          width: 70,
          height: 70,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: ringSize,
                height: ringSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.primary.withOpacity(ringOpacity),
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: badge,
                  border: Border.all(color: border, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.home_rounded,
                  size: 18,
                  color: scheme.primary.withOpacity(0.95),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final markers = <Marker>[];

    for (final s in widget.servers) {
      final selected = s.id == widget.selectedServerId;
      markers.add(
        Marker(
          point: s.point,
          width: 50,
          height: 50,
          alignment: Alignment.center,
          child: _serverDot(
            scheme: scheme,
            selected: selected,
            connected: widget.connected,
            onTap: widget.onServerTap == null
                ? null
                : () {
              widget.onServerTap!(s);
            },
          ),
        ),
      );
    }

    if (_hasIpPoint) {
      markers.add(
        Marker(
          point: _ipCenter(),
          width: 70,
          height: 70,
          alignment: Alignment.center,
          child: _homeMarker(scheme),
        ),
      );
    }

    final sel = _selectedServer();
    final showRoute = _hasIpPoint && sel != null && (widget.isConnecting || widget.connected);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _focusCenter(),
                initialZoom: _clampZoom(_focusZoom()),
                minZoom: _minZoom,
                maxZoom: _maxZoom,
                backgroundColor: const Color(0xFF0B1220),
                cameraConstraint: const CameraConstraint.unconstrained(),
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
                ),
                onTap: (_, __) => _hideToast(),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.colourswift.cssecurity',
                  maxZoom: _maxZoom,
                  keepBuffer: 6,
                ),
                if (showRoute)
                  AnimatedConnectingRouteLayer(
                    from: _ipCenter(),
                    to: sel!.point,
                    animate: widget.isConnecting,
                  ),
                if (markers.isNotEmpty) MarkerLayer(markers: markers),
              ],
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.55),
                      Colors.black.withOpacity(0.10),
                      Colors.black.withOpacity(0.55),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: !_showToast
                  ? const SizedBox.shrink()
                  : GestureDetector(
                key: const ValueKey("toast"),
                onTap: _hideToast,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.62),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.10)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.place_rounded, color: scheme.primary, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _toastText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.close_rounded, color: Colors.white.withOpacity(0.85), size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}