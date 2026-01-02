import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeManager extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _keyTheme = 'appTheme';

  late Box _box;
  String _themeName = 'black';
  ThemeData _themeData = _buildBlackTheme();

  String get themeName => _themeName;
  ThemeData get themeData => _themeData;

  ThemeMode get themeMode {
    switch (_themeName) {
      case 'white':
      case 'emerald':
        return ThemeMode.light;
      default:
        return ThemeMode.dark;
    }
  }

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
    _themeName = _box.get(_keyTheme, defaultValue: 'black') as String;
    _themeData = _resolveTheme(_themeName);
  }

  static ThemeData _resolveTheme(String name) {
    switch (name) {
      case 'white':
        return _buildWhiteTheme();
      case 'grey':
        return _buildGreyTheme();
      case 'emerald':
        return _buildEmeraldTheme();
      case 'purple':
        return _buildPurpleTheme();
      default:
        return _buildBlackTheme();
    }
  }

  Future<void> setTheme(String name) async {
    _themeName = name;
    _themeData = _resolveTheme(name);
    await _box.put(_keyTheme, name);
    notifyListeners();
  }

  static PageTransitionsTheme _pageTransitions() {
    return const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    );
  }

  static ThemeData _buildBlackTheme() {
    const surface = Color(0xFF121212);
    const card = Color(0xFF1C1C1C);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surface,
      cardColor: card,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF4EA3FF),
        secondary: Color(0xFF3DD6C6),
        surface: card,
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.white.withOpacity(0.88),
        displayColor: Colors.white.withOpacity(0.88),
      ),
      pageTransitionsTheme: _pageTransitions(),
      useMaterial3: true,
    );
  }

  static ThemeData _buildGreyTheme() {
    const surface = Color(0xFF232323);
    const card = Color(0xFF2F2F2F);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surface,
      cardColor: card,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF9FA4AA),
        secondary: Color(0xFFB0B5BB),
        surface: card,
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.white70,
        displayColor: Colors.white70,
      ),
      pageTransitionsTheme: _pageTransitions(),
      useMaterial3: true,
    );
  }

  static ThemeData _buildWhiteTheme() {
    const surface = Color(0xFFF6F7F8);
    const card = Color(0xFFFFFFFF);

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: surface,
      cardColor: card,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF3B82F6),
        secondary: Color(0xFF3B82F6),
        surface: card,
        onSurface: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
      pageTransitionsTheme: _pageTransitions(),
      useMaterial3: true,
    );
  }

  static ThemeData _buildEmeraldTheme() {
    const surface = Color(0xFFF1F6F4);
    const card = Color(0xFFE6F0EC);

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: surface,
      cardColor: card,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF00A97A),
        secondary: Color(0xFF00B989),
        surface: card,
        onSurface: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
      pageTransitionsTheme: _pageTransitions(),
      useMaterial3: true,
    );
  }

  static ThemeData _buildPurpleTheme() {
    const surface = Color(0xFF120F1A);
    const card = Color(0xFF1A1626);

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surface,
      cardColor: card,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF8B5CF6),
        secondary: Color(0xFFA78BFA),
        surface: card,
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.white.withOpacity(0.88),
        displayColor: Colors.white.withOpacity(0.88),
      ),
      pageTransitionsTheme: _pageTransitions(),
      useMaterial3: true,
    );
  }
}
