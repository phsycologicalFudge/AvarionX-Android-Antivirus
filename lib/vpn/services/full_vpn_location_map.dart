import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'animated_connecting_route_layer.dart';

class FullVpnServerLocation {
  final String id;
  final String label;
  final String countryCode;
  final LatLng point;

  const FullVpnServerLocation({
    required this.id,
    required this.label,
    required this.countryCode,
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

class _FullVpnLocationMapCardState extends State<FullVpnLocationMapCard>
    with TickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _pulseCtrl;
  late final AnimationController _focusCtrl;

  LatLng? _fromCenter;
  LatLng? _toCenter;
  double _fromZoom = 2.0;
  double _toZoom = 2.0;

  static const double _minZoom = 2.2;
  static const double _maxZoom = 6.2;

  static final LatLngBounds _worldBounds = LatLngBounds(
    const LatLng(-85.0, -180.0),
    const LatLng(85.0, 180.0),
  );

  LatLngBounds _areaBounds() {
    final pts = <LatLng>[];

    if (_hasIpPoint) pts.add(_ipCenter());
    for (final s in widget.servers) {
      pts.add(s.point);
    }

    if (pts.isEmpty) {
      return LatLngBounds(
        const LatLng(-60.0, -120.0),
        const LatLng(70.0, 120.0),
      );
    }

    final b = LatLngBounds.fromPoints(pts);

    final south = b.south < _worldBounds.south ? _worldBounds.south : b.south;
    final north = b.north > _worldBounds.north ? _worldBounds.north : b.north;
    final west = b.west < _worldBounds.west ? _worldBounds.west : b.west;
    final east = b.east > _worldBounds.east ? _worldBounds.east : b.east;

    return LatLngBounds(
      LatLng(south, west),
      LatLng(north, east),
    );
  }

  bool _focusQueued = false;

  int _lastMoveMs = 0;
  LatLng? _lastMovedCenter;
  double _lastMovedZoom = -1;

  String? _previewSelectedId;

  bool _userTouching = false;
  int _userTouchBlockUntilMs = 0;

  bool get _hasIpPoint {
    final la = widget.lat;
    final lo = widget.lon;
    if (la == null || lo == null) return false;
    if (!la.isFinite || !lo.isFinite) return false;
    return true;
  }

  LatLng _fallbackCenter() => const LatLng(20, 0);

  LatLng _ipCenter() => LatLng(widget.lat!, widget.lon!);

  String? get _effectiveSelectedId {
    final p = _previewSelectedId;
    if (p != null && p.isNotEmpty) return p;
    final w = widget.selectedServerId;
    if (w != null && w.isNotEmpty) return w;
    return null;
  }

  FullVpnServerLocation? _selectedServer() {
    final id = _effectiveSelectedId;
    if (id == null || id.isEmpty) return null;
    for (final s in widget.servers) {
      if (s.id == id) return s;
    }
    return null;
  }

  FullVpnServerLocation? _nearestServer(LatLng p) {
    if (widget.servers.isEmpty) return null;

    const d = Distance();

    FullVpnServerLocation? best;
    double bestM = double.infinity;

    for (final s in widget.servers) {
      final m = d(p, s.point);
      if (m < bestM) {
        bestM = m;
        best = s;
      }
    }

    if (bestM <= 220000) return best;
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

    if (!widget.connected && s != null) return s.point;

    if (widget.isConnecting && _hasIpPoint && s != null) {
      return _midpoint(_ipCenter(), s.point);
    }

    if (widget.connected && s != null) return s.point;

    if (_hasIpPoint) return _ipCenter();

    return _fallbackCenter();
  }

  double _focusZoom() {
    final s = _selectedServer();

    if (!widget.connected && s != null) return 4.8;

    if (widget.isConnecting && _hasIpPoint && s != null) return 2.8;

    if (widget.connected && s != null) return 5.6;

    if (_hasIpPoint) return 3.4;

    return 1.6;
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _focusCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..addListener(_tickFocus);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _queueFocus(force: true);
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

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  double _clampZoom(double z) {
    if (z < _minZoom) return _minZoom;
    if (z > _maxZoom) return _maxZoom;
    return z;
  }

  LatLng _clampCenterToWorld(LatLng c) {
    double lat = c.latitude;
    double lon = c.longitude;

    if (lat < -85.0) lat = -85.0;
    if (lat > 85.0) lat = 85.0;

    if (lon < -180.0) lon = -180.0;
    if (lon > 180.0) lon = 180.0;

    return LatLng(lat, lon);
  }

  LatLng _safeCenter(LatLng c) {
    final lat = c.latitude.isFinite ? c.latitude : 20.0;
    final lon = c.longitude.isFinite ? c.longitude : 0.0;
    return _clampCenterToWorld(LatLng(lat, lon));
  }

  bool _closeEnough(LatLng a, LatLng b) {
    return (a.latitude - b.latitude).abs() < 0.00005 &&
        (a.longitude - b.longitude).abs() < 0.00005;
  }

  bool _userInteractionBlocked() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_userTouching) return true;
    return now < _userTouchBlockUntilMs;
  }

  void _tickFocus() {
    if (_fromCenter == null || _toCenter == null) return;
    if (_userInteractionBlocked()) return;

    final nowMs = DateTime.now().millisecondsSinceEpoch;
    if (nowMs - _lastMoveMs < 16) return;

    final t = Curves.easeInOutCubic.transform(_focusCtrl.value);

    final lat = _lerp(_fromCenter!.latitude, _toCenter!.latitude, t);
    final lon = _lerp(_fromCenter!.longitude, _toCenter!.longitude, t);
    final z = _clampZoom(_lerp(_fromZoom, _toZoom, t));

    final nextCenter = _safeCenter(LatLng(lat, lon));

    final lastC = _lastMovedCenter;
    final lastZ = _lastMovedZoom;

    if (lastC != null) {
      if (_closeEnough(lastC, nextCenter) && (lastZ - z).abs() < 0.002) {
        return;
      }
    }

    _lastMoveMs = nowMs;
    _lastMovedCenter = nextCenter;
    _lastMovedZoom = z;

    _mapController.move(nextCenter, z);
  }

  void _queueFocus({bool force = false}) {
    if (!force && _userInteractionBlocked()) return;

    if (_focusQueued) return;
    _focusQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusQueued = false;
      if (!mounted) return;
      _animateFocus(force: force);
    });
  }

  void _animateFocus({bool force = false}) {
    if (!force && _userInteractionBlocked()) return;

    final toC = _safeCenter(_focusCenter());
    final toZ = _clampZoom(_focusZoom());

    final cam = _mapController.camera;

    final fromC = _safeCenter(cam.center);
    final fromZ = _clampZoom(cam.zoom);

    if (_closeEnough(fromC, toC) && (fromZ - toZ).abs() < 0.002) return;

    _fromCenter = fromC;
    _toCenter = toC;
    _fromZoom = fromZ;
    _toZoom = toZ;

    _lastMoveMs = 0;
    _focusCtrl.stop();
    _focusCtrl.value = 0;
    _focusCtrl.forward();
  }

  void _zoomBy(double delta) {
    final cam = _mapController.camera;
    final z = _clampZoom(cam.zoom + delta);
    _mapController.move(cam.center, z);
  }

  void _recenter() {
    _focusCtrl.stop();
    _previewSelectedId = null;
    _queueFocus(force: true);
  }

  Widget _mapControls(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget btn(IconData icon, VoidCallback onTap) {
      return Material(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: scheme.onSurface.withOpacity(0.95), size: 20),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        btn(Icons.add_rounded, () => _zoomBy(0.7)),
        const SizedBox(height: 10),
        btn(Icons.remove_rounded, () => _zoomBy(-0.7)),
        const SizedBox(height: 10),
        btn(Icons.my_location_rounded, _recenter),
      ],
    );
  }

  bool _changedDouble(double? a, double? b) {
    if (a == null || b == null) return a != b;
    return (a - b).abs() > 0.002;
  }

  @override
  void didUpdateWidget(covariant FullVpnLocationMapCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final parentSelectedChanged = oldWidget.selectedServerId != widget.selectedServerId;
    if (parentSelectedChanged) {
      _previewSelectedId = null;
    } else {
      final p = _previewSelectedId;
      if (p != null && p.isNotEmpty) {
        final stillExists = widget.servers.any((s) => s.id == p);
        if (!stillExists) _previewSelectedId = null;
      }
    }

    final latChanged = _changedDouble(oldWidget.lat, widget.lat);
    final lonChanged = _changedDouble(oldWidget.lon, widget.lon);
    final connChanged = oldWidget.connected != widget.connected;
    final connectingChanged = oldWidget.isConnecting != widget.isConnecting;

    if (latChanged || lonChanged || connChanged || connectingChanged || parentSelectedChanged) {
      _queueFocus(force: parentSelectedChanged);
    }
  }

  void _tapServer(FullVpnServerLocation s) {
    if (widget.onServerTap == null) return;
    _focusCtrl.stop();
    setState(() => _previewSelectedId = s.id);
    widget.onServerTap?.call(s);
    _queueFocus(force: true);
  }

  Widget _serverDot({
    required ColorScheme scheme,
    required bool selected,
    required bool connected,
    required VoidCallback? onTapDown,
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

        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (_) => onTapDown?.call(),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final selectedId = _effectiveSelectedId;

    final markers = <Marker>[];
    for (final s in widget.servers) {
      final selected = s.id == selectedId;
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
            onTapDown: () => _tapServer(s),
          ),
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
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) {
                _userTouching = true;
                _userTouchBlockUntilMs = DateTime.now().millisecondsSinceEpoch + 900;
              },
              onPointerUp: (_) {
                _userTouching = false;
                _userTouchBlockUntilMs = DateTime.now().millisecondsSinceEpoch + 650;
              },
              onPointerCancel: (_) {
                _userTouching = false;
                _userTouchBlockUntilMs = DateTime.now().millisecondsSinceEpoch + 650;
              },
              child: RepaintBoundary(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _safeCenter(_focusCenter()),
                    initialZoom: _clampZoom(_focusZoom()),
                    minZoom: _minZoom,
                    maxZoom: _maxZoom,
                    backgroundColor: Colors.black,
                    cameraConstraint: CameraConstraint.contain(
                      bounds: _worldBounds,
                    ),
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.drag |
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.doubleTapZoom,
                    ),
                    onTap: (_, p) {
                      final s = _nearestServer(p);
                      if (s == null) return;
                      _tapServer(s);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}{r}.png',
                      subdomains: const ['a', 'b', 'c', 'd'],
                      userAgentPackageName: 'com.colourswift.avarionxvpn',
                      maxZoom: _maxZoom,
                      maxNativeZoom: 6,
                      keepBuffer: 4,
                    ),
                    if (markers.isNotEmpty) MarkerLayer(markers: markers),
                  ],
                ),
              ),
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
            right: 12,
            top: 12,
            child: SafeArea(
              child: _mapControls(context),
            ),
          ),
        ],
      ),
    );
  }
}