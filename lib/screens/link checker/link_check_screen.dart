import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../services/av_engine.dart';
import '../../widgets/antivirus_bridge.dart';

class LinkCheckScreen extends StatefulWidget {
  const LinkCheckScreen({super.key});

  @override
  State<LinkCheckScreen> createState() => _LinkCheckScreenState();
}

class _LinkCheckScreenState extends State<LinkCheckScreen> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _av = AntivirusBridge();

  late final TabController _tabs;

  bool _checking = false;
  bool? _isSafe;
  Uri? _checkedUri;

  bool _viewUnlocked = false;
  bool _revealPage = false;

  WebViewController? _web;
  bool _webBlocked = false;
  bool _webLoading = false;
  String _analyseDetail = 'Verifying link…';
  String _webBlockedReason = 'Navigation blocked';

  final List<_HistoryItem> _history = [];
  static const int _historyMax = 250;

  File? _historyFile;
  Timer? _historySaveDebounce;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    Future.microtask(_loadHistory);
  }

  @override
  void dispose() {
    _historySaveDebounce?.cancel();
    _controller.dispose();
    _tabs.dispose();
    super.dispose();
  }

  Future<File> _getHistoryFile() async {
    if (_historyFile != null) return _historyFile!;
    final dir = await getApplicationDocumentsDirectory();
    final f = File('${dir.path}/link_history.txt');
    _historyFile = f;
    return f;
  }

  Future<void> _loadHistory() async {
    try {
      final f = await _getHistoryFile();
      if (!await f.exists()) return;

      final lines = await f.readAsLines();
      final items = <_HistoryItem>[];

      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split('\t');
        if (parts.length < 3) continue;

        final ts = int.tryParse(parts[0]);
        final safeFlag = parts[1];
        final url = parts.sublist(2).join('\t');

        if (ts == null) continue;

        items.add(
          _HistoryItem(
            url: url,
            safe: safeFlag == '1',
            when: DateTime.fromMillisecondsSinceEpoch(ts),
          ),
        );
      }

      items.sort((a, b) => b.when.compareTo(a.when));
      if (items.length > _historyMax) {
        items.removeRange(_historyMax, items.length);
      }

      if (!mounted) return;
      setState(() {
        _history
          ..clear()
          ..addAll(items);
      });
    } catch (_) {}
  }

  void _scheduleHistorySave() {
    _historySaveDebounce?.cancel();
    _historySaveDebounce = Timer(const Duration(milliseconds: 350), () async {
      try {
        final f = await _getHistoryFile();
        final b = StringBuffer();

        final items = _history.length > _historyMax ? _history.sublist(0, _historyMax) : _history;
        for (final h in items) {
          final ts = h.when.millisecondsSinceEpoch;
          final safe = h.safe ? '1' : '0';
          b.writeln('$ts\t$safe\t${h.url}');
        }

        await f.writeAsString(b.toString(), flush: true);
      } catch (_) {}
    });
  }

  void _addHistory(Uri u, bool safe) {
    _history.insert(
      0,
      _HistoryItem(
        url: u.toString(),
        safe: safe,
        when: DateTime.now(),
      ),
    );

    if (_history.length > _historyMax) {
      _history.removeRange(_historyMax, _history.length);
    }

    _scheduleHistorySave();
  }

  Uri? _parseUrl(String input) {
    final raw = input.trim();
    if (raw.isEmpty) return null;

    try {
      final u = Uri.parse(raw);
      if (u.scheme.isEmpty) return Uri.parse('https://$raw');
      return u;
    } catch (_) {
      return null;
    }
  }

  int _defaultPort(Uri u) {
    final s = u.scheme.toLowerCase();
    if (s == 'http') return 80;
    return 443;
  }

  bool _sameSite(String a, String b) {
    final ah = a.toLowerCase();
    final bh = b.toLowerCase();
    if (ah == bh) return true;
    if (ah == 'www.$bh') return true;
    if (bh == 'www.$ah') return true;
    return false;
  }

  Future<void> _checkLink() async {
    if (_checking) return;

    if (!AvEngine.isInitialized) {
      setState(() {
        _isSafe = null;
        _checkedUri = null;
        _viewUnlocked = false;
        _revealPage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Engine not ready')),
      );
      return;
    }

    final u = _parseUrl(_controller.text);
    if (u == null || u.host.isEmpty) {
      setState(() {
        _isSafe = null;
        _checkedUri = null;
        _viewUnlocked = false;
        _revealPage = false;
      });
      return;
    }

    final minDelayMs = 650 + (DateTime.now().microsecondsSinceEpoch % 400);
    final minAnalyseTime = Duration(milliseconds: minDelayMs);
    final analyseStart = DateTime.now();

    setState(() {
      _checking = true;
      _analyseDetail = 'Verifying link…';
      _isSafe = null;
      _checkedUri = u;
      _viewUnlocked = true;
      _revealPage = false;
      _webBlocked = false;
      _webLoading = false;
      _webBlockedReason = 'Navigation blocked';
    });

    try {
      await Future.delayed(const Duration(milliseconds: 180));
      if (!mounted) return;
      setState(() => _analyseDetail = 'Scanning page…');

      final addrs = await InternetAddress.lookup(u.host);
      final ip = addrs.isNotEmpty ? addrs.first.address : '';
      if (ip.isEmpty) {
        if (!mounted) return;
        setState(() {
          _checking = false;
          _isSafe = null;
          _viewUnlocked = false;
        });
        return;
      }

      final port = u.hasPort ? u.port : _defaultPort(u);
      final verdict = _av.checkNetwork(ip, u.host, port);
      final safe = verdict == 0;

      final elapsed = DateTime.now().difference(analyseStart);
      if (elapsed < minAnalyseTime) {
        await Future.delayed(minAnalyseTime - elapsed);
      }

      if (!mounted) return;

      setState(() {
        _checking = false;
        _isSafe = safe;
        _viewUnlocked = true;
      });

      _addHistory(u, safe);

      await _ensureWebViewController();
      await _verifyAndLoad(u.toString());
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _checking = false;
        _isSafe = null;
        _viewUnlocked = false;
      });
    }
  }

  Future<void> _ensureWebViewController() async {
    if (_web != null) return;

    final w = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final cur = _checkedUri;
            final u = Uri.tryParse(request.url);
            if (cur == null || u == null || u.host.isEmpty) return NavigationDecision.prevent;

            final scheme = u.scheme.toLowerCase();
            if (scheme != 'http' && scheme != 'https') {
              if (mounted) {
                setState(() {
                  _webBlocked = true;
                  _webBlockedReason = 'Unsupported link type';
                  _webLoading = false;
                });
              }
              return NavigationDecision.prevent;
            }

            if (_sameSite(u.host, cur.host)) {
              return NavigationDecision.navigate;
            }

            _verifyAndLoad(request.url);
            return NavigationDecision.prevent;
          },
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() => _webLoading = true);
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _webLoading = false);
          },
        ),
      );

    _web = w;
  }

  Future<void> _verifyAndLoad(String url) async {
    if (_web == null) return;
    if (_webBlocked) return;
    if (!AvEngine.isInitialized) return;

    final u = Uri.tryParse(url);
    if (u == null || u.host.isEmpty) {
      if (!mounted) return;
      setState(() {
        _webBlocked = true;
        _webBlockedReason = 'Invalid destination';
        _webLoading = false;
      });
      return;
    }

    final scheme = u.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') {
      if (!mounted) return;
      setState(() {
        _webBlocked = true;
        _webBlockedReason = 'Unsupported link type';
        _webLoading = false;
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
          _webBlocked = true;
          _webBlockedReason = 'Unable to resolve destination';
          _webLoading = false;
        });
        return;
      }

      final verdict = _av.checkNetwork(ip, u.host, port);
      if (!mounted) return;

      setState(() {
        _isSafe = verdict == 0;
        _checkedUri = u;
      });

      await _web!.loadRequest(u);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _webBlocked = true;
        _webBlockedReason = 'Unable to verify destination';
        _webLoading = false;
      });
    }
  }

  void _tryOpenViewTab(int index) {
    _tabs.animateTo(index);
  }

  Future<void> _copy(String v) async {
    await Clipboard.setData(ClipboardData(text: v));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied')),
    );
  }

  Widget _analyseTab(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    String title = 'Check page for suspicious content ';
    String detail = 'Paste a URL and run an analysis.';
    IconData icon = Icons.link_rounded;

    if (!AvEngine.isInitialized) {
      title = 'Engine not ready';
      detail = 'error 1001.';
      icon = Icons.warning_amber_rounded;
    } else if (_checking) {
      title = 'Checking';
      detail = _analyseDetail;
      icon = Icons.hourglass_top_rounded;
    } else if (_isSafe == true) {
      title = 'Clean';
      detail = 'This page appears to be safe.';
      icon = Icons.verified_user;
    } else if (_isSafe == false) {
      title = 'Suspicious';
      detail = 'This page contains suspicious content.';
      icon = Icons.block_rounded;
    }

    Color accent;
    if (!AvEngine.isInitialized) {
      accent = Colors.orangeAccent;
    } else if (_checking) {
      accent = theme.colorScheme.primary;
    } else if (_isSafe == true) {
      accent = Colors.greenAccent;
    } else if (_isSafe == false) {
      accent = Colors.redAccent;
    } else {
      accent = theme.colorScheme.onSurface.withOpacity(0.6);
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analyse',
                  style: text.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Check page for malware or suspicious content',
                  style: text.bodySmall?.copyWith(
                    height: 1.35,
                    color: text.bodySmall?.color?.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => AvEngine.isInitialized ? _checkLink() : null,
                  decoration: InputDecoration(
                    labelText: 'URL',
                    hintText: 'https://example.com',
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: AvEngine.isInitialized && !_checking ? _checkLink : null,
                    icon: Icon(
                      _checking ? Icons.hourglass_top_rounded : Icons.search_rounded,
                      size: 18,
                    ),
                    label: Text(_checking ? 'Checking' : 'Analyse'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Card(
                  color: theme.colorScheme.surfaceContainerHigh,
                  elevation: 10,
                  shadowColor: Colors.black.withOpacity(0.25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: accent.withOpacity(0.16),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(icon, color: accent, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                title,
                                style: text.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: theme.colorScheme.onSurface.withOpacity(0.9),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          detail,
                          style: text.bodySmall?.copyWith(
                            height: 1.35,
                            color: text.bodySmall?.color?.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Powered by VX-TITANIUM',
            style: text.bodySmall?.copyWith(
              fontSize: 11,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.32),
            ),
          ),
        ),
      ],
    );
  }

  Widget _viewTab(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    final unlocked = _viewUnlocked && _checkedUri != null;

    if (!unlocked) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'View',
              style: text.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Run an analysis first to enable viewing.',
              style: text.bodySmall?.copyWith(
                height: 1.35,
                color: text.bodySmall?.color?.withOpacity(0.75),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'View',
            style: text.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'View the webpage safely',
            style: text.bodySmall?.copyWith(
              height: 1.35,
              color: text.bodySmall?.color?.withOpacity(0.75),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  Container(
                    color: theme.colorScheme.surfaceContainerHigh,
                    child: _web == null
                        ? const SizedBox.shrink()
                        : WebViewWidget(controller: _web!),
                  ),
                  if (_webLoading && !_webBlocked)
                    IgnorePointer(
                      child: Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 10),
                        child: const LinearProgressIndicator(minHeight: 3),
                      ),
                    ),
                  if (_webBlocked)
                    Container(
                      color: theme.colorScheme.surface,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.block_rounded, size: 48, color: Colors.redAccent),
                            const SizedBox(height: 14),
                            Text(
                              _webBlockedReason,
                              style: text.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: theme.colorScheme.onSurface.withOpacity(0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'This page was stopped before it could load.',
                              style: text.bodySmall?.copyWith(
                                height: 1.35,
                                color: text.bodySmall?.color?.withOpacity(0.75),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 14),
                            OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!_revealPage && !_webBlocked)
                    Positioned.fill(
                      child: Container(
                        color: theme.colorScheme.surface.withOpacity(0.95),
                        child: Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() => _revealPage = true);
                                },
                                icon: const Icon(Icons.visibility_rounded, size: 18),
                                label: const Text('View page'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (_isSafe == false && !_webBlocked && _revealPage)
                    Positioned(
                      left: 12,
                      right: 12,
                      top: 12,
                      child: IgnorePointer(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant.withOpacity(0.8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, size: 18, color: Colors.orangeAccent),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Suspicious link, May not render if it requires blocked content.',
                                  style: text.bodySmall?.copyWith(
                                    height: 1.25,
                                    color: theme.colorScheme.onSurface.withOpacity(0.85),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyTab(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'History',
            style: text.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap an entry to copy the link.',
            style: text.bodySmall?.copyWith(
              height: 1.35,
              color: text.bodySmall?.color?.withOpacity(0.75),
            ),
          ),
          const SizedBox(height: 14),
          if (_history.isEmpty)
            Card(
              color: theme.colorScheme.surfaceContainerHigh,
              elevation: 10,
              shadowColor: Colors.black.withOpacity(0.25),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No checks yet.',
                  style: text.bodySmall?.copyWith(
                    color: text.bodySmall?.color?.withOpacity(0.75),
                  ),
                ),
              ),
            )
          else
            ..._history.map((h) {
              final accent = h.safe ? Colors.greenAccent : Colors.redAccent;
              final icon = h.safe ? Icons.verified_user : Icons.block_rounded;

              final when = '${h.when.year.toString().padLeft(4, '0')}-'
                  '${h.when.month.toString().padLeft(2, '0')}-'
                  '${h.when.day.toString().padLeft(2, '0')} '
                  '${h.when.hour.toString().padLeft(2, '0')}:'
                  '${h.when.minute.toString().padLeft(2, '0')}';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  color: theme.colorScheme.surfaceContainerHigh,
                  elevation: 10,
                  shadowColor: Colors.black.withOpacity(0.25),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => _copy(h.url),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: accent.withOpacity(0.16),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: accent, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  h.safe ? 'Clean' : 'Suspicious',
                                  style: text.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: theme.colorScheme.onSurface.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  h.url,
                                  style: text.bodySmall?.copyWith(
                                    height: 1.35,
                                    color: text.bodySmall?.color?.withOpacity(0.75),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  when,
                                  style: text.bodySmall?.copyWith(
                                    color: text.bodySmall?.color?.withOpacity(0.55),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Icon(
                              Icons.content_copy_rounded,
                              size: 20,
                              color: theme.iconTheme.color?.withOpacity(0.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final viewTabOpacity = (_checkedUri != null) ? 1.0 : 0.45;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: const Text('Link Checker'),
        bottom: TabBar(
          controller: _tabs,
          onTap: _tryOpenViewTab,
          tabs: [
            const Tab(text: 'Analyse'),
            Tab(
              child: Opacity(
                opacity: viewTabOpacity,
                child: const Text('View'),
              ),
            ),
            const Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _analyseTab(context),
          _viewTab(context),
          _historyTab(context),
        ],
      ),
    );
  }
}

class _HistoryItem {
  final String url;
  final bool safe;
  final DateTime when;

  _HistoryItem({
    required this.url,
    required this.safe,
    required this.when,
  });
}
