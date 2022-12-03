import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:data_class_plugin/src/annotations/constants.dart';
import 'package:data_class_plugin/src/annotations/data_class_internal.dart';
import 'package:data_class_plugin/src/extensions/analyzer_extensions.dart';
import 'package:data_class_plugin/src/extensions/annotation_extensions.dart';
import 'package:data_class_plugin/src/linter/annotation_linter/annotation_linter.dart';

class DataClassAnnotationLinter extends AnnotationLinter {
  DataClassAnnotationLinter({
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

    final DataClassInternal dataClassAnnotation = DataClassInternal.fromDartObject(
      element.metadata
          .firstWhere((ElementAnnotation annotation) => annotation.isDataClassAnnotation)
          .computeConstantValue(),
    );

    final List<VariableElement> fields = <VariableElement>[
      ...element.dataClassFinalFields,
      ...element.chainSuperClassDataClassFinalFields,
    ];

    if (classDeclaration.members.getSourceRangeForConstructor(null) == null && fields.isNotEmpty) {
      errors.add('Missing constructor');
    }

    super.checkMethod(
      args: DataClassAnnotationArgs.$toString,
      value: dataClassAnnotation.$toString,
      members: classDeclaration.members,
    );
    super.checkMethod(
      args: DataClassAnnotationArgs.copyWith,
      value: dataClassAnnotation.copyWith,
      members: classDeclaration.members,
    );
    super.checkMethod(
      args: DataClassAnnotationArgs.toJson,
      value: dataClassAnnotation.toJson,
      members: classDeclaration.members,
    );
    super.checkConstructor(
      args: DataClassAnnotationArgs.fromJson,
      value: dataClassAnnotation.fromJson,
      members: classDeclaration.members,
    );
    super.checkMethod(
      args: DataClassAnnotationArgs.hash,
      value: dataClassAnnotation.hashAndEquals,
      members: classDeclaration.members,
    );
    super.checkMethod(
      args: DataClassAnnotationArgs.equals,
      value: dataClassAnnotation.hashAndEquals,
      members: classDeclaration.members,
    );

    super.report();
  }
}
