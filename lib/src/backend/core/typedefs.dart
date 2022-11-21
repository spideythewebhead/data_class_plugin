import 'package:analyzer/dart/ast/ast.dart';

typedef ClassDeclarationFinder = Future<NamedCompilationUnitMember?> Function(String name);
