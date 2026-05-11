import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AvHomePrimaryControl extends StatelessWidget {
  final bool pressed;
  final ValueChanged<bool> onPressedChanged;
  final VoidCallback onToggleProtection;

  final Color accent;
  final bool isDark;
  final IconData icon;

  final String line1;
  final String defsLine;

  const AvHomePrimaryControl({
    super.key,
    required this.pressed,
    required this.onPressedChanged,
    required this.onToggleProtection,
    required this.accent,
    required this.isDark,
    required this.icon,
    required this.line1,
    required this.defsLine,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Card(
      elevation: 0,
      color: theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTapDown: (_) => onPressedChanged(true),
        onTapUp: (_) => onPressedChanged(false),
        onTapCancel: () => onPressedChanged(false),
        onTap: () {
          HapticFeedback.lightImpact();
          onToggleProtection();
        },
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: 82,
                color: accent.withOpacity(isDark ? 0.82 : 0.88),
                child: Icon(icon, size: 34, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        line1,
                        style: text.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface.withOpacity(0.92),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        defsLine,
                        style: text.bodySmall?.copyWith(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withOpacity(0.36),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 120),
                  scale: pressed ? 0.88 : 1.0,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: theme.iconTheme.color?.withOpacity(0.35),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}