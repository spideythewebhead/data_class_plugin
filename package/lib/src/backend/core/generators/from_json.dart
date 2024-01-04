import 'package:data_class_plugin/src/common/generator.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/json_key_name_convention.dart';
import 'package:data_class_plugin/src/typedefs.dart';
import 'package:tachyon/tachyon.dart';

class FromJsonGenerator implements Generator {
  FromJsonGenerator({
    required final CodeWriter codeWriter,
    required final List<DeclarationInfo> fields,
    required final String generatedClassName,
    required final String classTypeParametersWithoutConstraints,
    required final JsonKeyNameConventionGetter jsonKeyNameConventionGetter,
    required final ClassOrEnumDeclarationFinder classDeclarationFinder,
    required final Logger logger,
  })  : _codeWriter = codeWriter,
        _fields = fields,
        _generatedClassName = generatedClassName,
        _classTypeParametersWithoutConstraints = classTypeParametersWithoutConstraints,
        _jsonKeyNameConventionGetter = jsonKeyNameConventionGetter,
        _classOrEnumDeclarationFinder = classDeclarationFinder,
        _logger = logger;

  final CodeWriter _codeWriter;
  final List<DeclarationInfo> _fields;
  final String _generatedClassName;
  final String _classTypeParametersWithoutConstraints;
  final JsonKeyNameConventionGetter _jsonKeyNameConventionGetter;
  final ClassOrEnumDeclarationFinder _classOrEnumDeclarationFinder;
  final Logger _logger;

  late String _currentJsonFieldName;

  @override
  Future<void> execute() async {
    _codeWriter
      ..writeln('factory $_generatedClassName.fromJson(Map<dynamic, dynamic> json) {')
      ..writeln('return $_generatedClassName$_classTypeParametersWithoutConstraints(');

    for (final DeclarationInfo field in _fields) {
      AnnotationValueExtractor? annotationValueExtractor;
      String? customJsonConverter;

      for (final Annotation annotation in field.metadata) {
        // handle JsonKey
        if (annotation.isJsonKeyAnnotation) {
          annotationValueExtractor = AnnotationValueExtractor(annotation);
          continue;
        }

        final String className = annotation.name.name;
        final NamedCompilationUnitMember? node = await _classOrEnumDeclarationFinder(className)
            .then((FinderDeclarationMatch<NamedCompilationUnitMember>? match) => match?.node);

        // handle JsonConverter interface implementer
        if (node is ClassDeclaration) {
          for (final NamedType interface
              in (node.implementsClause?.interfaces ?? const <NamedType>[])) {
            if (interface.name2.lexeme == 'JsonConverter') {
              customJsonConverter = className;
              break;
            }
          }
        }
      }
      annotationValueExtractor ??= AnnotationValueExtractor(null);

      if (annotationValueExtractor.getBool('ignored') ?? false) {
        continue;
      }

      final JsonKeyNameConvention jsonKeyNameConvention =
          _jsonKeyNameConventionGetter(annotationValueExtractor.getEnumValue('nameConvention'));

      final String fieldName = field.name;
      final TachyonDartType dartType = field.type?.customDartType ?? TachyonDartType.dynamic;

      _currentJsonFieldName = annotationValueExtractor.getString('name') ??
          jsonKeyNameConvention.transform(fieldName.escapeDollarSign());

      if (field.isNamed) {
        _codeWriter.write('$fieldName: ');
      }

      if (customJsonConverter != null) {
        _codeWriter.writeln('const $customJsonConverter()'
            ".fromJson(json['$_currentJsonFieldName'], json, '$_currentJsonFieldName'),");
        continue;
      }

      final String? customFunction = annotationValueExtractor.getFunction('fromJson');
      if (customFunction != null) {
        _codeWriter.writeln(
            "$customFunction(json['$_currentJsonFieldName'], json, '$_currentJsonFieldName'),");
        continue;
      }

      final AnnotationValueExtractor defaultValueExtractor = AnnotationValueExtractor(field.metadata
          .firstWhereOrNull((Annotation annotation) => annotation.isDefaultValueAnnotation));

      await _parse(
        dartType: dartType,
        depthIndex: 0,
        parentVariableName: "json['$_currentJsonFieldName']",
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
    required final TachyonDartType dartType,
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

    if (!dartType.isPrimitive && (dartType.isNullable || defaultValue != null)) {
      _writeNullableCheck(
        variableName: parentVariableName,
        defaultValue: defaultValue,
      );
    }

    await _parsePrimary(
      dartType: dartType,
      parentVariableName: parentVariableName,
    );

    if (dartType.isPrimitive && defaultValue != null) {
      if (dartType.isNullable) {
        _logger.warning('Declared a nullable type ${dartType.fullTypeName} with default');
      } else {
        _codeWriter.writeln('?');
      }
      _codeWriter.write(' ?? $defaultValue');
    }

    _codeWriter.writeln(',');
  }

  Future<void> _parsePrimary({
    required final TachyonDartType dartType,
    required final String parentVariableName,
  }) async {
    if (dartType.isDynamic) {
      _codeWriter.writeln(parentVariableName);
      return;
    }

    if (dartType.isPrimitive) {
      if (dartType.isDouble) {
        if (dartType.isNullable) {
          _codeWriter.write('($parentVariableName as num?)?.toDouble()');
          return;
        }
        _codeWriter.write('($parentVariableName as num).toDouble()');
        return;
      }
      if (dartType.isInt) {
        if (dartType.isNullable) {
          _codeWriter.write('($parentVariableName as num?)?.toInt()');
          return;
        }
        _codeWriter.write('($parentVariableName as num).toInt()');
        return;
      }
      _codeWriter.write('$parentVariableName as ${dartType.fullTypeName}');
      return;
    }

    final NamedCompilationUnitMember? typeDeclarationNode =
        await _classOrEnumDeclarationFinder(dartType.name)
            .then((FinderDeclarationMatch<NamedCompilationUnitMember>? match) => match?.node);

    if (typeDeclarationNode is ClassDeclaration && typeDeclarationNode.hasFactory('fromJson') ||
        typeDeclarationNode is EnumDeclaration && typeDeclarationNode.hasFactory('fromJson')) {
      _codeWriter.write('${dartType.fullTypeName}.fromJson($parentVariableName)');
      return;
    }

    _logger.warning('~ No "fromJson" factory found for type "${dartType.fullTypeName}"');

    if (dartType.isNullable) {
      final String typeWithoutNullability =
          dartType.fullTypeName.substring(0, dartType.fullTypeName.length - 1);
      _codeWriter.write('jsonConverterRegistrant.find($typeWithoutNullability)'
          ".fromJson($parentVariableName, json, '$_currentJsonFieldName') as $typeWithoutNullability");
      return;
    }

    _codeWriter.write('jsonConverterRegistrant.find(${dartType.fullTypeName})'
        ".fromJson($parentVariableName, json, '$_currentJsonFieldName') as ${dartType.fullTypeName}");
  }

  Future<void> _parseList({
    required final TachyonDartType dartType,
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
    required final TachyonDartType dartType,
    required final String parentVariableName,
    required final int depthIndex,
  }) async {
    if (!dartType.typeArguments[0].isString) {
      _logger.error(
          'Key of type "${dartType.typeArguments[0].fullTypeName}" can not be used as a map key in json conversion');
      return;
    }

    final String secondArgumentFullType = dartType.typeArguments[1].fullTypeName;
    _codeWriter.write('<String, $secondArgumentFullType>{');

    final String loopVariableName = 'e$depthIndex';
    _codeWriter
      ..writeln(
          'for (final MapEntry<dynamic, dynamic> $loopVariableName in ($parentVariableName as Map<dynamic, dynamic>).entries)')
      ..write('$loopVariableName.key as String: ');

    await _parse(
      dartType: dartType.typeArguments[1],
      parentVariableName: '$loopVariableName.value',
      depthIndex: 1 + depthIndex,
    );

    _codeWriter.writeln('}');
  }
}
