import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

typedef EnumDeclarationNodeMatcher = bool Function(EnumDeclaration node);

class EnumAstVisitor extends RecursiveAstVisitor<void> {
  EnumAstVisitor({required this.matcher});

  static EnumDeclarationNodeMatcher offsetMatcher(int offset) {
    return (EnumDeclaration node) {
      return node.offset <= offset && offset <= node.rightBracket.offset;
    };
  }

  final EnumDeclarationNodeMatcher matcher;

  EnumDeclaration? _enumNode;
  EnumDeclaration? get enumNode => _enumNode;

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    if (matcher(node)) {
      _enumNode = node;
    }

    if (_enumNode != null) {
      return;
    }

    node.visitChildren(this);
  }
}

/// An AST Visitor that collects all the [EnumDeclaration] nodes matched by [matcher]
class EnumsCollectorAstVisitor extends GeneralizingAstVisitor<void> {
  EnumsCollectorAstVisitor({
    required this.matcher,
  });

  final EnumDeclarationNodeMatcher matcher;

  final List<EnumDeclaration> _matchesNodes = <EnumDeclaration>[];

  /// Provides all the matched [EnumDeclaration] nodes after calling [AstNode.visitChildren]
  List<EnumDeclaration> get matchedNodes => List<EnumDeclaration>.unmodifiable(_matchesNodes);

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    if (matcher(node)) {
      _matchesNodes.add(node);
      return;
    }
    node.visitChildren(this);
  }
}
