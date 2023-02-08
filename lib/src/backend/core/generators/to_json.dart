import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/backend/core/custom_dart_object.dart';
import 'package:data_class_plugin/src/backend/core/custom_dart_type.dart';
import 'package:data_class_plugin/src/backend/core/declaration_info.dart';
import 'package:data_class_plugin/src/backend/core/generators/generator.dart';
import 'package:data_class_plugin/src/backend/core/typedefs.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/json_key_name_convention.dart';
import 'package:data_class_plugin/src/tools/logger/plugin_logger.dart';
import 'package:data_class_plugin/src/typedefs.dart';

class ToJsonGenerator implements Generator {
  ToJsonGenerator({
    required CodeWriter codeWriter,
    required final List<DeclarationInfo> fields,
    required final JsonKeyNameConventionGetter jsonKeyNameConventionGetter,
    required ClassOrEnumDeclarationFinder classDeclarationFinder,
    PluginLogger? logger,
  })  : _codeWriter = codeWriter,
        _fields = fields,
        _jsonKeyNameConventionGetter = jsonKeyNameConventionGetter,
        _classDeclarationFinder = classDeclarationFinder,
        _logger = logger ?? PluginLogger();

  final CodeWriter _codeWriter;
  final List<DeclarationInfo> _fields;
  final JsonKeyNameConventionGetter _jsonKeyNameConventionGetter;
  final ClassOrEnumDeclarationFinder _classDeclarationFinder;
  final PluginLogger _logger;

  @override
  Future<void> execute() async {
    _codeWriter
      ..writeln()
      ..writeln('@override')
      ..writeln('Map<String, dynamic> toJson() {')
      ..writeln('return <String, dynamic>{');

    for (final DeclarationInfo field in _fields) {
      final AnnotationValueExtractor annotationValueExtractor = AnnotationValueExtractor(
          field.metadata.firstWhereOrNull((Annotation meta) => meta.isJsonKeyAnnotation));

      final JsonKeyNameConvention jsonKeyNameConvention =
          _jsonKeyNameConventionGetter(annotationValueExtractor.getEnumValue('nameConvention'));

      final String fieldName = field.name;
      final String jsonFieldName = annotationValueExtractor.getString('name') ??
          jsonKeyNameConvention.transform(fieldName.escapeDollarSign());
      final CustomDartType dartType = field.type?.customDartType ?? CustomDartType.dynamic;

      _codeWriter.write("'$jsonFieldName': ");

      final String? customFunction = annotationValueExtractor.getFunction('toJson');
      if (customFunction != null) {
        _codeWriter.writeln('$customFunction($fieldName),');
        continue;
      }

      await _encode(
        dartType: dartType,
        depthIndex: 0,
        parentVariableName: fieldName,
        requiresBangOperator: dartType.isNullable,
      );
    }

    _codeWriter
      ..writeln('};')
      ..writeln('}')
      ..writeln();
  }

  void _writeNullableParsingPrefix({
    required final String parentVariableName,
  }) {
    _codeWriter.write('$parentVariableName == null ? null : ');
  }

  Future<void> _encode({
    required final CustomDartType dartType,
    required final int depthIndex,
    required final String parentVariableName,
    final bool requiresBangOperator = false,
  }) async {
    if (dartType.isList) {
      await _encodeList(
        dartType: dartType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
        requiresBangOperator: requiresBangOperator,
      );
      _codeWriter.writeln(',');
      return;
    }

    if (dartType.isMap) {
      await _encodeMap(
        dartType: dartType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
        requiresBangOperator: requiresBangOperator,
      );
      _codeWriter.writeln(',');
      return;
    }

    await _encodePrimary(
      dartType: dartType,
      parentVariableName: parentVariableName,
    );
  }

  Future<void> _encodePrimary({
    required final CustomDartType dartType,
    required final String parentVariableName,
  }) async {
    if (dartType.isDynamic || dartType.isPrimary) {
      _codeWriter.writeln('$parentVariableName,');
      return;
    }

    if (dartType.isDateTime || dartType.isDuration || dartType.isUri) {
      _codeWriter
          .writeln('jsonConverterRegistrant.find(${dartType.name}).toJson($parentVariableName),');
      return;
    }

    final NamedCompilationUnitMember? typeDeclarationNode =
        await _classDeclarationFinder(dartType.name);

    if (typeDeclarationNode is ClassDeclaration && typeDeclarationNode.hasMethod('toJson') ||
        typeDeclarationNode is EnumDeclaration && typeDeclarationNode.hasMethod('toJson')) {
      final String accessOperator = dartType.isNullable ? '?.' : '.';
      _codeWriter.writeln('$parentVariableName${accessOperator}toJson(),');
      return;
    }

    _logger.warning('No "toJson" method found for type ${dartType.name}');

    if (dartType.isNullable) {
      _writeNullableParsingPrefix(parentVariableName: parentVariableName);
    }

    _codeWriter
        .writeln('jsonConverterRegistrant.find(${dartType.name}).toJson($parentVariableName),');
  }

  bool _shouldSkipForCollection(final CustomDartType originalDartType) {
    CustomDartType dartType = originalDartType;
    while (true) {
      if (dartType.isList) {
        dartType = dartType.typeArguments[0];
      } else if (dartType.isMap) {
        dartType = dartType.typeArguments[1];
      } else {
        break;
      }
    }
    return dartType.isPrimary;
  }

  Future<void> _encodeList({
    required final CustomDartType dartType,
    required final String parentVariableName,
    required final int depthIndex,
    required final bool requiresBangOperator,
  }) async {
    if (_shouldSkipForCollection(dartType)) {
      _codeWriter.writeln(parentVariableName);
      return;
    }

    if (dartType.isNullable) {
      _writeNullableParsingPrefix(
        parentVariableName: parentVariableName,
      );
    }

    _codeWriter.write('<dynamic>[');

    final String loopVariableName = 'i$depthIndex';
    _codeWriter.writeln('for (final '
        '${dartType.typeArguments[0].fullTypeName} '
        '$loopVariableName in $parentVariableName'
        '${requiresBangOperator ? '!' : ''})');

    await _encode(
      dartType: dartType.typeArguments[0],
      parentVariableName: loopVariableName,
      depthIndex: 1 + depthIndex,
    );

    _codeWriter.writeln(']');
  }

  Future<void> _encodeMap({
    required final CustomDartType dartType,
    required final String parentVariableName,
    required final int depthIndex,
    required final bool requiresBangOperator,
  }) async {
    if (!dartType.typeArguments[0].isPrimary) {
      return;
    }

    if (_shouldSkipForCollection(dartType)) {
      _codeWriter.writeln(parentVariableName);
      return;
    }

    if (dartType.isNullable) {
      _writeNullableParsingPrefix(
        parentVariableName: parentVariableName,
      );
    }

    _codeWriter.write('<String, dynamic>{');

    final String loopVariableName = 'e$depthIndex';
    _codeWriter
      ..writeln('for (final '
          'MapEntry<String, ${dartType.typeArguments[1].fullTypeName}> '
          '$loopVariableName in $parentVariableName'
          '${requiresBangOperator ? '!' : ''}'
          '.entries)')
      ..write('$loopVariableName.key: ');

    await _encode(
      dartType: dartType.typeArguments[1],
      parentVariableName: '$loopVariableName.value',
      depthIndex: 1 + depthIndex,
      requiresBangOperator: dartType.typeArguments[1].isNullable,
    );

    _codeWriter.writeln('}');
  }
}
