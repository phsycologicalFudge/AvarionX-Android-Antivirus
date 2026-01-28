import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeManager extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _keyTheme = 'appTheme';

  late Box _box;
  String _themeName = 'white';
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
    _themeName = _box.get(_keyTheme, defaultValue: 'white') as String;
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

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color secondary,
    required Color surface,
    required Color container,
  }) {
    final cs = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: brightness == Brightness.dark ? Colors.black : Colors.white,
      secondary: secondary,
      onSecondary: brightness == Brightness.dark ? Colors.black : Colors.white,
      surface: surface,
      onSurface: brightness == Brightness.dark ? Colors.white : Colors.black,
      background: surface,
      onBackground: brightness == Brightness.dark ? Colors.white : Colors.black,
      error: Colors.redAccent,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: cs,
      scaffoldBackgroundColor: surface,
      canvasColor: surface,

      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      cardTheme: CardThemeData(
        color: container,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: container,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: container,
        modalBackgroundColor: container,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      pageTransitionsTheme: _pageTransitions(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData _buildBlackTheme() {
    return _buildTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF4EA3FF),
      secondary: const Color(0xFF3DD6C6),
      surface: const Color(0xFF121212),
      container: const Color(0xFF1C1C1C),
    );
  }

  static ThemeData _buildGreyTheme() {
    return _buildTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFFB0B5BB),
      secondary: const Color(0xFF8E9398),
      surface: const Color(0xFF1E1E1E),
      container: const Color(0xFF2A2A2A),
    );
  }

  static ThemeData _buildWhiteTheme() {
    return _buildTheme(
      brightness: Brightness.light,
      primary: const Color(0xFF3B82F6),
      secondary: const Color(0xFF2563EB),
      surface: const Color(0xFFF6F7F8),
      container: const Color(0xFFFFFFFF),
    );
  }

  static ThemeData _buildEmeraldTheme() {
    return _buildTheme(
      brightness: Brightness.light,
      primary: const Color(0xFF00A97A),
      secondary: const Color(0xFF00C18A),
      surface: const Color(0xFFF1F6F4),
      container: const Color(0xFFE6F0EC),
    );
  }

  static ThemeData _buildPurpleTheme() {
    return _buildTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF8B5CF6),
      secondary: const Color(0xFFA78BFA),
      surface: const Color(0xFF14101F),
      container: const Color(0xFF1F1A33),
    );
  }
}