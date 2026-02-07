import 'package:colourswift_av/services/defs_update_scheduler.dart';
import 'package:colourswift_av/widgets/antivirus_bridge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/build_flags.dart';
import 'services/theme_manager.dart';
import 'screens/boot_screen.dart';
import 'screens/quarantine/quarantine_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:colourswift_av/services/purchase_service.dart';
import 'constants/launch_flag.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'translations/app_localizations.dart';

class LanguageManager extends ChangeNotifier {
  String _code = 'system';

  String get code => _code;

  Locale? get locale {
    if (_code == 'system') return null;
    return Locale(_code);
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _code = prefs.getString('app_language') ?? 'system';
  }

  Future<void> setLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', code);
    _code = code;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DefsUpdateScheduler.init();
  if (kEnableAds) {
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: ['8ED98C0895705131B2697FBAC479C616'],
      ),
    );
    await MobileAds.instance.initialize();
  }

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  final themeManager = ThemeManager();
  await themeManager.init();

  final languageManager = LanguageManager();
  await languageManager.init();

  await PurchaseService.init();

  final info = await PackageInfo.fromPlatform();
  final currentVersion = '${info.version}+${info.buildNumber}';

  final prefs = await SharedPreferences.getInstance();
  final lastSeen = prefs.getString('last_seen_app_version');

  bool showUpdateLog = false;

  if (lastSeen == null) {
    await prefs.setString('last_seen_app_version', currentVersion);
  } else if (lastSeen != currentVersion) {
    showUpdateLog = true;
    await prefs.setString('last_seen_app_version', currentVersion);
  }

  const channel = MethodChannel('colourswift/foreground_service');
  bool openQuarantine = false;
  try {
    final result = await channel.invokeMethod<Map>('getLaunchExtras');
    openQuarantine = result?['open_quarantine'] == true;
  } catch (_) {}

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeManager),
        ChangeNotifierProvider(create: (_) => languageManager),
        Provider(
          create: (_) => LaunchFlags(
            showUpdateLog: showUpdateLog,
            currentVersion: currentVersion,
          ),
        ),
      ],
      child: MyApp(openQuarantine: openQuarantine),
    ),
  );
}

Future<void> _ensureNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

class MyApp extends StatelessWidget {
  final bool openQuarantine;
  const MyApp({super.key, required this.openQuarantine});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final languageManager = Provider.of<LanguageManager>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AvarionX Security',
      theme: themeManager.themeData,
      themeMode: themeManager.themeMode,
      locale: languageManager.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: openQuarantine ? const QuarantineScreen() : const BootScreen(),
    );
  }
}

@pragma('vm:entry-point')
void vpnMain() {
  WidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('cs_vpn_channel');
  channel.setMethodCallHandler((call) async {
    if (call.method == 'checkConnection') {
      final ip = call.arguments['ip'] as String? ?? "";
      final sni = call.arguments['sni'] as String? ?? "";
      final port = call.arguments['port'] as int? ?? 0;

      final bridge = AntivirusBridge();
      return bridge.checkNetwork(ip, sni, port);
    }
    return 0;
  });
}
