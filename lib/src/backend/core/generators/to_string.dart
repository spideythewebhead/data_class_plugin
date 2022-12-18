import 'package:data_class_plugin/src/backend/core/declaration_info.dart';
import 'package:data_class_plugin/src/backend/core/generators/generator.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';

class ToStringGenerator implements Generator {
  ToStringGenerator({
    required CodeWriter codeWriter,
    required List<DeclarationInfo> fields,
    required String className,
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
      ..writeln('String toString() {')
      ..writeln("String toStringOutput = '$_className{<optimized out>}';")
      ..writeln('assert(() {')
      ..write("toStringOutput = '$_className@<\$hexIdentity>{");

    for (final DeclarationInfo field in _fields) {
      final String fieldName = field.name;

      _codeWriter.write('${fieldName.escapeDollarSign()}: \$');

      if (fieldName.contains('\$')) {
        _codeWriter.write('{$fieldName}');
      } else {
        _codeWriter.write(fieldName);
      }

      if (field != _fields.last) {
        _codeWriter.write(', ');
      }
    }

    _codeWriter
      ..writeln("}';")
      ..writeln('return true;')
      ..writeln('}());')
      ..writeln('return toStringOutput;')
      ..writeln('}');
  }
}
