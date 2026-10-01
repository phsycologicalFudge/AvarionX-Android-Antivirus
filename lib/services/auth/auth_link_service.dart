import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../purchase_service.dart';

class AuthLinkService {
  static const String kAuthToken = 'cs_auth_token';
  static const String _prefix = 'colourswift-av://auth';

  static final StreamController<String> _controller =
  StreamController<String>.broadcast();

  static Future<void>? _starting;
  static StreamSubscription<Uri>? _sub;

  static Stream<String> get tokenEvents => _controller.stream;

  static Future<void> start() {
    return _starting ??= _start();
  }

  static Future<void> _start() async {
    final links = AppLinks();

    try {
      await _handle(await links.getInitialLink());
    } catch (_) {}

    await _sub?.cancel();
    _sub = links.uriLinkStream.listen(
          (uri) => unawaited(_handle(uri)),
      onError: (Object e) {},
    );
  }

  static Future<void> _handle(Uri? uri) async {
    if (uri == null) return;
    if (!uri.toString().startsWith(_prefix)) return;

    final token = (uri.queryParameters['token'] ?? '').trim();
    if (token.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kAuthToken, token);
    unawaited(PurchaseService.syncCachedPurchaseToServer());
    if (!_controller.isClosed) _controller.add(token);
  }
}