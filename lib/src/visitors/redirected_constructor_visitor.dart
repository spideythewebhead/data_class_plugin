import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class RedirectedConstructorsVisitor extends RecursiveAstVisitor<void> {
  /// Shorthand constructor
  RedirectedConstructorsVisitor({
    required this.result,
  });

  final Map<String, RedirectedConstructor> result;

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    if (node.name == null || node.redirectedConstructor == null) {
      return;
    }

    final String redirectedCtorName = node.redirectedConstructor!.beginToken.lexeme;

    final StringBuffer typeBuffer = StringBuffer();
    for (Token? token = node.redirectedConstructor!.beginToken.next;
        token != null && token.type != TokenType.SEMICOLON;
        token = token.next) {
      typeBuffer.write(token.lexeme);
    }

    result[node.name!.lexeme] = RedirectedConstructor(
      name: redirectedCtorName,
      typeArgument: typeBuffer.toString(),
    );
  }
}

class RedirectedConstructor {
  /// Shorthand constructor
  RedirectedConstructor({
    required this.name,
    required this.typeArgument,
  });

  final String name;
  final String typeArgument;

  @override
  String toString() {
    return '$name$typeArgument';
  }
}
