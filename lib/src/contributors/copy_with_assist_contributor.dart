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

class CopyWithAssistContributor extends Object
    with AssistContributorMixin, ClassAstVisitorMixin
    implements AssistContributor {
  CopyWithAssistContributor(this.filePath);

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
    await _generateCopyWith();
  }

  Future<void> _generateCopyWith() async {
    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode == null ||
        classNode.members.isEmpty ||
        classNode.declaredElement == null) {
      return;
    }

    final ClassElement classElement = classNode.declaredElement!;
    final SourceRange? copyWithSourceRange =
        classNode.members.getSourceRangeForMethod('copyWith');

    final List<FieldElement> finalFieldsElements =
        classElement.fields.where((FieldElement field) {
      return field.isFinal && field.isPublic && !field.hasInitializer;
    }).toList(growable: false);

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      filePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerCopyWith(DartEditBuilder builder) {
          _writeCopyWith(
            className: classElement.name,
            finalFieldsElements: finalFieldsElements,
            builder: builder,
          );
        }

        if (copyWithSourceRange != null) {
          fileEditBuilder.addReplacement(copyWithSourceRange, writerCopyWith);
        } else {
          fileEditBuilder.addInsertion(
            classNode.rightBracket.offset,
            writerCopyWith,
          );
        }

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      },
    );

    addAssist(AvailableAssists.copyWith, changeBuilder);
  }

  void _writeCopyWith({
    required final String className,
    required final List<FieldElement> finalFieldsElements,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln('$className copyWith({');

    for (final FieldElement field in finalFieldsElements) {
      builder.writeln('final ${field.type.typeStringValue()}? ${field.name},');
    }

    builder
      ..writeln('}) {')
      ..writeln('return $className(');

    for (final FieldElement field in finalFieldsElements) {
      builder.writeln('${field.name}: ${field.name} ?? this.${field.name},');
    }

    builder
      ..writeln(');')
      ..writeln('}');
  }
}
