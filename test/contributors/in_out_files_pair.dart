import 'dart:io' show File;

class InOutFilesPair {
  /// Shorthand constructor
  InOutFilesPair({
    required this.input,
    required this.output,
  });

  final File input;
  final File output;
}
