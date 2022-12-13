import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/mixins.dart';

class EnumToJsonAssistContributor extends Object
    with AssistContributorMixin, EnumAstVisitorMixin, RelativeFilePathMixin
    implements AssistContributor {
  EnumToJsonAssistContributor(this.targetFilePath);

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
    await _generateToJson();
  }

  Future<void> _generateToJson() async {
    final EnumDeclaration? enumNode = findEnumDeclaration();
    if (enumNode == null || enumNode.declaredElement == null) {
      return;
    }

    final EnumElement enumElement = enumNode.declaredElement!;
    if (enumElement.hasEnumAnnotation) {
      return;
    }

    final SourceRange? toJsonSourceRange = enumNode.members.toJsonSourceRange;
    final List<FieldElement> finalFieldsElements = enumElement.jsonSupportedFields;

    if (finalFieldsElements.length > 1) {
      return;
    }

    if (finalFieldsElements.isNotEmpty && !finalFieldsElements[0].type.isPrimary) {
      return;
    }

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      targetFilePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerToJson(DartEditBuilder builder) {
          writeToJson(
            enumElement: enumElement,
            fieldElement: finalFieldsElements.firstOrNull,
            builder: builder,
          );
        }

        if (toJsonSourceRange != null) {
          fileEditBuilder.addReplacement(toJsonSourceRange, writerToJson);
        } else {
          fileEditBuilder.addInsertion(
            enumNode.rightBracket.offset,
            writerToJson,
          );
        }

        fileEditBuilder.format(SourceRange(enumNode.offset, enumNode.length));
      },
    );

    addAssist(AvailableAssists.toJson, changeBuilder);
  }

  static void writeToJson({
    required final EnumElement enumElement,
    required final FieldElement? fieldElement,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln('/// Converts [${enumElement.name}] to a json value');

    if (fieldElement == null) {
      builder.writeln('String toJson() => name;');
      return;
    }

    builder.writeln(
        '${fieldElement.type.typeStringValue(enclosingImports: enumElement.library.libraryImports)} toJson() => ${fieldElement.name};');
  }
}
