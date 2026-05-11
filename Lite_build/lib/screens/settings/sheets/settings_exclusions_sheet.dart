import 'package:flutter/material.dart';
import '../../../translations/app_localizations.dart';

Future<void> showSettingsExclusionsSheet({
  required BuildContext context,
  required Future<void> Function() onExcludeFolder,
  required Future<void> Function() onExcludeFile,
  required VoidCallback onManage,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);
  final scheme = theme.colorScheme;

  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    isScrollControlled: false,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: Material(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(22),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.folder_open_rounded),
                  title: Text(l10n.settingsExcludeFolder),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await onExcludeFolder();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.insert_drive_file_rounded),
                  title: Text(l10n.settingsExcludeFile),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await onExcludeFile();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.rule_folder_rounded),
                  title: Text(l10n.settingsManageExclusions),
                  subtitle: Text(l10n.settingsManageExclusionsSubtitle),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onManage();
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    },
  );
}