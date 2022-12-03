import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:data_class_plugin/src/annotations/constants.dart';
import 'package:data_class_plugin/src/annotations/union_internal.dart';
import 'package:data_class_plugin/src/extensions/annotation_extensions.dart';
import 'package:data_class_plugin/src/linter/annotation_linter/annotation_linter.dart';

class UnionAnnotationLinter extends AnnotationLinter {
  UnionAnnotationLinter({
    required super.logger,
    required super.path,
    required super.unitResult,
    required super.declaration,
    required super.pluginAnnotation,
    super.verbose,
  }) {
    classDeclaration = declaration as ClassDeclaration;
    element = classDeclaration.declaredElement!;
    name = classDeclaration.name.lexeme;
  }

  late final ClassElement element;
  late final ClassDeclaration classDeclaration;

  @override
  final List<String> hints = <String>[];

  @override
  final List<String> warnings = <String>[];

  @override
  final List<String> errors = <String>[];

  @override
  Future<void> check() async {
    super.clear();

    final UnionInternal unionAnnotation = UnionInternal.fromDartObject(
      element.metadata
          .firstWhere((ElementAnnotation annotation) => annotation.isUnionAnnotation)
          .computeConstantValue(),
    );

    super.checkMethod(
      args: UnionAnnotationArgs.dataClass,
      value: unionAnnotation.dataClass,
      members: classDeclaration.members,
    );

    super.checkMethod(
      args: UnionAnnotationArgs.toJson,
      value: unionAnnotation.toJson,
      members: classDeclaration.members,
    );

    super.checkConstructor(
      args: UnionAnnotationArgs.fromJson,
      value: unionAnnotation.fromJson,
      members: classDeclaration.members,
    );

    super.report();
  }
}
