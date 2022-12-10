import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:data_class_plugin/src/generators/code_generation_delegate.dart';

abstract class ClassGenerationDelegate extends CodeGenerationDelegate {
  ClassGenerationDelegate({
    required super.relativeFilePath,
    required super.targetFilePath,
    required super.changeBuilder,
    required super.pluginOptions,
    required this.classNode,
    required this.classElement,
  });

  final ClassDeclaration classNode;
  final ClassElement classElement;
}
