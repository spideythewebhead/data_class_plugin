import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:data_class_plugin/src/visitors/class_visitor.dart';

mixin ClassAstVisitorMixin on AssistContributor {
  DartAssistRequest get assistRequest;

  ClassDeclaration? findClassDeclaration() {
    final ClassAstVisitor visitor = ClassAstVisitor(
      matcher: ClassAstVisitor.offsetMatcher(assistRequest.offset),
    );
    assistRequest.result.unit.visitChildren(visitor);
    return visitor.classNode;
  }
}
