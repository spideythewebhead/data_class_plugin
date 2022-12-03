import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:data_class_plugin/src/annotations/constants.dart';
import 'package:data_class_plugin/src/annotations/enum_internal.dart';
import 'package:data_class_plugin/src/extensions/analyzer_extensions.dart';
import 'package:data_class_plugin/src/extensions/annotation_extensions.dart';
import 'package:data_class_plugin/src/linter/annotation_linter/annotation_linter.dart';

class EnumAnnotationLinter extends AnnotationLinter {
  EnumAnnotationLinter({
    required super.logger,
    required super.path,
    required super.unitResult,
    required super.declaration,
    required super.pluginAnnotation,
    super.verbose,
  }) {
    enumDeclaration = declaration as EnumDeclaration;
    element = enumDeclaration.declaredElement!;
    name = enumDeclaration.name.lexeme;
  }

  late final EnumElement element;
  late final EnumDeclaration enumDeclaration;

  @override
  final List<String> hints = <String>[];

  @override
  final List<String> warnings = <String>[];

  @override
  final List<String> errors = <String>[];

  @override
  Future<void> check() async {
    super.clear();

    final EnumInternal enumAnnotation = EnumInternal.fromDartObject(
      element.metadata
          .firstWhere((ElementAnnotation annotation) => annotation.isEnumAnnotation)
          .computeConstantValue(),
    );

    if (enumDeclaration.members.getSourceRangeForConstructor(null) == null) {
      errors.add('Missing constructor');
    }

    super.checkMethod(
      args: DataClassAnnotationArgs.$toString,
      value: enumAnnotation.$toString,
      members: enumDeclaration.members,
    );

    super.checkMethod(
      args: DataClassAnnotationArgs.toJson,
      value: enumAnnotation.toJson,
      members: enumDeclaration.members,
    );

    super.checkConstructor(
      args: DataClassAnnotationArgs.fromJson,
      value: enumAnnotation.fromJson,
      members: enumDeclaration.members,
    );

    super.report();
  }
}
