import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:data_class_plugin/src/analyzer_plugin/analyzer_plugin.dart';
import 'package:data_class_plugin/src/contributors/class/class_contributors.dart';
import 'package:data_class_plugin/src/contributors/common/to_string_assist_contributor.dart';
import 'package:data_class_plugin/src/contributors/enum/enum_contributors.dart';
import 'package:data_class_plugin/src/extensions/annotation_extensions.dart';
import 'package:data_class_plugin/src/tools/logger/plugin_logger.dart';
import 'package:data_class_plugin/src/visitors/visitors.dart';
import 'package:path/path.dart';

import '../utils/utils.dart';

final String testFilesPath = join(
  Directory.current.path,
  'test',
  'contributors',
  'assists',
  'mocks',
);

final String enumPath = join(testFilesPath, 'enum.dart');
final String enumAnnotationPath = join(testFilesPath, 'enum_annotation.dart');
final String unionAnnotationPath = join(testFilesPath, 'union_annotation.dart');
final String dataClassAnnotationPath = join(testFilesPath, 'data_class_annotation.dart');

class MockLogger extends PluginLogger {}

void main() async {
  final DataClassPlugin plugin = DataClassPlugin(PhysicalResourceProvider.INSTANCE);

  final AnalysisContextCollection analysis = AnalysisContextCollection(
    includedPaths: <String>[
      enumPath,
      enumAnnotationPath,
      unionAnnotationPath,
      dataClassAnnotationPath,
    ],
    resourceProvider: PhysicalResourceProvider.INSTANCE,
  );

  await testContributorAssists(
    assistGroupName: 'Enum',
    plugin: plugin,
    analysis: analysis,
    shouldHaveContributors: <Type>[
      EnumConstructorAssistContributor,
      EnumToJsonAssistContributor,
      EnumFromJsonAssistContributor,
      ToStringAssistContributor,
    ],
    filepath: enumPath,
  );

  await testContributorAssists(
    assistGroupName: 'Enum annotation',
    plugin: plugin,
    analysis: analysis,
    shouldHaveContributors: <Type>[
      EnumAnnotationAssistContributor,
    ],
    filepath: enumAnnotationPath,
    offsetProvider: (CompilationUnit unit) {
      final EnumAstVisitor enumVisitor = EnumAstVisitor(
          matcher: (EnumDeclaration node) =>
              node.declaredElement?.hasEnumAnnotation ?? node.hasEnumAnnotation);
      unit.visitChildren(enumVisitor);
      return enumVisitor.enumNode?.offset ?? -1;
    },
  );

  await testContributorAssists(
    assistGroupName: 'Data Class annotation',
    plugin: plugin,
    analysis: analysis,
    shouldHaveContributors: <Type>[
      DataClassAssistContributor,
    ],
    filepath: dataClassAnnotationPath,
    offsetProvider: (CompilationUnit unit) {
      final ClassAstVisitor classVisitor = ClassAstVisitor(
          matcher: (ClassDeclaration node) =>
              node.declaredElement?.hasDataClassAnnotation ?? node.hasDataClassAnnotation);
      unit.visitChildren(classVisitor);
      return classVisitor.classNode?.offset ?? -1;
    },
  );

  await testContributorAssists(
    assistGroupName: 'Union annotation',
    plugin: plugin,
    analysis: analysis,
    shouldHaveContributors: <Type>[
      UnionAssistContributor,
    ],
    filepath: unionAnnotationPath,
    offsetProvider: (CompilationUnit unit) {
      final ClassAstVisitor classVisitor = ClassAstVisitor(
          matcher: (ClassDeclaration node) =>
              node.declaredElement?.hasUnionAnnotation ?? node.hasUnionAnnotation);
      unit.visitChildren(classVisitor);
      return classVisitor.classNode?.offset ?? -1;
    },
  );
}
