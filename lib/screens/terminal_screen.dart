import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/theme/theme_manager.dart';
import '../terminal/terminal_controller.dart';
import '../widgets/mesh_background.dart';

class ConsoleScreen extends StatefulWidget {
  final bool isActive;

  const ConsoleScreen({
    super.key,
    required this.isActive,
  });

  @override
  State<ConsoleScreen> createState() => _ConsoleScreenState();
}

class _ConsoleScreenState extends State<ConsoleScreen>
    with AutomaticKeepAliveClientMixin {
  final TerminalController _terminal = TerminalController();
  final List<String> _log = [];

  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final FocusNode _focus = FocusNode();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _terminal.init(_emit);
  }

  void _emit(String line) {
    setState(() => _log.add(line));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _submit(String value) {
    final cmd = value.trim();
    if (cmd.isEmpty) return;

    _terminal.runCommand(cmd, _emit);
    _input.clear();
    _focus.requestFocus();
  }

  void _runButton() {
    final cmd = _input.text.trim();
    if (cmd.isEmpty) return;

    _terminal.runCommand(cmd, _emit);
    _input.clear();
    _focus.requestFocus();
  }

  @override
  void dispose() {
    _focus.dispose();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final themeManager = Provider.of<ThemeManager>(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: scheme.surface,
      body: MeshBackground(
        blobs: themeManager.meshBlobs,
        base: scheme.surface,
        child: SafeArea(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            opacity: widget.isActive ? 1.0 : 0.0,
            child: Column(
              children: [
                _TerminalTopBar(
                  title: 'AX Security Terminal',
                  onBack: () => Navigator.maybePop(context),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 2, 18, 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Local command console',
                      style: text.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.35,
                        color: scheme.onSurface.withOpacity(0.56),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black.withOpacity(0.26)
                            : scheme.surfaceContainerHighest.withOpacity(0.72),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: scheme.onSurface.withOpacity(
                            isDark ? 0.08 : 0.10,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.24 : 0.08),
                            blurRadius: 22,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: _log.isEmpty
                            ? _EmptyTerminalState(
                          color: scheme.primary,
                        )
                            : ListView.builder(
                          controller: _scroll,
                          physics: const BouncingScrollPhysics(),
                          padding:
                          const EdgeInsets.fromLTRB(14, 14, 14, 16),
                          itemCount: _log.length,
                          itemBuilder: (context, index) {
                            final line = _log[index];
                            final isPrompt = line.startsWith('AX@') ||
                                line.startsWith('>');

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: SelectableText(
                                line,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11.5,
                                  height: 1.32,
                                  letterSpacing: 0.1,
                                  color: isPrompt
                                      ? scheme.primary
                                      : scheme.onSurface.withOpacity(0.84),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                _TerminalInputBar(
                  controller: _input,
                  focusNode: _focus,
                  onSubmitted: _submit,
                  onRun: _runButton,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TerminalTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _TerminalTopBar({
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 18, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: onBack,
            color: scheme.onSurface.withOpacity(0.88),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: text.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                color: scheme.onSurface.withOpacity(0.88),
              ),
            ),
          ),
          Icon(
            Icons.terminal_rounded,
            size: 22,
            color: scheme.primary.withOpacity(0.92),
          ),
        ],
      ),
    );
  }
}

class _EmptyTerminalState extends StatelessWidget {
  final Color color;

  const _EmptyTerminalState({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.code_rounded,
              size: 34,
              color: color.withOpacity(0.88),
            ),
            const SizedBox(height: 12),
            Text(
              'Terminal ready',
              style: text.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.onSurface.withOpacity(0.88),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Run a command to view output here.',
              textAlign: TextAlign.center,
              style: text.bodySmall?.copyWith(
                height: 1.35,
                color: scheme.onSurface.withOpacity(0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TerminalInputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onRun;

  const _TerminalInputBar({
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.onRun,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? scheme.surfaceContainerHigh.withOpacity(0.82)
                : scheme.surfaceContainerHighest.withOpacity(0.88),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: scheme.onSurface.withOpacity(0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.20 : 0.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 11),
                  child: Text(
                    '>',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: scheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    maxLines: 4,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    cursorColor: scheme.primary,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12.5,
                      height: 1.32,
                      color: scheme.onSurface.withOpacity(0.88),
                    ),
                    decoration: InputDecoration(
                      hintText: 'enter command',
                      hintStyle: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12.5,
                        color: scheme.onSurface.withOpacity(0.42),
                      ),
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    ),
                    onSubmitted: onSubmitted,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 44,
                  height: 44,
                  child: FilledButton(
                    onPressed: onRun,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}