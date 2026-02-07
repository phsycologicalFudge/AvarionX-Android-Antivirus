import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProState extends ChangeNotifier {
  bool _isPro = false;
  bool get isPro => _isPro;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isPro = prefs.getBool('isPro') ?? false;
    notifyListeners();
  }

  Future<void> setPro(bool value) async {
    if (_isPro == value) return;
    _isPro = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPro', value);
    notifyListeners();
  }

  Future<void> refresh() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getBool('isPro') ?? false;
    if (_isPro == v) return;
    _isPro = v;
    notifyListeners();
  }
}
