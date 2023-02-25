import 'dart:io' as io;
import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/contributors/class/data_class_contributor.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:data_class_plugin/src/visitors/visitors.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../../utils/utils.dart';

final String _contributorsPath = path.join(
  io.Directory.current.path,
  'test',
  'contributors',
  'annotations',
  'data_class',
);

void main() async {
  final List<InOutFilesPair> testFiles = getTestFiles(_contributorsPath);
  final DataClassPluginOptions pluginOptions = await DataClassPluginOptions.fromFile(
      File(path.join('test', 'data_class_plugin_options.yaml')));

  group('DataClass annotation contributor', () {
    testFiles.runContributorTests(
      contributor: (String path) => DataClassAssistContributor(path, pluginOptions: pluginOptions),
      offsetProvider: (CompilationUnit unit) {
        // we need the offset to be between a class declaration
        // so we find the first class node, because of the import statement
        final ClassAstVisitor classVisitor = ClassAstVisitor(
            matcher: (ClassDeclaration node) =>
                node.declaredElement?.hasDataClassAnnotation ?? node.hasDataClassAnnotation);
        unit.visitChildren(classVisitor);
        return classVisitor.classNode?.offset ?? -1;
      },
    );
  });
}
