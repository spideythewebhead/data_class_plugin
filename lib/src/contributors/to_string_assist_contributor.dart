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

class ToStringAssistContributor extends Object
    with AssistContributorMixin, ClassAstVisitorMixin
    implements AssistContributor {
  ToStringAssistContributor(this.filePath);

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
    await _generateToString();
  }

  Future<void> _generateToString() async {
    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode == null ||
        classNode.members.isEmpty ||
        classNode.declaredElement == null) {
      return;
    }

    final ClassElement classElement = classNode.declaredElement!;
    final SourceRange? toStringSourceRange =
        classNode.members.getSourceRangeForMethod('toString');

    final List<FieldElement> finalFieldsElements = classElement.fields
        .where((FieldElement field) => field.isFinal && field.isPublic)
        .toList(growable: false);

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      filePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerToString(DartEditBuilder builder) {
          _writeToString(
            className: classElement.name,
            finalFieldsElements: finalFieldsElements,
            builder: builder,
          );
        }

        if (toStringSourceRange != null) {
          fileEditBuilder.addReplacement(toStringSourceRange, writerToString);
        } else {
          fileEditBuilder.addInsertion(
            classNode.rightBracket.offset,
            writerToString,
          );
        }

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      },
    );

    addAssist(AvailableAssists.toString2, changeBuilder);
  }

  void _writeToString({
    required final String className,
    required final List<FieldElement> finalFieldsElements,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln('/// Returns a string with the properties of [this]')
      ..writeln('@override')
      ..writeln('String toString() {')
      ..writeln('return """$className(');

    for (final FieldElement field in finalFieldsElements) {
      builder.writeln("<${field.name}= \$${field.name}>,");
    }

    builder
      ..writeln(')""";')
      ..writeln('}');
  }
}
