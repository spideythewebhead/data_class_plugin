import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/extensions.dart';
import 'package:data_class_plugin/src/mixins.dart';

class ToMapAssistContributor extends Object
    with AssistContributorMixin, ClassAstVisitorMixin
    implements AssistContributor {
  ToMapAssistContributor(this.filePath);

  static AssistKind assist = AssistKind('toMap', 999, "Generate 'toMap'");

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
    await _generateToMap();
  }

  Future<void> _generateToMap() async {
    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode == null ||
        classNode.members.isEmpty ||
        classNode.declaredElement == null) {
      return;
    }

    final ClassElement classElement = classNode.declaredElement!;
    final SourceRange? toMapSourceRange =
        classNode.members.getSourceRangeForMethod('toMap');

    final List<FieldElement> finalFieldsElements = classElement.fields
        .where((FieldElement field) => field.isFinal && field.isPublic)
        .toList(growable: false);

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      filePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerToMap(DartEditBuilder builder) {
          _writeToMap(
            finalFieldsElements: finalFieldsElements,
            builder: builder,
          );
        }

        if (toMapSourceRange != null) {
          fileEditBuilder.addReplacement(toMapSourceRange, writerToMap);
        } else {
          fileEditBuilder.addInsertion(
            classNode.rightBracket.offset,
            writerToMap,
          );
        }

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      },
    );

    addAssist(assist, changeBuilder);
  }

  void _writeToMap({
    required final List<FieldElement> finalFieldsElements,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln('Map<String, dynamic> toMap() {')
      ..writeln('return <String, dynamic>{');

    for (final FieldElement field in finalFieldsElements) {
      final String fieldName = field.name;
      builder.write("'$fieldName': $fieldName,");
    }

    builder
      ..writeln('};')
      ..writeln('}');
  }
}
