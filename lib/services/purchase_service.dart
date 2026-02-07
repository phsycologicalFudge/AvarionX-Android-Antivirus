import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static const String _proId = 'cs_security_pro';

  static const String _kIsPro = 'billing_is_pro';
  static const String _kToken = 'billing_server_verification_data';

  static bool _available = false;
  static bool _isPro = false;
  static String _lastServerVerificationData = '';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isPro = prefs.getBool(_kIsPro) ?? false;
    _lastServerVerificationData = prefs.getString(_kToken) ?? '';

    _available = await _iap.isAvailable();
    if (!_available) return;

    _iap.purchaseStream.listen(_handlePurchaseUpdates, onError: (_) {});
    await restore();
  }

  static Future<bool> hasPro() async => _isPro;
  static String get lastServerVerificationData => _lastServerVerificationData;

  static Future<void> buyPro() async {
    if (!_available) throw 'Play Billing unavailable';
    final details = await _iap.queryProductDetails({_proId});
    if (details.notFoundIDs.isNotEmpty) throw 'Product not found on Play Console';
    final product = details.productDetails.first;
    final param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  static Future<bool> restore() async {
    if (!_available) return false;
    await _iap.restorePurchases();
    await Future.delayed(const Duration(seconds: 3));
    return _isPro;
  }

  static void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    final prefs = await SharedPreferences.getInstance();

    for (final p in purchases) {
      if (p.productID == _proId &&
          (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored)) {
        final tok = p.verificationData.serverVerificationData;
        if (tok.isNotEmpty) {
          _isPro = true;
          _lastServerVerificationData = tok;
          await prefs.setBool(_kIsPro, true);
          await prefs.setString(_kToken, tok);
        }
      }

      if (p.pendingCompletePurchase) {
        _iap.completePurchase(p);
      }
    }
  }
}
