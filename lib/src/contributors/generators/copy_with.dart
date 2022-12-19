import 'package:analyzer/dart/element/element.dart';
import 'package:data_class_plugin/src/backend/core/generators/generator.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';

class CopyWithGenerator implements Generator {
  CopyWithGenerator({
    required CodeWriter codeWriter,
    required String className,
    required String commentClassName,
    required ClassElement classElement,
    required List<VariableElement> fields,
    required bool annotateWithOverride,
  })  : _codeWriter = codeWriter,
        _className = className,
        _commentClassName = commentClassName,
        _classElement = classElement,
        _fields = fields,
        _annotateWithOverride = annotateWithOverride;

  final CodeWriter _codeWriter;
  final String _className;
  final String _commentClassName;
  final ClassElement _classElement;
  final List<VariableElement> _fields;
  final bool _annotateWithOverride;

  @override
  void execute() {
    final ConstructorElement? defaultConstructor = _classElement.defaultConstructor;
    final bool isConst = defaultConstructor?.isConst ?? false;

    _codeWriter
      ..writeln()
      ..writeln('/// Creates a new instance of [$_commentClassName] with optional new values');

    if (_annotateWithOverride) {
      _codeWriter.writeln('@override');
    }

    _codeWriter.writeln('$_className copyWith(');

    if (_fields.isNotEmpty) {
      _codeWriter.write('{');
      for (final VariableElement field in _fields) {
        final String typeStringValue =
            field.type.typeStringValue(enclosingImports: _classElement.library.libraryImports);
        final bool isNullable = typeStringValue.endsWith('?');
        _codeWriter.writeln('final $typeStringValue${isNullable ? '' : '?'} ${field.name},');
      }
      _codeWriter.write('}');
    }
    _codeWriter.writeln(') {');

    if (isConst && _fields.isEmpty) {
      _codeWriter
        ..writeln('    // ignore: prefer_const_constructors')
        ..writeln('return $_className();')
        ..writeln('}');
      return;
    }

    _codeWriter.writeln('return $_className(');

    for (final VariableElement field in _fields) {
      _codeWriter.writeln('${field.name}: ${field.name} ?? this.${field.name},');
    }

    _codeWriter
      ..writeln(');')
      ..writeln('}');
  }
}
