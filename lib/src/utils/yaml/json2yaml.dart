import 'dart:convert';

import 'package:data_class_plugin/src/extensions/yaml_extensions.dart';
import 'package:yaml/yaml.dart';

class Json2YamlEncoder extends Converter<Object?, String> {
  Json2YamlEncoder({
    this.indent = '  ',
  });

  final String indent;
  final StringBuffer _buffer = StringBuffer();

  @override
  String convert(Object? input) {
    _parse(input);
    final String output = _buffer.toString();
    _buffer.clear();
    return output;
  }

  void _parse(Object? input, {int indentLevel = 0}) {
    if (input is Map) {
      for (final dynamic key in input.keys) {
        final dynamic value = input[key];

        _buffer.write(indent * indentLevel);

        if (value is Map) {
          _buffer.writeln('$key:');
          _parse(value, indentLevel: 1 + indentLevel);
        } else if (value is List) {
          _buffer.writeln('$key:');
          _parse(value, indentLevel: 1 + indentLevel);
        } else if (value is String) {
          _buffer.writeln("$key: '${value.normalize()}'");
        } else if (value is YamlScalar) {
          final String scalarValue = '${value.value}';

          switch (value.style) {
            case ScalarStyle.DOUBLE_QUOTED:
              _buffer.writeln('$key: "${scalarValue.normalize()}"');
              break;
            case ScalarStyle.SINGLE_QUOTED:
              _buffer.writeln("$key: '${scalarValue.normalize()}'");
              break;
            case ScalarStyle.ANY:
            case ScalarStyle.FOLDED:
            case ScalarStyle.LITERAL:
            case ScalarStyle.PLAIN:
              _buffer.writeln('$key: ${scalarValue.normalize()}');
              break;
          }
        } else {
          _buffer.writeln('$key: $value');
        }
      }
    } else if (input is List) {
      for (final Object value in input) {
        if (value is Map) {
          _parse(value, indentLevel: indentLevel);
        } else if (value is List) {
          _parse(value, indentLevel: indentLevel);
        }
      }
    } else if (input is String) {
      _buffer
        ..write(indent * indentLevel)
        ..writeln("'$input'");
    } else {
      _buffer
        ..write(indent * indentLevel)
        ..writeln(input);
    }
  }
}
