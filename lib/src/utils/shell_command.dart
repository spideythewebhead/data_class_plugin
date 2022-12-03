import 'dart:io';

class ShellCommand {
  ShellCommand({
    required this.executable,
    required this.arguments,
    this.workingDirectory,
  });

  final String executable;
  final List<String> arguments;
  final String? workingDirectory;

  Future<ProcessResult> run({final bool runInShell = true}) async {
    return await Process.run(
      executable,
      arguments,
      runInShell: runInShell,
      workingDirectory: workingDirectory,
    );
  }
}
