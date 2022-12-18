import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/contributors/generators/to_string.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
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
    if (enumNode != null && enumNode.declaredElement != null) {
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
    if (element.hasUnionAnnotation || element.hasDataClassAnnotation || element.hasEnumAnnotation) {
      return;
    }

    final SourceRange? toStringSourceRange = classMembers.toStringSourceRange;

    final List<VariableElement> fields = <VariableElement>[
      ...element.dataClassFinalFields,
      ...element.chainSuperClassDataClassFinalFields,
    ];

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      filePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerToString(DartEditBuilder builder) {
          late final String elementName;
          if (element is EnumElement) {
            elementName = '${element.name}.\$name';
          } else {
            elementName = (element as ClassElement)
                .thisType
                .typeStringValue(enclosingImports: element.library.libraryImports);
          }

          ToStringGenerator(
            codeWriter: CodeWriter.dartEditBuilder(builder),
            className: elementName,
            optimizedClassName: element.name,
            commentClassName: element.name,
            fields: fields,
          ).execute();
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
}
