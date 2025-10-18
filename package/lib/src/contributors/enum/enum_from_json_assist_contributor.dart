import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/mixins.dart';

class EnumFromJsonAssistContributor extends AssistContributorMixin
    with EnumAstVisitorMixin, RelativeFilePathMixin {
  EnumFromJsonAssistContributor(this.targetFilePath);

  @override
  final String targetFilePath;

  @override
  late final DartAssistRequest assistRequest;

  @override
  late final AssistCollector collector;

  @override
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
    final EnumDeclaration? enumNode = findEnumDeclaration();
    if (enumNode == null || enumNode.declaredFragment?.element == null) {
      return;
    }

    final EnumElement2 enumElement = enumNode.declaredFragment!.element;
    if (enumElement.metadata2.hasEnumAnnotation) {
      return;
    }

    final SourceRange? fromJsonSourceRange = enumNode.members.fromJsonSourceRange;
    final List<FieldElement2> finalFieldsElements = enumElement.jsonSupportedFields;

    if (finalFieldsElements.length > 1) {
      return;
    }

    if (finalFieldsElements.isNotEmpty && !finalFieldsElements[0].type.isPrimary) {
      return;
    }

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(targetFilePath, (
      DartFileEditBuilder fileEditBuilder,
    ) {
      void writerFromJson(DartEditBuilder builder) {
        writeFromJson(
          enumElement: enumElement,
          fieldElement: finalFieldsElements.firstOrNull,
          builder: builder,
          libraryImports: enumNode.declaredFragment!.libraryFragment.libraryImports2,
        );
      }

      if (fromJsonSourceRange != null) {
        fileEditBuilder.addReplacement(fromJsonSourceRange, writerFromJson);
      } else {
        fileEditBuilder.addInsertion(
          enumNode.rightBracket.offset,
          writerFromJson,
        );
      }

      fileEditBuilder.format(SourceRange(enumNode.offset, enumNode.length));
    });

    addAssist(AvailableAssists.fromJson, changeBuilder);
  }

  static void writeFromJson({
    required final EnumElement2 enumElement,
    required final FieldElement2? fieldElement,
    required final DartEditBuilder builder,
    required final List<LibraryImport> libraryImports,
  }) {
    final String enumName = enumElement.name3!;

    builder
      ..writeln()
      ..writeln('/// Creates an instance of [$enumName] from [json]');

    if (fieldElement == null) {
      builder
        ..writeln('factory $enumName.fromJson(String json) {')
        ..writeln(
          'return $enumName.values.firstWhere(($enumName value) => value.name == json);',
        )
        ..writeln('}');
      return;
    }

    builder
      ..writeln(
        'factory $enumName.fromJson(${fieldElement.type.typeStringValue(enclosingImports: libraryImports)} json) {',
      )
      ..writeln('return $enumName.values.firstWhere')
      ..writeln('(($enumName e) => e.${fieldElement.name3} == json);')
      ..writeln('}');
  }
}
