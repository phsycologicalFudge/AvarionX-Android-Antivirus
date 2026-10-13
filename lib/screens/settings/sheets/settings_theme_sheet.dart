import 'package:flutter/material.dart';
import '../../../translations/app_localizations.dart';

Future<void> showSettingsThemeSheet({
  required BuildContext context,
  required bool isPro,
  required String currentTheme,
  required Future<void> Function(String value) onSelectTheme,
  required VoidCallback onOpenPro,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);
  final text = theme.textTheme;
  final scheme = theme.colorScheme;

  Future<void> handleTap(String value) async {
    final isProTheme = value == 'emerald' ||
        value == 'grey' ||
        value == 'purple' ||
        value == 'royal_blue';
    Navigator.pop(context);

    if (isProTheme && !isPro) {
      onOpenPro();
      return;
    }

    await onSelectTheme(value);
  }

  Widget option({
    required String label,
    required String value,
    required Color color,
  }) {
    final isSelected = currentTheme == value;
    final isProTheme = value == 'emerald' ||
        value == 'grey' ||
        value == 'purple' ||
        value == 'royal_blue';

    return ListTile(
      onTap: () => handleTap(value),
      leading: CircleAvatar(
        backgroundColor: color,
        radius: 14,
      ),
      title: Text(
        isProTheme ? '$label (${l10n.proBadge})' : label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          color: isProTheme ? (isPro ? null : Colors.grey) : null,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check_rounded) : null,
    );
  }

  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 14,
            right: 14,
            top: 10,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 14,
          ),
          child: Material(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(22),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.settingsThemePickerTitle,
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  option(
                    label: AppLocalizations.of(context)!.settingsThemeBlack,
                    value: 'black',
                    color: Colors.black,
                  ),
                  option(
                    label: AppLocalizations.of(context)!.settingsThemeWhite,
                    value: 'white',
                    color: Colors.white,
                  ),
                  option(
                    label: AppLocalizations.of(context)!.settingsThemeGrey,
                    value: 'grey',
                    color: Colors.grey.shade700,
                  ),
                  option(
                    label: AppLocalizations.of(context)!.settingsThemeEmerald,
                    value: 'emerald',
                    color: const Color(0xFF009E73),
                  ),
                  option(
                    label: AppLocalizations.of(context)!.settingsThemePurple,
                    value: 'purple',
                    color: const Color(0xFF8B5CF6),
                  ),
                  option(
                    label: AppLocalizations.of(context)!.settingsThemeRoyalBlue,
                    value: 'royal_blue',
                    color: const Color(0xFF0B1220),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}