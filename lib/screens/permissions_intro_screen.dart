import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/theme/theme_manager.dart';
import '../widgets/mesh_background.dart';
import 'main_shell.dart';

import '../translations/app_localizations.dart';
class PermissionsIntroScreen extends StatefulWidget {
  const PermissionsIntroScreen({super.key});

  @override
  State<PermissionsIntroScreen> createState() => _PermissionsIntroScreenState();
}

class _PermissionsIntroScreenState extends State<PermissionsIntroScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  bool storageGranted = false;
  bool notifGranted = false;
  bool vpnGranted = false;

  Future<void> _requestStorage() async {
    bool granted = false;

    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      final sdk = info.version.sdkInt;

      if (sdk >= 30) {
        try {
          var status = await Permission.manageExternalStorage.status;
          if (!status.isGranted) {
            const platform = MethodChannel('colourswift/storage_permission');
            await platform.invokeMethod('openManageStorage');
            await Future.delayed(const Duration(seconds: 2));
            status = await Permission.manageExternalStorage.status;
          }
          granted = status.isGranted;
        } catch (_) {
          await openAppSettings();
        }
      } else {
        final status = await Permission.storage.status;
        granted = status.isGranted || await Permission.storage.request().isGranted;
      }
    } else {
      granted = true;
    }

    if (!mounted) return;

    setState(() => storageGranted = granted);

    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(AppLocalizations.of(context)!.onboardingStorageSnack)),
      );
    }
  }

  Future<void> _requestNotifications() async {
    try {
      final status = await Permission.notification.request();
      if (!mounted) return;
      setState(() => notifGranted = status.isGranted);
    } catch (_) {}
  }

  Future<bool> _requestVpnPermission() async {
    try {
      const chan = MethodChannel("cs_vpn_permission");
      final ok = await chan.invokeMethod<bool>("prepareVpn");
      return ok == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done_v2', true);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  void _next() {
    if (_page >= 3) return;
    _controller.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  void _back() {
    if (_page <= 0) return;
    _controller.previousPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: MeshBackground(
        blobs: themeManager.meshBlobs,
        base: scheme.surface,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.onboardingAppName,
                        style: text.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: scheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: List.generate(3, (i) {
                    final active = i == _page;
                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: EdgeInsets.only(right: i == 3 ? 0 : 8),
                        height: 4,
                        decoration: BoxDecoration(
                          color: active ? scheme.primary : scheme.outlineVariant.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _page = i),
                  children: [
                    _slide(
                      context,
                      icon: Icons.folder_rounded,
                      title: AppLocalizations.of(context)!.onboardingStorageTitle,
                      desc: AppLocalizations.of(context)!.onboardingStorageDesc,
                      granted: storageGranted,
                      primaryLabel: storageGranted ? AppLocalizations.of(context)!.onboardingGranted : AppLocalizations.of(context)!.onboardingGrantAccess,
                      onPrimary: storageGranted ? null : _requestStorage,
                      footnote: AppLocalizations.of(context)!.onboardingStorageFootnote,
                    ),
                    _slide(
                      context,
                      icon: Icons.notifications_active_rounded,
                      title: AppLocalizations.of(context)!.onboardingNotificationsTitle,
                      desc: AppLocalizations.of(context)!.onboardingNotificationsDesc,
                      granted: notifGranted,
                      primaryLabel: notifGranted ? AppLocalizations.of(context)!.onboardingGranted : AppLocalizations.of(context)!.onboardingAllowNotifications,
                      onPrimary: notifGranted ? null : _requestNotifications,
                      footnote: AppLocalizations.of(context)!.onboardingNotificationsFootnote,
                    ),
                    _finishSlide(context),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                child: Row(
                  children: [
                    if (_page > 0)
                      TextButton(
                        onPressed: _back,
                        style: TextButton.styleFrom(
                          foregroundColor: scheme.onSurface.withOpacity(0.8),
                          backgroundColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                        ),
                        child:  Text(AppLocalizations.of(context)!.onboardingBack),
                      )
                    else
                      const SizedBox(width: 72),
                    const Spacer(),
                    if (_page < 2)
                      FilledButton(
                        onPressed: _next,
                        style: FilledButton.styleFrom(
                          elevation: 0,
                          backgroundColor: scheme.primary,
                          foregroundColor: scheme.onPrimary,
                          surfaceTintColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child:  Text(AppLocalizations.of(context)!.onboardingNext),
                      )
                    else
                      FilledButton(
                        onPressed: _completeOnboarding,
                        style: FilledButton.styleFrom(
                          elevation: 0,
                          backgroundColor: scheme.primary,
                          foregroundColor: scheme.onPrimary,
                          surfaceTintColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child:  Text(AppLocalizations.of(context)!.onboardingFinish),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _finishSlide(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 64,
            color: scheme.tertiary,
          ),
          const SizedBox(height: 18),
          Text(
            AppLocalizations.of(context)!.onboardingSetupCompleteTitle,
            style: text.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: scheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.permissionsIntroSetupIsNowCompleteTimeToSecure,
            style: text.bodyMedium?.copyWith(
              color: scheme.onSurface.withOpacity(0.78),
              height: 1.35,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _completeOnboarding,
              style: FilledButton.styleFrom(
                elevation: 0,
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                surfaceTintColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child:  Text(AppLocalizations.of(context)!.onboardingGoHome),
            ),
          ),
        ],
      ),
    );
  }

  Widget _slide(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String desc,
        required bool granted,
        required String primaryLabel,
        required VoidCallback? onPrimary,
        required String footnote,
      }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    final iconColor = granted ? scheme.tertiary : scheme.primary;
    final badgeText = granted ? AppLocalizations.of(context)!.onboardingGranted : AppLocalizations.of(context)!.onboardingNotGranted;
    final badgeColor = granted ? scheme.tertiary : scheme.outline;

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 68, color: iconColor),
          const SizedBox(height: 16),
          Text(
            title,
            style: text.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: scheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            style: text.bodyMedium?.copyWith(
              color: scheme.onSurface.withOpacity(0.78),
              height: 1.35,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              badgeText,
              style: text.labelMedium?.copyWith(
                color: badgeColor,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onPrimary,
              style: FilledButton.styleFrom(
                elevation: 0,
                backgroundColor: granted ? scheme.tertiary : scheme.primary,
                foregroundColor: granted ? scheme.onTertiary : scheme.onPrimary,
                surfaceTintColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(primaryLabel),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            footnote,
            style: text.bodySmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.62),
              height: 1.25,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}