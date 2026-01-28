import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/defs_update_scheduler.dart';
import '../../services/exclusion_service.dart';
import '../../services/meta_password_service.dart';
import '../../services/theme_manager.dart';
import '../about/how_this_app_works.dart';
import 'package:flutter/services.dart';
import '../../services/purchase_service.dart';
import '../exclusions/exclusion_manager_screen.dart';
import 'package:flutter/foundation.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isPro = false;
  bool autoUpdateDefs = false;
  bool shizukuWanted = false;
  bool shizukuCertPresent = false;
  bool shizukuBinderAlive = false;
  bool shizukuPermissionGranted = false;

  final _shizukuChannel = const MethodChannel('cs.shizuku');
  final _managerChannel = const MethodChannel('cs.manager');

  @override
  void initState() {
    super.initState();
    _loadPro();
    _loadMetaPassword();
    _loadAutoUpdate();
    _loadShizukuState();
    _loadShizukuRuntimeState();
  }

  final _secure = const FlutterSecureStorage();
  String? _metaPassword;

  Future<void> _loadMetaPassword() async {
    _metaPassword = await MetaPasswordService.getMeta();
    setState(() {});
  }

  Future<void> _saveMetaPassword(String meta) async {
    await MetaPasswordService.setMeta(meta);
    setState(() => _metaPassword = meta);
  }

  Future<void> _clearMetaPassword() async {
    await MetaPasswordService.clearMeta();
    setState(() => _metaPassword = null);
  }

  Future<void> _loadAutoUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      autoUpdateDefs = prefs.getBool('defs_auto_update_enabled') ?? false;
    });
  }

  Future<void> _showUpgradeDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Want to get PRO?'),
          content: const Text(
            'PRO mode supports developement and provides cosmetics. You get Emerald and Grey themes, icon switching, and visual tweaks. Scans and protection are the same for everyone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await PurchaseService.buyPro();
      await Future.delayed(const Duration(seconds: 5));
      await PurchaseService.restore();

      final hasPro = await PurchaseService.hasPro();

      if (hasPro) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isPro', true);
        setState(() => isPro = true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PRO mode unlocked')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Purchase not confirmed')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase failed: $e')),
        );
      }
    }
  }

  Future<void> _loadPro() async {
    final prefs = await SharedPreferences.getInstance();
    bool playPro = false;
    try {
      playPro = await PurchaseService.hasPro();
    } catch (_) {
      playPro = false;
    }
    if (playPro) {
      await prefs.setBool('isPro', true);
      setState(() => isPro = true);
      return;
    }
    final cached = prefs.getBool('isPro') ?? false;
    setState(() => isPro = cached);
  }

  void _showProInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('About PRO'),
          content: const Text(
            'PRO mode does not give better protection, but it does give:\n\n'
                '• Emerald and Grey themes\n'
                '• Custom app icons\n'
                '• Future features\n\n'
                'Scanning and protection strength remain identical for all users. '
                'This upgrade supports future updates and development.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  void _showProOptions(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool hideGoldHeader = prefs.getBool('hideGoldHeader') ?? true;
    String selectedIcon = prefs.getString('selectedIcon') ?? 'default';
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
                          content: Text('Icon selected: ${icon.toUpperCase()}'),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PRO Customization',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SwitchListTile(
                            value: hideGoldHeader,
                            onChanged: (val) async {
                              setModalState(() => hideGoldHeader = val);
                              await prefs.setBool('hideGoldHeader', hideGoldHeader);
                            },
                            title: const Text('Hide gold header on Home Screen'),
                            contentPadding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'App Icon',
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
                                'Default',
                                    () => _changeIcon('default'),
                              ),
                              _iconPreview(
                                context,
                                'bird',
                                selectedIcon,
                                'Bird',
                                    () => _changeIcon('bird'),
                              ),
                              _iconPreview(
                                context,
                                'neon',
                                selectedIcon,
                                'Neon',
                                    () => _changeIcon('neon'),
                              ),
                              _iconPreview(
                                context,
                                'ax',
                                selectedIcon,
                                'AX',
                                    () => _changeIcon('ax'),
                              ),
                              _iconPreview(
                                context,
                                'avx',
                                selectedIcon,
                                'AVX',
                                    () => _changeIcon('avx'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Save'),
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('About Shizuku'),
          content: const Text(
            'AVarionX can integrate with Shizuku to access app processes at the system level.\n\n'
                'This allows the app to:\n'
                '• Detect malware that hides from standard scanners\n'
                '• Inspect running app processes\n'
                '• Disable or contain most active malware\n\n'
                'Shizuku however, does not grant root access\n\n'
                'This feature is intended for advanced users and is not required for normal protection.\n\n'
                'Documentation:\nhttps://shizuku.rikka.app',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _hasShizukuCert() async {
    if (kDebugMode) {
      return true;
    }

    final file = File(
      '/storage/emulated/0/Android/data/com.colourswift.cssecurity/files/cs_shizuku.cert',
    );
    return file.exists();
  }

  Future<void> _loadShizukuState() async {
    final prefs = await SharedPreferences.getInstance();
    shizukuWanted = prefs.getBool('shizuku_enabled') ?? false;
    shizukuCertPresent = await _hasShizukuCert();
    setState(() {});
  }

  Future<void> _setShizukuWanted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('shizuku_enabled', value);
    shizukuWanted = value;
    setState(() {});
  }

  Future<void> _loadShizukuRuntimeState() async {
    try {
      shizukuBinderAlive =
          await _shizukuChannel.invokeMethod<bool>('isBinderAlive') ?? false;

      shizukuPermissionGranted =
          await _shizukuChannel.invokeMethod<bool>('hasPermission') ?? false;
    } catch (_) {
      shizukuBinderAlive = false;
      shizukuPermissionGranted = false;
    }

    setState(() {});
  }

  void _showExclusionsSheet() {
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
                    title: const Text('Exclude a Folder'),
                    onTap: () async {
                      Navigator.pop(context);

                      final result = await FilePicker.platform.getDirectoryPath();
                      if (result != null) {
                        final ex = ExclusionService();
                        await ex.load();
                        await ex.addFolder(result);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Folder excluded')),
                          );
                        }
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.insert_drive_file_rounded),
                    title: const Text('Exclude a File'),
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

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('File excluded')),
                          );
                        }
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.rule_folder_rounded),
                    title: const Text('Manage Existing Exclusions'),
                    subtitle: const Text('View or remove exclusions'),
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
              color: isSelected ? scheme.primary : theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  void _openThemePicker(BuildContext context) {
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
                      'Choose Theme',
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
    final themeManager = Provider.of<ThemeManager>(context, listen: false);
    final isSelected = current == value;

    return ListTile(
      onTap: () {
        Navigator.pop(context);
        if ((value == 'emerald' || value == 'grey' || value == 'purple') && !isPro) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('That theme requires PRO mode')),
          );
        } else {
          themeManager.setTheme(value);
        }
      },
      leading: CircleAvatar(backgroundColor: color, radius: 14),
      title: Text(
        (value == 'emerald' || value == 'grey' || value == 'purple') ? '$label  (Pro)' : label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          color: (value == 'emerald' || value == 'grey' || value == 'purple')
              ? (isPro ? null : Colors.grey)
              : null,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check_rounded) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(
          'Settings',
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
              _sectionHeader(context, 'Appearance'),
              const SizedBox(height: 10),
              _buildSettingTile(
                context,
                icon: Icons.color_lens_rounded,
                title: 'Theme',
                subtitle:
                'Current: ${themeManager.themeName[0].toUpperCase()}${themeManager.themeName.substring(1)}',
                onTap: () => _openThemePicker(context),
              ),
              const SizedBox(height: 18),

              _sectionHeader(context, 'Join the community!'),
              const SizedBox(height: 10),
              _buildSettingTile(
                context,
                icon: Icons.chat_rounded,
                title: 'Discord',
                subtitle: 'Chat, updates and feedback',
                onTap: () async {
                  final uri = Uri.parse('https://discord.gg/VYubQJfcYM');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Unable to open Discord link')),
                    );
                  }
                },
              ),
              const SizedBox(height: 18),

              _sectionHeader(context, 'PRO Features'),
              const SizedBox(height: 10),
              if (isPro)
                _buildSponsorCard(
                  context,
                  onTap: () => _showProOptions(context),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFB8860B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _showUpgradeDialog,
                        child: const Text(
                          'Unlock PRO',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filledTonal(
                      onPressed: _showProInfo,
                      icon: const Icon(Icons.info_outline_rounded),
                    ),
                  ],
                ),
              const SizedBox(height: 18),

              _sectionHeader(context, 'Advanced Protection (Shizuku)'),
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
                  title: const Text(
                    'Enable Shizuku',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    !shizukuCertPresent
                        ? 'Requires external manager'
                        : !shizukuBinderAlive
                        ? 'Shizuku service not running'
                        : !shizukuPermissionGranted
                        ? 'Permission required'
                        : 'Advanced system access available',
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

                    await _setShizukuWanted(false);

                    final hasCert = await _hasShizukuCert();
                    if (!hasCert) {
                      setState(() => shizukuCertPresent = false);

                      if (!mounted) return;

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Advanced system Protection'),
                            content: const Text(
                              'Shizuku access requires an external manager intended for advanced users.\n\n'
                                  'This feature is optional and not recommended for casual protection.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }

                    await _loadShizukuRuntimeState();

                    if (!shizukuBinderAlive) {
                      return;
                    }

                    if (!shizukuPermissionGranted) {
                      await _shizukuChannel.invokeMethod('requestPermission');
                    }

                    await Future.delayed(const Duration(milliseconds: 250));
                    await _loadShizukuRuntimeState();

                    if (shizukuBinderAlive && shizukuPermissionGranted) {
                      await _setShizukuWanted(true);
                    }
                  },
                ),
              ),

              const SizedBox(height: 10),

              _buildSettingTile(
                context,
                icon: Icons.info_outline_rounded,
                title: 'About Advanced Protection',
                subtitle: 'Learn how advanced Protection works',
                onTap: _showShizukuInfo,
              ),

              const SizedBox(height: 18),

              _sectionHeader(context, 'General'),
              const SizedBox(height: 10),

              _buildSettingTile(
                context,
                icon: Icons.lock_outline_rounded,
                title: 'Meta Password',
                subtitle: _metaPassword == null
                    ? 'Required for password vault'
                    : 'Stored securely (tap to change)',
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
                            title: const Text('Set Meta Password'),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: controller,
                                    obscureText: obscure,
                                    decoration: InputDecoration(
                                      labelText: 'Meta password',
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
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () async {
                                  final value = controller.text.trim();
                                  if (value.isEmpty) return;
                                  await _secure.write(
                                    key: 'meta_password',
                                    value: value,
                                  );
                                  setState(() => _metaPassword = value);
                                  Navigator.pop(context);
                                },
                                child: const Text('Save'),
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
                title: 'Exclusions',
                subtitle: 'Manage and add exclusions',
                onTap: _showExclusionsSheet,
              ),

              _buildSettingTile(
                context,
                icon: Icons.security_rounded,
                title: 'Privacy Policy',
                subtitle: 'View how your data is handled',
                onTap: () async {
                  final uri = Uri.parse('https://colourswift.com/Policies/Private-Policy');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Unable to open privacy policy')),
                    );
                  }
                },
              ),

              _buildSettingTile(
                context,
                icon: Icons.info_outline_rounded,
                title: 'About AVarionX',
                subtitle: 'Version 3.0.2',
              ),

              _buildSettingTile(
                context,
                icon: Icons.help_outline_rounded,
                title: 'How This App Works',
                subtitle: 'Learn about protection',
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

  Widget _buildSponsorCard(BuildContext context, {required VoidCallback onTap}) {
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
                      'PRO Customization',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Icons, gold header, and cosmetics',
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
