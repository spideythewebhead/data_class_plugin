import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/annotations/map_key_internal.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/extensions.dart';
import 'package:data_class_plugin/src/mixins.dart';

class FromMapAssistContributor extends Object
    with AssistContributorMixin, ClassAstVisitorMixin
    implements AssistContributor {
  FromMapAssistContributor(this.filePath);

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
    await _generateFromMap();
  }

  Future<void> _generateFromMap() async {
    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode == null ||
        classNode.members.isEmpty ||
        classNode.declaredElement == null) {
      return;
    }

    final ClassElement classElement = classNode.declaredElement!;
    final SourceRange? fromMapSourceRange =
        classNode.members.getSourceRangeForConstructor('fromMap');

    final List<FieldElement> finalFieldsElements =
        classElement.fields.where((FieldElement field) {
      return field.isFinal &&
          field.isPublic &&
          !field.hasInitializer &&
          field.type.isJsonSupported;
    }).toList(growable: false);

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      filePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerFromMap(DartEditBuilder builder) {
          _writeFromMap(
            classElement: classElement,
            finalFieldsElements: finalFieldsElements,
            builder: builder,
          );
        }

        if (fromMapSourceRange != null) {
          fileEditBuilder.addReplacement(fromMapSourceRange, writerFromMap);
        } else {
          fileEditBuilder.addInsertion(
            classNode.rightBracket.offset,
            writerFromMap,
          );
        }

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      },
    );

    addAssist(AvailableAssists.fromMap, changeBuilder);
  }

  void _writeFromMap({
    required final ClassElement classElement,
    required final List<FieldElement> finalFieldsElements,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln(
          'factory ${classElement.name}.fromMap(Map<String, dynamic> map) {')
      ..writeln('return ${classElement.name}(');

    for (final FieldElement field in finalFieldsElements) {
      final ElementAnnotation? mapKeyAnnotation = field.metadata
          .firstWhereOrNull(
              (ElementAnnotation annotation) => annotation.isMapKeyAnnotation);
      final MapKeyInternal mapKey = MapKeyInternal //
          .fromDartObject(mapKeyAnnotation?.computeConstantValue());

      if (mapKey.ignore) {
        continue;
      }

      final String fieldName = field.name;
      final DartType fieldType = field.type;
      final String mapFieldName = "map['${mapKey.name ?? fieldName}']";
      final ConstructorElement? defaultConstructor = classElement.constructors
          .firstWhereOrNull((ConstructorElement ctor) => ctor.name.isEmpty);
      final String? defaultValueString = defaultConstructor?.parameters
          .firstWhereOrNull((ParameterElement param) => param.name == fieldName)
          ?.defaultValueCode;

      builder.write('$fieldName: ');

      if (mapKey.fromMap != null) {
        _parseWithCustomMethod(
          builder: builder,
          parentVariableName: 'map',
          parsingMethodName: mapKey.fromMap!.fullyQualifiedName(
            enclosingImports: classElement.library.libraryImports,
          ),
        );
        continue;
      }

      _decideNextParsingMethodBasedOnType(
        nextType: fieldType,
        builder: builder,
        parentVariableName: mapFieldName,
        depthIndex: 0,
        defaultValue: defaultValueString,
      );
    }

    builder
      ..writeln(');')
      ..writeln('}');
  }

  void _parsePrimary({
    required final DartEditBuilder builder,
    required final DartType type,
    required final String parentVariableName,
  }) {
    if (type.isDynamic) {
      builder.writeln('$parentVariableName,');
      return;
    }

    if (type.isPrimary) {
      builder.writeln('$parentVariableName as ${type.element2!.name},');
      return;
    }

    if (type.isUri) {
      builder.writeln('Uri.parse($parentVariableName as String),');
      return;
    }

    builder.writeln('${type.element2!.name}.fromMap($parentVariableName),');
  }

  void _writeNullableParsingPrefix({
    required final DartEditBuilder builder,
    required final String parentVariableName,
    final String? defaultValue,
  }) {
    builder.write('$parentVariableName == null ? $defaultValue : ');
  }

  void _parseList({
    required final DartEditBuilder builder,
    required final ParameterizedType type,
    required final String parentVariableName,
    required final int depthIndex,
  }) {
    builder.write('[');

    final String loopVariableName = 'i$depthIndex';
    builder.writeln(
        'for (final dynamic $loopVariableName in ($parentVariableName as ${type.element2!.name}<dynamic>))');

    _decideNextParsingMethodBasedOnType(
      nextType: type.typeArguments.first,
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

    builder.write('<String, ${type.typeArguments[1].element2!.name}>{');

    final String loopVariableName = 'e$depthIndex';
    builder
      ..writeln(
          'for (final MapEntry<String, dynamic> $loopVariableName in ($parentVariableName as ${type.element2!.name}<String, dynamic>).entries)')
      ..write('$loopVariableName.key: ');

    _decideNextParsingMethodBasedOnType(
      nextType: type.typeArguments[1],
      builder: builder,
      parentVariableName: '$loopVariableName.value',
      depthIndex: 1 + depthIndex,
    );

    builder.writeln('}');
  }

  void _parseWithCustomMethod({
    required final DartEditBuilder builder,
    required final String parentVariableName,
    required final String parsingMethodName,
  }) {
    builder.write('$parsingMethodName($parentVariableName),');
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

    if (nextType.isNullable || defaultValue != null) {
      _writeNullableParsingPrefix(
        builder: builder,
        parentVariableName: parentVariableName,
        defaultValue: defaultValue,
      );
    }

    if (nextType.isDartCoreList) {
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
      _parseMap(
        builder: builder,
        type: nextType as ParameterizedType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
      );
      builder.writeln(',');
      return;
    }

    _parsePrimary(
      builder: builder,
      type: nextType,
      parentVariableName: parentVariableName,
    );
  }
}
