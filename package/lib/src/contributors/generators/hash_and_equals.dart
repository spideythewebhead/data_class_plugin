import 'package:analyzer/dart/element/element.dart';
import 'package:data_class_plugin/src/backend/core/generators/generator.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';

class HashGenerator implements Generator {
  HashGenerator({
    required CodeWriter codeWriter,
    required List<VariableElement> fields,
  })  : _codeWriter = codeWriter,
        _fields = fields;

  final CodeWriter _codeWriter;
  final List<VariableElement> _fields;

  @override
  void execute() {
    _codeWriter
      ..writeln()
      ..writeln('/// Returns a hash code based on [this] properties')
      ..writeln('@override')
      ..writeln('int get hashCode {')
      ..writeln('return Object.hashAll(<Object?>[')
      ..writeln('runtimeType');

    for (final Element field in _fields) {
      _codeWriter.writeln(',${field.name}');
    }

    _codeWriter
      ..writeln(',]);')
      ..writeln('}');
  }
}

class EqualsGenerator implements Generator {
  EqualsGenerator({
    required CodeWriter codeWriter,
    required String className,
    required List<VariableElement> fields,
  })  : _codeWriter = codeWriter,
        _className = className,
        _fields = fields;

  final CodeWriter _codeWriter;
  final String _className;
  final List<VariableElement> _fields;

  @override
  void execute() {
    _codeWriter
      ..writeln()
      ..writeln('/// Compares [this] with [other] on identity, class type, and properties')
      ..writeln('/// *with deep comparison on collections*')
      ..writeln('@override')
      ..writeln('bool operator ==(Object? other) {')
      ..writeln(
          'return identical(this, other) || other is $_className && runtimeType == other.runtimeType');

    for (final VariableElement field in _fields) {
      if (field.type.isDartCoreList || field.type.isDartCoreMap || field.type.isDartCoreSet) {
        _codeWriter.write(' && deepEquality(${field.name}, other.${field.name})');
      } else {
        _codeWriter.write(' && ${field.name} == other.${field.name}');
      }
    }

    _codeWriter
      ..write(';')
      ..writeln('}');
  }
}
