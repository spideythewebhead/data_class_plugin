import 'package:data_class_plugin/src/common/generator.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/json_key_name_convention.dart';
import 'package:data_class_plugin/src/typedefs.dart';
import 'package:tachyon/tachyon.dart';

class ToJsonGenerator implements Generator {
  ToJsonGenerator({
    required final CodeWriter codeWriter,
    required final List<DeclarationInfo> fields,
    required final JsonKeyNameConventionGetter jsonKeyNameConventionGetter,
    required final ClassOrEnumDeclarationFinder classDeclarationFinder,
    required final bool dropNullValues,
    final String? toJsonUnionKey,
    required final Logger logger,
  })  : _codeWriter = codeWriter,
        _fields = fields,
        _jsonKeyNameConventionGetter = jsonKeyNameConventionGetter,
        _classDeclarationFinder = classDeclarationFinder,
        _dropNullValues = dropNullValues,
        _toJsonUnionKey = toJsonUnionKey,
        _logger = logger;

  final CodeWriter _codeWriter;
  final List<DeclarationInfo> _fields;
  final JsonKeyNameConventionGetter _jsonKeyNameConventionGetter;
  final ClassOrEnumDeclarationFinder _classDeclarationFinder;
  final String? _toJsonUnionKey;
  final bool _dropNullValues;
  final Logger _logger;

  @override
  Future<void> execute() async {
    _codeWriter
      ..writeln()
      ..writeln('@override')
      ..writeln('Map<String, dynamic> toJson() {')
      ..writeln('return <String, dynamic>{');

    if (_toJsonUnionKey != null &&
        _toJsonUnionKey.trim().isNotEmpty &&
        !_fields.any((DeclarationInfo field) => field.name == _toJsonUnionKey)) {
      _codeWriter
        ..write("'$_toJsonUnionKey': ")
        ..write('$_toJsonUnionKey,');
    }

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
        final NamedCompilationUnitMember? node = await _classDeclarationFinder(className)
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
      final String jsonFieldName = annotationValueExtractor.getString('name') ??
          jsonKeyNameConvention.transform(fieldName.escapeDollarSign());
      final TachyonDartType dartType = field.type?.customDartType ?? TachyonDartType.dynamic;

      if (_dropNullValues && dartType.isNullable) {
        _codeWriter.writeln('if ($fieldName != null)');
      }

      _codeWriter.write("'$jsonFieldName': ");

      if (customJsonConverter != null) {
        _codeWriter.writeln('''const $customJsonConverter().toJson($fieldName),''');
        continue;
      }

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
    if (_dropNullValues) {
      return;
    }
    _codeWriter.write('$parentVariableName == null ? null : ');
  }

  Future<void> _encode({
    required final TachyonDartType dartType,
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
    required final TachyonDartType dartType,
    required final String parentVariableName,
  }) async {
    if (dartType.isDynamic || dartType.isPrimitive) {
      _codeWriter.writeln('$parentVariableName,');
      return;
    }

    if (dartType.isDateTime || dartType.isDuration || dartType.isUri) {
      if (dartType.isNullable) {
        _writeNullableParsingPrefix(parentVariableName: parentVariableName);
      }

      _codeWriter
          .writeln('jsonConverterRegistrant.find(${dartType.name}).toJson($parentVariableName),');
      return;
    }

    final NamedCompilationUnitMember? typeDeclarationNode =
        await _classDeclarationFinder(dartType.name)
            .then((FinderDeclarationMatch<NamedCompilationUnitMember>? match) => match?.node);

    if (typeDeclarationNode is ClassDeclaration && typeDeclarationNode.hasMethod('toJson') ||
        typeDeclarationNode is EnumDeclaration && typeDeclarationNode.hasMethod('toJson')) {
      final String accessOperator = switch (dartType.isNullable) {
        true when _dropNullValues => '!.',
        true => '?.',
        false => '.',
      };
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

  bool _shouldSkipEncodingForCollection(final TachyonDartType originalDartType) {
    TachyonDartType dartType = originalDartType;
    while (true) {
      if (dartType.isList) {
        dartType = dartType.typeArguments[0];
      } else if (dartType.isMap) {
        dartType = dartType.typeArguments[1];
      } else {
        break;
      }
    }
    return dartType.isPrimitive;
  }

  Future<void> _encodeList({
    required final TachyonDartType dartType,
    required final String parentVariableName,
    required final int depthIndex,
    required final bool requiresBangOperator,
  }) async {
    if (_shouldSkipEncodingForCollection(dartType)) {
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
    required final TachyonDartType dartType,
    required final String parentVariableName,
    required final int depthIndex,
    required final bool requiresBangOperator,
  }) async {
    final TachyonDartType keyType = dartType.typeArguments[0];
    String? keyToStringSuffix;

    if (!keyType.isString) {
      if (keyType.isNullable) {
        _logger.error('Key can not be nullable. Given "${keyType.fullTypeName}".');
        return;
      }

      final NamedCompilationUnitMember? typeDeclarationNode =
          await _classDeclarationFinder(keyType.name)
              .then((FinderDeclarationMatch<NamedCompilationUnitMember>? match) => match?.node);

      if (typeDeclarationNode is! EnumDeclaration) {
        _logger.error(
            'Map key type can only be "String" or an enum. Given "${keyType.fullTypeName}".');
        return;
      }

      for (final ClassMember member in typeDeclarationNode.members) {
        if (member case MethodDeclaration method
            when method.name.lexeme == 'toJson' &&
                TachyonDartType.fromTypeAnnotation(method.returnType).isString) {
          keyToStringSuffix = '.toJson()';
          break;
        }
      }

      if (keyToStringSuffix == null) {
        final ClassMember? firstFinalStringField =
            typeDeclarationNode.members.firstWhereOrNull((ClassMember member) {
          return member is FieldDeclaration &&
              member.fields.isFinal &&
              TachyonDartType.fromTypeAnnotation(member.fields.type).isString;
        });

        if (firstFinalStringField is FieldDeclaration) {
          keyToStringSuffix = '.${firstFinalStringField.fields.variables[0].name.lexeme}';
        } else {
          _logger.warning(
              'Is recommended to provide a "toJson" method instead of using the default "name" field for enums.');
          keyToStringSuffix = '.name';
        }
      }
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
          'MapEntry<${keyType.fullTypeName}, ${dartType.typeArguments[1].fullTypeName}> '
          '$loopVariableName in $parentVariableName'
          '${requiresBangOperator ? '!' : ''}'
          '.entries)')
      ..write('$loopVariableName.key$keyToStringSuffix: ');

    await _encode(
      dartType: dartType.typeArguments[1],
      parentVariableName: '$loopVariableName.value',
      depthIndex: 1 + depthIndex,
      requiresBangOperator: dartType.typeArguments[1].isNullable,
    );

    _codeWriter.writeln('}');
  }
}
