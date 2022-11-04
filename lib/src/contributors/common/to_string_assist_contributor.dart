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
    with AssistContributorMixin, ClassAstVisitorMixin, EnumAstVisitorMixin
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

    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode != null && classNode.members.isNotEmpty && classNode.declaredElement != null) {
      await _generateToString(
        node: classNode,
        element: classNode.declaredElement!,
        classMembers: classNode.members,
        rightBracketOffset: classNode.rightBracket.offset,
      );
    }

    final EnumDeclaration? enumNode = findEnumDeclaration();
    if (enumNode != null && enumNode.members.isNotEmpty && enumNode.declaredElement != null) {
      await _generateToString(
        node: enumNode,
        element: enumNode.declaredElement!,
        classMembers: enumNode.members,
        rightBracketOffset: enumNode.rightBracket.offset,
      );
    }
  }

  Future<void> _generateToString({
    required final AstNode node,
    required final NodeList<ClassMember> classMembers,
    required final InterfaceElement element,
    required final int rightBracketOffset,
  }) async {
    final SourceRange? toStringSourceRange = classMembers.getSourceRangeForMethod('toString');

    final List<FieldElement> finalFieldsElements = element.fields
        .where((FieldElement field) => field.isFinal && field.isPublic)
        .toList(growable: false);

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      filePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerToString(DartEditBuilder builder) {
          _writeToString(
            element: element,
            finalFieldsElement: finalFieldsElements,
            builder: builder,
          );
        }

        if (toStringSourceRange != null) {
          fileEditBuilder.addReplacement(toStringSourceRange, writerToString);
        } else {
          fileEditBuilder.addInsertion(
            rightBracketOffset,
            writerToString,
          );
        }

        fileEditBuilder.format(SourceRange(node.offset, node.length));
      },
    );

    addAssist(AvailableAssists.toString2, changeBuilder);
  }

  void _writeToString({
    required final InterfaceElement element,
    required final List<FieldElement> finalFieldsElement,
    required final DartEditBuilder builder,
  }) {
    String elementName = element.name;

    if (element is EnumElement) {
      elementName = '$elementName.\$name';
    }

    builder
      ..writeln()
      ..writeln('/// Returns a string with the properties of [$elementName]')
      ..writeln('@override')
      ..writeln('String toString() {')
      ..writeln('return """$elementName(');

    for (final FieldElement field in finalFieldsElement) {
      builder.writeln('  <${field.name}= \$${field.name}>,');
    }

    builder
      ..writeln(')""";')
      ..writeln('}');
  }
}
