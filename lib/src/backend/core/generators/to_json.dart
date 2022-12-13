import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/backend/core/custom_dart_object.dart';
import 'package:data_class_plugin/src/backend/core/custom_dart_type.dart';
import 'package:data_class_plugin/src/backend/core/generators/generator.dart';
import 'package:data_class_plugin/src/backend/core/typedefs.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/json_key_name_convention.dart';
import 'package:data_class_plugin/src/typedefs.dart';

class ToJsonGenerator implements Generator {
  ToJsonGenerator({
    required CodeWriter codeWriter,
    required final List<MethodDeclaration> fields,
    required final JsonKeyNameConventionGetter jsonKeyNameConventionGetter,
    required ClassOrEnumDeclarationFinder classDeclarationFinder,
  })  : _codeWriter = codeWriter,
        _fields = fields,
        _jsonKeyNameConventionGetter = jsonKeyNameConventionGetter,
        _classDeclarationFinder = classDeclarationFinder;

  final CodeWriter _codeWriter;
  final List<MethodDeclaration> _fields;
  final JsonKeyNameConventionGetter _jsonKeyNameConventionGetter;
  final ClassOrEnumDeclarationFinder _classDeclarationFinder;

  @override
  Future<void> execute() async {
    _codeWriter
      ..writeln()
      ..writeln('@override')
      ..writeln('Map<String, dynamic> toJson() {')
      ..writeln('return <String, dynamic>{');

    for (final MethodDeclaration field in _fields) {
      final AnnotationValueExtractor annotationValueExtractor = AnnotationValueExtractor(
          field.metadata.firstWhereOrNull((Annotation meta) => meta.isJsonKeyAnnotation));

      final JsonKeyNameConvention jsonKeyNameConvention =
          _jsonKeyNameConventionGetter(annotationValueExtractor.getEnumValue('nameConvention'));

      final String fieldName = field.name.lexeme;
      final String jsonFieldName = annotationValueExtractor.getString('name') ??
          jsonKeyNameConvention.transform(fieldName.escapeDollarSign());
      final CustomDartType dartType = field.returnType?.customDartType ?? CustomDartType.dynamic;

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
    final String? defaultValue,
  }) async {
    if (dartType.isList) {
      if (dartType.isNullable || defaultValue != null) {}
      await _encodeList(
        dartType: dartType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
        requiresBangOperator: depthIndex == 0,
      );
      _codeWriter.writeln(',');
      return;
    }

    if (dartType.isMap) {
      if (dartType.isNullable || defaultValue != null) {}
      await _encodeMap(
        dartType: dartType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
      );
      _codeWriter.writeln(',');
      return;
    }

    await _encodePrimary(
      dartType: dartType,
      parentVariableName: parentVariableName,
    );
  }

  String _getBangOperatorIfNullable(CustomDartType type) {
    return type.isNullable ? '!' : '';
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
      _codeWriter.writeln('jsonConverterRegistrant.find(Duration).toJson($parentVariableName),');
      return;
    }

    final NamedCompilationUnitMember? typeDeclarationNode =
        await _classDeclarationFinder(dartType.name);

    if (typeDeclarationNode is ClassDeclaration && typeDeclarationNode.hasMethod('toJson') ||
        typeDeclarationNode is EnumDeclaration && typeDeclarationNode.hasMethod('toJson')) {
      _codeWriter.writeln('$parentVariableName.toJson(),');
      return;
    }

    print('WARNING: No "toJson" method found for type ${dartType.name}');

    _codeWriter.writeln('jsonConverterRegistrant.find(Duration).toJson($parentVariableName),');
  }

  Future<void> _encodeList({
    required final CustomDartType dartType,
    required final String parentVariableName,
    required final int depthIndex,
    required final bool requiresBangOperator,
  }) async {
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
        '${requiresBangOperator ? _getBangOperatorIfNullable(dartType) : ''})');

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
  }) async {
    if (!dartType.typeArguments[0].isString) {
      return;
    }

    _codeWriter.write('<String, ${dartType.typeArguments[1].fullTypeName}>{');

    final String loopVariableName = 'e$depthIndex';
    _codeWriter
      ..writeln(
          'for (final MapEntry<dynamic, dynamic> $loopVariableName in ($parentVariableName as Map<dynamic, dynamic>).entries)')
      ..write('$loopVariableName.key: ');

    await _encode(
      dartType: dartType.typeArguments[1],
      parentVariableName: '$loopVariableName.value',
      depthIndex: 1 + depthIndex,
    );

    _codeWriter.writeln('}');
  }
}
