import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/annotations/data_class_internal.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/contributors/class/copy_with_assist_contributor.dart';
import 'package:data_class_plugin/src/contributors/class/from_json_assist_contributor/from_json_assist_contributor.dart';
import 'package:data_class_plugin/src/contributors/class/hash_and_equals_assist_contributor.dart';
import 'package:data_class_plugin/src/contributors/class/to_json_assist_contributor/to_json_assist_contributor.dart';
import 'package:data_class_plugin/src/contributors/common/to_string_assist_contributor.dart';
import 'package:data_class_plugin/src/extensions.dart';
import 'package:data_class_plugin/src/mixins.dart';

class DataClassAssistContributor extends Object
    with AssistContributorMixin, ClassAstVisitorMixin
    implements AssistContributor {
  DataClassAssistContributor(this.filePath);

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
    await _generateDataClass();
  }

  Future<void> _generateDataClass() async {
    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode == null || classNode.declaredElement == null) {
      return;
    }

    final ClassElement classElement = classNode.declaredElement!;

    if (classElement.hasUnionAnnotation || !classElement.hasDataClassAnnotation) {
      return;
    }

    final DataClassInternal dataClassAnnotation = DataClassInternal.fromDartObject(
      classElement.metadata
          .firstWhere((ElementAnnotation annotation) => annotation.isDataClassAnnotation)
          .computeConstantValue(),
    );

    final SourceRange? copyWithSourceRange = classNode.members.getSourceRangeForMethod('copyWith');
    final SourceRange? equalsSourceRange = classNode.members.getSourceRangeForMethod('==');
    final SourceRange? hashCodeSourceRange = classNode.members.getSourceRangeForMethod('hashCode');
    final SourceRange? toStringSourceRange = classNode.members.getSourceRangeForMethod('toString');
    final SourceRange? fromJsonSourceRange =
        classNode.members.getSourceRangeForConstructor('fromJson');
    final SourceRange? toJsonSourceRange = classNode.members.getSourceRangeForMethod('toJson');

    final List<FieldElement> finalFieldsElements = classElement.fields
        .where((FieldElement field) => field.isFinal && field.isPublic && !field.hasInitializer)
        .toList(growable: false);

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(filePath, (DartFileEditBuilder fileEditBuilder) {
      if (dataClassAnnotation.$toString) {
        void writerToString(DartEditBuilder builder) {
          ToStringAssistContributor.writeToString(
            elementName: classElement.thisType.toString(),
            commentElementName: classElement.name,
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
      } else if (toStringSourceRange != null) {
        fileEditBuilder.addDeletion(toStringSourceRange);
      }

      if (dataClassAnnotation.hashAndEquals) {
        void writerHashCode(DartEditBuilder builder) {
          HashAndEqualsAssistContributor.writeHashCode(
            finalFieldsElements: finalFieldsElements,
            builder: builder,
          );
        }

        void writerEquals(DartEditBuilder builder) {
          HashAndEqualsAssistContributor.writeEquals(
            className: classElement.thisType.toString(),
            finalFieldsElements: finalFieldsElements,
            builder: builder,
          );
        }

        if (hashCodeSourceRange != null) {
          fileEditBuilder.addReplacement(hashCodeSourceRange, writerHashCode);
        } else {
          fileEditBuilder.addInsertion(
            classNode.rightBracket.offset,
            writerHashCode,
          );
        }

        if (equalsSourceRange != null) {
          fileEditBuilder.addReplacement(equalsSourceRange, writerEquals);
        } else {
          fileEditBuilder.addInsertion(
            classNode.rightBracket.offset,
            writerEquals,
          );
        }
      } else {
        if (hashCodeSourceRange != null) {
          fileEditBuilder.addDeletion(hashCodeSourceRange);
        }

        if (equalsSourceRange != null) {
          fileEditBuilder.addDeletion(equalsSourceRange);
        }
      }

      if (dataClassAnnotation.copyWith) {
        void writerCopyWith(DartEditBuilder builder) {
          CopyWithAssistContributor.writeCopyWith(
            className: classElement.thisType.toString(),
            commentClassName: classElement.name,
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
      } else if (copyWithSourceRange != null) {
        fileEditBuilder.addDeletion(copyWithSourceRange);
      }

      if (dataClassAnnotation.toJson) {
        void writerToJson(DartEditBuilder builder) {
          ToJsonAssistContributor.writeToJson(
            classElement: classElement,
            finalFieldsElements: finalFieldsElements,
            builder: builder,
          );
        }

        if (toJsonSourceRange != null) {
          fileEditBuilder.addReplacement(toJsonSourceRange, writerToJson);
        } else {
          fileEditBuilder.addInsertion(
            classNode.rightBracket.offset,
            writerToJson,
          );
        }
      } else if (toJsonSourceRange != null) {
        fileEditBuilder.addDeletion(toJsonSourceRange);
      }

      if (dataClassAnnotation.fromJson) {
        void writerFromJson(DartEditBuilder builder) {
          FromJsonAssistContributor.writeFromJson(
            classElement: classElement,
            finalFieldsElements: finalFieldsElements,
            builder: builder,
          );
        }

        if (fromJsonSourceRange != null) {
          fileEditBuilder.addReplacement(fromJsonSourceRange, writerFromJson);
        } else {
          fileEditBuilder.addInsertion(
            classNode.rightBracket.offset,
            writerFromJson,
          );
        }
      } else if (fromJsonSourceRange != null) {
        fileEditBuilder.addDeletion(fromJsonSourceRange);
      }

      fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
    });

    addAssist(AvailableAssists.dataClass, changeBuilder);
  }
}
