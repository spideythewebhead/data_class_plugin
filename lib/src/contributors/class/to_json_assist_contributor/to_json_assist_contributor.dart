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
import 'package:data_class_plugin/src/contributors/class/to_json_assist_contributor/to_json_generator.dart';
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

    if (classElement.hasUnionAnnotation) {
      return;
    }

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

      ToJsonGenerator(
        checkIfShouldUseToJson: (DartType type) {
          return type.element == classElement;
        },
      ).run(
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
}
