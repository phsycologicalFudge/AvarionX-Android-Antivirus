import 'package:flutter/material.dart';

class SettingsIconPreview extends StatelessWidget {
  final String name;
  final String selected;
  final String label;
  final VoidCallback onTap;

  const SettingsIconPreview({
    super.key,
    required this.name,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isSelected = name == selected;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? scheme.primary : scheme.outlineVariant,
                width: isSelected ? 2.0 : 1.0,
              ),
              color: isSelected
                  ? scheme.primaryContainer.withOpacity(0.25)
                  : scheme.surfaceContainer,
            ),
            padding: const EdgeInsets.all(6),
            child: Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/icons/ic_launcher_$name.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: scheme.onPrimary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? scheme.primary
                  : theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}