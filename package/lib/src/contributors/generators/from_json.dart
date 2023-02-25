import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:data_class_plugin/src/annotations/json_key_internal.dart';
import 'package:data_class_plugin/src/backend/core/generators/generator.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/contributors/class/utils.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/json_key_name_convention.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';

class FromJsonGenerator implements Generator {
  /// Shorthand constructor
  FromJsonGenerator({
    required CodeWriter codeWriter,
    required String className,
    required String factoryClassName,
    required bool hasConstConstructor,
    required List<VariableElement> fields,
    required bool Function(DartType dartType)? checkIfShouldUseFromJson,
    required List<LibraryImportElement> libraryImports,
    required String targetFileRelativePath,
    required DataClassPluginOptions pluginOptions,
    required String? Function(String fieldName) getDefaultValueForField,
  })  : _codeWriter = codeWriter,
        _className = className,
        _factoryClassName = factoryClassName,
        _hasConstConstructor = hasConstConstructor,
        _checkIfShouldUseFromJson = checkIfShouldUseFromJson,
        _libraryImports = libraryImports,
        _fields = fields,
        _targetFileRelativePath = targetFileRelativePath,
        _pluginOptions = pluginOptions,
        _getDefaultValueForField = getDefaultValueForField;

  final CodeWriter _codeWriter;
  final String _className;
  final String _factoryClassName;
  final bool _hasConstConstructor;
  final List<VariableElement> _fields;
  final bool Function(DartType dartType)? _checkIfShouldUseFromJson;
  final List<LibraryImportElement> _libraryImports;
  final String _targetFileRelativePath;
  final DataClassPluginOptions _pluginOptions;
  final String? Function(String fieldName) _getDefaultValueForField;

  late String _currentJsonFieldName;

  @override
  void execute() {
    _codeWriter
      ..writeln()
      ..writeln('/// Creates an instance of [$_factoryClassName] from [json]')
      ..writeln('factory $_factoryClassName.fromJson(Map<dynamic, dynamic> json) {');

    if (_hasConstConstructor && _fields.isEmpty) {
      _codeWriter
        ..writeln('return const $_className();')
        ..writeln('}');
      return;
    }

    _codeWriter.writeln('return $_className(');

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

      final String fieldName = field.name;
      final DartType fieldType = field.type;

      _currentJsonFieldName =
          jsonKey.name ?? jsonKeyNameConvention.transform(fieldName.escapeDollarSign());

      _codeWriter.write('$fieldName: ');

      if (customJsonConverter != null) {
        _codeWriter.writeln('const $customJsonConverter()'
            ".fromJson(json['$_currentJsonFieldName'], json, '$_currentJsonFieldName'),");
        continue;
      }

      if (jsonKey.fromJson != null) {
        _codeWriter
          ..write(jsonKey.fromJson!.fullyQualifiedName(enclosingImports: _libraryImports))
          ..write("(json['$_currentJsonFieldName'], json, '$_currentJsonFieldName'),");
        continue;
      }

      _parse(
        nextType: fieldType,
        parentVariableName: "json['$_currentJsonFieldName']",
        depthIndex: 0,
        defaultValue: _getDefaultValueForField(fieldName),
      );
    }

    _codeWriter
      ..writeln(');')
      ..writeln('}');
  }

  void _parse({
    required final DartType? nextType,
    required final int depthIndex,
    required final String parentVariableName,
    final String? defaultValue,
  }) {
    if (nextType == null) {
      return;
    }

    if (nextType.isDartCoreList) {
      if (nextType.isNullable || defaultValue != null) {
        _writeNullableParsingPrefix(
          parentVariableName: parentVariableName,
          defaultValue: defaultValue,
        );
      }
      _parseList(
        type: nextType as ParameterizedType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
      );
      _codeWriter.writeln(',');
      return;
    }

    if (nextType.isDartCoreMap) {
      if (nextType.isNullable || defaultValue != null) {
        _writeNullableParsingPrefix(
          parentVariableName: parentVariableName,
          defaultValue: defaultValue,
        );
      }
      _parseMap(
        type: nextType as ParameterizedType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
      );
      _codeWriter.writeln(',');
      return;
    }

    if (nextType.isNullable || defaultValue != null) {
      _writeNullableParsingPrefix(
        parentVariableName: parentVariableName,
        defaultValue: defaultValue,
      );
    }

    _parsePrimary(
      type: nextType,
      parentVariableName: parentVariableName,
    );
  }

  void _writeNullableParsingPrefix({
    required final String parentVariableName,
    final String? defaultValue,
  }) {
    _codeWriter.write('$parentVariableName == null ? $defaultValue : ');
  }

  void _parsePrimary({
    required final DartType type,
    required final String parentVariableName,
  }) {
    final String? fieldType = type.element!.name;

    if (type.isDynamic) {
      _codeWriter
        ..writeln('// FIXME: variable is dynamic or contains a type that is not yet declared')
        ..writeln('$parentVariableName, ');
      return;
    }

    if (type.isPrimary) {
      _codeWriter.writeln('$parentVariableName as $fieldType,');
      return;
    }

    if (type.element is ClassElement || type.element is EnumElement) {
      final InterfaceElement element = type.element as InterfaceElement;
      final String? convertMethod = <String>[
        ...element.methods.map((MethodElement method) => method.name),
        ...element.constructors.map((ConstructorElement ctor) => ctor.name)
      ].firstWhereOrNull((String name) {
        switch (name) {
          case 'fromMap':
          case 'fromJson':
            return true;
          default:
            return false;
        }
      });

      if (convertMethod != null) {
        _codeWriter.writeln('$fieldType.$convertMethod($parentVariableName),');
        return;
      }

      if (_checkIfShouldUseFromJson?.call(type) ?? false) {
        _codeWriter.writeln('$fieldType.fromJson($parentVariableName),');
        return;
      }
    }

    _codeWriter.write('jsonConverterRegistrant.find($fieldType)'
        " .fromJson(json['$_currentJsonFieldName'], json, '$_currentJsonFieldName') as $fieldType,");
  }

  void _parseList({
    required final ParameterizedType type,
    required final String parentVariableName,
    required final int depthIndex,
  }) {
    _codeWriter
        .write('<${type.typeArguments[0].typeStringValue(enclosingImports: _libraryImports)}>[');

    final String loopVariableName = 'i$depthIndex';
    _codeWriter.writeln(
        'for (final dynamic $loopVariableName in ($parentVariableName as ${type.element!.name}<dynamic>))');

    _parse(
      nextType: type.typeArguments[0],
      parentVariableName: loopVariableName,
      depthIndex: 1 + depthIndex,
    );

    _codeWriter.writeln(']');
  }

  void _parseMap({
    required final ParameterizedType type,
    required final String parentVariableName,
    required final int depthIndex,
  }) {
    if (!type.typeArguments[0].isDartCoreString) {
      return;
    }

    _codeWriter.write(
        '<String, ${type.typeArguments[1].typeStringValue(enclosingImports: _libraryImports)}>{');

    final String loopVariableName = 'e$depthIndex';
    _codeWriter
      ..writeln(
          'for (final MapEntry<dynamic, dynamic> $loopVariableName in ($parentVariableName as ${type.element!.name}<dynamic, dynamic>).entries)')
      ..write('$loopVariableName.key: ');

    _parse(
      nextType: type.typeArguments[1],
      parentVariableName: '$loopVariableName.value',
      depthIndex: 1 + depthIndex,
    );

    _codeWriter.writeln('}');
  }
}
