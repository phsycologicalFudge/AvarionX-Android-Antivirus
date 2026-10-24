import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:app_links/app_links.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../purchase_service.dart';

class AuthLinkService {
  static const String kAuthToken = 'cs_auth_token';
  static const String _apiBase = 'https://api.colourswift.com';
  static const String _appLinkHost = 'account.colourswift.com';
  static const String _appLinkPath = '/app/auth/av';
  static const String _scheme = 'colourswift-av';
  static const String _kVerifier = 'cs_auth_pkce_verifier';
  static const String _kStartedAt = 'cs_auth_pkce_started_at';
  static const Duration _pendingTtl = Duration(minutes: 10);

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

  static Future<void> startLogin() async {
    final rnd = Random.secure();
    final verifier = _b64url(List<int>.generate(32, (_) => rnd.nextInt(256)));
    final challenge = _b64url(sha256.convert(ascii.encode(verifier)).bytes);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kVerifier, verifier);
    await prefs.setInt(_kStartedAt, DateTime.now().millisecondsSinceEpoch);

    final uri = Uri.parse('$_apiBase/login').replace(queryParameters: {
      'app': 'av',
      'flow': 'v2',
      'applink': '1',
      'code_challenge': challenge,
    });
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> _handle(Uri? uri) async {
    if (uri == null) return;
    final isAppLink = uri.scheme == 'https' && uri.host == _appLinkHost && uri.path == _appLinkPath;
    final isScheme = uri.scheme == _scheme && uri.host == 'auth';
    if (!isAppLink && !isScheme) return;

    final code = (uri.queryParameters['code'] ?? '').trim();
    if (code.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final verifier = prefs.getString(_kVerifier) ?? '';
    final startedAt = prefs.getInt(_kStartedAt) ?? 0;
    await prefs.remove(_kVerifier);
    await prefs.remove(_kStartedAt);

    if (verifier.isEmpty) return;
    final age = DateTime.now().millisecondsSinceEpoch - startedAt;
    if (age < 0 || age > _pendingTtl.inMilliseconds) return;

    final token = await _exchange(code, verifier);
    if (token == null) return;

    await prefs.setString(kAuthToken, token);
    unawaited(PurchaseService.syncCachedPurchaseToServer());
    if (!_controller.isClosed) _controller.add(token);
  }

  static Future<String?> _exchange(String code, String verifier) async {
    try {
      final res = await http
          .post(
        Uri.parse('$_apiBase/auth/exchange'),
        headers: {'content-type': 'application/json; charset=utf-8'},
        body: jsonEncode({'code': code, 'codeVerifier': verifier}),
      )
          .timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) return null;
      final token = ((jsonDecode(res.body) as Map)['token'] ?? '').toString().trim();
      return token.isEmpty ? null : token;
    } catch (_) {
      return null;
    }
  }

  static String _b64url(List<int> bytes) =>
      base64Url.encode(bytes).replaceAll('=', '');
}
