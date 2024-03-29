import 'dart:io' as io;

import 'package:data_class_plugin/src/contributors/class/union_assist_contributor.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:path/path.dart' as path;
import 'package:tachyon/tachyon.dart';
import 'package:test/test.dart';

import '../../utils/utils.dart';

final String _contributorsPath = path.join(
  io.Directory.current.path,
  'test',
  'contributors',
  'annotations',
  'union',
);

void main() async {
  final List<InOutFilesPair> testFiles = getTestFiles(_contributorsPath);
  final DataClassPluginOptions pluginOptions = getPluginOptions();

  group('Union annotation contributor', () {
    testFiles.runContributorTests(
      contributor: (String path) => UnionAssistContributor(path, pluginOptions: pluginOptions),
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
