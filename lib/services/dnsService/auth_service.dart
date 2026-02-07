import 'package:shared_preferences/shared_preferences.dart';
import '../pro_temp_service.dart';
import '../purchase_service.dart';

class ProEntitlementService {
  static const _prefsProKey = 'entitlement_is_pro';
  static const _prefsLastCheckKey = 'entitlement_last_check';

  static const _cacheDuration = Duration(minutes: 5);

  static Future<bool> isPro() async {
    final prefs = await SharedPreferences.getInstance();

    final cached = prefs.getBool(_prefsProKey);
    final lastCheck = prefs.getInt(_prefsLastCheckKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    if (cached != null && (now - lastCheck) < _cacheDuration.inMilliseconds) {
      return cached;
    }

    final fresh = await _checkEntitlement();

    await prefs.setBool(_prefsProKey, fresh);
    await prefs.setInt(_prefsLastCheckKey, now);

    return fresh;
  }

  static Future<bool> _checkEntitlement() async {
    final gate = await ProGate.sync();
    if (gate) return true;

    final prefs = await SharedPreferences.getInstance();
    final until = prefs.getInt('pro_trial_until');
    final trialActive = until != null && until > DateTime.now().millisecondsSinceEpoch;
    if (trialActive) return true;

    return PurchaseService.lastServerVerificationData.isNotEmpty;
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsProKey);
    await prefs.remove(_prefsLastCheckKey);
  }
}
