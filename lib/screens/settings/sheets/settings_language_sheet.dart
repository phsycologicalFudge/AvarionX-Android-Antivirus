import 'package:flutter/material.dart';
import '../../../translations/app_localizations.dart';

Future<void> showSettingsLanguageSheet({
  required BuildContext context,
  required String currentLanguage,
  required Future<void> Function(String code) onSelectLanguage,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);
  final text = theme.textTheme;
  final scheme = theme.colorScheme;
  final supported = AppLocalizations.supportedLocales;

  String labelFor(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'it':
        return 'Italiano';
      case 'pl':
        return 'Polski';
      case 'pt':
        return 'Português';
      case 'ar':
        return 'العربية';
      case 'ja':
        return '日本語';
      default:
        return locale.languageCode;
    }
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
                    l10n.settingsChooseLanguage,
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      await onSelectLanguage('system');
                    },
                    title: Text(
                      l10n.settingsSystemDefault,
                      style: TextStyle(
                        fontWeight: currentLanguage == 'system'
                            ? FontWeight.w800
                            : FontWeight.w600,
                      ),
                    ),
                    trailing: currentLanguage == 'system'
                        ? const Icon(Icons.check_rounded)
                        : null,
                  ),
                  ...supported.map((loc) {
                    final code = loc.languageCode;
                    final isSelected = currentLanguage == code;
                    return ListTile(
                      onTap: () async {
                        Navigator.pop(sheetContext);
                        await onSelectLanguage(code);
                      },
                      title: Text(
                        labelFor(loc),
                        style: TextStyle(
                          fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                      trailing:
                      isSelected ? const Icon(Icons.check_rounded) : null,
                    );
                  }),
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