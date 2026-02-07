import 'package:shared_preferences/shared_preferences.dart';
import 'purchase_service.dart';

class ProGate {
  static const String trialUntilKey = 'pro_trial_until';
  static const String localUnlockKey = 'pro_local_unlocked';
  static const String debugIgnorePaidKey = 'pro_debug_ignore_paid';

  static Future<bool> sync() async {
    final sp = await SharedPreferences.getInstance();

    final ignorePaid = sp.getBool(debugIgnorePaidKey) ?? false;

    bool paid = false;
    if (!ignorePaid) {
      try {
        paid = await PurchaseService.hasPro();
      } catch (_) {
        paid = false;
      }
    }

    final until = sp.getInt(trialUntilKey);
    final now = DateTime.now().millisecondsSinceEpoch;
    final trialActive = until != null && until > now;

    final local = sp.getBool(localUnlockKey) ?? false;

    final effective = paid || trialActive || local;

    await sp.setBool('isPro', effective);

    if (!trialActive && until != null) {
      await sp.remove(trialUntilKey);
    }

    return effective;
  }

  static Future<void> setTrial(Duration duration) async {
    final sp = await SharedPreferences.getInstance();
    final until = DateTime.now().add(duration).millisecondsSinceEpoch;
    await sp.setInt(trialUntilKey, until);
    await sp.setBool('isPro', true);
  }

  static Future<void> clearTrial() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(trialUntilKey);
    await sync();
  }

  static Future<int?> trialUntilMs() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(trialUntilKey);
  }

  static Future<void> setLocalUnlocked(bool value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(localUnlockKey, value);
    await sync();
  }

  static Future<void> clearLocalUnlock() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(localUnlockKey);
    await sync();
  }

  static Future<void> setDebugIgnorePaid(bool value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(debugIgnorePaidKey, value);
  }
}
