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
    return replaceAllMapped(RegExp(r'(?<=(<|,\s*))(\w+)'), (Match match) {
      return '\$${match.group(2)}';
    });
  }

  /// Removes trailing whitespaces and carriage return characters.
  String normalizeWhitespaces() {
    return replaceFirst(RegExp(r'\s$'), '').replaceAll('\r', '');
  }

  String wrapWithAngleBracketsIfNotEmpty() {
    if (isEmpty) {
      return this;
    }
    return '<$this>';
  }
}
