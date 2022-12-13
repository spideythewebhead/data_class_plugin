import 'dart:io' as io;
import 'dart:io';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/contributors/class/class_contributors.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';

import 'package:data_class_plugin/src/visitors/visitors.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../../utils/utils.dart';

final String _path = path.join(
  io.Directory.current.path,
  'test',
  'contributors',
  'annotations',
  'json_key',
);

void main() async {
  final List<InOutFilesPair> testFiles = getTestFiles(_path);
  final DataClassPluginOptions pluginOptions = await DataClassPluginOptions.fromFile(
      File(path.join('test', 'data_class_plugin_options.yaml')));

  group('JsonKey Annotation', () {
    testFiles.runContributorTests(
      contributor: (String path) => DataClassAssistContributor(path, pluginOptions: pluginOptions),
      offsetProvider: (CompilationUnit unit) {
        // we need the offset to be between a class declaration
        // so we find the first class node, because of the import statement
        final ClassAstVisitor classVisitor =
            ClassAstVisitor(matcher: (ClassDeclaration node) => true);
        unit.visitChildren(classVisitor);
        return classVisitor.classNode?.offset ?? -1;
      },
    );
  });
}
