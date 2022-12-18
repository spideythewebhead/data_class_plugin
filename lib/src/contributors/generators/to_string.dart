import 'package:analyzer/dart/element/element.dart';
import 'package:data_class_plugin/src/backend/core/generators/generator.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';

class ToStringGenerator implements Generator {
  ToStringGenerator({
    required CodeWriter codeWriter,
    required String className,
    required String commentClassName,
    required String optimizedClassName,
    required List<VariableElement> fields,
  })  : _codeWriter = codeWriter,
        _className = className,
        _commentClassName = commentClassName,
        _optimizedClassName = optimizedClassName,
        _fields = fields;

  final CodeWriter _codeWriter;
  final String _className;
  final String _commentClassName;
  final String _optimizedClassName;
  final List<VariableElement> _fields;

  @override
  void execute() {
    _codeWriter
      ..writeln()
      ..writeln('/// Returns a string with the properties of [$_commentClassName]')
      ..writeln('@override')
      ..writeln('String toString() {')
      ..writeln("String value = '$_optimizedClassName{<optimized out>}';")
      ..writeln('assert(() {')
      ..write("value = '$_className@<\$hexIdentity>{");

    for (final VariableElement field in _fields) {
      _codeWriter.write('${field.name.escapeDollarSign()}: \$');

      if (field.name.contains('\$')) {
        _codeWriter.write('{${field.name}}');
      } else {
        _codeWriter.write(field.name);
      }

      if (field != _fields.last) {
        _codeWriter.write(', ');
      }
    }

    _codeWriter
      ..writeln("}';")
      ..writeln('return true;')
      ..writeln('}());')
      ..writeln('return value;')
      ..writeln('}');
  }
}
