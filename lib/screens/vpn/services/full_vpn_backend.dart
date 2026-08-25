import 'dart:async';
import 'dart:convert';
import 'package:colourswift_av/screens/vpn/services/full_vpn_location_service.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/service_manager.dart';
import 'package:latlong2/latlong.dart';
import 'full_vpn_location_map.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../translations/app_localizations.dart';

class FullVpnController extends ChangeNotifier {
  static const vpnChannel = MethodChannel("cs_vpn_control");

  static const kAuthToken = "cs_auth_token";
  static const kWgPriv = "cs_wg_private_key_b64";
  static const kWgPub = "cs_wg_public_key_b64";
  static const kDeviceId = "cs_device_id";
  static const kVpnMode = "cs_vpn_mode";
  static const kDnsBlocklistsJson = "cs_dns_blocklists_json";
  static const kWgConfigLast = "cs_wg_config_last";
  static const kSelectedServerId = "cs_vpn_selected_region";
  static const kLastLat = "cs_vpn_last_lat";
  static const kLastLon = "cs_vpn_last_lon";

  final String apiBase;
  final String loginUrl;
  final String deepLinkPrefix;

  FullVpnController({
    required this.apiBase,
    required this.loginUrl,
    required this.deepLinkPrefix,
  });

  Timer? _usageTimer;
  Timer? _runtimeSyncTimer;

  bool _busy = false;
  String _status = "";
  String _statusArg = "";
  String _token = "";
  Map<String, dynamic>? _me;
  bool _connected = false;
  bool _disposed = false;
  bool _connectingUi = false;
  bool get connectingUi => _connectingUi;


  dynamic _loc;
  DateTime? _locFetchedAt;

  double? _lastLat;
  double? _lastLon;

  double? get lastLat => _lastLat;
  double? get lastLon => _lastLon;

  int _usedBytes = 0;
  int _limitBytes = 0;
  bool _unlimited = false;

  bool _usageSyncing = false;
  bool _usageEverLoaded = false;

  final List<FullVpnServerLocation> servers = const [
    FullVpnServerLocation(
      id: "de-nuremberg",
      label: "DE, Nürnberg",
      point: LatLng(49.4521, 11.0767),
    ),
    FullVpnServerLocation(
      id: "us-ashburn",
      label: "US, Ashburn",
      point: LatLng(39.0438, -77.4874),
    ),
    FullVpnServerLocation(
      id: "fl-finland",
      label: "FL, Finland",
      point: LatLng(60.1699, 24.9384),
    ),
    FullVpnServerLocation(
      id: "sg-singapore",
      label: "SG, Singapore",
      point: LatLng(1.3521, 103.8198),
    ),
  ];

  String _selectedServerId = "de-nuremberg";

  final Map<String, bool> blocklists = {
    "ads": true,
    "trackers": true,
    "malware": true,
    "adult": false,
    "gambling": false,
    "social": false,
    "crypto": false,
  };

  bool get busy => _busy;
  bool get hasStatus => _status.isNotEmpty;

  String statusText(AppLocalizations l10n) {
    switch (_status) {
      case 'failedOpenBrowser':
        return l10n.vpnBackendFailedOpenBrowser;
      case 'signedIn':
        return l10n.vpnBackendSignedIn;
      case 'signedOut':
        return l10n.vpnBackendSignedOut;
      case 'sessionExpiredSignIn':
        return l10n.vpnBackendSessionExpiredSignIn;
      case 'failedLoadAccountStatus':
        return l10n.vpnBackendFailedLoadAccountStatus(_statusArg);
      case 'failedLoadAccountError':
        return l10n.vpnBackendFailedLoadAccountError(_statusArg);
      case 'signInFirst':
        return l10n.vpnBackendSignInFirst;
      case 'connecting':
        return l10n.vpnBackendConnecting;
      case 'notificationsPermissionRequired':
        return l10n.vpnBackendNotificationsPermissionRequired;
      case 'vpnPermissionNotGranted':
        return l10n.vpnBackendPermissionNotGranted;
      case 'anotherVpnActive':
        return l10n.vpnBackendAnotherVpnActive;
      case 'provisionIncomplete':
        return l10n.vpnBackendProvisionIncomplete;
      case 'securingConnection':
        return l10n.vpnBackendSecuringConnection;
      case 'connected':
        return l10n.vpnBackendConnected;
      case 'wireGuardFailed':
        return l10n.vpnBackendWireGuardFailed(_statusArg);
      case 'disconnecting':
        return l10n.vpnBackendDisconnecting;
      case 'disconnected':
        return l10n.vpnBackendDisconnected;
      case 'selectedServer':
        return l10n.vpnBackendSelectedServer(_statusArg);
      case 'switchingServer':
        return l10n.vpnBackendSwitchingServer(_statusArg);
      case 'vpnKeyNotFound':
        return l10n.vpnBackendKeyNotFound;
      case 'dnsUpdated':
        return l10n.vpnBackendDnsUpdated;
      case 'sessionExpired':
        return l10n.vpnBackendSessionExpired;
      case 'failedStatus':
        return l10n.vpnBackendFailedStatus(_statusArg);
      case 'planNotAllowed':
        return l10n.vpnBackendPlanNotAllowed;
      case 'provisionFailed':
        return l10n.vpnBackendProvisionFailed(_statusArg);
      default:
        return '';
    }
  }
  String get token => _token;
  Map<String, dynamic>? get me => _me;
  bool get connected => _connected;

  dynamic get loc => _loc;

  int get usedBytes => _usedBytes;
  int get limitBytes => _limitBytes;
  bool get unlimited => _unlimited;

  bool get usageSyncing => _usageSyncing;
  bool get usageEverLoaded => _usageEverLoaded;

  String get selectedServerId => _selectedServerId;

  Future<void> startLoginInBrowser() async {
    final u = Uri.parse(loginUrl);
    final ok = await launchUrl(u, mode: LaunchMode.externalApplication);
    if (!ok) {
      _status = "failedOpenBrowser";
      notifyListeners();
    }
  }

  Future<void> _loadLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final a = prefs.getDouble(kLastLat);
    final b = prefs.getDouble(kLastLon);
    _lastLat = a;
    _lastLon = b;
  }

  Future<void> init() async {
    await _loadBlocklists();
    await _loadSelectedServer();
    await _loadToken();
    await _loadLastLocation();
    await _syncWithRuntime();
    _startRuntimeSync();

    if (_token.isNotEmpty) {
      await refreshMe();
      await refreshLocation(force: true);
      await fetchUsage(showSync: true);
      _startUsagePolling();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _usageTimer?.cancel();
    _runtimeSyncTimer?.cancel();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  Future<void> onResumed() async {
    await _syncWithRuntime();
    await _loadToken();

    if (_token.isNotEmpty) {
      await refreshMe();
      await refreshLocation(force: false);
      await fetchUsage(showSync: !_usageEverLoaded);
      if (_usageTimer == null) _startUsagePolling();
    }
  }

  Future<void> setTokenFromLogin(String t) async {
    await _saveToken(t);
    await refreshMe();
    await refreshLocation(force: true);
    await fetchUsage(showSync: true);
    _startUsagePolling();
    _status = "signedIn";
    notifyListeners();
  }

  Future<void> signOut() async {
    await disconnect();
    await _clearSession();
    _status = "signedOut";
    notifyListeners();
  }

  Future<void> refreshMe() async {
    if (_token.isEmpty) return;

    try {
      final res = await http.get(
        Uri.parse("$apiBase/me"),
        headers: {"authorization": "Bearer $_token"},
      );

      if (res.statusCode == 200) {
        final j = jsonDecode(res.body) as Map<String, dynamic>;
        _me = (j["user"] as Map?)?.cast<String, dynamic>();
        _status = "";
        _statusArg = "";
        notifyListeners();
        return;
      }

      if (res.statusCode == 401) {
        await _clearSession();
        _status = "sessionExpiredSignIn";
        notifyListeners();
        return;
      }

      _status = "failedLoadAccountStatus";
      _statusArg = res.statusCode.toString();
      notifyListeners();
    } catch (e) {
      _status = "failedLoadAccountError";
      _statusArg = e.toString();
      notifyListeners();
    }
  }

  Future<void> refreshLocation({bool force = false}) async {
    if (_token.isEmpty) return;

    final now = DateTime.now();
    if (!force && _locFetchedAt != null) {
      final age = now.difference(_locFetchedAt!);
      if (age.inSeconds < 10) return;
    }

    try {
      final svc = FullVpnLocationService(apiBase: apiBase);
      final l = await svc.fetchMyIpLocation(token: _token);
      _loc = l;
      _locFetchedAt = DateTime.now();
      final a = locLat();
      final b = locLon();
      if (a != null && b != null) {
        _lastLat = a;
        _lastLon = b;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble(kLastLat, a);
        await prefs.setDouble(kLastLon, b);
      }
      notifyListeners();
    } catch (e) {
      if (e.toString().contains("unauthorized")) {
        await _clearSession();
        _status = "sessionExpiredSignIn";
        notifyListeners();
      }
    }
  }

  Future<void> fetchUsage({bool showSync = true}) async {
    if (_token.isEmpty) return;

    int asInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    bool asBool(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is String) return v.toLowerCase() == "true";
      if (v is num) return v != 0;
      return false;
    }

    final prevSync = _usageSyncing;
    if (showSync && !_usageSyncing) {
      _usageSyncing = true;
      notifyListeners();
    }

    try {
      final res = await http.get(
        Uri.parse("$apiBase/vpn/usage"),
        headers: {"authorization": "Bearer $_token"},
      );

      if (res.statusCode == 200) {
        final j = jsonDecode(res.body);
        final nextUsed = asInt((j as Map?)?["usedBytes"]);
        final nextLimit = asInt((j as Map?)?["limitBytes"]);
        final nextUnlimited = asBool((j as Map?)?["unlimited"]);

        final firstLoad = !_usageEverLoaded;

        final changed = nextUsed != _usedBytes ||
            nextLimit != _limitBytes ||
            nextUnlimited != _unlimited;

        _usedBytes = nextUsed;
        _limitBytes = nextLimit;
        _unlimited = nextUnlimited;

        _usageEverLoaded = true;
        _usageSyncing = false;

        if (firstLoad || changed || prevSync != _usageSyncing) {
          notifyListeners();
        }
        return;
      }

      if (res.statusCode == 401) {
        await _clearSession();
        _usageSyncing = false;
        notifyListeners();
        return;
      }

      if (_usageSyncing) {
        _usageSyncing = false;
        notifyListeners();
      }
    } catch (_) {
      if (_usageSyncing) {
        _usageSyncing = false;
        notifyListeners();
      }
    }
  }

  Future<void> connect() async {
    if (_token.isEmpty) {
      _status = "signInFirst";
      notifyListeners();
      return;
    }

    await _runBusy(() async {
      _connectingUi = true;
      _status = "connecting";
      notifyListeners();

      final notif = await Permission.notification.request();
      if (!notif.isGranted) {
        _connectingUi = false;
        _status = "notificationsPermissionRequired";
        notifyListeners();
        return;
      }

      final ok = await _requestVpnPermission();
      if (!ok) {
        _connectingUi = false;
        _status = "vpnPermissionNotGranted";
        notifyListeners();
        return;
      }

      final conflict = await _isAnotherVpnActive();
      if (conflict) {
        _connectingUi = false;
        _status = "anotherVpnActive";
        notifyListeners();
        return;
      }

      await refreshMe();

      final deviceId = await _getOrCreateDeviceId();
      final kp = await _getOrCreateKeypair();

      final peer = await _provision(
        deviceId,
        "Android",
        kp["public"]!,
        region: _selectedServerId.split("-").first,
      );

      if (peer == null) {
        _connectingUi = false;
        notifyListeners();
        return;
      }

      final assignedIp = (peer["assignedIp"] ?? "").toString();
      final endpoint = (peer["endpoint"] ?? "").toString();
      final serverPublicKey = (peer["serverPublicKey"] ?? "").toString();
      final allowed = (peer["allowedIps"] as List?)?.map((e) => e.toString()).toList() ?? const [];
      final dns = (peer["dns"] as List?)?.map((e) => e.toString()).toList() ?? const [];

      if (assignedIp.isEmpty || endpoint.isEmpty || serverPublicKey.isEmpty || allowed.isEmpty) {
        _connectingUi = false;
        _status = "provisionIncomplete";
        notifyListeners();
        return;
      }

      final cfg = _buildWgConfig(
        privateKeyB64: kp["private"]!,
        address: assignedIp,
        serverPublicKeyB64: serverPublicKey,
        endpoint: endpoint,
        allowedIps: allowed,
        dns: dns,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kWgConfigLast, cfg);

      try {
        await AvServiceManager.stopVpn();
      } catch (_) {}

      try {
        await vpnChannel.invokeMethod("startWireGuard", {"config": cfg});
        await _setGlobalModeFull();

        _status = "securingConnection";
        notifyListeners();

        await _syncWithRuntime();

        if (_connected) {
          await fetchUsage(showSync: !_usageEverLoaded);
          _startUsagePolling();
        }

        await Future.delayed(const Duration(seconds: 2));
        await refreshLocation(force: true);

        _connectingUi = false;
        _status = "connected";
        notifyListeners();
      } catch (e) {
        _connectingUi = false;
        _status = "wireGuardFailed";
        _statusArg = e.toString();
        notifyListeners();
        await _syncWithRuntime();
      }
    });
  }

  Future<void> disconnect() async {
    await _runBusy(() async {
      _connectingUi = false;
      _status = "disconnecting";
      notifyListeners();

      try {
        await vpnChannel.invokeMethod("stopWireGuard");
      } catch (_) {}

      await _setGlobalModeOff();
      _stopUsagePolling();

      await _syncWithRuntime();
      await refreshLocation(force: true);

      _status = "disconnected";
      notifyListeners();
    });
  }

  Future<void> switchServer(FullVpnServerLocation s) async {
    if (_busy) return;

    _selectedServerId = s.id;
    _status = "selectedServer";
    _statusArg = s.label;
    notifyListeners();

    await _persistSelectedServer();
    await _syncWithRuntime();

    if (!_connected) return;

    await _runBusy(() async {
      try {
        await vpnChannel.invokeMethod("stopWireGuard");
      } catch (_) {}

      await _setGlobalModeOff();
      _status = "switchingServer";
      _statusArg = s.label;
      notifyListeners();

      await _syncWithRuntime();
      await refreshLocation(force: true);
      await connect();
    });
  }

  Future<void> persistBlocklists() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kDnsBlocklistsJson, jsonEncode(blocklists));
  }

  Future<void> saveDnsSettings() async {
    if (_token.isEmpty) {
      _status = "signInFirst";
      notifyListeners();
      return;
    }

    await _runBusy(() async {
      final prefs = await SharedPreferences.getInstance();
      final pub = prefs.getString(kWgPub) ?? "";

      if (pub.isEmpty) {
        _status = "vpnKeyNotFound";
        notifyListeners();
        return;
      }

      final enabled = blocklists.entries.where((e) => e.value).map((e) => e.key).toList();
      final settingsJson = jsonEncode({"blocklists": enabled});
      final settingsB64 = base64Encode(utf8.encode(settingsJson));

      final res = await http.post(
        Uri.parse("$apiBase/vpn/update-dns"),
        headers: {
          "authorization": "Bearer $_token",
          "content-type": "application/json",
        },
        body: jsonEncode({
          "publicKey": pub,
          "settingsB64": settingsB64,
        }),
      );

      if (res.statusCode == 200) {
        await persistBlocklists();
        _status = "dnsUpdated";
        notifyListeners();
      } else if (res.statusCode == 401) {
        await _clearSession();
        _status = "sessionExpired";
        notifyListeners();
      } else {
        _status = "failedStatus";
        _statusArg = res.statusCode.toString();
        notifyListeners();
      }
    });
  }

  String formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const units = ["B", "KB", "MB", "GB", "TB"];
    double size = bytes.toDouble();
    int unit = 0;
    while (size >= 1024 && unit < units.length - 1) {
      size /= 1024;
      unit++;
    }
    return "${size.toStringAsFixed(2)} ${units[unit]}";
  }

  double? locLat() {
    final l = _loc;
    if (l == null) return null;
    final d = l as dynamic;

    dynamic tryRead(dynamic Function() fn) {
      try {
        return fn();
      } catch (_) {
        return null;
      }
    }

    final a = tryRead(() => d.lat);
    if (a is num) return a.toDouble();

    final b = tryRead(() => d.latitude);
    if (b is num) return b.toDouble();

    final c = tryRead(() => d.locationLat);
    if (c is num) return c.toDouble();

    return null;
  }

  double? locLon() {
    final l = _loc;
    if (l == null) return null;
    final d = l as dynamic;

    dynamic tryRead(dynamic Function() fn) {
      try {
        return fn();
      } catch (_) {
        return null;
      }
    }

    final a = tryRead(() => d.lon);
    if (a is num) return a.toDouble();

    final b = tryRead(() => d.lng);
    if (b is num) return b.toDouble();

    final c = tryRead(() => d.longitude);
    if (c is num) return c.toDouble();

    final e = tryRead(() => d.locationLon);
    if (e is num) return e.toDouble();

    return null;
  }

  Future<void> _startRuntimeSync() async {
    _runtimeSyncTimer?.cancel();
    _runtimeSyncTimer = Timer.periodic(
      const Duration(seconds: 3),
          (_) => _syncWithRuntime(),
    );
  }

  Future<void> _syncWithRuntime() async {
    final running = await _isWireGuardRunning();
    final changed = _connected != running;
    _connected = running;

    if (!_connected && _connectingUi && !_busy) {
      _connectingUi = false;
    }

    if (_connected) {
      if (_usageTimer == null) _startUsagePolling();
    } else {
      if (_usageTimer != null) _stopUsagePolling();
    }

    if (changed) notifyListeners();
  }

  void _startUsagePolling() {
    _usageTimer?.cancel();
    _usageTimer = Timer.periodic(
      const Duration(seconds: 30),
          (_) async {
        if (_token.isEmpty) return;
        await fetchUsage(showSync: false);
      },
    );
  }

  void _stopUsagePolling() {
    _usageTimer?.cancel();
    _usageTimer = null;
  }

  Future<bool> _isWireGuardRunning() async {
    try {
      return await vpnChannel.invokeMethod<bool>("isWireGuardRunning") == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString(kAuthToken) ?? "";
    if (t != _token) {
      _token = t;
      notifyListeners();
    }
  }

  Future<void> _saveToken(String t) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kAuthToken, t);
    _token = t;
    notifyListeners();
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kAuthToken);
    await prefs.remove(kWgPriv);
    await prefs.remove(kWgPub);
    await prefs.remove(kDnsBlocklistsJson);
    await prefs.remove(kWgConfigLast);

    _token = "";
    _me = null;
    _connected = false;
    _usedBytes = 0;
    _limitBytes = 0;
    _unlimited = false;
    _usageSyncing = false;
    _usageEverLoaded = false;

    notifyListeners();
  }

  Future<void> _loadBlocklists() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(kDnsBlocklistsJson) ?? "";
    if (raw.isEmpty) return;

    try {
      final j = jsonDecode(raw);
      if (j is! Map) return;

      for (final k in blocklists.keys) {
        final v = j[k];
        if (v is bool) {
          blocklists[k] = v;
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _loadSelectedServer() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(kSelectedServerId) ?? "";
    if (saved.isEmpty) return;
    final ok = servers.any((s) => s.id == saved);
    if (!ok) return;
    _selectedServerId = saved;
    notifyListeners();
  }

  Future<void> _persistSelectedServer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kSelectedServerId, _selectedServerId);
  }

  Future<bool> _requestVpnPermission() async {
    const chan = MethodChannel("cs_vpn_permission");
    try {
      return await chan.invokeMethod<bool>("prepareVpn") == true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _isAnotherVpnActive() async {
    const chan = MethodChannel("cs_vpn_state");
    try {
      return await chan.invokeMethod<bool>("isAnotherVpnActive") ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _setGlobalModeFull() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kVpnMode, "full");
    await prefs.setBool("protectionEnabled", true);
    await prefs.setBool("networkProtectionEnabled", false);
    await prefs.setString("networkProtectionMode", "full");
  }

  Future<void> _setGlobalModeOff() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kVpnMode, "off");
    await prefs.setBool("networkProtectionEnabled", false);
    await prefs.setString("networkProtectionMode", "off");
  }

  Future<String> _getOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(kDeviceId) ?? "";
    if (existing.isNotEmpty) return existing;

    final now = DateTime.now().millisecondsSinceEpoch;
    final r = base64Url.encode(List<int>.generate(24, (i) => (now + i * 997) & 0xff));
    final id = "android_$r";
    await prefs.setString(kDeviceId, id);
    return id;
  }

  Future<Map<String, String>> _getOrCreateKeypair() async {
    final prefs = await SharedPreferences.getInstance();
    final priv = prefs.getString(kWgPriv) ?? "";
    final pub = prefs.getString(kWgPub) ?? "";

    if (priv.isNotEmpty && pub.isNotEmpty) {
      return {"private": priv, "public": pub};
    }

    final algo = X25519();
    final kp = await algo.newKeyPair();
    final pubKey = await kp.extractPublicKey();
    final privBytes = await kp.extractPrivateKeyBytes();

    final privB64 = base64Encode(privBytes);
    final pubB64 = base64Encode(pubKey.bytes);

    await prefs.setString(kWgPriv, privB64);
    await prefs.setString(kWgPub, pubB64);

    return {"private": privB64, "public": pubB64};
  }

  Future<Map<String, dynamic>?> _provision(
      String deviceId,
      String deviceName,
      String publicKeyB64, {
        required String region,
      }) async {
    final res = await http.post(
      Uri.parse("$apiBase/vpn/provision"),
      headers: {
        "content-type": "application/json; charset=utf-8",
        "authorization": "Bearer $_token",
      },
      body: jsonEncode({
        "deviceId": deviceId,
        "deviceName": deviceName,
        "publicKey": publicKeyB64,
        "region": region,
      }),
    );

    if (res.statusCode == 200) {
      final j = jsonDecode(res.body) as Map<String, dynamic>;
      return (j["peer"] as Map?)?.cast<String, dynamic>();
    }

    if (res.statusCode == 401) {
      await _clearSession();
      _status = "sessionExpiredSignIn";
      notifyListeners();
      return null;
    }

    if (res.statusCode == 403) {
      _status = "planNotAllowed";
      notifyListeners();
      return null;
    }

    _status = "provisionFailed";
    _statusArg = res.statusCode.toString();
    notifyListeners();
    return null;
  }

  String _buildWgConfig({
    required String privateKeyB64,
    required String address,
    required String serverPublicKeyB64,
    required String endpoint,
    required List<String> allowedIps,
    required List<String> dns,
  }) {
    final b = StringBuffer();
    b.writeln("[Interface]");
    b.writeln("PrivateKey = $privateKeyB64");
    b.writeln("Address = $address");
    if (dns.isNotEmpty) {
      b.writeln("DNS = ${dns.join(", ")}");
    }
    b.writeln("");
    b.writeln("[Peer]");
    b.writeln("PublicKey = $serverPublicKeyB64");
    b.writeln("Endpoint = $endpoint");
    b.writeln("AllowedIPs = ${allowedIps.join(", ")}");
    b.writeln("PersistentKeepalive = 25");
    return b.toString();
  }

  Future<void> _runBusy(Future<void> Function() fn) async {
    if (_busy) return;
    _busy = true;
    notifyListeners();
    try {
      await fn();
    } finally {
      _busy = false;
      notifyListeners();
    }
  }
}
