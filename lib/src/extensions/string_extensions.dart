import 'package:dart_style/dart_style.dart' show DartFormatter;

extension StringX on String {
  String snakeCaseToCamelCase() {
    return replaceAllMapped(RegExp(r'_([a-z])'), (Match match) {
      return match.group(1)!.toUpperCase();
    });
  }

  /// Escape $ with \$
  String escapeDollarSign() {
    return replaceAllMapped('\$', (Match match) {
      return '\\${match.group(0)}';
    });
  }

  String prefixGenericArgumentsWithDollarSign() {
    return replaceAllMapped(
      RegExp(r'(?<=(<|,\s*))(\w+)'),
      (Match match) {
        return '\$${match.group(2)}';
      },
    );
  }

  /// Removes trailing whitespaces and carriage return characters.
  String normalizeWhitespaces() {
    return replaceFirst(RegExp(r'\s$'), '').replaceAll('\r', '');
  }

  /// Returns a string formatted using [DartFormatter]
  ///
  /// This is a workaround for generated code by the contributors,
  /// as the generated code in test has always length of 80 characters.
  String dartFormat({int lineLength = 100}) {
    return DartFormatter(pageWidth: lineLength).format(this).normalizeWhitespaces();
  }

  String wrapWithAngleBracketsIfNotEmpty() {
    if (isEmpty) {
      return this;
    }
    return '<$this>';
  }
}
