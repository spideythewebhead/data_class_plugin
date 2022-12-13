import 'package:data_class_plugin/src/backend/core/declaration_info.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';

void createToString({
  required final CodeWriter codeWriter,
  required final String className,
  required final List<DeclarationInfo> fields,
}) {
  codeWriter
    ..writeln('@override')
    ..writeln('String toString() {')
    ..writeln("String toStringOutput = '$className{<optimized out>}';")
    ..writeln('assert(() {')
    ..write("toStringOutput = '$className@<\$hexIdentity>{");

  for (final DeclarationInfo field in fields) {
    final String fieldName = field.name;

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
    ..writeln('return toStringOutput;')
    ..writeln('}');
}
