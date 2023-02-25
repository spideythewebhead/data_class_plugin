part of 'utils.dart';

class InOutFilesPair {
  /// Shorthand constructor
  InOutFilesPair({
    required this.input,
    required this.output,
  });

  final io.File input;
  final io.File output;
}
