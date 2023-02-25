import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:data_class_plugin/src/annotations/json_key_internal.dart';
import 'package:data_class_plugin/src/backend/core/generators/generator.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/contributors/class/utils.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/json_key_name_convention.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';

class ToJsonGenerator implements Generator {
  ToJsonGenerator({
    required CodeWriter codeWriter,
    required String className,
    required List<VariableElement> fields,
    required bool Function(DartType dartType)? checkIfShouldUseToJson,
    required List<LibraryImportElement> libraryImports,
    required String targetFileRelativePath,
    required DataClassPluginOptions pluginOptions,
    required bool annotateWithOverride,
  })  : _codeWriter = codeWriter,
        _className = className,
        _checkIfShouldUseToJson = checkIfShouldUseToJson,
        _libraryImports = libraryImports,
        _fields = fields,
        _targetFileRelativePath = targetFileRelativePath,
        _pluginOptions = pluginOptions,
        _annotateWithOverride = annotateWithOverride;

  final CodeWriter _codeWriter;
  final String _className;
  final List<VariableElement> _fields;
  final bool Function(DartType dartType)? _checkIfShouldUseToJson;
  final List<LibraryImportElement> _libraryImports;
  final String _targetFileRelativePath;
  final DataClassPluginOptions _pluginOptions;
  final bool _annotateWithOverride;

  @override
  void execute() {
    _codeWriter
      ..writeln()
      ..writeln('/// Converts [$_className] to a [Map] json');

    if (_annotateWithOverride) {
      _codeWriter.writeln('@override');
    }

    _codeWriter
      ..writeln('Map<String, dynamic> toJson() {')
      ..writeln('return <String, dynamic>{');

    for (final VariableElement field in _fields) {
      JsonKeyInternal? jsonKey;
      String? customJsonConverter;

      for (final ElementAnnotation annotation in field.metadata) {
        if (annotation.isJsonKeyAnnotation) {
          jsonKey = JsonKeyInternal.fromDartObject(annotation.computeConstantValue());
          continue;
        }

        final Element? annotationElement = annotation.element;
        if (annotationElement is! ConstructorElement) {
          continue;
        }

        final ClassElement classElement = annotationElement.enclosingElement as ClassElement;
        for (final InterfaceType interface in classElement.interfaces) {
          if (interface.element.name == 'JsonConverter') {
            customJsonConverter = classElement.name;
            break;
          }
        }
      }
      jsonKey ??= JsonKeyInternal.fromDartObject(null);

      if (jsonKey.ignore) {
        continue;
      }

      final JsonKeyNameConvention jsonKeyNameConvention = getJsonKeyNameConvention(
        targetFileRelativePath: _targetFileRelativePath,
        jsonKey: jsonKey,
        pluginOptions: _pluginOptions,
      );

      _codeWriter.write(
          "'${jsonKey.name ?? jsonKeyNameConvention.transform(field.name.escapeDollarSign())}': ");

      if (customJsonConverter != null) {
        _codeWriter.writeln('const $customJsonConverter().toJson(${field.name}),');
        continue;
      }

      if (jsonKey.toJson != null) {
        _codeWriter
          ..write(jsonKey.toJson!.fullyQualifiedName(enclosingImports: _libraryImports))
          ..write('(${field.name}),');
        continue;
      }

      _encode(
        nextType: field.type,
        parentVariableName: field.name,
        depthIndex: 0,
        requiresBangOperator: field.type.isNullable,
      );
    }

    _codeWriter
      ..writeln('};')
      ..writeln('}');
  }

  void _encode({
    required final DartType? nextType,
    required final int depthIndex,
    required final String parentVariableName,
    final bool requiresBangOperator = false,
  }) {
    if (nextType == null) {
      return;
    }

    if (nextType.isDartCoreList) {
      _encodeList(
        type: nextType as ParameterizedType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
        requiresBangOperator: requiresBangOperator,
      );
      _codeWriter.writeln(',');
      return;
    }

    if (nextType.isDartCoreMap) {
      _encodeMap(
        type: nextType as ParameterizedType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
        requiresBangOperator: requiresBangOperator,
      );
      _codeWriter.writeln(',');
      return;
    }

    _encodePrimary(
      type: nextType,
      parentVariableName: parentVariableName,
    );
  }

  void _writeNullableParsingPrefix({
    required final String parentVariableName,
  }) {
    _codeWriter.write('$parentVariableName == null ? null : ');
  }

  void _encodePrimary({
    required final DartType type,
    required final String parentVariableName,
  }) {
    if (type.isDynamic || type.isPrimary) {
      _codeWriter.writeln('$parentVariableName,');
      return;
    }

    final String? fieldType = type.element!.name;

    if (type.element is ClassElement || type.element is EnumElement) {
      final InterfaceElement element = type.element as InterfaceElement;
      final String? convertMethod = <String>[
        ...element.methods.map((MethodElement method) => method.name),
        ...element.constructors.map((ConstructorElement ctor) => ctor.name)
      ].firstWhereOrNull((String name) {
        switch (name) {
          case 'toMap':
          case 'toJson':
            return true;
          default:
            return false;
        }
      });

      final String accessOperator = type.isNullable ? '?.' : '.';

      if (convertMethod != null) {
        _codeWriter.writeln('$parentVariableName$accessOperator$convertMethod(),');
        return;
      }

      if (_checkIfShouldUseToJson?.call(type) ?? false) {
        _codeWriter.writeln('$parentVariableName${accessOperator}toJson(),');
        return;
      }
    }

    if (type.isNullable) {
      _writeNullableParsingPrefix(parentVariableName: parentVariableName);
    }
    _codeWriter.write('jsonConverterRegistrant.find($fieldType).toJson($parentVariableName),');
  }

  void _encodeList({
    required final ParameterizedType type,
    required final String parentVariableName,
    required final int depthIndex,
    required final bool requiresBangOperator,
  }) {
    if (type.isNullable) {
      _writeNullableParsingPrefix(
        parentVariableName: parentVariableName,
      );
    }

    _codeWriter.write('<dynamic>[');

    final String loopVariableName = 'i$depthIndex';
    _codeWriter.writeln('for (final '
        '${type.typeArguments[0].typeStringValue(enclosingImports: _libraryImports)} '
        '$loopVariableName in $parentVariableName'
        '${requiresBangOperator ? '!' : ''})');

    _encode(
      nextType: type.typeArguments.first,
      parentVariableName: loopVariableName,
      depthIndex: 1 + depthIndex,
    );

    _codeWriter.writeln(']');
  }

  void _encodeMap({
    required final ParameterizedType type,
    required final String parentVariableName,
    required final int depthIndex,
    required final bool requiresBangOperator,
  }) {
    if (!type.typeArguments[0].isDartCoreString) {
      return;
    }

    if (type.isNullable) {
      _writeNullableParsingPrefix(
        parentVariableName: parentVariableName,
      );
    }

    _codeWriter.write('<String, dynamic>{');

    final String loopVariableName = 'e$depthIndex';
    _codeWriter
      ..writeln('for (final '
          'MapEntry<String, ${type.typeArguments[1].typeStringValue(enclosingImports: _libraryImports)}> '
          '$loopVariableName in $parentVariableName'
          '${requiresBangOperator ? '!' : ''}'
          '.entries)')
      ..write('$loopVariableName.key: ');

    _encode(
      nextType: type.typeArguments[1],
      parentVariableName: '$loopVariableName.value',
      depthIndex: 1 + depthIndex,
      requiresBangOperator: type.typeArguments[1].isNullable,
    );

    _codeWriter.writeln('}');
  }
}
