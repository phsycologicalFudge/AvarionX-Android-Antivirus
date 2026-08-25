import 'package:flutter/material.dart';

import '../../../translations/app_localizations.dart';
Future<void> showSettingsRtpNotificationSheet({
  required BuildContext context,
  required int currentSeconds,
  required Future<void> Function(int seconds) onSelect,
}) async {
  final theme = Theme.of(context);
  final text = theme.textTheme;
  final scheme = theme.colorScheme;

  Widget option({
    required String title,
    required int value,
  }) {
    return ListTile(
      title: Text(title),
      trailing: currentSeconds == value ? const Icon(Icons.check_rounded) : null,
      onTap: () async {
        Navigator.pop(context);
        await onSelect(value);
      },
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
                    AppLocalizations.of(context)!.settingsRtpNotificationAutoClearNotifications,
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  option(title: AppLocalizations.of(context)!.settingsRtpNotificationNever, value: 0),
                  option(title: AppLocalizations.of(context)!.settingsRtpNotification5Minutes, value: 300),
                  option(title: AppLocalizations.of(context)!.settingsRtpNotification10Minutes, value: 600),
                  option(title: AppLocalizations.of(context)!.settingsRtpNotification30Minutes, value: 1800),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}