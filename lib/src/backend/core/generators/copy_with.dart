import 'package:data_class_plugin/src/backend/core/declaration_info.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';

void createCopyWith({
  required final CodeWriter codeWriter,
  required final List<DeclarationInfo> fields,
  required final String generatedClassName,
  final bool shouldAnnotateWithOverride = true,
}) {
  codeWriter
    ..writeln(shouldAnnotateWithOverride ? '@override' : '')
    ..writeln('$generatedClassName copyWith(');

  if (fields.isNotEmpty) {
    codeWriter.write('{');
    for (final DeclarationInfo field in fields) {
      final String typeName = field.type?.toSource() ?? 'dynamic';
      final bool isNullableType = typeName != 'dynamic' && typeName.endsWith('?');

      codeWriter
        ..write('final ')
        ..write('$typeName${isNullableType ? '' : '?'}')
        ..write(' ')
        ..write(field.name)
        ..write(',');
    }
    codeWriter.write('}');
  }

  codeWriter
    ..writeln(') {')
    ..writeln('return $generatedClassName(');

  for (final DeclarationInfo field in fields) {
    final String fieldName = field.name;
    codeWriter.writeln('$fieldName: $fieldName ?? this.$fieldName,');
  }

  codeWriter
    ..writeln(');')
    ..writeln('}');
}
