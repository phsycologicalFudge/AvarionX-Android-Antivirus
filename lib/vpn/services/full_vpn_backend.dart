//legacy

import 'dart:async';
import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/purchase_service.dart';
import '../../../services/service_manager.dart';
import 'package:latlong2/latlong.dart';
import '../../screens/vpn/services/full_vpn_location_map.dart';
import '../../screens/vpn/services/full_vpn_location_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
  static const int kStandaloneSoftLimitBytes = 10 * 1024 * 1024 * 1024;

  int get effectiveUiLimitBytes {
    if (_unlimited) return 0;
    if (_limitBytes <= 0) return kStandaloneSoftLimitBytes;
    return _limitBytes;
  }

  bool get softCapReached {
    if (_unlimited) return false;
    final lim = effectiveUiLimitBytes;
    if (lim <= 0) return false;
    return _usedBytes >= lim;
  }

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
  Timer? _serverStatusTimer;

  Map<String, dynamic> _serverStatusByRegion = {};
  bool _serverStatusEverLoaded = false;

  String get selectedRegionKey {
    final id = _selectedServerId;
    final parts = id.split("-");
    return parts.isNotEmpty ? parts.first.toLowerCase() : id.toLowerCase();
  }

  int? get selectedServerConnectedNow {
    final s = _serverStatusByRegion[selectedRegionKey];
    if (s is! Map) return null;
    final v = s["connectedNow"];
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  int? get selectedServerCap {
    final s = _serverStatusByRegion[selectedRegionKey];
    if (s is! Map) return null;
    final v = s["cap"];
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  bool get serverStatusEverLoaded => _serverStatusEverLoaded;

  bool _busy = false;
  String _status = "";
  String _token = "";
  Map<String, dynamic>? _me;
  bool _connected = false;
  bool _disposed = false;
  bool _postConnectRefreshing = false;
  bool _connectingUi = false;
  bool get connectingUi => _connectingUi;
  DateTime? _connectStartedAt;

  dynamic _loc;
  DateTime? _locFetchedAt;
  DateTime? _connectedAt;

  FullVpnServerLocation get selectedServer {
    return servers.firstWhere(
          (s) => s.id == _selectedServerId,
      orElse: () => servers.first,
    );
  }

  Future<void> _loadServerPlanHint() async {
    final prefs = await SharedPreferences.getInstance();
    final plan = prefs.getString('billing_server_plan') ?? '';
    if (plan.isEmpty) return;
    _me ??= {};
    _me!['plan'] = plan;
    notifyListeners();
  }

  String get selectedServerCountryCode => selectedServer.countryCode;

  bool get vpnLocationFresh {
    if (!_connected) return false;
    if (_connectedAt == null || _locFetchedAt == null) return false;
    return _locFetchedAt!.isAfter(_connectedAt!.add(const Duration(milliseconds: 900)));
  }

  String get uiCountry {
    if (!_connected) return "";
    if (vpnLocationFresh) {
      final l = _loc as dynamic;
      final ip = l == null ? "" : ((l.ip)?.toString() ?? "");
      final c = l == null ? "" : ((l.country)?.toString() ?? "");
      if (ip.isNotEmpty && c.isNotEmpty) return c;
    }
    return selectedServerCountryCode;
  }

  String get uiCity {
    if (!_connected) return "";
    if (!vpnLocationFresh) return "";
    final l = _loc as dynamic;
    final ip = l == null ? "" : ((l.ip)?.toString() ?? "");
    if (ip.isEmpty) return "";
    return l == null ? "" : ((l.city)?.toString() ?? "");
  }

  String get uiIp {
    if (!_connected) return "";
    if (!vpnLocationFresh) return "";
    final l = _loc as dynamic;
    return l == null ? "" : ((l.ip)?.toString() ?? "");
  }

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
      label: "Nürnberg",
      countryCode: "DE",
      point: LatLng(49.4521, 11.0767),
    ),

    FullVpnServerLocation(
      id: "us-ashburn",
      label: "Ashburn",
      countryCode: "US",
      point: LatLng(39.0438, -77.4874),
    ),

    FullVpnServerLocation(
      id: "fl-finland",
      label: "Finland",
      countryCode: "FI",
      point: LatLng(60.1699, 24.9384),
    ),

    FullVpnServerLocation(
      id: "sg-singapore",
      label: "Singapore",
      countryCode: "SG",
      point: LatLng(1.3521, 103.8198),
    ),

    FullVpnServerLocation(
      id: "uk-portsmouth",
      label: "Portsmouth",
      countryCode: "GB",
      point: LatLng(50.8198, -1.0880),

    ),

    FullVpnServerLocation(
      id: "jp-tokyo",
      label: "Tokyo",
      countryCode: "JP",
      point: LatLng(35.6762, 139.6503),
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
  String get status => _status;
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
      _status = "Failed to open browser.";
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
      await _loadServerPlanHint();
      await refreshLocation(force: true);
      await fetchServerStatus();
      await fetchUsage(showSync: true);
      await fetchServerStatus();
      _startUsagePolling();
      _startServerStatusPolling();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _usageTimer?.cancel();
    _runtimeSyncTimer?.cancel();
    _serverStatusTimer?.cancel();
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
      await _loadServerPlanHint();
      await refreshLocation(force: false);
      await fetchUsage(showSync: !_usageEverLoaded);
      await fetchServerStatus();
      if (_usageTimer == null) _startUsagePolling();
      if (_serverStatusTimer == null) _startServerStatusPolling();
    }
  }

  Future<void> setTokenFromLogin(String t) async {
    await _saveToken(t);
    await refreshMe();
    await _syncAccountEntitlementToLocalPro();
    await refreshLocation(force: true);
    await fetchUsage(showSync: true);
    await fetchServerStatus();
    _startUsagePolling();
    _startServerStatusPolling();
    _status = "Signed in.";
    notifyListeners();
  }

  Future<void> _syncAccountEntitlementToLocalPro() async {
    final rawExpiry = _me?["planExpiresAt"];
    final planExpiresAt = rawExpiry is num
        ? rawExpiry.toInt()
        : int.tryParse((rawExpiry ?? "").toString());

    await PurchaseService.applyServerAccountEntitlement(
      signedIn: _token.isNotEmpty && _me != null,
      plan: (_me?["plan"] ?? "").toString(),
      planExpiresAt: planExpiresAt,
    );
  }

  Future<void> signOut() async {
    await disconnect();
    await _clearSession();
    _status = "Signed out.";
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
        await _syncAccountEntitlementToLocalPro();
        _status = "";
        notifyListeners();
        return;
      }

      if (res.statusCode == 401) {
        await _clearSession();
        _status = "Session expired. Sign in again.";
        notifyListeners();
        return;
      }

      _status = "Failed to load account (${res.statusCode}).";
      notifyListeners();
    } catch (e) {
      _status = "Failed to load account ($e).";
      notifyListeners();
    }
  }

  Future<void> fetchServerStatus() async {
    if (_token.isEmpty) return;

    try {
      final res = await http.get(
        Uri.parse("$apiBase/vpn/servers"),
        headers: {"authorization": "Bearer $_token"},
      );

      if (res.statusCode == 200) {
        final j = jsonDecode(res.body);
        final list = (j as Map?)?["servers"];
        if (list is List) {
          final next = <String, dynamic>{};
          for (final item in list) {
            if (item is! Map) continue;
            final region = (item["region"] ?? "").toString().trim().toLowerCase();
            if (region.isEmpty) continue;

            next[region] = {
              "connectedNow": item["connectedNow"],
              "cap": item["cap"],
              "lastSeenAt": item["lastSeenAt"],
              "vpsName": item["vpsName"],
            };
          }
          _serverStatusByRegion = next;
          _serverStatusEverLoaded = true;
          notifyListeners();
        }
        return;
      }

      if (res.statusCode == 401) {
        await _clearSession();
        notifyListeners();
        return;
      }
    } catch (_) {}
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
      final l = await svc
          .fetchMyIpLocation(token: _token)
          .timeout(const Duration(seconds: 4));

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
        _status = "Session expired. Sign in again.";
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
      _status = "Sign in first.";
      notifyListeners();
      return;
    }

    if (softCapReached) {
      _status = "Free limit reached. Upgrade to continue using Full VPN.";
      notifyListeners();
      return;
    }

    await _runBusy(() async {
      await _connectInternal();
    });
  }

  Future<void> _connectInternal() async {
    if (_disposed) return;
    if (_token.isEmpty) return;

    _connectingUi = true;
    _connectStartedAt = DateTime.now();
    _status = "Connecting...";
    notifyListeners();

    final notifStatus = await Permission.notification.status;
    if (_disposed) return;

    if (!notifStatus.isGranted) {
      final notif = await Permission.notification.request();
      if (_disposed) return;

      if (!notif.isGranted) {
        _connectingUi = false;
        _status = "Notifications permission required.";
        notifyListeners();
        return;
      }
    }

    if (_token.isEmpty) {
      _connectingUi = false;
      notifyListeners();
      return;
    }

    final ok = await _requestVpnPermission();
    if (_disposed) return;

    if (!ok) {
      _connectingUi = false;
      _status = "VPN permission not granted.";
      notifyListeners();
      return;
    }

    final conflict = await _isAnotherVpnActive();
    if (_disposed) return;

    if (conflict) {
      _connectingUi = false;
      _status = "Another VPN is active. Disable it first.";
      notifyListeners();
      return;
    }

    await refreshMe();
    if (_disposed) return;

    if (_token.isEmpty) {
      _connectingUi = false;
      notifyListeners();
      return;
    }

    final deviceId = await _getOrCreateDeviceId();
    if (_disposed) return;

    final kp = await _getOrCreateKeypair();
    if (_disposed) return;

    final peer = await _provision(
      deviceId,
      "Android",
      kp["public"]!,
      region: _selectedServerId.split("-").first,
    );

    if (_disposed) return;

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
      _status = "Provision returned incomplete settings.";
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
    if (_disposed) return;

    try {
      await AvServiceManager.stopVpn();
    } catch (_) {}

    try {
      _status = "Starting WireGuard...";
      notifyListeners();

      final sw = Stopwatch()..start();
      final prefs = await SharedPreferences.getInstance();
      final excludedApps = (prefs.getStringList("cs_vpn_split_excluded_pkgs") ?? const <String>[])
          .where((e) => e.trim().isNotEmpty)
          .map((e) => e.trim())
          .toList();

      final r = await vpnChannel.invokeMethod("startWireGuard", {
        "config": cfg,
        "excluded_apps": excludedApps,
      });
      sw.stop();

      if (_disposed) return;

      _status = "WireGuard start returned in ${sw.elapsedMilliseconds}ms";
      notifyListeners();

      await _setGlobalModeFull();
      if (_disposed) return;

      _status = "Securing connection...";
      notifyListeners();

      await _syncWithRuntime();
      if (_disposed) return;

      if (_connected) {
        await fetchUsage(showSync: !_usageEverLoaded);
        _startUsagePolling();
      }

      final start = DateTime.now();
      while (!_disposed && DateTime.now().difference(start).inMilliseconds < 2500) {
        final running = await _isWireGuardRunning();
        if (running) break;
        await Future.delayed(const Duration(milliseconds: 120));
      }

      await refreshLocation(force: true);
      if (_disposed) return;

      _status = "Securing connection...";
      notifyListeners();

      unawaited(refreshLocation(force: true));
    } catch (e) {
      if (_disposed) return;
      _connectingUi = false;
      _status = "Failed to start WireGuard ($e).";
      notifyListeners();
      await _syncWithRuntime();
    }
  }

  Future<void> disconnect() async {
    await _runBusy(() async {
      _connectingUi = false;
      _connectedAt = null;
      _status = "Disconnecting...";
      notifyListeners();

      try {
        await vpnChannel.invokeMethod("stopWireGuard");
      } catch (_) {}

      await _setGlobalModeOff();
      _stopUsagePolling();

      await _syncWithRuntime();
      await refreshLocation(force: true);

      _status = "Disconnected.";
      notifyListeners();
    });
  }

  Future<void> switchServer(FullVpnServerLocation s) async {
    if (_busy) return;

    final wasConnected = _connected;

    _selectedServerId = s.id;
    _status = "Selected ${s.label}";
    notifyListeners();

    await _persistSelectedServer();
    await _syncWithRuntime();
    await fetchServerStatus();

    if (!wasConnected) return;

    await _runBusy(() async {
      _connectingUi = true;
      _status = "Switching to ${s.label}...";
      notifyListeners();

      try {
        await vpnChannel.invokeMethod("stopWireGuard");
      } catch (_) {}

      await _setGlobalModeOff();
      await _syncWithRuntime();

      await refreshLocation(force: true);

      await _connectInternal();
    });
  }

  Future<void> persistBlocklists() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kDnsBlocklistsJson, jsonEncode(blocklists));
  }

  Future<void> saveDnsSettings() async {
    if (_token.isEmpty) {
      _status = "Sign in first.";
      notifyListeners();
      return;
    }

    await _runBusy(() async {
      final prefs = await SharedPreferences.getInstance();
      final pub = prefs.getString(kWgPub) ?? "";

      if (pub.isEmpty) {
        _status = "VPN key not found.";
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
        _status = "DNS settings updated.";
        notifyListeners();
      } else if (res.statusCode == 401) {
        await _clearSession();
        _status = "Session expired.";
        notifyListeners();
      } else {
        _status = "Failed (${res.statusCode}).";
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
      const Duration(seconds: 1),
          (_) => _syncWithRuntime(),
    );
  }

  Future<void> _postConnectRefresh() async {
    if (_token.isEmpty) return;

    for (int i = 0; i < 8; i++) {
      if (_disposed) return;

      try {
        final res = await http
            .get(
          Uri.parse("$apiBase/me"),
          headers: {"authorization": "Bearer $_token"},
        )
            .timeout(const Duration(seconds: 4));

        if (res.statusCode == 200) {
          final j = jsonDecode(res.body) as Map<String, dynamic>;
          _me = (j["user"] as Map?)?.cast<String, dynamic>();
          notifyListeners();
        } else if (res.statusCode == 401) {
          await _clearSession();
          _status = "Session expired. Sign in again.";
          _connectingUi = false;
          notifyListeners();
          return;
        }
      } catch (_) {}

      try {
        await fetchUsage(showSync: !_usageEverLoaded);
      } catch (_) {}

      try {
        await refreshLocation(force: true);
      } catch (_) {}

      if (!_connected) {
        _connectingUi = false;
        notifyListeners();
        return;
      }

      if (vpnLocationFresh && uiIp.isNotEmpty) {
        _status = "Connected.";
        _connectingUi = false;
        notifyListeners();
        return;
      }

      _status = "Securing connection...";
      notifyListeners();

      await Future.delayed(Duration(milliseconds: 350 + (i * 250)));
    }

    if (_connected) {
      _status = "Connected.";
    }
    _connectingUi = false;
    notifyListeners();
  }

  Future<void> _syncWithRuntime() async {
    final running = await _isWireGuardRunning();
    final changed = _connected != running;

    _connected = running;

    if (changed && _connected) {
      _connectedAt = DateTime.now();
      _loc = null;
      _locFetchedAt = null;
      _connectingUi = true;
      _status = "Securing connection...";
      notifyListeners();
      await _postConnectRefresh();
      return;
    }

    if (changed && !_connected) {
      _connectedAt = null;
      notifyListeners();
      return;
    }

    if (!_connected && _connectingUi && !_busy) {
      final started = _connectStartedAt;
      if (started == null) {
        _connectingUi = false;
      } else {
        final ageMs = DateTime.now().difference(started).inMilliseconds;
        if (ageMs > 9000) {
          _connectingUi = false;
          _connectStartedAt = null;
        }
      }
    }

    if (_connected) {
      if (_usageTimer == null) _startUsagePolling();
    } else {
      if (_usageTimer != null) _stopUsagePolling();
    }

    if (changed) notifyListeners();
  }

  void selectServerPreview(FullVpnServerLocation s) {
    if (_connected || _connectingUi) return;
    if (s.id == _selectedServerId) return;

    _selectedServerId = s.id;
    _status = "Selected ${s.label}";
    notifyListeners();
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

  void _startServerStatusPolling() {
    _serverStatusTimer?.cancel();

    if (_token.isEmpty) return;

    fetchServerStatus();

    _serverStatusTimer = Timer.periodic(
      const Duration(seconds: 8),
          (_) async {
        if (_token.isEmpty || _disposed) return;
        await fetchServerStatus();
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

    await PurchaseService.clearServerAccountEntitlement();

    _serverStatusTimer?.cancel();
    _serverStatusTimer = null;
    _serverStatusByRegion = {};
    _serverStatusEverLoaded = false;

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
    try {
      final res = await http
          .post(
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
      )
          .timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final j = jsonDecode(res.body) as Map<String, dynamic>;
        return (j["peer"] as Map?)?.cast<String, dynamic>();
      }

      if (res.statusCode == 401) {
        await _clearSession();
        _status = "Session expired. Sign in again.";
        notifyListeners();
        return null;
      }

      if (res.statusCode == 403) {
        _status = "Your plan is not allowed to use Full VPN.";
        notifyListeners();
        return null;
      }

      final body = res.body.trim();
      _status = body.isEmpty
          ? "Provision failed (${res.statusCode})."
          : "Provision failed (${res.statusCode}): $body";
      notifyListeners();
      return null;
    } on TimeoutException {
      _status = "Provision timed out. Try again.";
      notifyListeners();
      return null;
    } catch (e) {
      _status = "Provision error ($e).";
      notifyListeners();
      return null;
    }
  }

  String _buildWgConfig({
    required String privateKeyB64,
    required String address,
    required String serverPublicKeyB64,
    required String endpoint,
    required List<String> allowedIps,
    required List<String> dns,
  }) {
    String fixCidr(String a) {
      final parts = a.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final out = <String>[];
      for (final p in parts) {
        if (p.contains("/")) {
          out.add(p);
          continue;
        }
        if (p.contains(":")) {
          out.add("$p/128");
        } else {
          out.add("$p/32");
        }
      }
      return out.join(", ");
    }

    final b = StringBuffer();
    b.writeln("[Interface]");
    b.writeln("PrivateKey = $privateKeyB64");
    b.writeln("Address = ${fixCidr(address)}");
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
