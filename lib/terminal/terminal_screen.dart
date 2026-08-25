import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'settings/terminal_settings_screen.dart';
import 'terminal_controller.dart';

const _kBg      = Color(0xFF000000);
const _kBar     = Color(0xFF000000);
const _kBorder  = Color(0xFF1C1C1C);
const _kFg      = Color(0xFFD4D4D4);
const _kFgDim   = Color(0xFF4A4A4A);
const _kRed     = Color(0xFFE06C75);
const _kYellow  = Color(0xFFE5C07B);

enum ShellType { alpine }

final terminalRouteObserver = RouteObserver<ModalRoute<void>>();

class ConsoleScreen extends StatefulWidget {
  final bool isActive;
  const ConsoleScreen({super.key, required this.isActive});

  @override
  State<ConsoleScreen> createState() => _ConsoleScreenState();
}

class _ConsoleScreenState extends State<ConsoleScreen>
    with AutomaticKeepAliveClientMixin, RouteAware {

  static const _method = MethodChannel('ax_terminal');
  static const _events = EventChannel('ax_terminal_events');

  StreamSubscription<dynamic>? _eventSub;
  late final TerminalController _controller;
  final _pendingInjections = <String>[];
  bool _installing  = false;
  bool _sessionStarted = false;
  bool _spawnFailed = false;
  int  _viewKey     = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = TerminalController();
    _controller.init(_injectOutput);
    _eventSub = _events.receiveBroadcastStream().listen((event) {
      if (event is! String) return;
      if (event == 'shizuku_ready' && mounted) {
        setState(() {
          _sessionStarted = false;
          _spawnFailed    = false;
          _viewKey++;
        });
        _loadAndStart();
      } else if (event.startsWith('ax_cmd:')) {
        final cmd = event.substring(7);
        _controller.runCommand(cmd, _injectOutput);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAndStart());
  }

  Future<void> _loadAndStart() async {
    if (!mounted) return;
    await _startSession(ShellType.alpine);
  }

  Future<void> _startSession(ShellType shell) async {
    if (mounted) setState(() => _spawnFailed = false);
    try {
      await _method.invokeMethod('start', {'shell': shell.name});
      if (mounted) {
        setState(() => _sessionStarted = true);
        for (final line in _pendingInjections) {
          _method.invokeMethod('injectOutput', {'text': line});
        }
        _pendingInjections.clear();
        Future.delayed(const Duration(milliseconds: 150), () {
          _sendRaw('\x1b[0m\x1b[40m\x1b[2J\x1b[H');
        });
      }
    } on PlatformException catch (e) {
      if (e.code == 'NEEDS_ALPINE') {
        if (mounted) await _installAlpine();
      } else {
        if (mounted) setState(() => _spawnFailed = true);
        debugPrint('[AXTerminal] start failed: ${e.code} - ${e.message}');
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) terminalRouteObserver.subscribe(this, route);
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    terminalRouteObserver.unsubscribe(this);
    super.dispose();
  }

  void _sendRaw(String text) => _method.invokeMethod('write', {'text': text});
  void _sendTab()            => _sendRaw('\t');
  void _sendEsc()            => _sendRaw('\x1b');
  void _sendCtrlC()          => _method.invokeMethod('sendCtrlC');
  void _sendCtrlD()          => _method.invokeMethod('sendCtrlD');
  void _sendCtrlZ()          => _method.invokeMethod('sendCtrlZ');
  void _sendArrowUp()        => _sendRaw('\x1b[A');
  void _sendArrowDown()      => _sendRaw('\x1b[B');
  void _sendArrowLeft()      => _sendRaw('\x1b[D');
  void _sendArrowRight()     => _sendRaw('\x1b[C');
  void _sendHome()           => _sendRaw('\x1b[H');
  void _sendEnd()            => _sendRaw('\x1b[F');
  void _sendPageUp()         => _sendRaw('\x1b[5~');
  void _sendPageDown()       => _sendRaw('\x1b[6~');

  Future<void> _installAlpine() async {
    if (_installing) return;
    setState(() => _installing = true);
    try {
      await _method.invokeMethod<String>('installAlpine');
      if (mounted) {
        setState(() {
          _sessionStarted = false;
          _spawnFailed    = false;
          _viewKey++;
        });
      }
      await _method.invokeMethod('reset');
      if (mounted) await _startSession(ShellType.alpine);
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            e.message ?? 'install failed',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: _kFg,
            ),
          ),
          backgroundColor: _kBar,
          behavior: SnackBarBehavior.floating,
          elevation: 0,
        ));
      }
    } finally {
      if (mounted) setState(() => _installing = false);
    }
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TerminalSettingsScreen()),
    );
  }

  void _injectOutput(String line) {
    if (_sessionStarted) {
      _method.invokeMethod('injectOutput', {'text': line});
    } else {
      _pendingInjections.add(line);
    }
  }

  Widget _buildErrorView() {
    return Container(
      color: _kBg,
      padding: const EdgeInsets.all(20),
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            r'$ ax-terminal start',
            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: _kFgDim),
          ),
          const SizedBox(height: 6),
          const Text(
            'error: terminal environment not ready',
            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: _kRed),
          ),
          const Text(
            'hint:  check shizuku is running and try again',
            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: _kFgDim),
          ),
          const SizedBox(height: 16),
          _InlineButton(label: '[retry]', onTap: _loadAndStart, color: _kFg),
        ],
      ),
    );
  }

  Widget _buildTerminalView() {
    return PlatformViewLink(
      key: ValueKey(_viewKey),
      viewType: 'ax_terminal_view',
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: 'ax_terminal_view',
          layoutDirection: TextDirection.ltr,
          creationParams: const <String, dynamic>{},
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () => params.onFocusChanged(true),
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: _kBg,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: _kBg,
        body: SafeArea(
          child: Column(
            children: [
              _TitleBar(
                onBack:     () => Navigator.maybePop(context),
                onSettings: _openSettings,
              ),
              Expanded(
                child: _sessionStarted
                    ? _buildTerminalView()
                    : _spawnFailed
                    ? _buildErrorView()
                    : const Center(
                  child: Text(
                    'starting session...',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: _kFgDim,
                    ),
                  ),
                ),
              ),
              _KeyBar(
                onEsc:       _sendEsc,
                onTab:       _sendTab,
                onArrowUp:   _sendArrowUp,
                onArrowDown: _sendArrowDown,
                onArrowLeft: _sendArrowLeft,
                onArrowRight:_sendArrowRight,
                onHome:      _sendHome,
                onEnd:       _sendEnd,
                onPageUp:    _sendPageUp,
                onPageDown:  _sendPageDown,
                onCtrlC:     _sendCtrlC,
                onCtrlD:     _sendCtrlD,
                onCtrlZ:     _sendCtrlZ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSettings;
  const _TitleBar({required this.onBack, required this.onSettings});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: _kBar,
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: const SizedBox(
              width: 40,
              height: 36,
              child: Icon(Icons.chevron_left_rounded, color: _kFgDim, size: 18),
            ),
          ),
          Container(width: 1, height: 14, color: _kBorder),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'AX Terminal 3.0.0',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: _kFgDim,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
          GestureDetector(
            onTap: onSettings,
            behavior: HitTestBehavior.opaque,
            child: const SizedBox(
              width: 44,
              height: 36,
              child: Icon(Icons.tune_rounded, color: _kFgDim, size: 17),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyBar extends StatelessWidget {
  final VoidCallback onEsc, onTab;
  final VoidCallback onArrowUp, onArrowDown, onArrowLeft, onArrowRight;
  final VoidCallback onHome, onEnd, onPageUp, onPageDown;
  final VoidCallback onCtrlC, onCtrlD, onCtrlZ;

  const _KeyBar({
    required this.onEsc,
    required this.onTab,
    required this.onArrowUp,
    required this.onArrowDown,
    required this.onArrowLeft,
    required this.onArrowRight,
    required this.onHome,
    required this.onEnd,
    required this.onPageUp,
    required this.onPageDown,
    required this.onCtrlC,
    required this.onCtrlD,
    required this.onCtrlZ,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      color: _kBar,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _Key(label: 'ESC',  onTap: onEsc),
            _Div(),
            _Key(label: 'TAB',  onTap: onTab),
            _Div(),
            _Key(label: '↑',    onTap: onArrowUp),
            _Div(),
            _Key(label: '↓',    onTap: onArrowDown),
            _Div(),
            _Key(label: '←',    onTap: onArrowLeft),
            _Div(),
            _Key(label: '→',    onTap: onArrowRight),
            _Div(),
            _Key(label: 'HOME', onTap: onHome),
            _Div(),
            _Key(label: 'END',  onTap: onEnd),
            _Div(),
            _Key(label: 'PGUP', onTap: onPageUp),
            _Div(),
            _Key(label: 'PGDN', onTap: onPageDown),
            _Div(),
            _Key(label: '^C',   onTap: onCtrlC, color: _kRed),
            _Div(),
            _Key(label: '^D',   onTap: onCtrlD, color: _kYellow),
            _Div(),
            _Key(label: '^Z',   onTap: onCtrlZ, color: _kYellow),
          ],
        ),
      ),
    );
  }
}

class _Key extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _Key({required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color ?? _kFgDim,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

class _InlineButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const _InlineButton({required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: onTap == null ? _kFgDim : color,
        ),
      ),
    );
  }
}

class _Div extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 16, color: _kBorder);
}