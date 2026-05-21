import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../translations/app_localizations.dart';
import '../widgets/settings_icon_preview.dart';

Future<void> showSettingsProOptionsSheet({
  required BuildContext context,
  required VoidCallback onChanged,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final prefs = await SharedPreferences.getInstance();
  bool goldHeaderEnabled = prefs.getBool('goldHeaderEnabled') ?? false;
  String selectedIcon = prefs.getString('selectedIcon') ?? 'default';
  const iconChannel = MethodChannel('colourswift/icon_switch');

  String iconLabel(String icon) {
    switch (icon) {
      case 'default':
        return 'Default';
      case 'bird':
        return 'Bird';
      case 'neon':
        return 'Neon';
      case 'ax':
        return 'AX';
      case 'avx':
        return 'AVX';
      case 'a':
        return 'A';
      case 'edr':
        return 'EDR';
      case 'original':
        return 'Original';
      default:
        return icon;
    }
  }

  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) {
      final theme = Theme.of(sheetContext);
      final scheme = theme.colorScheme;

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
              child: StatefulBuilder(
                builder: (sheetContext, setModalState) {
                  Future<void> changeIcon(String icon) async {
                    setModalState(() => selectedIcon = icon);
                    await prefs.setString('selectedIcon', icon);

                    try {
                      await iconChannel.invokeMethod('setIcon', {'icon': icon});
                    } catch (_) {}

                    if (!sheetContext.mounted) return;
                    ScaffoldMessenger.of(sheetContext).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.settingsIconSelected(icon.toUpperCase()),
                        ),
                      ),
                    );

                    onChanged();
                  }

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.settingsProSheetTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          l10n.settingsAppIcon,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            SettingsIconPreview(
                              name: 'default',
                              selected: selectedIcon,
                              label: iconLabel('default'),
                              onTap: () => changeIcon('default'),
                            ),
                            SettingsIconPreview(
                              name: 'bird',
                              selected: selectedIcon,
                              label: iconLabel('bird'),
                              onTap: () => changeIcon('bird'),
                            ),
                            SettingsIconPreview(
                              name: 'neon',
                              selected: selectedIcon,
                              label: iconLabel('neon'),
                              onTap: () => changeIcon('neon'),
                            ),
                            SettingsIconPreview(
                              name: 'ax',
                              selected: selectedIcon,
                              label: iconLabel('ax'),
                              onTap: () => changeIcon('ax'),
                            ),
                            SettingsIconPreview(
                              name: 'avx',
                              selected: selectedIcon,
                              label: iconLabel('avx'),
                              onTap: () => changeIcon('avx'),
                            ),
                            SettingsIconPreview(
                              name: 'a',
                              selected: selectedIcon,
                              label: iconLabel('a'),
                              onTap: () => changeIcon('a'),
                            ),
                            SettingsIconPreview(
                              name: 'edr',
                              selected: selectedIcon,
                              label: iconLabel('edr'),
                              onTap: () => changeIcon('edr'),
                            ),
                            SettingsIconPreview(
                              name: 'original',
                              selected: selectedIcon,
                              label: iconLabel('original'),
                              onTap: () => changeIcon('original'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            child: Text(l10n.settingsSave),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    },
  );
}