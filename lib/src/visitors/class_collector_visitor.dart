import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:data_class_plugin/src/typedefs.dart';

class ClassCollectorAstVisitor extends GeneralizingAstVisitor<void> {
  ClassCollectorAstVisitor({
    required this.matcher,
  });

  final ClassDeclarationNodeMatcher matcher;

  final List<ClassDeclaration> _classNodes = <ClassDeclaration>[];
  List<ClassDeclaration> get classNodes => List<ClassDeclaration>.unmodifiable(_classNodes);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (matcher(node)) {
      _classNodes.add(node);
    }
    node.visitChildren(this);
  }
}
