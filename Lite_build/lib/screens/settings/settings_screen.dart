import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import '../../services/exclusion_service.dart';
import '../../services/purchase_service.dart';
import '../../services/theme/theme_manager.dart';
import '../../translations/app_localizations.dart';
import '../../widgets/mesh_background.dart';
import '../about/how_this_app_works.dart';
import 'sheets/settings_exclusions_sheet.dart';
import 'sheets/settings_language_sheet.dart';
import 'sheets/settings_pro_options_sheet.dart';
import 'sheets/settings_rtp_notification_sheet.dart';
import 'sheets/settings_theme_sheet.dart';
import 'widgets/settings_account_card.dart';
import 'widgets/settings_pro_card.dart';
import 'widgets/settings_section_header.dart';
import 'widgets/settings_setting_tile.dart';

class MetaPasswordService { static Future<String?> getMeta() async => null; }
String? _metaPassword;
void _showMetaPasswordDialog() {}


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool isPro = false;
  bool autoUpdateDefs = false;
  bool showScanModePicker = false;
  int _rtpNotificationAutoDismissSeconds = 0;
  bool shizukuWanted = false;
  bool shizukuBinderAlive = false;
  bool shizukuPermissionGranted = false;

  bool _closing = false;
  String? _accountEmail;
  String? _accountId;
  bool _accountLoading = false;
  bool _signedIn = false;
  String _authToken = '';

  final _shizukuChannel = const MethodChannel('cs.shizuku');
  final _managerChannel = const MethodChannel('cs.manager');
  final _secure = const FlutterSecureStorage();

  String _language = 'system';
  bool _signingOut = false;
  late final AnimationController _signOutSpinController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _signOutSpinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _loadLanguage();
    _loadPro();
    _loadRtpNotificationSetting();
    _loadAutoUpdate();
    _loadScanModePicker();
    _loadShizukuState();
    _loadShizukuRuntimeState();
    _initAuthState();
  }

  @override
  void dispose() {
    _closing = true;
    WidgetsBinding.instance.removeObserver(this);
    _signOutSpinController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;

    unawaited(() async {
      final prefs = await SharedPreferences.getInstance();
      final token = (prefs.getString('cs_auth_token') ?? '').trim();

      if (_closing || !mounted) return;

      if (token.isEmpty) {
        if (_signedIn || _accountLoading || _accountEmail != null || _accountId != null) {
          await PurchaseService.clearServerAccountEntitlement();

          if (!mounted) return;
          setState(() {
            _authToken = '';
            _signedIn = false;
            _accountEmail = null;
            _accountId = null;
            _accountLoading = false;
          });
        }

        await _loadPro();
        return;
      }

      _authToken = token;
      await _loadAccountInfo(token);
      await _loadPro();
    }());
  }

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
        return 'العربية';
      case 'ja':
        return '日本語';
      default:
        return code;
    }
  }

  String _rtpNotificationSettingLabel(AppLocalizations l10n, int seconds) {
    switch (seconds) {
      case 0:
        return 'Never';
      case 300:
        return '5 minutes';
      case 600:
        return '10 minutes';
      case 1800:
        return '30 minutes';
      default:
        return 'Custom';
    }
  }

  Future<void> refresh() async {
    await _loadPro();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _loadLanguage() async {
    final lm = Provider.of<LanguageManager>(context, listen: false);
    if (!mounted) return;
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


  Future<void> _loadAutoUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      autoUpdateDefs = prefs.getBool('defs_auto_update_enabled') ?? false;
    });
  }

  Future<void> _loadScanModePicker() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      showScanModePicker = prefs.getBool('show_scan_mode_picker') ?? false;
    });
  }

  Future<void> _setScanModePicker(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_scan_mode_picker', value);
    if (!mounted) return;
    setState(() {
      showScanModePicker = value;
    });
  }

  Future<void> _loadRtpNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _rtpNotificationAutoDismissSeconds =
          prefs.getInt('rtp_notification_auto_dismiss_seconds') ?? 0;
    });
  }

  Future<void> _setRtpNotificationSetting(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('rtp_notification_auto_dismiss_seconds', seconds);
    if (!mounted) return;
    setState(() {
      _rtpNotificationAutoDismissSeconds = seconds;
    });
  }

  Future<void> _initAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = (prefs.getString('cs_auth_token') ?? '').trim();

    if (!mounted) return;
    setState(() {
      _signedIn = _authToken.isNotEmpty;
      _accountLoading = _authToken.isNotEmpty;
    });

    if (_authToken.isNotEmpty) {
      await _loadAccountInfo(_authToken);
      await _loadPro();
    } else {
      await PurchaseService.clearServerAccountEntitlement();
      await _loadPro();
    }
  }


  Future<void> _startAvLoginInBrowser() async {
    final uri = Uri.parse('https://api.colourswift.com/login?app=av');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _loadPro() async {
    final billingPro = await PurchaseService.cachedHasPro();
    final effective = billingPro;

    if (!mounted) return;
    setState(() {
      isPro = effective;
    });
  }

  Future<void> _restorePurchasesNow() async {
    final l10n = AppLocalizations.of(context)!;

    await PurchaseService.ensureReady();
    await PurchaseService.restore();

    final billingPro = await PurchaseService.cachedHasPro();
    final effective = billingPro;

    if (!mounted) return;
    setState(() {
      isPro = effective;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.ok)),
    );
  }

  Future<void> _showUpgradeDialog() async {}

  Future<void> _unlockProLocally() async {
    final l10n = AppLocalizations.of(context)!;
    await _loadPro();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsProUnlocked)),
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
          builder: (context, setDialogState) {
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
                          setDialogState(() => expected = v);
                        } catch (_) {}
                      },
                      child: Text(
                        expected == null
                            ? 'Pick Certificate'
                            : 'Certificate loaded',
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

  Future<void> _resetProForDebug() async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();

    await PurchaseService.clearLocalProFlag();
    await PurchaseService.clearServerAccountEntitlement();
    await prefs.setBool('isPro', false);
    await prefs.remove('billing_vpn_entitled');
    await prefs.remove('billing_server_plan');

    await _loadPro();

    if (!mounted) return;
    setState(() {
      isPro = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsProReset)),
    );
  }

  Future<void> _enableProForDebug() async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isPro', true);

    await _loadPro();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsProUnlocked)),
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

  void _showAboutAvarionXPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Avarionx Security'),
          content: Text(
            'AvarionX is a mobile security suite created by ColourSwift Tech, based in Birmingham, UK.\n\n'
                'Contact: support@colourswift.com',
          ),
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
      shizukuBinderAlive =
          await _shizukuChannel.invokeMethod<bool>('isBinderAlive') ?? false;
      shizukuPermissionGranted =
          await _shizukuChannel.invokeMethod<bool>('hasPermission') ?? false;
    } catch (_) {
      shizukuBinderAlive = false;
      shizukuPermissionGranted = false;
    }

    if (!mounted) return;
    setState(() {});
  }

  Future<void> _loadAccountInfo([String? overrideToken]) async {
    final token = (overrideToken ?? _authToken).trim();

    if (token.isEmpty) {
      await PurchaseService.clearServerAccountEntitlement();
      if (!mounted) return;
      setState(() {
        _signedIn = false;
        _accountEmail = null;
        _accountId = null;
        _accountLoading = false;
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _signedIn = true;
      _accountLoading = true;
    });

    final client = HttpClient();

    try {
      final req =
      await client.getUrl(Uri.parse('https://api.colourswift.com/me'));
      req.headers.set('authorization', 'Bearer $token');
      final res = await req.close();

      if (res.statusCode == 200) {
        final body = await res.transform(utf8.decoder).join();
        final json = jsonDecode(body) as Map<String, dynamic>;
        final user = (json['user'] is Map ? json['user'] as Map : json)
            .cast<String, dynamic>();

        final email = (user['email'] ?? '').toString().trim();
        final id = (user['accountId'] ??
            user['account_id'] ??
            user['id'] ??
            user['uid'] ??
            '')
            .toString()
            .trim();

        final plan = (user['plan'] ?? '').toString();
        final rawExp = user['planExpiresAt'] ?? user['plan_expires_at'];

        final int? exp = rawExp is num
            ? rawExp.toInt()
            : int.tryParse((rawExp ?? '').toString());

        await PurchaseService.applyServerAccountEntitlement(
          signedIn: true,
          plan: plan,
          planExpiresAt: exp,
        );

        if (!mounted) return;
        setState(() {
          _signedIn = true;
          _accountEmail = email.isEmpty ? null : email;
          _accountId = id.isEmpty ? null : id;
          _accountLoading = false;
        });
        return;
      }

      if (res.statusCode == 401) {
        await PurchaseService.clearServerAccountEntitlement();

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('cs_auth_token');
        _authToken = '';

        if (!mounted) return;
        setState(() {
          _signedIn = false;
          _accountEmail = null;
          _accountId = null;
          _accountLoading = false;
        });
        return;
      }
    } catch (_) {
    } finally {
      client.close(force: true);
    }

    if (!mounted) return;
    setState(() {
      _signedIn = true;
      _accountLoading = false;
    });
  }

  Future<void> _openAccountDashboard() async {
    final token = _authToken.trim();
    if (token.isEmpty) return;

    final uri = Uri.parse('https://api.colourswift.com/account?token=$token');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _signOutAccount() async {
    if (_signingOut) return;

    if (mounted) {
      setState(() {
        _signingOut = true;
      });
    }

    try {
      _authToken = '';

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cs_auth_token');
      await PurchaseService.clearServerAccountEntitlement();
      await _loadPro();

      if (!mounted) return;
      setState(() {
        _signedIn = false;
        _accountEmail = null;
        _accountId = null;
        _accountLoading = false;
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _signingOut = false;
      });
    }
  }


  Future<void> _handleShizukuTap() async {
    final value = !shizukuWanted;

    if (!value) {
      await _setShizukuWanted(false);

      try {
        await _shizukuChannel.invokeMethod('disable');
      } catch (_) {}

      await _loadShizukuRuntimeState();
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
                  'Experimental warning:\n'
                  'These features use advanced system access and may behave differently across devices, Android versions, and Shizuku setups. Some actions may affect running apps, files, or cache data more directly than normal scanning.\n\n'
                  'Only enable this if you understand Shizuku, accept that the feature is still being tested, and have backed up anything important.\n\n'
                  'Please read the documentation before enabling.',
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final uri = Uri.parse(
                    'https://github.com/ColourSwift/AvarionX-Security',
                  );
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

  Widget _buildSigningOutLoader(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface.withOpacity(0.88),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 92,
              width: 92,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  RotationTransition(
                    turns: _signOutSpinController,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.1),
                            theme.colorScheme.primary,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.surface,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.logout_rounded,
                    size: 34,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Signing out...',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAccountSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (routeContext) => _AccountSettingsScreen(
          signedIn: _signedIn,
          accountLoading: _accountLoading,
          accountEmail: _accountEmail,
          accountId: _accountId,
          isPro: isPro,
          onSignIn: () async {
            Navigator.pop(routeContext);
            await _startAvLoginInBrowser();
          },
          onDashboard: _openAccountDashboard,
          onSignOut: _signOutAccount,
          onOpenPro: _showUpgradeDialog,
          onRestorePurchases: _restorePurchasesNow,
        ),
      ),
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
    final themeLabel = themeName.isEmpty
        ? themeName
        : '${themeName[0].toUpperCase()}${themeName.substring(1)}';

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
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: MeshBackground(
        blobs: themeManager.meshBlobs,
        base: scheme.surface,
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsSectionHeader(title: 'Account'),
                    const SizedBox(height: 10),
                    SettingsSettingTile(
                      icon: Icons.person_outline_rounded,
                      title: _signedIn ? 'Account' : 'Sign in',
                      subtitle: _accountLoading
                          ? 'Checking account status...'
                          : _signedIn
                          ? (_accountEmail ?? 'Signed in')
                          : 'Manage sign in, Premium, and purchases',
                      onTap: _openAccountSettings,
                    ),
                    const SizedBox(height: 18),
                    SettingsSectionHeader(title: l10n.settingsSectionAppearance),
                    const SizedBox(height: 10),
                    SettingsSettingTile(
                      icon: Icons.color_lens_rounded,
                      title: l10n.settingsTheme,
                      subtitle: l10n.settingsThemeCurrent(themeLabel),
                      onTap: () {
                        showSettingsThemeSheet(
                          context: context,
                          isPro: isPro,
                          currentTheme: themeManager.themeName,
                          onSelectTheme: (value) async {
                            final manager =
                            Provider.of<ThemeManager>(context, listen: false);
                            manager.setTheme(value);
                          },
                          onOpenPro: _showUpgradeDialog,
                        );
                      },
                    ),
                    SettingsSettingTile(
                      icon: Icons.language_rounded,
                      title: l10n.settingsLanguage,
                      subtitle: l10n.settingsLanguageCurrent(
                        _languageLabel(_language),
                      ),
                      onTap: () {
                        showSettingsLanguageSheet(
                          context: context,
                          currentLanguage: _language,
                          onSelectLanguage: _setLanguage,
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    SettingsSectionHeader(title: l10n.settingsSectionCommunity),
                    const SizedBox(height: 10),
                    SettingsSettingTile(
                      icon: Icons.chat_rounded,
                      title: l10n.settingsDiscord,
                      subtitle: l10n.settingsDiscordSubtitle,
                      onTap: () async {
                        final uri = Uri.parse('https://discord.gg/VYubQJfcYM');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.settingsDiscordOpenFail)),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 18),
                    SettingsSectionHeader(title: l10n.settingsSectionPro),
                    const SizedBox(height: 10),
                    SettingsSettingTile(
                      icon: Icons.workspace_premium_rounded,
                      title: isPro ? 'Premium active' : 'Premium',
                      subtitle: isPro
                          ? 'Manage Premium options and restore purchases'
                          : 'Unlock Deep analysis mode and VPN features',
                      onTap: () {
                        if (isPro) {
                          showSettingsProOptionsSheet(
                            context: context,
                            onChanged: () {
                              if (!mounted) return;
                              setState(() {});
                            },
                          );
                        } else {
                          _showUpgradeDialog();
                        }
                      },
                    ),
                    const SizedBox(height: 18),
                    const SettingsSectionHeader(title: 'Realtime Protection'),
                    const SizedBox(height: 10),
                    SettingsSettingTile(
                      icon: Icons.notifications_active_rounded,
                      title: 'Auto-clear notifications',
                      subtitle: _rtpNotificationSettingLabel(
                        l10n,
                        _rtpNotificationAutoDismissSeconds,
                      ),
                      onTap: () {
                        showSettingsRtpNotificationSheet(
                          context: context,
                          currentSeconds: _rtpNotificationAutoDismissSeconds,
                          onSelect: _setRtpNotificationSetting,
                        );
                      },
                    ),
                    SettingsSectionHeader(title: l10n.settingsSectionShizuku),
                    const SizedBox(height: 10),
                    SettingsSettingTile(
                      icon: Icons.developer_mode_rounded,
                      title: l10n.settingsEnableShizuku,
                      subtitle: !shizukuBinderAlive
                          ? l10n.settingsShizukuNotRunning
                          : !shizukuPermissionGranted
                          ? l10n.settingsShizukuPermissionRequired
                          : l10n.settingsShizukuAvailable,
                      trailing: Transform.scale(
                        scale: 0.92,
                        child: IgnorePointer(
                          child: Switch(
                            value: shizukuWanted,
                            onChanged: (_) {},
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                      onTap: _handleShizukuTap,
                    ),
                    SettingsSettingTile(
                      icon: Icons.info_outline_rounded,
                      title: l10n.settingsAboutAdvancedProtection,
                      subtitle: l10n.settingsAboutAdvancedProtectionSubtitle,
                      onTap: _showShizukuInfo,
                    ),
                    SettingsSettingTile(
                      icon: Icons.tune_rounded,
                      title: 'Advanced scan modes',
                      subtitle: showScanModePicker
                          ? 'Disable to use the default scanning mode'
                          : 'Toggle to enable all scanning modes',
                      trailing: Transform.scale(
                        scale: 0.92,
                        child: IgnorePointer(
                          child: Switch(
                            value: showScanModePicker,
                            onChanged: (_) {},
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                      onTap: () => _setScanModePicker(!showScanModePicker),
                    ),
                    const SizedBox(height: 18),
                    const SizedBox(height: 18),
                    SettingsSectionHeader(title: l10n.settingsSectionGeneral),
                    const SizedBox(height: 10),
                    SettingsSettingTile(
                      icon: Icons.rule_folder_rounded,
                      title: l10n.settingsExclusions,
                      subtitle: l10n.settingsExclusionsSubtitle,
                      onTap: () {
                        showSettingsExclusionsSheet(
                          context: context,
                          onExcludeFolder: () async {
                            final result =
                            await FilePicker.platform.getDirectoryPath();
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
                          onExcludeFile: () async {
                            final r = await FilePicker.platform.pickFiles();
                            if (r != null && r.files.isNotEmpty) {
                              final path = r.files.single.path;
                              if (path == null) return;

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
                          onManage: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SizedBox(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SettingsSettingTile(
                      icon: Icons.security_rounded,
                      title: l10n.settingsPrivacyPolicy,
                      subtitle: l10n.settingsPrivacyPolicySubtitle,
                      onTap: () async {
                        final uri = Uri.parse(
                          'https://colourswift.com/Policies/Private-Policy',
                        );
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.settingsPrivacyPolicyOpenFail),
                            ),
                          );
                        }
                      },
                    ),
                    SettingsSettingTile(
                      icon: Icons.info_outline_rounded,
                      title: l10n.settingsAboutApp,
                      subtitle: 'v4.0.5',
                      onTap: _showAboutAvarionXPopup,
                    ),
                    if (kDebugMode)
                      SettingsSettingTile(
                        icon: Icons.bug_report_rounded,
                        title: l10n.settingsProReset,
                        subtitle: l10n.settingsProReset,
                        onTap: _resetProForDebug,
                      ),
                    if (kDebugMode)
                      SettingsSettingTile(
                        icon: Icons.verified_rounded,
                        title: 'Enable Pro (debug)',
                        subtitle: 'Local unlock for UI testing',
                        onTap: _enableProForDebug,
                      ),
                    if (kDebugMode)
                      SettingsSettingTile(
                        icon: Icons.restore_rounded,
                        title: 'Restore purchases',
                        subtitle: 'Re-check Play Billing',
                        onTap: _restorePurchasesNow,
                      ),
                    SettingsSettingTile(
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
              if (_signingOut)
                Positioned.fill(
                  child: _buildSigningOutLoader(theme),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountSettingsScreen extends StatelessWidget {
  final bool signedIn;
  final bool accountLoading;
  final String? accountEmail;
  final String? accountId;
  final bool isPro;
  final Future<void> Function() onSignIn;
  final Future<void> Function() onDashboard;
  final Future<void> Function() onSignOut;
  final Future<void> Function() onOpenPro;
  final Future<void> Function() onRestorePurchases;

  const _AccountSettingsScreen({
    required this.signedIn,
    required this.accountLoading,
    required this.accountEmail,
    required this.accountId,
    required this.isPro,
    required this.onSignIn,
    required this.onDashboard,
    required this.onSignOut,
    required this.onOpenPro,
    required this.onRestorePurchases,
  });

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(
          'Account',
          style: text.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: MeshBackground(
        blobs: themeManager.meshBlobs,
        base: scheme.surface,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SettingsSectionHeader(title: 'Status'),
                const SizedBox(height: 10),
                Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 8),
                  color: theme.cardTheme.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          accountLoading
                              ? 'Checking account...'
                              : signedIn
                              ? (accountEmail ?? 'Signed in')
                              : 'Not signed in',
                          style: text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          signedIn
                              ? (accountId == null ? 'AvarionX account connected' : 'Account ID: $accountId')
                              : 'Sign in to manage purchases and account features.',
                          style: text.bodySmall?.copyWith(
                            height: 1.32,
                            color: scheme.onSurface.withOpacity(0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const SettingsSectionHeader(title: 'Actions'),
                const SizedBox(height: 10),
                if (!signedIn)
                  SettingsSettingTile(
                    icon: Icons.login_rounded,
                    title: 'Sign in',
                    subtitle: 'Open the AvarionX account portal',
                    onTap: () async => onSignIn(),
                  )
                else ...[
                  SettingsSettingTile(
                    icon: Icons.dashboard_rounded,
                    title: 'Account dashboard',
                    subtitle: 'Open billing and account settings',
                    onTap: () async => onDashboard(),
                  ),
                  SettingsSettingTile(
                    icon: Icons.logout_rounded,
                    title: 'Sign out',
                    subtitle: 'Remove this account from the app',
                    onTap: () async {
                      await onSignOut();
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                ],
                SettingsSettingTile(
                  icon: Icons.workspace_premium_rounded,
                  title: isPro ? 'Premium active' : 'Premium',
                  subtitle: isPro
                      ? 'Premium features are available on this device'
                      : 'View optional Premium features',
                  onTap: () async => onOpenPro(),
                ),
                SettingsSettingTile(
                  icon: Icons.restore_rounded,
                  title: 'Restore purchases',
                  subtitle: 'Re-check Play Billing entitlement',
                  onTap: () async => onRestorePurchases(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
