import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/meta_password_service.dart';
import '../../widgets/antivirus_bridge.dart';

import '../../translations/app_localizations.dart';
class PasswordSettingsScreen extends StatefulWidget {
  const PasswordSettingsScreen({super.key});

  @override
  State<PasswordSettingsScreen> createState() =>
      _PasswordSettingsScreenState();
}

class _PasswordSettingsScreenState extends State<PasswordSettingsScreen> {
  final _bridge = AntivirusBridge();

  String? _meta;
  String? _restoreCode;
  bool _loading = true;

  static const _vaultKey = 'vault_entries';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final meta = await MetaPasswordService.getMeta();
    setState(() {
      _meta = meta;
      _loading = false;
    });
  }

  Future<String> _loadVaultJson() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_vaultKey) ?? [];

    final List<Map<String, dynamic>> restoreEntries = [];

    for (final item in raw) {
      try {
        final entry = jsonDecode(item) as Map<String, dynamic>;

        final label = entry['label'] as String?;
        final versions = entry['versions'] as List?;

        if (label == null || versions == null || versions.isEmpty) continue;

        final selected =
            entry['selectedVersion'] as int? ??
                (versions.last as Map)['version'] as int;

        final versionItem = versions.firstWhere(
              (v) => v['version'] == selected,
          orElse: () => versions.last,
        ) as Map<String, dynamic>;

        restoreEntries.add({
          'id': label,
          'version': versionItem['version'],
          'length': versionItem['length'],
        });
      } catch (_) {}
    }

    return jsonEncode(restoreEntries);
  }

  Future<void> _generateRestoreCode() async {
    if (_meta == null || _meta!.isEmpty) return;

    final vaultJson = await _loadVaultJson();
    final code = _bridge.generateRestoreCode(_meta!, vaultJson);

    setState(() => _restoreCode = code);
  }

  Future<void> _copyRestoreCode() async {
    if (_restoreCode == null) return;
    await Clipboard.setData(ClipboardData(text: _restoreCode!));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(AppLocalizations.of(context)!.passwordSettingsRestoreCodeCopied)),
    );
  }

  Future<void> _restoreFromCode(String code) async {
    if (_meta == null || _meta!.isEmpty) return;

    final json = _bridge.restoreFromCode(_meta!, code);
    if (json.isEmpty) return;

    final decoded = jsonDecode(json);
    if (decoded is! List) return;

    final normalized = <String>[];

    for (final item in decoded) {
      if (item is! Map) continue;

      final entry = <String, dynamic>{};

      final id = item['id'] as String?;
      final version = item['version'] as int?;
      final length = item['length'] as int?;

      if (id == null || version == null || length == null) continue;
      entry['label'] = id;
      entry['package'] = null;
      entry['icon'] = null;
      entry['versions'] = [
        { 'version': version, 'length': length }
      ];
      entry['selectedVersion'] = version;
      entry['label'] ??= '';
      entry['package'] ??= null;
      entry['icon'] ??= null;

      final versions = (entry['versions'] is List)
          ? List<Map<String, dynamic>>.from(
        entry['versions'].whereType<Map>(),
      )
          : <Map<String, dynamic>>[];
      if (versions.isEmpty) {
        versions.add({'version': 1, 'length': 24});
      }

      entry['versions'] = versions;
      entry['selectedVersion'] ??= versions.last['version'];
      normalized.add(jsonEncode(entry));
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_vaultKey, normalized);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(AppLocalizations.of(context)!.passwordSettingsVaultRestored)),
    );

    Navigator.pop(context);
  }

  Future<void> _changeMetaPassword() async {
    final controller = TextEditingController(text: _meta ?? '');
    bool obscure = true;

    final res = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title:  Text(AppLocalizations.of(context)!.passwordSettingsSetMetaPassTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    obscureText: obscure,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.passwordSettingsMetaPasswordTitle,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            setState(() => obscure = !obscure),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                   Text(
                    AppLocalizations.of(context)!.passwordSettingsChangingThisAltersAllPasswords +
                        AppLocalizations.of(context)!.passwordSettingsUsingTheSameMetaPassRestoresThem,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:  Text(AppLocalizations.of(context)!.cancel),
                ),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context, controller.text.trim()),
                  child:  Text(AppLocalizations.of(context)!.vpnSave),
                ),
              ],
            );
          },
        );
      },
    );

    if (res == null || res.isEmpty) return;

    await MetaPasswordService.setMeta(res);
    setState(() {
      _meta = res;
      _restoreCode = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title:  Text(AppLocalizations.of(context)!.passwordSettingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            AppLocalizations.of(context)!.passwordSettingsSectionMetaPass,
            style: text.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.key_rounded),
              title:  Text(AppLocalizations.of(context)!.passwordSettingsMetaPasswordTitle),
              subtitle: Text(
                _meta == null
                    ? AppLocalizations.of(context)!.passwordSettingsMetaNotSet
                    : AppLocalizations.of(context)!.passwordSettingsMetaStoredSecurely,
              ),
              trailing: TextButton(
                onPressed: _changeMetaPassword,
                child:  Text(AppLocalizations.of(context)!.passwordSettingsChange),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.passwordSettingsRestoreCodeLabel,
            style: text.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_restoreCode == null)
                    FilledButton(
                      onPressed: _generateRestoreCode,
                      child:  Text(AppLocalizations.of(context)!.passwordSettingsGenerateRestoreCode),
                    )
                  else ...[
                    SelectableText(
                      _restoreCode!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: _copyRestoreCode,
                        icon: const Icon(Icons.copy_rounded),
                        label:  Text(AppLocalizations.of(context)!.passwordSettingsCopy),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.passwordSettingsSectionRestoreFromCode,
            style: text.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _RestoreInput(
            onRestore: _restoreFromCode,
          ),
          const SizedBox(height: 24),
          Card(
            color: theme.colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(context)!.passwordSettingsPasswordsAreNeverStored +
                    AppLocalizations.of(context)!.passwordSettingsTheRestoreCodeContainsOnlyStructureData +
                    AppLocalizations.of(context)!.passwordSettingsCombinedWithYourMetaPassItRebuildsYour,
                style: text.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RestoreInput extends StatefulWidget {
  final void Function(String) onRestore;
  const _RestoreInput({required this.onRestore});

  @override
  State<_RestoreInput> createState() => _RestoreInputState();
}

class _RestoreInputState extends State<_RestoreInput> {
  final controller = TextEditingController();
  bool canRestore = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      final ok = controller.text.trim().isNotEmpty;
      if (ok != canRestore) {
        setState(() => canRestore = ok);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration:  InputDecoration(
                labelText: AppLocalizations.of(context)!.passwordSettingsRestoreCodeLabel,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: canRestore
                    ? () => widget.onRestore(controller.text.trim())
                    : null,
                child:  Text(AppLocalizations.of(context)!.quarantineRestore),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
