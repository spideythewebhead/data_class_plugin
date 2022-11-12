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
import 'package:data_class_plugin/src/contributors/class/from_json_assist_contributor/from_json_generator.dart';
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

    if (classElement.hasUnionAnnotation) {
      return;
    }

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
          writeFromJson(
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

  static void writeFromJson({
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

      FromJsonGenerator(
        checkIfShouldUseFromJson: (DartType type) {
          return type.element == classElement;
        },
      ).run(
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
}
