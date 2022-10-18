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

class HashAndEqualsAssistContributor extends Object
    with AssistContributorMixin, ClassAstVisitorMixin
    implements AssistContributor {
  HashAndEqualsAssistContributor(this.filePath);

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
    await _generateHashAndEquals();
  }

  Future<void> _generateHashAndEquals() async {
    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode == null ||
        classNode.members.isEmpty ||
        classNode.declaredElement == null) {
      return;
    }

    final ClassElement classElement = classNode.declaredElement!;
    final SourceRange? equalsSourceRange =
        classNode.members.getSourceRangeForMethod('==');
    final SourceRange? hashCodeSourceRange =
        classNode.members.getSourceRangeForMethod('hashCode');

    final List<FieldElement> finalFieldsElements = classElement.fields
        .where((FieldElement field) => field.isFinal && field.isPublic)
        .toList(growable: false);

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      filePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerHashCode(DartEditBuilder builder) {
          _writeHashCode(
            finalFieldsElements: finalFieldsElements,
            builder: builder,
          );
        }

        if (hashCodeSourceRange != null) {
          fileEditBuilder.addReplacement(hashCodeSourceRange, writerHashCode);
        } else {
          fileEditBuilder.addInsertion(
              classNode.rightBracket.offset, writerHashCode);
        }

        void writerEquals(DartEditBuilder builder) {
          _writeEquals(
            finalFieldsElements: finalFieldsElements,
            className: classElement.name,
            builder: builder,
          );
        }

        if (equalsSourceRange != null) {
          fileEditBuilder.addReplacement(equalsSourceRange, writerEquals);
        } else {
          fileEditBuilder.addInsertion(
              classNode.rightBracket.offset, writerEquals);
        }

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      },
    );

    addAssist(AvailableAssists.hashCodeAndEquals, changeBuilder);
  }

  void _writeHashCode({
    required final List<FieldElement> finalFieldsElements,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln('@override')
      ..writeln('int get hashCode {')
      ..writeln('return Object.hashAll(<Object?>[');

    for (final FieldElement field in finalFieldsElements) {
      builder.writeln('${field.name},');
    }

    builder
      ..writeln(']);')
      ..writeln('}');
  }

  void _writeEquals({
    required final List<FieldElement> finalFieldsElements,
    required final String className,
    required final DartEditBuilder builder,
  }) {
    builder
      ..writeln()
      ..writeln('@override')
      ..writeln('bool operator ==(Object other) {')
      ..writeln('return identical(this, other) || other is $className');

    for (final FieldElement field in finalFieldsElements) {
      if (field.type.isDartCoreList ||
          field.type.isDartCoreMap ||
          field.type.isDartCoreSet) {
        builder.write(' && deepEquality(${field.name}, other.${field.name})');
      } else {
        builder.write(' && ${field.name} == other.${field.name}');
      }
    }

    builder
      ..write(';')
      ..writeln('}');
  }
}
