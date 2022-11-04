import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/annotations/json_key_internal.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/extensions.dart';
import 'package:data_class_plugin/src/mixins.dart';

class FromJsonAssistContributor extends Object
    with AssistContributorMixin, ClassAstVisitorMixin
    implements AssistContributor {
  FromJsonAssistContributor(this.filePath);

  final String filePath;

  @override
  late final DartAssistRequest assistRequest;

  @override
  late final AssistCollector collector;

  AnalysisSession get session => assistRequest.result.session;

  @override
  Future<void> computeAssists(
    covariant DartAssistRequest request,
    AssistCollector collector,
  ) async {
    assistRequest = request;
    this.collector = collector;
    await _generateFromJson();
  }

  Future<void> _generateFromJson() async {
    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode == null || classNode.members.isEmpty || classNode.declaredElement == null) {
      return;
    }

    final ClassElement classElement = classNode.declaredElement!;
    final SourceRange? fromJsonSourceRange =
        classNode.members.getSourceRangeForConstructor('fromJson');

    final List<FieldElement> finalFieldsElements = classElement.fields.where((FieldElement field) {
      return field.isFinal && field.isPublic && !field.hasInitializer && field.type.isJsonSupported;
    }).toList(growable: false);

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      filePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerFromJson(DartEditBuilder builder) {
          _writeFromJson(
            classElement: classElement,
            finalFieldsElements: finalFieldsElements,
            builder: builder,
          );
        }

        if (fromJsonSourceRange != null) {
          fileEditBuilder.addReplacement(fromJsonSourceRange, writerFromJson);
        } else {
          fileEditBuilder.addInsertion(
            classNode.rightBracket.offset,
            writerFromJson,
          );
        }

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      },
    );

    addAssist(AvailableAssists.fromJson, changeBuilder);
  }

  void _writeFromJson({
    required final ClassElement classElement,
    required final List<FieldElement> finalFieldsElements,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln('/// Creates an instance of [${classElement.name}] from [json]')
      ..writeln('factory ${classElement.name}.fromJson(Map<String, dynamic> json) {')
      ..writeln('return ${classElement.name}(');

    for (final FieldElement field in finalFieldsElements) {
      final ElementAnnotation? jsonKeyAnnotation = field.metadata
          .firstWhereOrNull((ElementAnnotation annotation) => annotation.isJsonKeyAnnotation);
      final JsonKeyInternal jsonKey = JsonKeyInternal //
          .fromDartObject(jsonKeyAnnotation?.computeConstantValue());

      if (jsonKey.ignore) {
        continue;
      }

      final String fieldName = field.name;
      final DartType fieldType = field.type;
      final String jsonFieldName = "json['${jsonKey.name ?? fieldName}']";
      final ConstructorElement? defaultConstructor = classElement.constructors
          .firstWhereOrNull((ConstructorElement ctor) => ctor.name.isEmpty);
      final String? defaultValueString = defaultConstructor?.parameters
          .firstWhereOrNull((ParameterElement param) => param.name == fieldName)
          ?.defaultValueCode;

      builder.write('$fieldName: ');

      if (jsonKey.fromJson != null) {
        builder
          ..write(jsonKey.fromJson!.fullyQualifiedName(
            enclosingImports: classElement.library.libraryImports,
          ))
          ..write('(json),');
        continue;
      }

      _decideNextParsingMethodBasedOnType(
        nextType: fieldType,
        builder: builder,
        parentVariableName: jsonFieldName,
        depthIndex: 0,
        defaultValue: defaultValueString,
      );
    }

    builder
      ..writeln(');')
      ..writeln('}');
  }

  void _decideNextParsingMethodBasedOnType({
    required final DartType? nextType,
    required final DartEditBuilder builder,
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
          builder: builder,
          parentVariableName: parentVariableName,
          defaultValue: defaultValue,
        );
      }
      _parseList(
        builder: builder,
        type: nextType as ParameterizedType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
      );
      builder.writeln(',');
      return;
    }

    if (nextType.isDartCoreMap) {
      if (nextType.isNullable || defaultValue != null) {
        _writeNullableParsingPrefix(
          builder: builder,
          parentVariableName: parentVariableName,
          defaultValue: defaultValue,
        );
      }
      _parseMap(
        builder: builder,
        type: nextType as ParameterizedType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
      );
      builder.writeln(',');
      return;
    }

    if (nextType.isNullable || defaultValue != null) {
      _writeNullableParsingPrefix(
        builder: builder,
        parentVariableName: parentVariableName,
        defaultValue: defaultValue,
      );
    }

    _parsePrimary(
      builder: builder,
      type: nextType,
      parentVariableName: parentVariableName,
    );
  }

  void _writeNullableParsingPrefix({
    required final DartEditBuilder builder,
    required final String parentVariableName,
    final String? defaultValue,
  }) {
    builder.write('$parentVariableName == null ? $defaultValue : ');
  }

  void _parsePrimary({
    required final DartEditBuilder builder,
    required final DartType type,
    required final String parentVariableName,
  }) {
    final String? fieldType = type.element!.name;

    if (type.isDynamic) {
      builder.writeln('$parentVariableName,');
      return;
    }

    if (type.isPrimary) {
      builder.writeln('$parentVariableName as $fieldType,');
      return;
    }

    if (type.element is ClassElement) {
      final ClassElement classElement = type.element as ClassElement;
      final String? convertMethod = <String>[
        ...classElement.methods.map((MethodElement method) => method.name),
        ...classElement.constructors.map((ConstructorElement ctor) => ctor.name)
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
        builder.writeln('$fieldType.$convertMethod($parentVariableName),');
        return;
      }
    }

    builder.write('jsonConverterRegistrant.find($fieldType).fromJson($parentVariableName) '
        'as $fieldType,');
  }

  void _parseList({
    required final DartEditBuilder builder,
    required final ParameterizedType type,
    required final String parentVariableName,
    required final int depthIndex,
  }) {
    builder.write('<${type.typeArguments[0].typeStringValue()}>[');

    final String loopVariableName = 'i$depthIndex';
    builder.writeln(
        'for (final dynamic $loopVariableName in ($parentVariableName as ${type.element!.name}<dynamic>))');

    _decideNextParsingMethodBasedOnType(
      nextType: type.typeArguments[0],
      builder: builder,
      parentVariableName: loopVariableName,
      depthIndex: 1 + depthIndex,
    );

    builder.writeln(']');
  }

  void _parseMap({
    required final DartEditBuilder builder,
    required final ParameterizedType type,
    required final String parentVariableName,
    required final int depthIndex,
  }) {
    if (!type.typeArguments[0].isDartCoreString) {
      return;
    }

    builder.write('<String, ${type.typeArguments[1].typeStringValue()}>{');

    final String loopVariableName = 'e$depthIndex';
    builder
      ..writeln(
          'for (final MapEntry<String, dynamic> $loopVariableName in ($parentVariableName as ${type.element!.name}<String, dynamic>).entries)')
      ..write('$loopVariableName.key: ');

    _decideNextParsingMethodBasedOnType(
      nextType: type.typeArguments[1],
      builder: builder,
      parentVariableName: '$loopVariableName.value',
      depthIndex: 1 + depthIndex,
    );

    builder.writeln('}');
  }
}
