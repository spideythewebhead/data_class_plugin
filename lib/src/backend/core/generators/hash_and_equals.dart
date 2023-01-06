import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/backend/core/custom_dart_type.dart';
import 'package:data_class_plugin/src/backend/core/declaration_info.dart';
import 'package:data_class_plugin/src/backend/core/generators/generator.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';

class HashGenerator implements Generator {
  HashGenerator({
    required CodeWriter codeWriter,
    required List<DeclarationInfo> fields,
    required bool skipCollections,
  })  : _codeWriter = codeWriter,
        _fields = fields,
        _skipCollections = skipCollections;

  final CodeWriter _codeWriter;
  final List<DeclarationInfo> _fields;
  final bool _skipCollections;

  @override
  void execute() {
    _codeWriter
      ..writeln()
      ..writeln('@override')
      ..writeln('int get hashCode {')
      ..writeln('return Object.hashAll(<Object?>[')
      ..writeln('runtimeType');

    for (final DeclarationInfo field in _fields) {
      if (_skipCollections && field.type.customDartType.isCollection) {
        continue;
      }
      _codeWriter.writeln(',${field.name}');
    }

    _codeWriter
      ..writeln(',]);')
      ..writeln('}')
      ..writeln();
  }
}

class EqualsGenerator implements Generator {
  EqualsGenerator({
    required CodeWriter codeWriter,
    required String className,
    required List<DeclarationInfo> fields,
  })  : _codeWriter = codeWriter,
        _className = className,
        _fields = fields;

  final CodeWriter _codeWriter;
  final String _className;
  final List<DeclarationInfo> _fields;

  @override
  void execute() {
    _codeWriter
      ..writeln()
      ..writeln('@override')
      ..writeln('bool operator ==(Object? other) {')
      ..writeln(
          'return identical(this, other) || other is $_className && runtimeType == other.runtimeType');

    for (final DeclarationInfo field in _fields) {
      if (field.metadata.any((Annotation element) => element.name.name == 'SkipHash')) {
        continue;
      }

      final CustomDartType dartType = field.type.customDartType;
      if (dartType.isList || dartType.isMap) {
        _codeWriter.write(' && deepEquality(${field.name}, other.${field.name})');
        continue;
      }
      _codeWriter.write(' && ${field.name} == other.${field.name}');
    }

    _codeWriter
      ..write(';')
      ..writeln('}')
      ..writeln();
  }
}
