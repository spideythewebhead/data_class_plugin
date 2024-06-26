import 'package:data_class_plugin/src/common/generator.dart';
import 'package:tachyon/tachyon.dart';

class HashGenerator implements Generator {
  HashGenerator({
    required final CodeWriter codeWriter,
    required final List<DeclarationInfo> fields,
    required final bool skipCollections,
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
    required final CodeWriter codeWriter,
    required final String className,
    required final String classTypeParametersWithoutConstraints,
    required final List<DeclarationInfo> fields,
  })  : _codeWriter = codeWriter,
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
          'return identical(this, other) || other is $_className$_classTypeParametersWithoutConstraints && runtimeType == other.runtimeType');

    for (final DeclarationInfo field in _fields) {
      if (field.metadata.any((Annotation element) => element.name.name == 'SkipHash')) {
        continue;
      }

      final TachyonDartType dartType = field.type.customDartType;
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
