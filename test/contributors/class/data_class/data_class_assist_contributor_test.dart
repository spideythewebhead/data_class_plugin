import 'dart:io' as io;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/contributors/class/data_class_contributor.dart';
import 'package:data_class_plugin/src/visitors/class_visitor.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../../utils/utils.dart';

final String _contributorsPath = path.join(
  io.Directory.current.path,
  'test',
  'contributors',
  'class',
  'data_class',
);

void main() {
  final List<InOutFilesPair> testFiles = getTestFiles(_contributorsPath);

  group('DataClass annotation contributor', () {
    testFiles.runContributorTests(
      contributorsPath: _contributorsPath,
      contributor: (String path) => DataClassAssistContributor(path),
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
