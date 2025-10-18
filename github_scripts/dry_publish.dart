import 'dart:convert';
import 'dart:io';

final RegExp _warningMatcher = RegExp(r'Package has \d+ warnings?.');
final RegExp _numberMatcher = RegExp(r'\d+');

void main() {
  final ProcessResult dryRunProcess = Process.runSync('dart', <String>[
    'pub',
    'publish',
    '--dry-run',
  ]);

  if (dryRunProcess.exitCode == 0) {
    exit(0);
  }

  final List<String> reversedLines = LineSplitter.split(
    dryRunProcess.stderr as String,
  ).toList(growable: false).reversed.toList(growable: false);

  int packageWarningsCount = 0;
  for (String line in reversedLines) {
    if (!_warningMatcher.hasMatch(line)) {
      continue;
    }

    packageWarningsCount = int.parse(
      _numberMatcher.firstMatch(line)?.group(0) ?? '',
    );
    break;
  }

  for (final String line in reversedLines) {
    if (line == '* Rename the top-level "tools" directory to "tool".') {
      packageWarningsCount -= 1;
    }
  }

  if (packageWarningsCount > 1) {
    exit(1);
  }

  exit(0);
}
