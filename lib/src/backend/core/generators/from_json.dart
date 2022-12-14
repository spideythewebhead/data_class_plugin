import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/backend/core/custom_dart_object.dart';
import 'package:data_class_plugin/src/backend/core/custom_dart_type.dart';
import 'package:data_class_plugin/src/backend/core/declaration_info.dart';
import 'package:data_class_plugin/src/backend/core/generators/generator.dart';
import 'package:data_class_plugin/src/backend/core/typedefs.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/json_key_name_convention.dart';
import 'package:data_class_plugin/src/typedefs.dart';

class FromJsonGenerator implements Generator {
  FromJsonGenerator({
    required CodeWriter codeWriter,
    required List<DeclarationInfo> fields,
    required String generatedClassName,
    required String classTypeParametersSource,
    required JsonKeyNameConventionGetter jsonKeyNameConventionGetter,
    required ClassOrEnumDeclarationFinder classDeclarationFinder,
  })  : _codeWriter = codeWriter,
        _fields = fields,
        _generatedClassName = generatedClassName,
        _classTypeParametersSource = classTypeParametersSource,
        _jsonKeyNameConventionGetter = jsonKeyNameConventionGetter,
        _classOrEnumDeclarationFinder = classDeclarationFinder;

  final CodeWriter _codeWriter;
  final List<DeclarationInfo> _fields;
  final String _generatedClassName;
  final String _classTypeParametersSource;
  final JsonKeyNameConventionGetter _jsonKeyNameConventionGetter;
  final ClassOrEnumDeclarationFinder _classOrEnumDeclarationFinder;

  @override
  Future<void> execute() async {
    _codeWriter
      ..writeln('factory $_generatedClassName.fromJson(Map<dynamic, dynamic> json) {')
      ..writeln('return $_generatedClassName$_classTypeParametersSource(');

    for (final DeclarationInfo field in _fields) {
      final AnnotationValueExtractor annotationValueExtractor = AnnotationValueExtractor(
          field.metadata.firstWhereOrNull((Annotation meta) => meta.isJsonKeyAnnotation));

      final JsonKeyNameConvention jsonKeyNameConvention =
          _jsonKeyNameConventionGetter(annotationValueExtractor.getEnumValue('nameConvention'));

      final String fieldName = field.name;
      final String jsonFieldName = annotationValueExtractor.getString('name') ??
          jsonKeyNameConvention.transform(fieldName.escapeDollarSign());
      final CustomDartType dartType = field.type?.customDartType ?? CustomDartType.dynamic;

      _codeWriter.write('$fieldName: ');

      final String? customFunction = annotationValueExtractor.getFunction('fromJson');
      if (customFunction != null) {
        _codeWriter.writeln('$customFunction(json),');
        continue;
      }

      final AnnotationValueExtractor defaultValueExtractor = AnnotationValueExtractor(field.metadata
          .firstWhereOrNull((Annotation annotation) => annotation.isDefaultValueAnnotation));

      await _parse(
        dartType: dartType,
        depthIndex: 0,
        parentVariableName: "json['$jsonFieldName']",
        defaultValue: defaultValueExtractor.getPositionedArgument(0),
      );
    }

    _codeWriter
      ..writeln(');')
      ..writeln('}')
      ..writeln();
  }

  void _writeNullableCheck({
    required final String variableName,
    Expression? defaultValue,
  }) {
    final String optionalConst =
        (defaultValue is TypedLiteral || defaultValue is MethodInvocation) ? 'const' : '';
    _codeWriter.write('$variableName == null ? $optionalConst $defaultValue : ');
  }

  Future<void> _parse({
    required final CustomDartType dartType,
    required final int depthIndex,
    required final String parentVariableName,
    final Expression? defaultValue,
  }) async {
    if (dartType.isList) {
      if (dartType.isNullable || defaultValue != null) {
        _writeNullableCheck(
          variableName: parentVariableName,
          defaultValue: defaultValue,
        );
      }
      await _parseList(
        dartType: dartType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
      );
      _codeWriter.writeln(',');
      return;
    }

    if (dartType.isMap) {
      if (dartType.isNullable || defaultValue != null) {
        _writeNullableCheck(
          variableName: parentVariableName,
          defaultValue: defaultValue,
        );
      }
      await _parseMap(
        dartType: dartType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
      );
      _codeWriter.writeln(',');
      return;
    }

    if (dartType.isNullable || defaultValue != null) {
      _writeNullableCheck(
        variableName: parentVariableName,
        defaultValue: defaultValue,
      );
    }

    await _parsePrimary(
      dartType: dartType,
      parentVariableName: parentVariableName,
    );
  }

  Future<void> _parsePrimary({
    required final CustomDartType dartType,
    required final String parentVariableName,
  }) async {
    if (dartType.isDynamic) {
      _codeWriter.writeln('$parentVariableName,');
      return;
    }

    if (dartType.isPrimary) {
      _codeWriter.writeln('$parentVariableName as ${dartType.name},');
      return;
    }

    if (dartType.isDateTime || dartType.isDuration || dartType.isUri) {
      _codeWriter.writeln(
          'jsonConverterRegistrant.find(${dartType.name}).fromJson($parentVariableName) as ${dartType.name},');
      return;
    }

    final NamedCompilationUnitMember? typeDeclarationNode =
        await _classOrEnumDeclarationFinder(dartType.name);

    if (typeDeclarationNode is ClassDeclaration &&
            typeDeclarationNode.members.hasFactory('fromJson') ||
        typeDeclarationNode is EnumDeclaration &&
            typeDeclarationNode.members.hasFactory('fromJson')) {
      _codeWriter.writeln('${dartType.name}.fromJson($parentVariableName),');
      return;
    }

    print('WARNING: No "fromJson" factory found for type ${dartType.name}');

    _codeWriter.writeln(
        'jsonConverterRegistrant.find(${dartType.name}).fromJson($parentVariableName) as ${dartType.name},');
  }

  Future<void> _parseList({
    required final CustomDartType dartType,
    required final String parentVariableName,
    required final int depthIndex,
  }) async {
    final String fullType = dartType.typeArguments[0].fullTypeName;
    _codeWriter.write('<$fullType>[');

    final String loopVariableName = 'i$depthIndex';
    _codeWriter
        .writeln('for (final dynamic $loopVariableName in ($parentVariableName as List<dynamic>))');

    await _parse(
      dartType: dartType.typeArguments[0],
      parentVariableName: loopVariableName,
      depthIndex: 1 + depthIndex,
    );

    _codeWriter.writeln(']');
  }

  Future<void> _parseMap({
    required final CustomDartType dartType,
    required final String parentVariableName,
    required final int depthIndex,
  }) async {
    if (!dartType.typeArguments[0].isString) {
      return;
    }

    final String secondArgumentFullType = dartType.typeArguments[1].fullTypeName;
    _codeWriter.write('<String, $secondArgumentFullType>{');

    final String loopVariableName = 'e$depthIndex';
    _codeWriter
      ..writeln(
          'for (final MapEntry<dynamic, dynamic> $loopVariableName in ($parentVariableName as Map<dynamic, dynamic>).entries)')
      ..write('$loopVariableName.key: ');

    await _parse(
      dartType: dartType.typeArguments[1],
      parentVariableName: '$loopVariableName.value',
      depthIndex: 1 + depthIndex,
    );

    _codeWriter.writeln('}');
  }
}
