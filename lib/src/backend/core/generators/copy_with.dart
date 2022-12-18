import 'package:data_class_plugin/src/backend/core/declaration_info.dart';
import 'package:data_class_plugin/src/backend/core/generators/generator.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';

class CopyWithGenerator implements Generator {
  CopyWithGenerator({
    required final CodeWriter codeWriter,
    required final List<DeclarationInfo> fields,
    required final String generatedClassName,
    final bool shouldAnnotateWithOverride = true,
  })  : _codeWriter = codeWriter,
        _generatedClassName = generatedClassName,
        _fields = fields,
        _shouldAnnotateWithOverride = shouldAnnotateWithOverride;

  final CodeWriter _codeWriter;
  final String _generatedClassName;
  final List<DeclarationInfo> _fields;
  final bool _shouldAnnotateWithOverride;

  @override
  void execute() {
    _codeWriter
      ..writeln()
      ..writeln(_shouldAnnotateWithOverride ? '@override' : '')
      ..writeln('$_generatedClassName copyWith(');

    if (_fields.isNotEmpty) {
      _codeWriter.write('{');
      for (final DeclarationInfo field in _fields) {
        final String typeName = field.type?.toSource() ?? 'dynamic';
        final bool isNullableType = typeName != 'dynamic' && typeName.endsWith('?');

        _codeWriter
          ..write('final ')
          ..write('$typeName${isNullableType ? '' : '?'}')
          ..write(' ')
          ..write(field.name)
          ..write(',');
      }
      _codeWriter.write('}');
    }

    _codeWriter
      ..writeln(') {')
      ..writeln('return $_generatedClassName(');

    for (final DeclarationInfo field in _fields) {
      final String fieldName = field.name;
      _codeWriter.writeln('$fieldName: $fieldName ?? this.$fieldName,');
    }

    _codeWriter
      ..writeln(');')
      ..writeln('}');
  }
}
