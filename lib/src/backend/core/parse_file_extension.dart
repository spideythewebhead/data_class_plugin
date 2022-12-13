import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/error/error.dart';
import 'package:data_class_plugin/src/tools/logger/ansi.dart';

extension ParseFileX on String {
  ParseStringResult parse({
    required FeatureSet featureSet,
  }) {
    final ParseStringResult result = parseFile(
      path: this,
      featureSet: featureSet,
      throwIfDiagnostics: false,
    );

    if (result.errors.isNotEmpty) {
      throw ParseException(result.errors);
    }

    return result;
  }
}

class ParseException implements Exception {
  const ParseException(this.errors);

  final List<AnalysisError> errors;

  @override
  String toString() {
    return errors.map((AnalysisError error) {
      final StringBuffer buffer = StringBuffer()..writeln();

      buffer
        ..writeln('Severity: ${error.severity.name.capitalize().red()}')
        ..write('File: ')
        ..writeln(error.source.fullName.bold())
        ..write('Error: ')
        ..writeln(error.message.red());
      if (error.correction != null) {
        buffer
          ..write('Possible solution: ')
          ..writeln(error.correctionMessage!.green());
      }

      return buffer.toString();
    }).join('\n');
  }
}

extension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    if (length == 1) {
      return toUpperCase();
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
