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

class ToJsonAssistContributor extends Object
    with AssistContributorMixin, ClassAstVisitorMixin
    implements AssistContributor {
  ToJsonAssistContributor(this.filePath);

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
    await _generateToJson();
  }

  Future<void> _generateToJson() async {
    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode == null || classNode.members.isEmpty || classNode.declaredElement == null) {
      return;
    }

    final ClassElement classElement = classNode.declaredElement!;
    final SourceRange? toJsonSourceRange = classNode.members.getSourceRangeForMethod('toJson');

    final List<FieldElement> finalFieldsElements = classElement.fields
        .where((FieldElement field) => field.isFinal && field.isPublic)
        .toList(growable: false);

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      filePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerToJson(DartEditBuilder builder) {
          _writeToJson(
            classElement: classElement,
            finalFieldsElements: finalFieldsElements,
            builder: builder,
          );
        }

        if (toJsonSourceRange != null) {
          fileEditBuilder.addReplacement(toJsonSourceRange, writerToJson);
        } else {
          fileEditBuilder.addInsertion(
            classNode.rightBracket.offset,
            writerToJson,
          );
        }

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      },
    );

    addAssist(AvailableAssists.toJson, changeBuilder);
  }

  void _writeToJson({
    required final ClassElement classElement,
    required final List<FieldElement> finalFieldsElements,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln('/// Converts [${classElement.name}] to a [Map] json')
      ..writeln('Map<String, dynamic> toJson() {')
      ..writeln('return <String, dynamic>{');

    for (final FieldElement field in finalFieldsElements) {
      final ElementAnnotation? jsonKeyAnnotation = field.metadata
          .firstWhereOrNull((ElementAnnotation annotation) => annotation.isJsonKeyAnnotation);
      final JsonKeyInternal jsonKey = JsonKeyInternal //
          .fromDartObject(jsonKeyAnnotation?.computeConstantValue());

      if (jsonKey.ignore) {
        continue;
      }

      builder.write("'${jsonKey.name ?? field.name}': ");

      if (jsonKey.toJson != null) {
        builder
          ..write(jsonKey.toJson!
              .fullyQualifiedName(enclosingImports: classElement.library.libraryImports))
          ..write('(${field.name}),');
        continue;
      }

      _decideNextParsingMethodBasedOnType(
        nextType: field.type,
        builder: builder,
        parentVariableName: field.name,
        depthIndex: 0,
      );
    }

    builder
      ..writeln('};')
      ..writeln('}');
  }

  void _decideNextParsingMethodBasedOnType({
    required final DartType? nextType,
    required final DartEditBuilder builder,
    required final int depthIndex,
    required final String parentVariableName,
  }) {
    if (nextType == null) {
      return;
    }

    if (nextType.isDartCoreList) {
      _writeList(
        builder: builder,
        type: nextType as ParameterizedType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
        requiresBangOperator: depthIndex == 0,
      );
      builder.writeln(',');
      return;
    }

    if (nextType.isDartCoreMap) {
      _writeMap(
        builder: builder,
        type: nextType as ParameterizedType,
        parentVariableName: parentVariableName,
        depthIndex: depthIndex,
        requiresBangOperator: depthIndex == 0,
      );
      builder.writeln(',');
      return;
    }

    _writePrimary(
      builder: builder,
      type: nextType,
      parentVariableName: parentVariableName,
    );
  }

  String _getBangOperatorIfNullable(DartType type) {
    return type.isNullable ? '!' : '';
  }

  void _writeNullableParsingPrefix({
    required final DartEditBuilder builder,
    required final String parentVariableName,
  }) {
    builder.write('$parentVariableName == null ? null : ');
  }

  void _writePrimary({
    required final DartEditBuilder builder,
    required final DartType type,
    required final String parentVariableName,
  }) {
    if (type.isDynamic || type.isPrimary) {
      builder.writeln('$parentVariableName,');
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

      if (convertMethod != null) {
        builder.writeln('$parentVariableName.$convertMethod(),');
        return;
      }
    }

    builder.write('jsonConverterRegistrant.find($fieldType).toJson($parentVariableName),');
  }

  void _writeList({
    required final DartEditBuilder builder,
    required final ParameterizedType type,
    required final String parentVariableName,
    required final int depthIndex,
    required final bool requiresBangOperator,
  }) {
    if (type.isNullable) {
      _writeNullableParsingPrefix(
        builder: builder,
        parentVariableName: parentVariableName,
      );
    }

    builder.write('<dynamic>[');

    final String loopVariableName = 'i$depthIndex';
    builder.writeln('for (final '
        '${type.typeArguments[0].typeStringValue()} '
        '$loopVariableName in $parentVariableName'
        '${requiresBangOperator ? _getBangOperatorIfNullable(type) : ''})');

    _decideNextParsingMethodBasedOnType(
      nextType: type.typeArguments.first,
      builder: builder,
      parentVariableName: loopVariableName,
      depthIndex: 1 + depthIndex,
    );

    builder.writeln(']');
  }

  void _writeMap({
    required final DartEditBuilder builder,
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
        builder: builder,
        parentVariableName: parentVariableName,
      );
    }

    builder.write('<String, dynamic>{');

    final String loopVariableName = 'e$depthIndex';
    builder
      ..writeln('for (final '
          'MapEntry<String, ${type.typeArguments[1].typeStringValue()}> '
          '$loopVariableName in $parentVariableName'
          '${requiresBangOperator ? _getBangOperatorIfNullable(type) : ''}'
          '.entries)')
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
