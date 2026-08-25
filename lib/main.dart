import 'package:colourswift_av/services/defs_update_scheduler.dart';
import 'package:colourswift_av/utils/route_observer.dart';
import 'package:colourswift_av/widgets/antivirus_bridge.dart';
import 'package:colourswift_av/widgets/mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/build_flags.dart';
import 'services/theme/theme_manager.dart';
import 'screens/boot_screen.dart';
import 'screens/quarantine/quarantine_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:colourswift_av/services/purchase_service.dart';
import 'constants/launch_flag.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'translations/app_localizations.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'services/realtime_protection_service.dart';
import 'terminal/terminal_screen.dart' show terminalRouteObserver;

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

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

const String _kMaxConcurrentKey = 'scan_limits_max_concurrent';
const String _kMaxThreadsKey = 'scan_limits_max_threads';

int _clampInt(int v, int min, int max) {
  if (v < min) return min;
  if (v > max) return max;
  return v;
}

Future<void> applyScanLimitsFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final mc = _clampInt(prefs.getInt(_kMaxConcurrentKey) ?? 1, 1, 4);
  final mt = _clampInt(prefs.getInt(_kMaxThreadsKey) ?? 0, 0, 16);
  try {
    AntivirusBridge().setScanLimits(mc, mt);
  } catch (_) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  const routingChannel = MethodChannel('colourswift/routing');
  routingChannel.setMethodCallHandler((call) async {
    if (call.method == 'pushQuarantine') {
      appNavigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const QuarantineScreen()),
      );
    }
  });

  final themeManager = ThemeManager();
  await themeManager.init();

  final languageManager = LanguageManager();
  await languageManager.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeManager),
        ChangeNotifierProvider(create: (_) => languageManager),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _ensureNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final languageManager = Provider.of<LanguageManager>(context);

    return MaterialApp(
      navigatorKey: appNavigatorKey,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [loggingRouteObserver, terminalRouteObserver],
      title: 'Avarionx Security',
      theme: themeManager.themeData,
      themeMode: themeManager.themeMode,
      locale: languageManager.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (deviceLocale == null) return supportedLocales.first;

        for (final locale in supportedLocales) {
          if (locale.languageCode == deviceLocale.languageCode) {
            return locale;
          }
        }

        return supportedLocales.first;
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        final tm = Provider.of<ThemeManager>(context);
        return MeshBackground(
          blobs: tm.meshBlobs,
          base: tm.themeData.colorScheme.surface,
          child: child!,
        );
      },
      home: const BootScreen(),
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

@pragma('vm:entry-point')
Future<void> rtpBackgroundMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final enabled = prefs.getBool('protectionEnabled') ?? false;

  if (!enabled) return;

  await RealtimeProtectionService.start();

  final keepAlive = Completer<void>();
  await keepAlive.future;
}