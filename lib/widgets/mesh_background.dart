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
  final Color? overlayColor;
  final Widget child;

  const MeshBackground({
    super.key,
    required this.blobs,
    required this.base,
    this.overlayColor,
    required this.child,
  });

  @override
  State<MeshBackground> createState() => _MeshBackgroundState();
}

class _MeshBackgroundState extends State<MeshBackground>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _overlayController;
  late Animation<Color?> _overlayAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();

    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _overlayAnim = ColorTween(
      begin: Colors.transparent,
      end: Colors.transparent,
    ).animate(CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(covariant MeshBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.overlayColor != widget.overlayColor) {
      final from = _overlayAnim.value ?? Colors.transparent;
      _overlayAnim = ColorTween(
        begin: from,
        end: widget.overlayColor ?? Colors.transparent,
      ).animate(CurvedAnimation(
        parent: _overlayController,
        curve: Curves.easeInOut,
      ));
      _overlayController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _overlayController.dispose();
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
          overlayColor: widget.overlayColor ?? Colors.transparent,
          progress: 0.0,
        ),
        isComplex: true,
        child: widget.child,
      );
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _overlayController]),
      child: widget.child,
      builder: (context, child) {
        return CustomPaint(
          painter: _MeshPainter(
            blobs: widget.blobs,
            base: widget.base,
            overlayColor: _overlayAnim.value ?? Colors.transparent,
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
  final Color overlayColor;
  final double progress;

  _MeshPainter({
    required this.blobs,
    required this.base,
    required this.overlayColor,
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

    if (overlayColor.alpha > 0) {
      canvas.drawRect(Offset.zero & size, Paint()..color = overlayColor);
    }
  }

  @override
  bool shouldRepaint(covariant _MeshPainter old) =>
      old.base != base ||
          old.blobs != blobs ||
          old.overlayColor != overlayColor ||
          old.progress != progress;
}