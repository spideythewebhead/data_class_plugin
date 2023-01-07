import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:data_class_plugin/src/typedefs.dart';

class ClassCollectorAstVisitor extends GeneralizingAstVisitor<void> {
  ClassCollectorAstVisitor({
    required this.matcher,
  });

  final ClassDeclarationNodeMatcher matcher;

  final List<ClassDeclaration> _matchesNodes = <ClassDeclaration>[];
  List<ClassDeclaration> get matchedNodes => List<ClassDeclaration>.unmodifiable(_matchesNodes);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (matcher(node)) {
      _matchesNodes.add(node);
      return;
    }
    node.visitChildren(this);
  }
}
