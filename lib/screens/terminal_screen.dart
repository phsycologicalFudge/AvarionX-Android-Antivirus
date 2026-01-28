import 'package:flutter/material.dart';
import '../terminal/terminal_controller.dart';

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
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
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

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surfaceTint,
        elevation: 0,
        title: Text(
          "AX Security Terminal",
          style: TextStyle(
            fontFamily: "monospace",
            color: scheme.primary,
            fontSize: 13,
          ),
        ),
      ),
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        opacity: widget.isActive ? 1.0 : 0.0,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                itemCount: _log.length,
                itemBuilder: (context, index) {
                  final line = _log[index];
                  final isPrompt = line.startsWith('AX@') || line.startsWith('>');

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: SelectableText(
                      line,
                      style: TextStyle(
                        fontFamily: "monospace",
                        fontSize: 11,
                        height: 1.25,
                        color: isPrompt
                            ? scheme.primary
                            : theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Material(
                color: scheme.surfaceContainerHigh,
                surfaceTintColor: scheme.surfaceTint,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          ">",
                          style: TextStyle(
                            fontFamily: "monospace",
                            fontSize: 12,
                            color: scheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _input,
                          focusNode: _focus,
                          maxLines: 4,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          style: TextStyle(
                            fontFamily: "monospace",
                            fontSize: 12,
                            height: 1.3,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                          decoration: InputDecoration(
                            hintText: "enter command",
                            hintStyle: TextStyle(
                              fontFamily: "monospace",
                              fontSize: 12,
                              color: scheme.onSurface.withOpacity(0.5),
                            ),
                            filled: true,
                            fillColor: scheme.surfaceContainerHighest,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: scheme.outlineVariant,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: scheme.outlineVariant,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: scheme.primary.withOpacity(0.8),
                              ),
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                          ),
                          onSubmitted: _submit,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        onPressed: _runButton,
                        icon: Icon(
                          Icons.play_arrow_rounded,
                          size: 20,
                          color: scheme.onSurface,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
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
    );
  }
}
