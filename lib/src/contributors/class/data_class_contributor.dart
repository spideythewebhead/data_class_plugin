import 'dart:io' as io show File;

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
import 'package:data_class_plugin/src/contributors/class/class_contributors.dart';
import 'package:data_class_plugin/src/contributors/class/utils.dart' as utils;
import 'package:data_class_plugin/src/contributors/common/to_string_assist_contributor.dart';
import 'package:data_class_plugin/src/extensions.dart';
import 'package:data_class_plugin/src/mixins.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';

class DataClassAssistContributor extends Object
    with AssistContributorMixin, ClassAstVisitorMixin, RelativeFilePathMixin
    implements AssistContributor {
  DataClassAssistContributor(this.targetFilePath);

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

    final SourceRange? constructorSourceRange =
        classNode.members.getSourceRangeForConstructor(null);
    final SourceRange? copyWithSourceRange = classNode.members.getSourceRangeForMethod('copyWith');
    final SourceRange? equalsSourceRange = classNode.members.getSourceRangeForMethod('==');
    final SourceRange? hashCodeSourceRange = classNode.members.getSourceRangeForMethod('hashCode');
    final SourceRange? toStringSourceRange = classNode.members.getSourceRangeForMethod('toString');
    final SourceRange? fromJsonSourceRange =
        classNode.members.getSourceRangeForConstructor('fromJson');
    final SourceRange? toJsonSourceRange = classNode.members.getSourceRangeForMethod('toJson');

    final List<VariableElement> fields = <VariableElement>[
      ...classElement.dataClassFinalFields,
      ...classElement.chainSuperClassDataClassFinalFields,
    ];

    final DataClassPluginOptions pluginOptions = await DataClassPluginOptions.fromFile((io.File(
      utils.getDataClassPluginOptionsPath(session.analysisContext.contextRoot.root.path),
    )));

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(targetFilePath, (DartFileEditBuilder fileEditBuilder) {
      void writerConstructor(DartEditBuilder builder) {
        ShorthandConstructorAssistContributor.writeConstructor(
          classElement: classElement,
          builder: builder,
          members: classNode.members,
        );
      }

      if (constructorSourceRange != null) {
        fileEditBuilder.addReplacement(
          constructorSourceRange,
          writerConstructor,
        );
      } else {
        fileEditBuilder.addInsertion(
          classNode.leftBracket.offset + 1,
          writerConstructor,
        );
      }

      if (dataClassAnnotation.$toString ??
          pluginOptions.dataClass.effectiveToString(relativeFilePath)) {
        void writerToString(DartEditBuilder builder) {
          ToStringAssistContributor.writeToString(
            className:
                classElement.thisType.typeStringValue().prefixGenericArgumentsWithDollarSign(),
            optimizedName: classElement.name,
            commentElementName: classElement.name,
            fields: fields,
            builder: builder,
          );
        }

        if (toStringSourceRange != null) {
          fileEditBuilder.addReplacement(
            toStringSourceRange,
            writerToString,
          );
        } else {
          fileEditBuilder.addInsertion(
            classNode.rightBracket.offset,
            writerToString,
          );
        }
      } else if (toStringSourceRange != null) {
        fileEditBuilder.addDeletion(toStringSourceRange);
      }

      if (dataClassAnnotation.hashAndEquals ??
          pluginOptions.dataClass.effectiveHashAndEquals(relativeFilePath)) {
        void writerHashCode(DartEditBuilder builder) {
          HashAndEqualsAssistContributor.writeHashCode(
            fields: fields,
            builder: builder,
          );
        }

        void writerEquals(DartEditBuilder builder) {
          HashAndEqualsAssistContributor.writeEquals(
            className: classElement.thisType.toString(),
            fields: fields,
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

      if (dataClassAnnotation.copyWith ??
          pluginOptions.dataClass.effectiveCopyWith(relativeFilePath)) {
        void writerCopyWith(DartEditBuilder builder) {
          CopyWithAssistContributor.writeCopyWith(
            className: classElement.thisType.toString(),
            classElement: classElement,
            commentClassName: classElement.name,
            fields: fields,
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

      if (dataClassAnnotation.toJson ?? pluginOptions.dataClass.effectiveToJson(relativeFilePath)) {
        void writerToJson(DartEditBuilder builder) {
          ToJsonAssistContributor.writeToJson(
            targetFileRelativePath: relativeFilePath,
            pluginOptions: pluginOptions,
            classElement: classElement,
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

      if (dataClassAnnotation.fromJson ??
          pluginOptions.dataClass.effectiveFromJson(relativeFilePath)) {
        void writerFromJson(DartEditBuilder builder) {
          FromJsonAssistContributor.writeFromJson(
            targetFileRelativePath: relativeFilePath,
            pluginOptions: pluginOptions,
            classElement: classElement,
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
