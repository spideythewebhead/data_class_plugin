import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/extensions.dart';
import 'package:data_class_plugin/src/mixins.dart';

class EnumFromJsonAssistContributor extends Object
    with AssistContributorMixin, EnumAstVisitorMixin
    implements AssistContributor {
  EnumFromJsonAssistContributor(this.filePath);

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
    final EnumDeclaration? enumNode = findEnumDeclaration();
    if (enumNode == null || enumNode.members.isEmpty || enumNode.declaredElement == null) {
      return;
    }

    final EnumElement enumElement = enumNode.declaredElement!;
    final SourceRange? fromJsonSourceRange =
        enumNode.members.getSourceRangeForConstructor('fromJson');

    final List<FieldElement> finalFieldsElements = enumElement.fields.where((FieldElement field) {
      return field.isFinal && field.isPublic && field.type.isJsonSupported;
    }).toList(growable: false);

    if (finalFieldsElements.length > 1) {
      return;
    }

    if (finalFieldsElements.isNotEmpty && !finalFieldsElements[0].type.isPrimary) {
      return;
    }

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      filePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerFromJson(DartEditBuilder builder) {
          _writeFromJson(
            enumElement: enumElement,
            fieldElement: finalFieldsElements.firstOrNull,
            builder: builder,
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
      },
    );

    addAssist(AvailableAssists.fromJson, changeBuilder);
  }

  void _writeFromJson({
    required final EnumElement enumElement,
    required final FieldElement? fieldElement,
    required final DartEditBuilder builder,
  }) {
    final String enumName = enumElement.name;

    builder
      ..writeln()
      ..writeln('/// Creates an instance of [$enumName] from [json]');

    if (fieldElement == null) {
      builder
        ..writeln('factory $enumName.fromJson(String json) {')
        ..writeln('return $enumName.values.firstWhere(($enumName value) => value.name == json);')
        ..writeln('}');
      return;
    }

    builder
      ..writeln('factory $enumName.fromJson(${fieldElement.type.typeStringValue()} json) {')
      ..writeln('return $enumName.values.firstWhere')
      ..writeln('(($enumName e) => e.${fieldElement.name} == json);')
      ..writeln('}');
  }
}