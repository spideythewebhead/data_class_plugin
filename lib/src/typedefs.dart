import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/json_key_name_convention.dart';

typedef ClassDeclarationNodeMatcher = bool Function(ClassDeclaration node);

typedef JsonKeyNameConventionGetter = JsonKeyNameConvention Function(String? availableConvention);
