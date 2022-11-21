import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';

void createCopyWith({
  required final CodeWriter codeWriter,
  required final List<MethodDeclaration> fields,
  required final String generatedClassName,
}) {
  codeWriter
    ..writeln('@override')
    ..writeln('$generatedClassName copyWith(');

  if (fields.isNotEmpty) {
    codeWriter.write('{');
    for (final MethodDeclaration field in fields) {
      final String typeName = field.returnType?.toSource() ?? 'dynamic';
      final bool isNullableType = typeName != 'dynamic' && typeName.endsWith('?');

      codeWriter
        ..write('final ')
        ..write('$typeName${isNullableType ? '' : '?'}')
        ..write(' ')
        ..write(field.name.lexeme)
        ..write(',');
    }
    codeWriter.write('}');
  }

  codeWriter
    ..writeln(') {')
    ..writeln('return $generatedClassName(');

  for (final MethodDeclaration field in fields) {
    final String fieldName = field.name.lexeme;
    codeWriter.writeln('$fieldName: $fieldName ?? this.$fieldName,');
  }

  codeWriter
    ..writeln(');')
    ..writeln('}');
}
