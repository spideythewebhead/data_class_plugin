import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:data_class_plugin/src/visitors/visitors.dart';

mixin AstVisitorMixin on AssistContributor {
  DartAssistRequest get assistRequest;
}

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

mixin EnumAstVisitorMixin on AssistContributor {
  DartAssistRequest get assistRequest;

  EnumDeclaration? findEnumDeclaration() {
    final EnumAstVisitor visitor = EnumAstVisitor(
      matcher: EnumAstVisitor.offsetMatcher(assistRequest.offset),
    );
    assistRequest.result.unit.visitChildren(visitor);
    return visitor.enumNode;
  }
}

mixin RelativeFilePathMixin on AssistContributor {
  String get targetFilePath;
  AnalysisSession get session;

  String get relativeFilePath =>
      // relative file path from the root of the project folder
      // adding one to length to include path separator
      targetFilePath.substring(1 + session.analysisContext.contextRoot.root.path.length);
}
