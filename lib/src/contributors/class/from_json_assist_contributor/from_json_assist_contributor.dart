import 'dart:io' as io show File;

import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:data_class_plugin/src/annotations/json_key_internal.dart';
import 'package:data_class_plugin/src/contributors/available_assists.dart';
import 'package:data_class_plugin/src/contributors/class/from_json_assist_contributor/from_json_generator.dart';
import 'package:data_class_plugin/src/contributors/class/utils.dart' as utils;
import 'package:data_class_plugin/src/extensions.dart';
import 'package:data_class_plugin/src/json_key_name_convention.dart';
import 'package:data_class_plugin/src/mixins.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';

class FromJsonAssistContributor extends Object
    with AssistContributorMixin, ClassAstVisitorMixin, RelativeFilePathMixin
    implements AssistContributor {
  FromJsonAssistContributor(this.targetFilePath);

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
    await _generateFromJson();
  }

  Future<void> _generateFromJson() async {
    final ClassDeclaration? classNode = findClassDeclaration();
    if (classNode == null || classNode.members.isEmpty || classNode.declaredElement == null) {
      return;
    }

    final ClassElement classElement = classNode.declaredElement!;

    if (classElement.hasUnionAnnotation) {
      return;
    }

    final SourceRange? fromJsonSourceRange =
        classNode.members.getSourceRangeForConstructor('fromJson');

    final DataClassPluginOptions pluginOptions = await DataClassPluginOptions.fromFile((io.File(
      utils.getDataClassPluginOptionsPath(session.analysisContext.contextRoot.root.path),
    )));

    final ChangeBuilder changeBuilder = ChangeBuilder(session: session);
    await changeBuilder.addDartFileEdit(
      targetFilePath,
      (DartFileEditBuilder fileEditBuilder) {
        void writerFromJson(DartEditBuilder builder) {
          writeFromJson(
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

        fileEditBuilder.format(SourceRange(classNode.offset, classNode.length));
      },
    );

    addAssist(AvailableAssists.fromJson, changeBuilder);
  }

  static void writeFromJson({
    required final String targetFileRelativePath,
    required final DataClassPluginOptions pluginOptions,
    required final ClassElement classElement,
    required final DartEditBuilder builder,
  }) {
    final String className = classElement.name;
    final ConstructorElement? defaultConstructor = classElement.defaultConstructor;
    final bool isConst = defaultConstructor?.isConst ?? false;
    final List<VariableElement> fields = <VariableElement>[
      ...classElement.dataClassFinalFields,
      ...classElement.chainSuperClassDataClassFinalFields,
    ];

    builder
      ..writeln()
      ..writeln('/// Creates an instance of [$className] from [json]')
      ..writeln('factory $className.fromJson(Map<dynamic, dynamic> json) {');

    if (isConst && fields.isEmpty) {
      builder
        ..writeln('return const $className();')
        ..writeln('}');
      return;
    }

    builder.writeln('return $className(');

    for (final VariableElement field in fields) {
      final ElementAnnotation? jsonKeyAnnotation = field.metadata
          .firstWhereOrNull((ElementAnnotation annotation) => annotation.isJsonKeyAnnotation);
      final JsonKeyInternal jsonKey = JsonKeyInternal //
          .fromDartObject(jsonKeyAnnotation?.computeConstantValue());

      if (jsonKey.ignore) {
        continue;
      }

      final JsonKeyNameConvention jsonKeyNameConvention = utils.getJsonKeyNameConvention(
        targetFileRelativePath: targetFileRelativePath,
        jsonKey: jsonKey,
        pluginOptions: pluginOptions,
      );
      final String fieldName = field.name;
      final DartType fieldType = field.type;
      final String jsonFieldName =
          "json['${jsonKey.name ?? jsonKeyNameConvention.transform(fieldName.escapeDollarSign())}']";
      final ConstructorElement? defaultConstructor = classElement.constructors
          .firstWhereOrNull((ConstructorElement ctor) => ctor.name.isEmpty);
      final String? defaultValueString = defaultConstructor?.parameters
          .firstWhereOrNull((ParameterElement param) => param.name == fieldName)
          ?.defaultValueCode;

      builder.write('$fieldName: ');

      if (jsonKey.fromJson != null) {
        builder
          ..write(jsonKey.fromJson!.fullyQualifiedName(
            enclosingImports: classElement.library.libraryImports,
          ))
          ..write('(json),');
        continue;
      }

      FromJsonGenerator(
        checkIfShouldUseFromJson: (DartType type) {
          return type.element == classElement;
        },
      ).run(
        nextType: fieldType,
        builder: builder,
        parentVariableName: jsonFieldName,
        depthIndex: 0,
        defaultValue: defaultValueString,
      );
    }

    builder
      ..writeln(');')
      ..writeln('}');
  }
}
