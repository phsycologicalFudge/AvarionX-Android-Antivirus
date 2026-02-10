import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'boot_screen.dart';
import 'home_screen.dart';
import 'services/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeManager = ThemeManager();
  await themeManager.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeManager,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AvarionX Security',
      theme: themeManager.themeData,
      themeMode: themeManager.themeMode,
      home: const BootScreen(),
    );
  }
}
