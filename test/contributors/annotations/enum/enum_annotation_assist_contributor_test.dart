import 'dart:io' as io;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/contributors/enum/enum_annotation_assist_contributor.dart';
import 'package:data_class_plugin/src/extensions/annotation_extensions.dart';
import 'package:data_class_plugin/src/visitors/enum_visitor.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../../utils/utils.dart';

final String _contributorsPath = path.join(
  io.Directory.current.path,
  'test',
  'contributors',
  'annotations',
  'enum',
);

void main() {
  final List<InOutFilesPair> testFiles = getTestFiles(_contributorsPath);

  group('Enum annotation contributor', () {
    testFiles.runContributorTests(
      contributor: (String path) => EnumAnnotationAssistContributor(path),
      offsetProvider: (CompilationUnit unit) {
        // we need the offset to be between a class declaration
        // so we find the first class node, because of the import statement
        final EnumAstVisitor enumVisitor = EnumAstVisitor(
            matcher: (EnumDeclaration node) =>
                node.declaredElement?.hasEnumAnnotation ?? node.hasEnumAnnotation);
        unit.visitChildren(enumVisitor);
        return enumVisitor.enumNode?.offset ?? -1;
      },
    );
  });
}
