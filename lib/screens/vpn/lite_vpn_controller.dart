import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:colourswift_av/services/purchase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LiteVpnNotice {
  none,
  notificationsRequired,
  connectFailed,
  sessionExpired,
}

class LiteVpnServer {
  final String id;
  final String label;
  final String countryCode;
  final String? city;

  const LiteVpnServer({
    required this.id,
    required this.label,
    required this.countryCode,
    this.city,
  });

  factory LiteVpnServer.fromJson(Map<String, dynamic> json) {
    return LiteVpnServer(
      id: ((json["id"] as String?) ?? "").trim().toLowerCase(),
      label: (json["label"] as String?) ?? "",
      countryCode: ((json["countryCode"] as String?) ?? "").toUpperCase(),
      city: json["city"] as String?,
    );
  }

  bool get isWireGuard {
    final first = id.split("-").firstWhere((e) => e.isNotEmpty, orElse: () => "");
    return id.isNotEmpty && first != "awg" && first != "hy";
  }
}

class LiteVpnController extends ChangeNotifier {
  static const String apiBase = "https://api.colourswift.com";
  static const String kAuthToken = "cs_auth_token";
  static const String kSelectedServerId = "cs_vpn_selected_region";
  static const String kLocationsJson = "cs_vpn_locations_json";
  static const String kLocationsVersion = "cs_vpn_locations_version";
  static const String kAnonymousDeviceKeyFallback = "cs_anonymous_device_key_fallback";
  static const String _anonKeyPath =
      "/storage/emulated/0/Documents/avarionx/deviceKey/devicekey.txt";

  static const MethodChannel _managedChannel = MethodChannel("cs_fullvpn");
  static final Stream<dynamic> statusEvents =
      const EventChannel("cs_vpn_status").receiveBroadcastStream();

  static Future<bool> isTunnelConnected() async {
    try {
      final raw = await _managedChannel.invokeMethod("runtimeSnapshot");
      if (raw is Map) return "${raw["state"]}".toLowerCase() == "connected";
    } catch (_) {}
    return false;
  }

  StreamSubscription? _runtimeSub;
  Timer? _locationsTimer;
  bool _disposed = false;

  String _token = "";
  bool _cachedPro = false;

  List<LiteVpnServer> _servers = [];
  String _locationsVersion = "";
  String _selectedServerId = "de";

  bool _connected = false;
  bool _connecting = false;
  bool _reconnecting = false;
  bool _paused = false;
  bool _wantsConnected = false;
  String _detail = "";
  String _expectedIp = "";
  int _rxBytes = 0;
  int _txBytes = 0;
  int _latencyMs = 0;

  Map<String, dynamic>? _exitLocation;
  bool _locationFetching = false;
  DateTime? _lastFetchAt;

  LiteVpnNotice _notice = LiteVpnNotice.none;

  String get token => _token;
  bool get signedIn => _token.isNotEmpty;
  bool get connected => _connected;
  bool get connecting => _connecting;
  bool get reconnecting => _reconnecting;
  bool get paused => _paused;
  bool get wantsConnected => _wantsConnected;
  String get detail => _detail;
  int get rxBytes => _rxBytes;
  int get txBytes => _txBytes;
  int get latencyMs => _latencyMs;
  bool get locationFetching => _locationFetching;
  LiteVpnNotice get notice => _notice;
  String get selectedServerId => _selectedServerId;

  bool get hasPremiumAccess {
    return _cachedPro || PurchaseService.isPro;
  }

  List<LiteVpnServer> get servers {
    return _servers.where((s) => s.isWireGuard).toList(growable: false);
  }

  int get lockedServerCount {
    return _servers.where((s) => !s.isWireGuard).length;
  }

  LiteVpnServer? get selectedServer {
    final list = servers;
    for (final s in list) {
      if (s.id == _selectedServerId) return s;
    }
    return null;
  }

  String get exitIp => (_exitLocation?["ip"] ?? "").toString();
  String get exitCountry {
    final raw = (_exitLocation?["country"] ?? "").toString().trim();
    if (raw.isEmpty) return "";
    final city = (_exitLocation?["city"] ?? "").toString().trim().toLowerCase();
    final code = raw.length == 2 ? raw.toUpperCase() : "";

    LiteVpnServer? match;
    for (final s in servers) {
      final sameCountry = code.isNotEmpty
          ? s.countryCode == code
          : s.label.toLowerCase() == raw.toLowerCase();
      if (!sameCountry) continue;
      match ??= s;
      if (city.isNotEmpty && (s.city ?? "").trim().toLowerCase() == city) {
        match = s;
        break;
      }
    }

    if (match != null) {
      final c = (match.city ?? "").trim();
      if (c.isNotEmpty) return c;
      if (match.label.isNotEmpty) return match.label;
    }
    return _countryNames[code] ?? raw;
  }

  static const Map<String, String> _countryNames = {
    "US": "United States",
    "GB": "United Kingdom",
    "JP": "Japan",
    "DE": "Germany",
    "SG": "Singapore",
    "FI": "Finland",
    "FR": "France",
    "CA": "Canada",
    "PL": "Poland",
    "NL": "Netherlands",
    "AU": "Australia",
    "ES": "Spain",
  };
  String get exitCity => (_exitLocation?["city"] ?? "").toString();

  Future<void> init() async {
    await _loadCachedLocations();
    await _loadSelectedServer();
    await _loadToken();
    _cachedPro = await PurchaseService.cachedHasPro();

    await _startRuntimeBridge();
    await _refreshRuntimeOnce();
    unawaited(fetchLocations());
    _locationsTimer?.cancel();
    _locationsTimer = Timer.periodic(const Duration(hours: 1), (_) => fetchLocations());

    if (_token.isNotEmpty) {
      await refreshMe();
    } else {
      await PurchaseService.clearServerAccountEntitlement();
      _cachedPro = await PurchaseService.cachedHasPro();
    }
    notifyListeners();
  }

  Future<void> onResumed() async {
    await _refreshRuntimeOnce();
    await _loadToken();
    _cachedPro = await PurchaseService.cachedHasPro();
    if (_token.isNotEmpty) {
      await refreshMe();
    }
    unawaited(fetchLocations());
    notifyListeners();
  }

  Future<void> onTokenChanged() async {
    await _loadToken();
    _notice = LiteVpnNotice.none;
    if (_token.isNotEmpty) {
      await refreshMe();
    }
    _cachedPro = await PurchaseService.cachedHasPro();
    notifyListeners();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = (prefs.getString(kAuthToken) ?? "").trim();
  }

  Future<void> _loadSelectedServer() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = (prefs.getString(kSelectedServerId) ?? "").trim().toLowerCase();
    _selectedServerId = saved.isEmpty ? "de" : saved;
  }

  Future<void> _persistSelection() async {
    if (selectedServer == null && servers.isNotEmpty) {
      _selectedServerId = servers.first.id;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kSelectedServerId, _selectedServerId);
  }

  Future<void> refreshMe() async {
    if (_token.isEmpty) return;
    try {
      final res = await http.get(
        Uri.parse("$apiBase/me"),
        headers: {"authorization": "Bearer $_token"},
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final j = jsonDecode(res.body) as Map<String, dynamic>;
        final me = (j["user"] as Map?)?.cast<String, dynamic>();
        final rawExpiry = me?["planExpiresAt"];
        final planExpiresAt = rawExpiry is num
            ? rawExpiry.toInt()
            : int.tryParse((rawExpiry ?? "").toString());

        await PurchaseService.applyServerAccountEntitlement(
          signedIn: me != null,
          plan: (me?["plan"] ?? "").toString(),
          planExpiresAt: planExpiresAt,
        );
        _cachedPro = await PurchaseService.cachedHasPro();
        notifyListeners();
        return;
      }

      if (res.statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(kAuthToken);
        _token = "";
        await PurchaseService.clearServerAccountEntitlement();
        _cachedPro = await PurchaseService.cachedHasPro();
        _notice = LiteVpnNotice.sessionExpired;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> fetchLocations() async {
    if (_disposed) return;
    try {
      final res = await http
          .get(Uri.parse("$apiBase/vpn/locations"))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) return;

      final j = jsonDecode(res.body) as Map<String, dynamic>;
      final version = (j["version"] ?? "").toString();
      final list = j["locations"];
      if (list is! List) return;
      if (version.isNotEmpty && version == _locationsVersion && _servers.isNotEmpty) return;

      final parsed = _parseServers(list);
      if (parsed.isEmpty) return;

      _servers = parsed;
      _locationsVersion = version;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kLocationsVersion, version);
      await prefs.setString(kLocationsJson, jsonEncode(list));
      notifyListeners();
    } catch (_) {}
  }

  List<LiteVpnServer> _parseServers(List list) {
    final out = <LiteVpnServer>[];
    for (final item in list) {
      if (item is! Map) continue;
      final s = LiteVpnServer.fromJson(item.cast<String, dynamic>());
      if (s.id.isEmpty) continue;
      out.add(s);
    }
    return out;
  }

  Future<void> _loadCachedLocations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(kLocationsJson);
      if (cached == null || cached.isEmpty) return;
      final list = jsonDecode(cached);
      if (list is! List) return;
      final parsed = _parseServers(list);
      if (parsed.isEmpty) return;
      _servers = parsed;
      _locationsVersion = prefs.getString(kLocationsVersion) ?? "";
    } catch (_) {}
  }

  Future<void> _startRuntimeBridge() async {
    await _runtimeSub?.cancel();
    try {
      _runtimeSub = statusEvents.listen(
        (event) {
          if (event is Map) _applyRuntime(event);
        },
        onError: (Object e) {},
        cancelOnError: false,
      );
    } catch (_) {}
  }

  Future<void> _refreshRuntimeOnce() async {
    try {
      final raw = await _managedChannel.invokeMethod("runtimeSnapshot");
      if (raw is Map) _applyRuntime(raw);
    } catch (_) {}
  }

  int _asInt(Object? v) {
    if (v is num) return v.toInt();
    return int.tryParse("${v ?? ""}") ?? 0;
  }

  void _applyRuntime(Map m) {
    if (_disposed) return;

    final state = "${m["state"] ?? "disconnected"}".toLowerCase();
    final wasConnected = _connected;

    _connected = state == "connected";
    _connecting = state == "connecting";
    _reconnecting = state == "reconnecting";
    _paused = state == "paused";
    _wantsConnected = m["wantsConnected"] == true;
    _detail = "${m["detail"] ?? ""}";
    _expectedIp = "${m["expectedIp"] ?? ""}";
    _rxBytes = _asInt(m["rxBytes"]);
    _txBytes = _asInt(m["txBytes"]);
    _latencyMs = _asInt(m["latencyMs"]);

    if (_connected && !wasConnected) {
      _exitLocation = null;
    }

    if (!_connected) {
      _exitLocation = null;
      _locationFetching = false;
      _lastFetchAt = null;
    } else if (_exitLocation == null && !_locationFetching) {
      final last = _lastFetchAt;
      if (last == null || DateTime.now().difference(last) > const Duration(seconds: 4)) {
        unawaited(_fetchExitLocation());
      }
    }

    notifyListeners();
  }

  Future<String> _anonymousDeviceKey() async {
    try {
      final f = File(_anonKeyPath);
      if (await f.exists()) {
        final v = (await f.readAsString()).trim();
        if (v.isNotEmpty) return v;
      }
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(kAnonymousDeviceKeyFallback) ?? "").trim();
  }

  Future<void> _fetchExitLocation() async {
    _lastFetchAt = DateTime.now();
    _locationFetching = true;
    notifyListeners();

    final hasAuth = _token.isNotEmpty;
    final params = <String, String>{};
    if (!hasAuth) {
      final anon = await _anonymousDeviceKey();
      if (anon.isEmpty) {
        _locationFetching = false;
        notifyListeners();
        return;
      }
      params["anonymousDeviceKey"] = anon;
    }
    if (_expectedIp.isNotEmpty) params["expectedIp"] = _expectedIp;

    final uri = Uri.parse("$apiBase/vpn/my-ip").replace(
      queryParameters: params.isEmpty ? null : params,
    );
    final headers = <String, String>{};
    if (hasAuth) headers["authorization"] = "Bearer $_token";

    Map<String, dynamic>? lastBody;
    for (var attempt = 0; attempt < 6; attempt++) {
      if (_disposed || !_connected) break;
      try {
        final res = await http.get(uri, headers: headers).timeout(const Duration(milliseconds: 1800));
        if (res.statusCode == 200) {
          final j = jsonDecode(res.body) as Map<String, dynamic>;
          lastBody = j;
          if (_expectedIp.isNotEmpty) {
            if (j["confirmed"] == true) {
              j["ip"] = _expectedIp;
              _exitLocation = j;
              break;
            }
          } else if ((j["ip"] ?? "").toString().isNotEmpty) {
            _exitLocation = j;
            break;
          }
        }
      } catch (_) {}
      await Future.delayed(const Duration(milliseconds: 600));
    }

    if (_exitLocation == null && _connected && lastBody != null && _expectedIp.isNotEmpty) {
      lastBody["ip"] = _expectedIp;
      _exitLocation = lastBody;
    }

    _locationFetching = false;
    notifyListeners();
  }

  Future<void> connect() async {
    _notice = LiteVpnNotice.none;

    final notif = await Permission.notification.status;
    if (!notif.isGranted) {
      final asked = await Permission.notification.request();
      if (!asked.isGranted) {
        _notice = LiteVpnNotice.notificationsRequired;
        notifyListeners();
        return;
      }
    }

    await _persistSelection();

    try {
      final res = await _managedChannel.invokeMethod("connectManaged", {
        "premium": hasPremiumAccess,
      });
      if (res is Map && res["started"] == true) {
        _connecting = true;
        notifyListeners();
      }
    } catch (_) {
      _notice = LiteVpnNotice.connectFailed;
      notifyListeners();
    }
  }

  Future<void> disconnect() async {
    try {
      await _managedChannel.invokeMethod("disconnectManaged");
    } catch (_) {}
  }

  Future<void> select(LiteVpnServer server) async {
    if (!hasPremiumAccess || !server.isWireGuard) return;
    _selectedServerId = server.id;
    await _persistSelection();
    notifyListeners();

    if (!_wantsConnected) return;
    try {
      await _managedChannel.invokeMethod("switchServerManaged", {
        "premium": hasPremiumAccess,
      });
    } catch (_) {
      _notice = LiteVpnNotice.connectFailed;
      notifyListeners();
    }
  }

  void clearNotice() {
    if (_notice == LiteVpnNotice.none) return;
    _notice = LiteVpnNotice.none;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _locationsTimer?.cancel();
    _runtimeSub?.cancel();
    _runtimeSub = null;
    super.dispose();
  }
}