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
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bg = theme.scaffoldBackgroundColor;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
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
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                color: bg,
                child: ListView.builder(
                  controller: _scroll,
                  itemCount: _log.length,
                  itemBuilder: (context, index) {
                    final line = _log[index];
                    final isPrompt = line.startsWith('AX@') || line.startsWith('>');

                    return SelectableText(
                      line,
                      style: TextStyle(
                        fontFamily: "monospace",
                        fontSize: 11,
                        height: 1.25,
                        color: isPrompt
                            ? scheme.primary
                            : theme.textTheme.bodyMedium?.color,
                      ),
                    );
                  },
                ),
              ),
            ),

            Container(
              color: theme.cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ">",
                    style: TextStyle(
                      fontFamily: "monospace",
                      fontSize: 12,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: _input,
                      maxLines: null,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      style: TextStyle(
                        fontFamily: "monospace",
                        fontSize: 12,
                        height: 1.3,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      decoration: const InputDecoration(
                        hintText: "enter command",
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: _submit,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    onPressed: () {
                      final cmd = _input.text.trim();
                      if (cmd.isEmpty) return;
                      _terminal.runCommand(cmd, _emit);
                      _input.clear();
                    },
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      size: 20,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
