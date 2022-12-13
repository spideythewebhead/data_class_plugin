import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:data_class_plugin/src/typedefs.dart';

class ClassAstVisitor extends RecursiveAstVisitor<void> {
  ClassAstVisitor({
    required this.matcher,
  });

  static ClassDeclarationNodeMatcher offsetMatcher(int offset) {
    return (ClassDeclaration node) {
      return node.offset <= offset && offset <= node.rightBracket.offset;
    };
  }

  final ClassDeclarationNodeMatcher matcher;

  ClassDeclaration? _classNode;
  ClassDeclaration? get classNode => _classNode;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (matcher(node)) {
      _classNode = node;
    }

    if (_classNode != null) {
      return;
    }

    node.visitChildren(this);
  }
}
