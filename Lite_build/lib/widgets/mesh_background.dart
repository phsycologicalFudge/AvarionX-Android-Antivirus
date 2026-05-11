import 'dart:math';
import 'package:flutter/material.dart';

class MeshBlob {
  final double x;
  final double y;
  final Color color;
  final double radius;
  final double opacity;

  const MeshBlob({
    required this.x,
    required this.y,
    required this.color,
    required this.radius,
    required this.opacity,
  });
}

class MeshBackground extends StatefulWidget {
  final List<MeshBlob> blobs;
  final Color base;
  final Widget child;

  const MeshBackground({
    super.key,
    required this.blobs,
    required this.base,
    required this.child,
  });

  @override
  State<MeshBackground> createState() => _MeshBackgroundState();
}

class _MeshBackgroundState extends State<MeshBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (disableAnimations) {
      return CustomPaint(
        painter: _MeshPainter(
          blobs: widget.blobs,
          base: widget.base,
          progress: 0.0,
        ),
        isComplex: true,
        child: widget.child,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return CustomPaint(
          painter: _MeshPainter(
            blobs: widget.blobs,
            base: widget.base,
            progress: _controller.value,
          ),
          isComplex: true,
          willChange: true,
          child: child,
        );
      },
    );
  }
}

class _MeshPainter extends CustomPainter {
  final List<MeshBlob> blobs;
  final Color base;
  final double progress;

  _MeshPainter({
    required this.blobs,
    required this.base,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    final dim = max(size.width, size.height);
    final t = progress * pi * 2;

    for (var i = 0; i < blobs.length; i++) {
      final blob = blobs[i];
      final phase = i * 1.91;

      final center = Offset(
        blob.x * size.width +
            sin(t + phase) * size.width * 0.08 +
            sin((t * 2.0) + phase) * size.width * 0.024,
        blob.y * size.height +
            cos(t + phase) * size.height * 0.06 +
            cos((t * 2.0) + phase) * size.height * 0.018,
      );

      final radius = blob.radius * dim;

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            blob.color.withOpacity(blob.opacity * 1.35),
            blob.color.withOpacity(blob.opacity * 0.92),
            blob.color.withOpacity(blob.opacity * 0.44),
            blob.color.withOpacity(0.0),
          ],
          stops: const [0.0, 0.34, 0.68, 1.0],
        ).createShader(
          Rect.fromCircle(
            center: center,
            radius: radius,
          ),
        );

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MeshPainter old) =>
      old.base != base ||
          old.blobs != blobs ||
          old.progress != progress;
}