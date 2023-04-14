import 'package:data_class_plugin/src/common/generator.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:tachyon/tachyon.dart';

class ToStringGenerator implements Generator {
  ToStringGenerator({
    required final CodeWriter codeWriter,
    required final List<DeclarationInfo> fields,
    required final String className,
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
