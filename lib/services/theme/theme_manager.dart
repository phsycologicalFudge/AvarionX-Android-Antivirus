import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:colourswift_av/widgets/mesh_background.dart';

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

  List<MeshBlob> get meshBlobs => _meshBlobsFor(_themeName);

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
      case 'royal_blue':
        return _buildRoyalBlueTheme();
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
      scaffoldBackgroundColor: Colors.transparent,
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
      surface: const Color(0xFF101012),
      container: const Color(0xFF1A1A1D),
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
      surface: const Color(0xFFF4F7F5),
      container: const Color(0xFFFFFFFF),
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

  static ThemeData _buildRoyalBlueTheme() {
    return _buildTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF38588F),
      secondary: const Color(0xFF28436F),
      surface: const Color(0xFF0B1220),
      container: const Color(0xFF121D33),
    );
  }

  static List<MeshBlob> _meshBlobsFor(String name) {
    switch (name) {
      case 'white':
        return const [
          MeshBlob(x: 0.10, y: 0.08, color: Color(0xFFFFFFFF), radius: 0.42, opacity: 0.52),
          MeshBlob(x: 0.86, y: 0.05, color: Color(0xFFE4E8F0), radius: 0.48, opacity: 0.48),
          MeshBlob(x: 0.18, y: 0.82, color: Color(0xFFDDE5F2), radius: 0.40, opacity: 0.34),
          MeshBlob(x: 0.72, y: 0.62, color: Color(0xFFF8FAFC), radius: 0.36, opacity: 0.28),
        ];

      case 'emerald':
        return const [
          MeshBlob(x: 0.10, y: 0.08, color: Color(0xFFFFFFFF), radius: 0.42, opacity: 0.46),
          MeshBlob(x: 0.86, y: 0.05, color: Color(0xFFDDEBE6), radius: 0.48, opacity: 0.40),
          MeshBlob(x: 0.18, y: 0.82, color: Color(0xFFCFE2DA), radius: 0.40, opacity: 0.30),
          MeshBlob(x: 0.72, y: 0.62, color: Color(0xFFF6FAF8), radius: 0.36, opacity: 0.24),
        ];

      case 'grey':
        return const [
          MeshBlob(x: 0.12, y: 0.08, color: Color(0xFF363A40), radius: 0.42, opacity: 0.42),
          MeshBlob(x: 0.86, y: 0.10, color: Color(0xFF4A4F56), radius: 0.48, opacity: 0.36),
          MeshBlob(x: 0.18, y: 0.82, color: Color(0xFF2A2D33), radius: 0.40, opacity: 0.34),
          MeshBlob(x: 0.72, y: 0.62, color: Color(0xFF555B63), radius: 0.36, opacity: 0.22),
        ];

      case 'purple':
        return const [
          MeshBlob(x: 0.12, y: 0.08, color: Color(0xFF2D2540), radius: 0.42, opacity: 0.48),
          MeshBlob(x: 0.86, y: 0.10, color: Color(0xFF3B3155), radius: 0.48, opacity: 0.38),
          MeshBlob(x: 0.18, y: 0.82, color: Color(0xFF211B33), radius: 0.40, opacity: 0.36),
          MeshBlob(x: 0.72, y: 0.62, color: Color(0xFF4A3D6B), radius: 0.36, opacity: 0.24),
        ];

      case 'royal_blue':
        return const [
          MeshBlob(x: 0.12, y: 0.08, color: Color(0xFF162743), radius: 0.42, opacity: 0.48),
          MeshBlob(x: 0.86, y: 0.10, color: Color(0xFF203A63), radius: 0.48, opacity: 0.38),
          MeshBlob(x: 0.18, y: 0.82, color: Color(0xFF0F1A2D), radius: 0.40, opacity: 0.36),
          MeshBlob(x: 0.72, y: 0.62, color: Color(0xFF294B7E), radius: 0.36, opacity: 0.24),
        ];

      default:
        return const [
          MeshBlob(x: 0.10, y: 0.08, color: Color(0xFF28282C), radius: 0.16, opacity: 0.42),
          MeshBlob(x: 0.36, y: 0.16, color: Color(0xFF242428), radius: 0.14, opacity: 0.34),
          MeshBlob(x: 0.78, y: 0.10, color: Color(0xFF2C2C31), radius: 0.18, opacity: 0.38),
          MeshBlob(x: 0.16, y: 0.42, color: Color(0xFF202024), radius: 0.13, opacity: 0.32),
          MeshBlob(x: 0.82, y: 0.44, color: Color(0xFF303035), radius: 0.15, opacity: 0.30),
          MeshBlob(x: 0.30, y: 0.72, color: Color(0xFF26262A), radius: 0.17, opacity: 0.36),
          MeshBlob(x: 0.70, y: 0.78, color: Color(0xFF34343A), radius: 0.14, opacity: 0.28),
        ];
    }
  }
}