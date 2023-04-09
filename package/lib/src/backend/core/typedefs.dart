import 'package:data_class_plugin/src/backend/core/declaration_finder.dart';

typedef ClassOrEnumDeclarationFinder = Future<ClassOrEnumDeclarationMatch?> Function(String name);
