import 'dart:math' as math;
import 'package:colourswift_av/screens/home/ring_pulse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AvHomePrimaryControl extends StatelessWidget {
  final bool pressed;
  final ValueChanged<bool> onPressedChanged;
  final VoidCallback onToggleProtection;

  final double ring;
  final Color accent;
  final bool isDark;
  final IconData icon;

  final String line1;
  final String line2;
  final String defsLine;

  final String scanButtonText;
  final VoidCallback onOpenScanDrawer;

  final bool showPulse;
  final AnimationController pulseController;
  final double Function(double t) pulseOpacity;

  const AvHomePrimaryControl({
    super.key,
    required this.pressed,
    required this.onPressedChanged,
    required this.onToggleProtection,
    required this.ring,
    required this.accent,
    required this.isDark,
    required this.icon,
    required this.line1,
    required this.line2,
    required this.defsLine,
    required this.scanButtonText,
    required this.onOpenScanDrawer,
    required this.showPulse,
    required this.pulseController,
    required this.pulseOpacity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => onPressedChanged(true),
          onTapUp: (_) => onPressedChanged(false),
          onTapCancel: () => onPressedChanged(false),
          onTap: () {
            HapticFeedback.lightImpact();
            onToggleProtection();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: 212,
                height: 212,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accent.withOpacity(ring > 0 ? 0.16 : 0.0),
                      accent.withOpacity(0.0),
                    ],
                    stops: const [0.35, 1.0],
                  ),
                ),
              ),
              CircularPercentIndicator(
                radius: 96,
                lineWidth: 14,
                percent: ring.clamp(0.0, 1.0),
                animation: true,
                animateFromLastPercent: true,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: theme.colorScheme.onSurface.withOpacity(isDark ? 0.14 : 0.10),
                progressColor: accent.withOpacity(0.85),
                center: AnimatedScale(
                  duration: const Duration(milliseconds: 120),
                  scale: pressed ? 0.94 : 1.0,
                  child: Icon(
                    icon,
                    size: 64,
                    color: accent,
                  ),
                ),
              ),
              if (showPulse)
                IgnorePointer(
                  child: SizedBox(
                    width: 192,
                    height: 192,
                    child: AnimatedBuilder(
                      animation: pulseController,
                      builder: (_, __) {
                        final t = pulseController.value;
                        final opacity = pulseOpacity(t);

                        return CustomPaint(
                          painter: RingPulsePainter(
                            color: accent.withOpacity(opacity),
                            strokeWidth: 14,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          line1,
          style: text.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          line2,
          style: text.bodySmall?.copyWith(
            color: text.bodySmall?.color?.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          defsLine,
          style: text.bodySmall?.copyWith(
            fontSize: 12,
            color: text.bodySmall?.color?.withOpacity(0.55),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTapDown: (_) {
              HapticFeedback.lightImpact();
              onPressedChanged(true);
            },
            onTapUp: (_) => onPressedChanged(false),
            onTapCancel: () => onPressedChanged(false),
            child: FilledButton.icon(
              onPressed: onOpenScanDrawer,
              icon: const Icon(Icons.search_rounded, size: 18),
              label: Text(scanButtonText),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}