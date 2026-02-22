import 'package:app_links/app_links.dart';
import 'package:colourswift_av/screens/vpn/services/full_vpn_backend.dart';
import 'package:colourswift_av/screens/vpn/settings/full_vpn_settings_tab.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../translations/app_localizations.dart';
import 'dns/NetworkProtectionScreen.dart';
import 'full_vpn_footer_nav.dart';
import 'services/full_vpn_location_map.dart';
import 'dart:async';

class FullVpnModeScreen extends StatefulWidget {
  const FullVpnModeScreen({super.key});

  @override
  State<FullVpnModeScreen> createState() => _FullVpnModeScreenState();
}

class _FullVpnModeScreenState extends State<FullVpnModeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final FullVpnController c;
  late final AnimationController _glowCtrl;
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSub;
  bool _closing = false;
  String _tab = "connection";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    c = FullVpnController(
      apiBase: "https://api.colourswift.com",
      loginUrl: "https://api.colourswift.com/login",
      deepLinkPrefix: "colourswift://auth?token=",
    );

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    c.init();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _closing = true;
    _linkSub?.cancel();
    _linkSub = null;
    WidgetsBinding.instance.removeObserver(this);
    _glowCtrl.dispose();
    c.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      c.onResumed();
    }
  }

  ThemeData _darkTheme(BuildContext context) {
    const bg = Color(0xFF0B1220);
    const surface = Color(0xFF111827);
    const surface2 = Color(0xFF1F2937);
    const accent = Color(0xFF60A5FA);

    final base = ThemeData.dark(useMaterial3: true);
    final scheme = base.colorScheme.copyWith(
      brightness: Brightness.dark,
      primary: accent,
      secondary: accent,
      surface: surface,
      surfaceContainerHighest: surface2,
      background: bg,
      onSurface: const Color(0xFFE7ECF5),
      onSurfaceVariant: const Color(0xFFB7C1D6),
      outline: const Color(0xFF22304A),
      outlineVariant: const Color(0xFF1B2740),
      tertiary: const Color(0xFF60A5FA),
      onTertiary: const Color(0xFF0B1220),
      tertiaryContainer: const Color(0xFF0B2545),
      onTertiaryContainer: const Color(0xFFE7ECF5),
      primaryContainer: const Color(0xFF0B2545),
      onPrimaryContainer: const Color(0xFFE7ECF5),
      secondaryContainer: const Color(0xFF0B2545),
      onSecondaryContainer: const Color(0xFFE7ECF5),
    );

    return base.copyWith(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.primary,
        selectionColor: scheme.primary.withOpacity(0.25),
        selectionHandleColor: scheme.primary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outlineVariant.withOpacity(0.45)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        foregroundColor: Color(0xFFE7ECF5),
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface2,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      dividerColor: scheme.outlineVariant.withOpacity(0.35),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          backgroundColor: const Color(0xFF1F2937),
          foregroundColor: const Color(0xFFE7ECF5),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.onSurface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    Future<void> handle(Uri? uri) async {
      if (uri == null) return;
      if (_closing || !mounted) return;

      final u = uri.toString();
      if (!u.startsWith("colourswift://auth")) return;

      final token = uri.queryParameters["token"] ?? "";
      if (token.isEmpty) return;

      await c.setTokenFromLogin(token);

      if (_closing || !mounted) return;

      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.showSnackBar(
        const SnackBar(content: Text("Signed in.")),
      );
    }

    try {
      final initial = await _appLinks.getInitialLink();
      await handle(initial);
    } catch (_) {}

    _linkSub?.cancel();
    _linkSub = _appLinks.uriLinkStream.listen((uri) async {
      await handle(uri);
    });
  }

  Future<void> _showSignInPopup() async {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Container(
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withOpacity(0.92),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: scheme.outlineVariant.withOpacity(0.25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withOpacity(0.10),
                    blurRadius: 90,
                    spreadRadius: -18,
                    offset: const Offset(0, 28),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: scheme.surface.withOpacity(0.35),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: scheme.outlineVariant.withOpacity(0.22),
                            ),
                          ),
                          child: Icon(
                            Icons.login_rounded,
                            color: scheme.onSurface.withOpacity(0.92),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Sign in required",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: Icon(Icons.close_rounded, color: scheme.onSurfaceVariant),
                          splashRadius: 20,
                          tooltip: "Close",
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Sign in to use Secure VPN.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: scheme.onSurface,
                              side: BorderSide(color: scheme.outlineVariant.withOpacity(0.45)),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              textStyle: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              await c.startLoginInBrowser();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: scheme.primary,
                              foregroundColor: scheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              textStyle: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                            child: const Text("Sign in"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _serverDropdown(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final items = c.servers
        .map(
          (s) => DropdownMenuItem<String>(
        value: s.id,
        child: Text(
          s.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    )
        .toList();

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: c.selectedServerId,
        items: items,
        onChanged: c.busy
            ? null
            : (id) async {
          if (id == null) return;
          final s = c.servers.firstWhere((e) => e.id == id);
          await c.switchServer(s);
        },
        dropdownColor: scheme.surfaceContainerHighest,
        iconEnabledColor: scheme.onSurfaceVariant,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _usageRow(BuildContext context, {bool showWhenDisconnected = false}) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (!c.connected && !showWhenDisconnected) {
      return const SizedBox.shrink();
    }

    final syncing = c.usageSyncing;

    if (!c.usageEverLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Loading usage...",
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          const LinearProgressIndicator(minHeight: 6),
        ],
      );
    }

    if (c.unlimited) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "No data limits",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              AnimatedOpacity(
                opacity: syncing ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: Text(
                  "Syncing",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "${c.formatBytes(c.usedBytes)} used this month",
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    if (c.limitBytes > 0) {
      final target = (c.usedBytes / c.limitBytes).clamp(0.0, 1.0);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Data Usage",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 10),
              AnimatedOpacity(
                opacity: syncing ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: Text(
                  "Syncing",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: target,
            minHeight: 6,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(height: 6),
          Text(
            "${c.formatBytes(c.usedBytes)} / ${c.formatBytes(c.limitBytes)}",
            style: theme.textTheme.bodySmall,
          ),
        ],
      );
    }

    return Text(
      "Usage unavailable",
      style: theme.textTheme.bodySmall?.copyWith(
        color: scheme.onSurfaceVariant,
      ),
    );
  }

  Widget _connectionScreen(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final loc = c.loc as dynamic;
    final city = loc == null ? "" : ((loc.city)?.toString() ?? "");
    final country = loc == null ? "" : ((loc.country)?.toString() ?? "");
    final ip = loc == null ? "" : ((loc.ip)?.toString() ?? "");

    final mapHeader = c.connectingUi
        ? "Connecting..."
        : (c.connected
        ? (country.isNotEmpty ? "Connected to $country" : "Connected")
        : "Secure VPN");

    final lat = c.locLat() ?? c.lastLat;
    final lon = c.locLon() ?? c.lastLon;

    final canConnect = !c.connected && !c.busy;
    final canDisconnect = c.connected && !c.busy;

    final connectStyle = ElevatedButton.styleFrom(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      disabledBackgroundColor: scheme.surface.withOpacity(0.35),
      disabledForegroundColor: scheme.onSurfaceVariant.withOpacity(0.8),
    );

    final disconnectStyle = ElevatedButton.styleFrom(
      backgroundColor: scheme.surfaceContainerHighest.withOpacity(0.85),
      foregroundColor: scheme.onSurface,
      disabledBackgroundColor: scheme.surface.withOpacity(0.35),
      disabledForegroundColor: scheme.onSurfaceVariant.withOpacity(0.8),
    );

    final titleCountry = c.connectingUi
        ? "Connecting..."
        : (c.connected ? (country.isNotEmpty ? country : "Secure VPN") : "Secure VPN");

    final subtitle = c.connectingUi
        ? "Establishing tunnel..."
        : (city.isNotEmpty && country.isNotEmpty
        ? "$city, $country"
        : (country.isNotEmpty ? country : "Finding location..."));

    final ipLine = (c.connected && !c.connectingUi)
        ? (ip.isNotEmpty ? ip : "loading...")
        : "";

    final statusLabel = c.connectingUi
        ? "Connecting"
        : (c.connected ? "Protected" : "Not connected");

    final statusTone = c.connectingUi
        ? scheme.tertiaryContainer
        : (c.connected ? const Color(0xFF0B3B24) : scheme.surface.withOpacity(0.30));

    final statusTextTone = c.connectingUi
        ? scheme.onTertiaryContainer
        : (c.connected ? const Color(0xFFBFF7D4) : scheme.onSurface.withOpacity(0.92));

    final connectLabel = c.connectingUi ? "Connecting..." : "Connect";

    final cardContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: scheme.surface.withOpacity(0.28),
                shape: BoxShape.circle,
                border: Border.all(
                  color: scheme.outlineVariant.withOpacity(0.25),
                ),
              ),
              child: Icon(
                c.connected ? Icons.verified_user_rounded : Icons.shield_outlined,
                color: scheme.onSurface.withOpacity(0.92),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleCountry,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: scheme.surface.withOpacity(0.26),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: scheme.outlineVariant.withOpacity(0.25),
                ),
              ),
              child: _serverDropdown(context),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: statusTone,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: scheme.outlineVariant.withOpacity(0.22),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusTextTone.withOpacity(0.95),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: statusTextTone,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            if (c.connected && !c.connectingUi)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: scheme.surface.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: scheme.outlineVariant.withOpacity(0.22),
                  ),
                ),
                child: Text(
                  "IP: $ipLine",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scheme.onSurface.withOpacity(0.92),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            if (c.status.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: scheme.surface.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: scheme.outlineVariant.withOpacity(0.18),
                  ),
                ),
                child: Text(
                  c.status,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        _usageRow(context),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: canConnect
                    ? () async {
                  if (c.token.isEmpty) {
                    await _showSignInPopup();
                    return;
                  }
                  await c.connect();
                }
                    : null,
                style: connectStyle,
                child: Text(connectLabel),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: canDisconnect ? c.disconnect : null,
                style: disconnectStyle,
                child: const Text("Disconnect"),
              ),
            ),
          ],
        ),
      ],
    );

    return Stack(
      children: [
        Positioned.fill(
          child: FullVpnLocationMapCard(
            lat: lat,
            lon: lon,
            connected: c.connected,
            isConnecting: c.connectingUi,
            headerText: mapHeader,
            servers: c.servers,
            selectedServerId: c.selectedServerId,
            onServerTap: (s) async {
              await c.switchServer(s);
            },
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 12,
          child: SafeArea(
            top: false,
            child: AnimatedBuilder(
              animation: _glowCtrl,
              builder: (context, _) {
                final t = _glowCtrl.value;
                final a = (t * 2) - 1;

                return ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: scheme.outlineVariant.withOpacity(0.22),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment(-1 + a, -1),
                        end: Alignment(1 + a, 1),
                        colors: [
                          scheme.primaryContainer.withOpacity(0.18),
                          scheme.surfaceContainerHighest.withOpacity(0.86),
                          scheme.primaryContainer.withOpacity(0.14),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: scheme.primary.withOpacity(0.10),
                          blurRadius: 90,
                          spreadRadius: -18,
                          offset: const Offset(0, 28),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 320),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: cardContent,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _customisationScreen(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        Text(
          "Secure VPN Blocklists",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        ...c.blocklists.entries.map((e) {
          return SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: e.value,
            title: Text(e.key.toUpperCase()),
            onChanged: (v) async {
              final m = c.blocklists;
              if (m is Map<String, bool>) {
                m[e.key] = v;
                await c.persistBlocklists();
                c.notifyListeners();
              }
            },
          );
        }).toList(),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: c.busy
                ? null
                : () async {
              if (c.token.isEmpty) {
                await _showSignInPopup();
                return;
              }
              await c.saveDnsSettings();
            },
            child: const Text("Save"),
          ),
        ),
      ],
    );
  }

  Widget _settingsScreen(BuildContext context) {
    return FullVpnSettingsTab(
      c: c,
      usageRow: _usageRow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _darkTheme(context),
      child: AnimatedBuilder(
        animation: c,
        builder: (context, _) {
          Widget body;
          if (_tab == "dns") {
            body = const NetworkProtectionScreen();
          } else if (_tab == "customisation") {
            body = _customisationScreen(context);
          } else if (_tab == "settings") {
            body = _settingsScreen(context);
          } else {
            body = _connectionScreen(context);
          }

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(44),
              child: AppBar(
                toolbarHeight: 44,
                leadingWidth: 44,
                leading: const BackButton(),
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: c.connected
                        ? const Color(0xFF1B7F4B)
                        : Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.55),
                  ),
                ),
                titleSpacing: 0,
                title: Builder(
                  builder: (context) {
                    final loc = c.loc as dynamic;
                    final country = loc == null ? "" : ((loc.country)?.toString() ?? "");
                    final ip = loc == null ? "" : ((loc.ip)?.toString() ?? "");

                    final topLine = c.connectingUi
                        ? "Connecting..."
                        : (c.connected
                        ? (country.isNotEmpty ? "Connected to $country" : "Connected")
                        : "Secure VPN");

                    final showIp = c.connected && !c.connectingUi && ip.isNotEmpty;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          topLine,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        if (showIp)
                          Text(
                            ip,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            body: SafeArea(child: body),
            bottomNavigationBar: FullVpnFooterNav(
              active: _tab,
              onTabChange: (t) {
                setState(() => _tab = t);
              },
            ),
          );
        },
      ),
    );
  }
}

class _LoginWebView extends StatefulWidget {
  final String initialUrl;
  final String deepLinkPrefix;
  final Future<void> Function(String token) onToken;

  const _LoginWebView({
    required this.initialUrl,
    required this.deepLinkPrefix,
    required this.onToken,
  });

  @override
  State<_LoginWebView> createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<_LoginWebView> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onNavigationRequest: (req) async {
            final url = req.url;
            if (url.startsWith(widget.deepLinkPrefix)) {
              final token = Uri.parse(url).queryParameters["token"] ?? "";
              if (token.isNotEmpty) {
                await widget.onToken(token);
              }
              if (mounted) Navigator.of(context).pop();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign in"),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading) const LinearProgressIndicator(),
        ],
      ),
    );
  }
}