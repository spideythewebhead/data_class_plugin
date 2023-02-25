import 'package:analyzer/dart/ast/ast.dart';

typedef ClassOrEnumDeclarationFinder = Future<NamedCompilationUnitMember?> Function(String name);
