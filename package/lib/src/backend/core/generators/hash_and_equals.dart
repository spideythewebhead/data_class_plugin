import 'package:data_class_plugin/src/common/generator.dart';
import 'package:tachyon/tachyon.dart';

class HashGenerator implements Generator {
  HashGenerator({
    required final CodeWriter codeWriter,
    required final List<DeclarationInfo> fields,
  }) : _codeWriter = codeWriter,
       _fields = fields;

  final CodeWriter _codeWriter;
  final List<DeclarationInfo> _fields;

  @override
  void execute() {
    _codeWriter
      ..writeln()
      ..writeln('@override')
      ..writeln('int get hashCode {')
      ..writeln('return Object.hashAll(<Object?>[')
      ..writeln('runtimeType');

    for (final DeclarationInfo field in _fields) {
      if (_isSkipped(field)) {
        continue;
      }

      // Collections are compared by content in the generated ==, so they must be
      // hashed by content as well. Otherwise equal objects could get different
      // hash codes.
      if (_isComparedByContent(field.type.customDartType)) {
        _codeWriter.writeln(',deepHash(${field.name})');
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
    required final CodeWriter codeWriter,
    required final String className,
    required final String classTypeParametersWithoutConstraints,
    required final List<DeclarationInfo> fields,
  }) : _codeWriter = codeWriter,
       _className = className,
       _classTypeParametersWithoutConstraints = classTypeParametersWithoutConstraints,
       _fields = fields;

  final CodeWriter _codeWriter;
  final String _className;
  final String _classTypeParametersWithoutConstraints;
  final List<DeclarationInfo> _fields;

  @override
  void execute() {
    _codeWriter
      ..writeln()
      ..writeln('@override')
      ..writeln('bool operator ==(Object other) {')
      ..writeln(
        'return identical(this, other) || other is $_className$_classTypeParametersWithoutConstraints && runtimeType == other.runtimeType',
      );

    for (final DeclarationInfo field in _fields) {
      if (_isSkipped(field)) {
        continue;
      }

      final TachyonDartType dartType = field.type.customDartType;
      if (_isComparedByContent(dartType)) {
        _codeWriter.write(
          ' && deepEquality(${field.name}, other.${field.name})',
        );
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

/// Whether [field] is left out of the generated == and hashCode.
bool _isSkipped(final DeclarationInfo field) {
  return field.metadata.any((Annotation element) => element.name.name == 'SkipHash');
}

/// Whether the generated == and hashCode compare [dartType] by content.
bool _isComparedByContent(final TachyonDartType dartType) {
  return dartType.isList || dartType.isMap || dartType.name == 'Set';
}
