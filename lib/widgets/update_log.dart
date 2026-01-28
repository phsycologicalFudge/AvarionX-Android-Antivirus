import 'package:flutter/material.dart';

class UpdateLogData {
  final String version;
  final List<String> changes;

  const UpdateLogData({
    required this.version,
    required this.changes,
  });

  String get displayVersion {
    final i = version.indexOf('+');
    if (i == -1) return version;
    return version.substring(0, i);
  }
}

Future<void> showUpdateLogDialog(
    BuildContext context, {
      required UpdateLogData data,
    }) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => UpdateLogDialog(data: data),
  );
}

class UpdateLogDialog extends StatelessWidget {
  final UpdateLogData data;

  const UpdateLogDialog({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final version = data.displayVersion;

    return AlertDialog(
      title: Text('Update: v$version'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi there! AvarionX has been updated, below are the changes:',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              ...data.changes.map(
                    (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Icon(Icons.circle, size: 6),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          c,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (data.changes.isEmpty)
                Text(
                  'No user-facing changes in this update.',
                  style: theme.textTheme.bodyMedium,
                ),
            ],
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Continue'),
        ),
      ],
    );
  }
}
