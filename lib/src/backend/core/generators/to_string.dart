import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';

void createToString({
  required final CodeWriter codeWriter,
  required final String className,
  required final List<MethodDeclaration> fields,
  required final String genericTypeArguments,
}) {
  codeWriter
    ..writeln('@override')
    ..writeln('String toString() {')
    ..writeln("String value = '$className{<optimized out>}';")
    ..writeln('assert(() {')
    ..write("value = '$className$genericTypeArguments@<\$hexIdentity>{");

  for (final MethodDeclaration field in fields) {
    final String fieldName = field.name.lexeme;

    codeWriter.write('${fieldName.escapeDollarSign()}: \$');

    if (fieldName.contains('\$')) {
      codeWriter.write('{$fieldName}');
    } else {
      codeWriter.write(fieldName);
    }

    if (field != fields.last) {
      codeWriter.write(', ');
    }
  }

  codeWriter
    ..writeln("}';")
    ..writeln('return true;')
    ..writeln('}());')
    ..writeln('return value;')
    ..writeln('}');
}
