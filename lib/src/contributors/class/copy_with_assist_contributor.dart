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
    if (classNode == null || classNode.members.isEmpty || classNode.declaredElement == null) {
      return;
    }

    final ClassElement classElement = classNode.declaredElement!;

    if (classElement.hasUnionAnnotation) {
      return;
    }

    final SourceRange? copyWithSourceRange = classNode.members.getSourceRangeForMethod('copyWith');

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      filePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerCopyWith(DartEditBuilder builder) {
          writeCopyWith(
            className: classElement.name,
            classElement: classElement,
            fields: <VariableElement>[
              ...classElement.dataClassFinalFields,
              ...classElement.chainSuperClassDataClassFinalFields,
            ],
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

  static void writeCopyWith({
    required final String className,
    required final ClassElement classElement,
    required final List<VariableElement> fields,
    required final DartEditBuilder builder,
    final String? commentClassName,
  }) {
    final ConstructorElement? defaultConstructor = classElement.defaultConstructor;
    final bool isConst = defaultConstructor?.isConst ?? false;

    builder
      ..writeln()
      ..writeln(
          '/// Creates a new instance of [${commentClassName ?? className}] with optional new values')
      ..writeln('$className copyWith(');

    if (fields.isNotEmpty) {
      builder.write('{');
      for (final VariableElement field in fields) {
        final String typeStringValue = field.type.typeStringValue();
        final bool isNullable = typeStringValue.endsWith('?');
        builder.writeln('final $typeStringValue${isNullable ? '' : '?'} ${field.name},');
      }
      builder.write('}');
    }
    builder.writeln(') {');

    if (isConst && fields.isEmpty) {
      builder
        ..writeln('    // ignore: prefer_const_constructors')
        ..writeln('return $className();')
        ..writeln('}');
      return;
    }

    builder.writeln('return $className(');

    for (final VariableElement field in fields) {
      builder.writeln('${field.name}: ${field.name} ?? this.${field.name},');
    }

    builder
      ..writeln(');')
      ..writeln('}');
  }
}
