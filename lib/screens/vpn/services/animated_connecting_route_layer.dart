import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AnimatedConnectingRouteLayer extends StatefulWidget {
  final LatLng from;
  final LatLng to;
  final bool animate;

  const AnimatedConnectingRouteLayer({
    super.key,
    required this.from,
    required this.to,
    required this.animate,
  });

  @override
  State<AnimatedConnectingRouteLayer> createState() => _AnimatedConnectingRouteLayerState();
}

class _AnimatedConnectingRouteLayerState extends State<AnimatedConnectingRouteLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    if (widget.animate) _ctrl.repeat();
  }

  @override
  void didUpdateWidget(covariant AnimatedConnectingRouteLayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animate && !_ctrl.isAnimating) {
      _ctrl.repeat();
    } else if (!widget.animate && _ctrl.isAnimating) {
      _ctrl.stop();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  double _rad(double deg) => deg * math.pi / 180.0;
  double _deg(double rad) => rad * 180.0 / math.pi;

  List<LatLng> _greatCircle(LatLng a, LatLng b, int steps) {
    final lat1 = _rad(a.latitude);
    final lon1 = _rad(a.longitude);
    final lat2 = _rad(b.latitude);
    final lon2 = _rad(b.longitude);

    final x1 = math.cos(lat1) * math.cos(lon1);
    final y1 = math.cos(lat1) * math.sin(lon1);
    final z1 = math.sin(lat1);

    final x2 = math.cos(lat2) * math.cos(lon2);
    final y2 = math.cos(lat2) * math.sin(lon2);
    final z2 = math.sin(lat2);

    var dot = (x1 * x2 + y1 * y2 + z1 * z2).clamp(-1.0, 1.0);
    final omega = math.acos(dot);
    final sinOmega = math.sin(omega);

    if (sinOmega.abs() < 1e-9) {
      return List<LatLng>.generate(
        steps,
            (i) {
          final t = steps <= 1 ? 1.0 : i / (steps - 1);
          return LatLng(
            a.latitude + (b.latitude - a.latitude) * t,
            a.longitude + (b.longitude - a.longitude) * t,
          );
        },
      );
    }

    LatLng point(double t) {
      final s1 = math.sin((1.0 - t) * omega) / sinOmega;
      final s2 = math.sin(t * omega) / sinOmega;

      final x = x1 * s1 + x2 * s2;
      final y = y1 * s1 + y2 * s2;
      final z = z1 * s1 + z2 * s2;

      final lat = math.atan2(z, math.sqrt(x * x + y * y));
      final lon = math.atan2(y, x);

      return LatLng(_deg(lat), _deg(lon));
    }

    return List<LatLng>.generate(
      steps,
          (i) {
        final t = steps <= 1 ? 1.0 : i / (steps - 1);
        return point(t);
      },
    );
  }

  List<LatLng> _segment(List<LatLng> pts, double t) {
    final clamped = t.clamp(0.0, 1.0);
    final take = (pts.length * clamped).clamp(2, pts.length).toInt();
    return pts.take(take).toList();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final a = widget.from;
    final b = widget.to;

    final pts = _greatCircle(a, b, 80);

    if (!widget.animate) {
      return PolylineLayer(
        polylines: [
          Polyline(
            points: pts,
            strokeWidth: 4,
            color: scheme.primary.withOpacity(0.28),
          ),
        ],
      );
    }

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = _ctrl.value;
        final head = (t * 0.85) + 0.15;
        final tail = (head - 0.35).clamp(0.0, 1.0);

        final headPts = _segment(pts, head);
        final tailPts = _segment(pts, tail);

        return PolylineLayer(
          polylines: [
            Polyline(
              points: tailPts,
              strokeWidth: 7,
              color: scheme.primary.withOpacity(0.14),
            ),
            Polyline(
              points: headPts,
              strokeWidth: 4,
              color: scheme.primary.withOpacity(0.48),
            ),
          ],
        );
      },
    );
  }
}