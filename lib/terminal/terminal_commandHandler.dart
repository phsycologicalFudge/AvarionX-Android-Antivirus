typedef CommandHandler = Future<void> Function(
    String raw,
    bool forceCloud,
    void Function(String) emit,
    );

class TerminalCommand {
  final bool Function(String) matches;
  final CommandHandler run;

  TerminalCommand({
    required this.matches,
    required this.run,
  });
}
