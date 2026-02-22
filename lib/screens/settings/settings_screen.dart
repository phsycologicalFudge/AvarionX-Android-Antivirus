import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import '../../services/defs_update_scheduler.dart';
import '../../services/exclusion_service.dart';
import '../../services/meta_password_service.dart';
import '../../services/pro_temp_service.dart';
import '../../services/theme_manager.dart';
import '../../translations/app_localizations.dart';
import '../about/how_this_app_works.dart';
import 'package:flutter/services.dart';
import '../../services/purchase_service.dart';
import '../exclusions/exclusion_manager_screen.dart';
import 'package:flutter/foundation.dart';
import '../../constants/build_flags.dart';
import '../pro/pro_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool isPro = false;
  bool autoUpdateDefs = false;
  bool shizukuWanted = false;
  bool shizukuBinderAlive = false;
  bool shizukuPermissionGranted = false;

  final _shizukuChannel = const MethodChannel('cs.shizuku');
  final _managerChannel = const MethodChannel('cs.manager');

  String _language = 'system';

  static const Map<String, String> _languageLabels = {
    'system': 'system',
    'en': 'en',
    'es': 'es',
    'fr': 'fr',
    'de': 'de',
    'it': 'it',
    'pl': 'pl',
    'pt': 'pt',
    'ar': 'ar',
  };

  final _secure = const FlutterSecureStorage();
  String? _metaPassword;

  String _languageLabel(String code) {
    final l10n = AppLocalizations.of(context)!;
    switch (code) {
      case 'system':
        return l10n.settingsSystemDefault;
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
        return 'عربي';
      default:
        return code;
    }
  }

  Future<void> refresh() async {
    await _loadPro();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _loadLanguage() async {
    final lm = Provider.of<LanguageManager>(context, listen: false);
    setState(() => _language = lm.code);
  }

  Future<void> _setLanguage(String code) async {
    final l10n = AppLocalizations.of(context)!;
    final lm = Provider.of<LanguageManager>(context, listen: false);
    await lm.setLanguage(code);
    if (!mounted) return;
    setState(() => _language = code);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsLanguageApplied)),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadPro();
    _loadMetaPassword();
    _loadAutoUpdate();
    _loadShizukuState();
    _loadShizukuRuntimeState();
  }

  Future<void> _loadMetaPassword() async {
    _metaPassword = await MetaPasswordService.getMeta();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _saveMetaPassword(String meta) async {
    await MetaPasswordService.setMeta(meta);
    if (!mounted) return;
    setState(() => _metaPassword = meta);
  }

  Future<void> _clearMetaPassword() async {
    await MetaPasswordService.clearMeta();
    if (!mounted) return;
    setState(() => _metaPassword = null);
  }

  Future<void> _loadAutoUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      autoUpdateDefs = prefs.getBool('defs_auto_update_enabled') ?? false;
    });
  }

  Future<void> _resetProForDebug() async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();

    await ProGate.setDebugIgnorePaid(false);
    await ProGate.clearLocalUnlock();
    await ProGate.clearTrial();
    await PurchaseService.clearLocalProFlag();
    await prefs.setBool('isPro', false);

    await _loadPro();

    if (!mounted) return;
    setState(() {
      isPro = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsProReset)),
    );
  }

  Future<void> _showUpgradeDialog() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProScreen()),
    );
  }

  Future<void> _showSupportUnlockDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    String? expected;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Sponsors unlock ❤️'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        final picked = await FilePicker.platform.pickFiles();
                        if (picked == null || picked.files.isEmpty) return;

                        final path = picked.files.single.path;
                        if (path == null) return;

                        try {
                          final txt = await File(path).readAsString();
                          final v = txt.trim();
                          if (v.isEmpty) return;
                          setState(() => expected = v);
                        } catch (_) {}
                      },
                      child: Text(
                        expected == null ? 'Pick Certificate' : 'Certificate loaded',
                      ),
                    ),
                  ),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'enter code',
                      filled: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.metaPassCancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(l10n.metaPassContinue),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed != true) return;

    if (expected == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Support file missing')),
      );
      return;
    }

    final code = controller.text.trim();
    if (code != expected) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid support code')),
      );
      return;
    }

    await _unlockProLocally();
  }

  Future<void> _unlockProLocally() async {
    final l10n = AppLocalizations.of(context)!;
    await ProGate.setLocalUnlocked(true);
    await ProGate.clearTrial();
    await _loadPro();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsProUnlocked)),
    );
  }

  static const String _supportUnlockCode = 'CS-SUPPORT-UNLOCK';

  Future<void> _loadPro() async {
    await PurchaseService.restore();
    final billingPro = await PurchaseService.hasPro();
    final gatePro = await ProGate.sync();
    final effective = billingPro || gatePro;

    if (!mounted) return;

    setState(() {
      isPro = effective;
    });
  }

  Future<void> _activateTrialPro() async {
    await ProGate.setTrial(const Duration(days: 7));
    await _loadPro();
  }

  void _showProOptions(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    bool goldHeaderEnabled = prefs.getBool('goldHeaderEnabled') ?? false;    String selectedIcon = prefs.getString('selectedIcon') ?? 'default';
    final iconChannel = MethodChannel('colourswift/icon_switch');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        final theme = Theme.of(context);
        final scheme = theme.colorScheme;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 14,
              right: 14,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 14,
            ),
            child: Material(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(22),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: StatefulBuilder(
                  builder: (context, setModalState) {
                    Future<void> _changeIcon(String icon) async {
                      setModalState(() => selectedIcon = icon);
                      await prefs.setString('selectedIcon', icon);

                      try {
                        iconChannel.invokeMethod('setIcon', {'icon': icon});
                      } catch (_) {}

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.settingsIconSelected(icon.toUpperCase()),
                          ),
                        ),
                      );
                    }

                    String _iconLabel(String icon) {
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
                        default:
                          return icon;
                      }
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
                          const SizedBox(height: 10),
                          SwitchListTile(
                            value: goldHeaderEnabled,
                            onChanged: (val) async {
                              setModalState(() => goldHeaderEnabled = val);
                              await prefs.setBool('goldHeaderEnabled', goldHeaderEnabled);
                            },
                            title: Text(l10n.settingsHideGoldHeader),
                            contentPadding: EdgeInsets.zero,
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
                              _iconPreview(
                                context,
                                'default',
                                selectedIcon,
                                _iconLabel('default'),
                                    () => _changeIcon('default'),
                              ),
                              _iconPreview(
                                context,
                                'bird',
                                selectedIcon,
                                _iconLabel('bird'),
                                    () => _changeIcon('bird'),
                              ),
                              _iconPreview(
                                context,
                                'neon',
                                selectedIcon,
                                _iconLabel('neon'),
                                    () => _changeIcon('neon'),
                              ),
                              _iconPreview(
                                context,
                                'ax',
                                selectedIcon,
                                _iconLabel('ax'),
                                    () => _changeIcon('ax'),
                              ),
                              _iconPreview(
                                context,
                                'avx',
                                selectedIcon,
                                _iconLabel('avx'),
                                    () => _changeIcon('avx'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () => Navigator.pop(context),
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

  void _showShizukuInfo() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.settingsAboutShizukuTitle),
          content: Text(l10n.settingsAboutShizukuBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadShizukuState() async {
    final prefs = await SharedPreferences.getInstance();
    shizukuWanted = prefs.getBool('shizuku_enabled') ?? false;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _setShizukuWanted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('shizuku_enabled', value);
    shizukuWanted = value;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _loadShizukuRuntimeState() async {
    try {
      shizukuBinderAlive = await _shizukuChannel.invokeMethod<bool>('isBinderAlive') ?? false;

      shizukuPermissionGranted = await _shizukuChannel.invokeMethod<bool>('hasPermission') ?? false;
    } catch (_) {
      shizukuBinderAlive = false;
      shizukuPermissionGranted = false;
    }

    if (!mounted) return;
    setState(() {});
  }

  void _showExclusionsSheet() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      isScrollControlled: false,
      builder: (context) {
        final theme = Theme.of(context);
        final scheme = theme.colorScheme;

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
                      Navigator.pop(context);

                      final result = await FilePicker.platform.getDirectoryPath();
                      if (result != null) {
                        final ex = ExclusionService();
                        await ex.load();
                        await ex.addFolder(result);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.settingsFolderExcluded)),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.insert_drive_file_rounded),
                    title: Text(l10n.settingsExcludeFile),
                    onTap: () async {
                      Navigator.pop(context);

                      final r = await FilePicker.platform.pickFiles();
                      if (r != null && r.files.isNotEmpty) {
                        final path = r.files.single.path!;
                        final bytes = File(path).readAsBytesSync();
                        final sha = sha256.convert(bytes).toString();

                        final ex = ExclusionService();
                        await ex.load();
                        await ex.addSha(sha);

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.settingsFileExcluded)),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.rule_folder_rounded),
                    title: Text(l10n.settingsManageExclusions),
                    subtitle: Text(l10n.settingsManageExclusionsSubtitle),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ExclusionManagerScreen()),
                      );
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

  Widget _iconPreview(BuildContext context, String name, String selected, String label, VoidCallback onTap) {
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
              color: isSelected ? scheme.primaryContainer.withOpacity(0.25) : scheme.surfaceContainer,
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
              color: isSelected ? scheme.primary : theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  void _openLanguagePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    final languageManager = Provider.of<LanguageManager>(context, listen: false);
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
          return 'عربي';
        default:
          return locale.languageCode;
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 14,
              right: 14,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 14,
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
                      style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        await languageManager.setLanguage('system');
                        if (!mounted) return;
                        setState(() => _language = 'system');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.settingsLanguageApplied)),
                        );
                      },
                      title: Text(
                        l10n.settingsSystemDefault,
                        style: TextStyle(
                          fontWeight: languageManager.code == 'system' ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                      trailing: languageManager.code == 'system' ? const Icon(Icons.check_rounded) : null,
                    ),
                    ...supported.map((loc) {
                      final code = loc.languageCode;
                      final isSelected = languageManager.code == code;
                      return ListTile(
                        onTap: () async {
                          Navigator.pop(context);
                          await languageManager.setLanguage(code);
                          if (!mounted) return;
                          setState(() => _language = code);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.settingsLanguageApplied)),
                          );
                        },
                        title: Text(
                          labelFor(loc),
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          ),
                        ),
                        trailing: isSelected ? const Icon(Icons.check_rounded) : null,
                      );
                    }).toList(),
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

  void _openThemePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final themeManager = Provider.of<ThemeManager>(context, listen: false);
    final current = themeManager.themeName;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 14,
              right: 14,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 14,
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
                      style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    _themeOption(context, 'Black', 'black', Colors.black, current),
                    _themeOption(context, 'White', 'white', Colors.white, current),
                    _themeOption(context, 'Grey', 'grey', Colors.grey.shade700, current),
                    _themeOption(context, 'Emerald', 'emerald', const Color(0xFF009E73), current),
                    _themeOption(context, 'Purple', 'purple', const Color(0xFF8B5CF6), current),
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

  Widget _themeOption(BuildContext context, String label, String value, Color color, String current) {
    final l10n = AppLocalizations.of(context)!;
    final themeManager = Provider.of<ThemeManager>(context, listen: false);
    final isSelected = current == value;
    final isProTheme = value == 'emerald' || value == 'grey' || value == 'purple';

    return ListTile(
      onTap: () {
        Navigator.pop(context);
        if (isProTheme && !isPro) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProScreen()),
          );
        } else {
          themeManager.setTheme(value);
        }
      },
      leading: CircleAvatar(backgroundColor: color, radius: 14),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final themeManager = Provider.of<ThemeManager>(context);
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    final themeName = themeManager.themeName;
    final themeLabel = themeName.isEmpty ? themeName : '${themeName[0].toUpperCase()}${themeName.substring(1)}';

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(
          l10n.footerSettings,
          style: text.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surfaceTint,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(context, l10n.settingsSectionAppearance),
              const SizedBox(height: 10),
              _buildSettingTile(
                context,
                icon: Icons.color_lens_rounded,
                title: l10n.settingsTheme,
                subtitle: l10n.settingsThemeCurrent(themeLabel),
                onTap: () => _openThemePicker(context),
              ),
              _buildSettingTile(
                context,
                icon: Icons.language_rounded,
                title: l10n.settingsLanguage,
                subtitle: l10n.settingsLanguageCurrent(_languageLabel(_language)),
                onTap: () => _openLanguagePicker(context),
              ),
              _sectionHeader(context, l10n.settingsSectionCommunity),
              const SizedBox(height: 10),
              _buildSettingTile(
                context,
                icon: Icons.chat_rounded,
                title: l10n.settingsDiscord,
                subtitle: l10n.settingsDiscordSubtitle,
                onTap: () async {
                  final uri = Uri.parse('https://discord.gg/VYubQJfcYM');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.settingsDiscordOpenFail)),
                    );
                  }
                },
              ),
              const SizedBox(height: 18),
              _sectionHeader(context, l10n.settingsSectionPro),
              const SizedBox(height: 10),
              Column(
                children: [
                  if (isPro)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSponsorCard(
                          context,
                          onTap: () => _showProOptions(context),
                          trialLabel: '',
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: _showUpgradeDialog,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                              child: Text(
                                'Change plan',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Card.outlined(
                      color: scheme.surfaceContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xFFB8860B).withOpacity(0.18),
                                  child: const Icon(
                                    Icons.workspace_premium_rounded,
                                    color: Color(0xFFB8860B),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.settingsUnlockPro,
                                        style: text.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        l10n.settingsProSubtitle,
                                        style: text.bodySmall?.copyWith(
                                          color: scheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFFB8860B),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const ProScreen()),
                                  );
                                },
                                child: Text(
                                  l10n.settingsUnlockPro,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              _sectionHeader(context, l10n.settingsSectionShizuku),
              const SizedBox(height: 10),
              Card.outlined(
                color: scheme.surfaceContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SwitchListTile(
                  secondary: CircleAvatar(
                    backgroundColor: scheme.primaryContainer,
                    child: Icon(
                      Icons.developer_mode_rounded,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(
                    l10n.settingsEnableShizuku,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                    subtitle: Text(
                      !shizukuBinderAlive
                          ? l10n.settingsShizukuNotRunning
                          : !shizukuPermissionGranted
                          ? l10n.settingsShizukuPermissionRequired
                          : l10n.settingsShizukuAvailable,
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  value: shizukuWanted,
                    onChanged: (value) async {
                      if (!value) {
                        await _setShizukuWanted(false);
                        return;
                      }

                      final prefs = await SharedPreferences.getInstance();
                      final firstTime = !(prefs.getBool('shizuku_warning_shown') ?? false);

                      if (firstTime) {
                        final accepted = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Experimental Features'),
                              content: const Text(
                                  'Enabling Shizuku unlocks experimental work-in-progress features:\n\n'
                                      '• Advanced Ransomware Protection\n'
                                      '• Cache Cleaner Plus\n\n'
                                      'These features may change and are still being refined.\n\n'
                                      'Please read the documentation before enabling.'
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    final uri = Uri.parse('https://github.com/ColourSwift/AvarionX-Security');
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  child: const Text('GitHub'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Enable'),
                                ),
                              ],
                            );
                          },
                        );

                        if (accepted != true) return;

                        await prefs.setBool('shizuku_warning_shown', true);
                      }

                      await _loadShizukuRuntimeState();

                      if (!shizukuBinderAlive) return;

                      if (!shizukuPermissionGranted) {
                        await _shizukuChannel.invokeMethod('requestPermission');
                        await Future.delayed(const Duration(milliseconds: 300));
                        await _loadShizukuRuntimeState();
                      }

                      if (shizukuBinderAlive && shizukuPermissionGranted) {
                        await _setShizukuWanted(true);
                      }
                    }
                ),
              ),
              const SizedBox(height: 10),
              _buildSettingTile(
                context,
                icon: Icons.info_outline_rounded,
                title: l10n.settingsAboutAdvancedProtection,
                subtitle: l10n.settingsAboutAdvancedProtectionSubtitle,
                onTap: _showShizukuInfo,
              ),
              const SizedBox(height: 18),
              _sectionHeader(context, l10n.settingsSectionGeneral),
              const SizedBox(height: 10),
              _buildSettingTile(
                context,
                icon: Icons.lock_outline_rounded,
                title: l10n.passwordSettingsMetaPasswordTitle,
                subtitle: _metaPassword == null ? l10n.passwordSettingsMetaNotSet : l10n.passwordSettingsMetaStoredSecurely,
                onTap: () async {
                  final controller = TextEditingController(
                    text: await _secure.read(key: 'meta_password') ?? '',
                  );

                  showDialog(
                    context: context,
                    builder: (context) {
                      bool obscure = true;
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            scrollable: true,
                            title: Text(l10n.metaPassSetMetaTitle),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: controller,
                                    obscureText: obscure,
                                    decoration: InputDecoration(
                                      labelText: l10n.metaPassMetaLabel,
                                      prefixIcon: const Icon(Icons.key_rounded),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          obscure ? Icons.visibility_off : Icons.visibility,
                                        ),
                                        onPressed: () => setState(() => obscure = !obscure),
                                      ),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(l10n.metaPassCancel),
                              ),
                              FilledButton(
                                onPressed: () async {
                                  final value = controller.text.trim();
                                  if (value.isEmpty) return;
                                  await _secure.write(
                                    key: 'meta_password',
                                    value: value,
                                  );
                                  if (!mounted) return;
                                  setState(() => _metaPassword = value);
                                  Navigator.pop(context);
                                },
                                child: Text(l10n.metaPassSave),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
              _buildSettingTile(
                context,
                icon: Icons.rule_folder_rounded,
                title: l10n.settingsExclusions,
                subtitle: l10n.settingsExclusionsSubtitle,
                onTap: _showExclusionsSheet,
              ),
              _buildSettingTile(
                context,
                icon: Icons.security_rounded,
                title: l10n.settingsPrivacyPolicy,
                subtitle: l10n.settingsPrivacyPolicySubtitle,
                onTap: () async {
                  final uri = Uri.parse('https://colourswift.com/Policies/Private-Policy');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.settingsPrivacyPolicyOpenFail)),
                    );
                  }
                },
              ),
              _buildSettingTile(
                context,
                icon: Icons.info_outline_rounded,
                title: l10n.settingsAboutApp,
                subtitle: 'v3.0.6',
              ),
              if (kDebugMode)
                _buildSettingTile(
                  context,
                  icon: Icons.bug_report_rounded,
                  title: l10n.settingsProReset,
                  subtitle: l10n.settingsProReset,
                  onTap: _resetProForDebug,
                ),
              _buildSettingTile(
                context,
                icon: Icons.help_outline_rounded,
                title: l10n.settingsHowThisAppWorks,
                subtitle: l10n.settingsHowThisAppWorksSubtitle,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HowThisAppWorksScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w800,
        color: scheme.onSurface.withOpacity(0.92),
      ),
    );
  }

  Widget _buildSponsorCard(BuildContext context, {required VoidCallback onTap, required String trialLabel}) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card.outlined(
      color: scheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFB8860B).withOpacity(0.18),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Color(0xFFB8860B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsProCustomization,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.settingsProSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        Widget? trailing,
        VoidCallback? onTap,
      }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card.outlined(
        color: scheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: scheme.primaryContainer,
            child: Icon(icon, color: scheme.onPrimaryContainer),
          ),
          title: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}
