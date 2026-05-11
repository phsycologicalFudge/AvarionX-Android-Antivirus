import 'package:flutter/material.dart';

class RingPulsePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  RingPulsePainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final radius = (size.width / 2) - (strokeWidth / 2);

    canvas.drawCircle(
      size.center(Offset.zero),
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant RingPulsePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}