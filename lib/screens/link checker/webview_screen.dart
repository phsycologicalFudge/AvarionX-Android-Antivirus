import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../widgets/antivirus_bridge.dart';

class SafeWebViewScreen extends StatefulWidget {
  final Uri uri;

  const SafeWebViewScreen({super.key, required this.uri});

  @override
  State<SafeWebViewScreen> createState() => _SafeWebViewScreenState();
}

class _SafeWebViewScreenState extends State<SafeWebViewScreen> {
  late final WebViewController _controller;
  final _av = AntivirusBridge();

  bool _blocked = false;
  bool _loading = true;
  String _blockedReason = 'Navigation blocked';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            _verifyAndLoad(request.url);
            return NavigationDecision.prevent;
          },
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() => _loading = true);
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _loading = false);
          },
        ),
      );

    _verifyAndLoad(widget.uri.toString());
  }

  int _defaultPort(Uri u) {
    final s = u.scheme.toLowerCase();
    if (s == 'http') return 80;
    return 443;
  }

  Future<void> _verifyAndLoad(String url) async {
    if (_blocked) return;

    final u = Uri.tryParse(url);
    if (u == null || u.host.isEmpty) {
      if (!mounted) return;
      setState(() {
        _blocked = true;
        _blockedReason = 'Invalid destination';
        _loading = false;
      });
      return;
    }

    final scheme = u.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') {
      if (!mounted) return;
      setState(() {
        _blocked = true;
        _blockedReason = 'Unsupported scheme';
        _loading = false;
      });
      return;
    }

    final port = u.hasPort ? u.port : _defaultPort(u);

    try {
      final addrs = await InternetAddress.lookup(u.host);
      final ip = addrs.isNotEmpty ? addrs.first.address : '';

      if (ip.isEmpty) {
        if (!mounted) return;
        setState(() {
          _blocked = true;
          _blockedReason = 'Unable to resolve destination';
          _loading = false;
        });
        return;
      }

      final verdict = _av.checkNetwork(ip, u.host, port);
      if (verdict != 0) {
        if (!mounted) return;
        setState(() {
          _blocked = true;
          _blockedReason = 'Destination blocked';
          _loading = false;
        });
        return;
      }

      await _controller.loadRequest(u);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _blocked = true;
        _blockedReason = 'Unable to verify destination';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: const Text('Safe View'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading && !_blocked)
            IgnorePointer(
              child: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 10),
                child: const LinearProgressIndicator(minHeight: 3),
              ),
            ),
          if (_blocked)
            Container(
              color: theme.colorScheme.surface,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.block_rounded, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(
                      _blockedReason,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This page was stopped before it could load.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
