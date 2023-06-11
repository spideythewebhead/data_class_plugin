import 'dart:async';

import 'package:data_class_plugin/src/annotations/constants.dart';
import 'package:data_class_plugin/src/backend/core/generators/generators.dart';
import 'package:data_class_plugin/src/backend/core/generators/union_from_json.dart';
import 'package:data_class_plugin/src/backend/core/generators/union_when.dart';
import 'package:data_class_plugin/src/backend/core/utils.dart' as utils;
import 'package:data_class_plugin/src/common/utils.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:data_class_plugin/src/typedefs.dart';
import 'package:path/path.dart' as path;
import 'package:tachyon/tachyon.dart';

class DataClassPluginGenerator extends TachyonPluginCodeGenerator {
  DataClassPluginOptions _getPluginOptionWithDefaultFallback(String projectDirPath) {
    try {
      return DataClassPluginOptions.fromFile(getDataClassPluginOptionsFile(
        projectDirPath,
      ));
    } catch (_) {
      return const DataClassPluginOptions();
    }
  }

  @override
  FutureOr<String> generate(
    FileChangeBuildInfo buildInfo,
    TachyonDeclarationFinder declarationFinder,
    Logger logger,
  ) async {
    final CodeWriter codeWriter = CodeWriter.stringBuffer();
    final ClassCollectorAstVisitor classCollectorVisitor =
        ClassCollectorAstVisitor(matcher: (ClassDeclaration node) {
      return node.metadata
          .any((Annotation meta) => meta.isDataClassAnnotation || meta.isUnionAnnotation);
    });
    buildInfo.compilationUnit.visitChildren(classCollectorVisitor);

    final List<ClassDeclaration> dataClasses = classCollectorVisitor.matchedNodes
        .where((ClassDeclaration classDecl) => classDecl.hasDataClassAnnotation)
        .toList(growable: false);
    final List<ClassDeclaration> unionClasses = classCollectorVisitor.matchedNodes
        .where((ClassDeclaration classDecl) => classDecl.hasUnionAnnotation)
        .toList(growable: false);

    final DataClassPluginOptions pluginOptions =
        _getPluginOptionWithDefaultFallback(buildInfo.projectDirectoryPath);

    final JsonKeyNameConventionGetter jsonKeyNameConventionGetter = utils.getJsonKeyNameConvention(
      targetFileRelativePath: path.relative(buildInfo.targetFilePath),
      pluginOptions: pluginOptions,
    );

    await _generateDataClasses(
      buildInfo: buildInfo,
      declarationFinder: declarationFinder,
      codeWriter: codeWriter,
      pluginOptions: pluginOptions,
      compilationUnit: buildInfo.compilationUnit,
      classDeclarations: dataClasses,
      targetFilePath: buildInfo.targetFilePath,
      targetFileRelativePath:
          path.relative(buildInfo.targetFilePath, from: buildInfo.projectDirectoryPath),
      jsonKeyNameConventionGetter: jsonKeyNameConventionGetter,
      logger: logger,
    );

    await _generateUnionClasses(
      buildInfo: buildInfo,
      declarationFinder: declarationFinder,
      codeWriter: codeWriter,
      pluginOptions: pluginOptions,
      compilationUnit: buildInfo.compilationUnit,
      classDeclarations: unionClasses,
      targetFilePath: buildInfo.targetFilePath,
      targetFileRelativePath:
          path.relative(buildInfo.targetFilePath, from: buildInfo.projectDirectoryPath),
      jsonKeyNameConventionGetter: jsonKeyNameConventionGetter,
      logger: logger,
    );

    return codeWriter.content;
  }

  Future<void> _generateDataClasses({
    required final FileChangeBuildInfo buildInfo,
    required final TachyonDeclarationFinder declarationFinder,
    required final CodeWriter codeWriter,
    required final DataClassPluginOptions pluginOptions,
    required final CompilationUnit compilationUnit,
    required final List<ClassDeclaration> classDeclarations,
    required final String targetFilePath,
    required final String targetFileRelativePath,
    required final JsonKeyNameConventionGetter jsonKeyNameConventionGetter,
    required final Logger logger,
  }) async {
    for (final ClassDeclaration classDeclaration in classDeclarations) {
      final String className = classDeclaration.name.lexeme;
      final String classTypeParametersWithoutConstraints = <String>[
        for (final TypeParameter typeParam
            in (classDeclaration.typeParameters?.typeParameters ?? const <TypeParameter>[]))
          typeParam.name.lexeme
      ].join(', ').wrapWithAngleBracketsIfNotEmpty();
      final String classTypeParametersSource = classDeclaration.typeParameters?.toSource() ?? '';
      final String generatedClassName = '_\$${className}Impl';

      final ConstructorDeclaration? defaultFactoryConstructor =
          classDeclaration.members.firstWhereOrNull((ClassMember member) {
        return member is ConstructorDeclaration &&
            member.factoryKeyword != null &&
            member.name == null;
      }) as ConstructorDeclaration?;

      final String? superConstructorName =
          (classDeclaration.members.firstWhereOrNull((ClassMember member) {
        return member is ConstructorDeclaration && member.parameters.parameters.isEmpty;
      }) as ConstructorDeclaration?)
              ?.name
              ?.lexeme;

      final List<DeclarationInfo> fields = classDeclaration.members
          .where((ClassMember member) {
            return member is MethodDeclaration &&
                member.name.lexeme != 'hashCode' &&
                member.isGetter &&
                member.isAbstract;
          })
          .cast<MethodDeclaration>()
          .map((MethodDeclaration methodDecl) {
            return DeclarationInfo(
              name: methodDecl.name.lexeme,
              type: methodDecl.returnType,
              metadata: methodDecl.metadata,
              isPositional: false,
              isNamed: true,
              isRequired: defaultFactoryConstructor?.parameters.parameters
                      .firstWhereOrNull((FormalParameter parameter) =>
                          parameter.name?.lexeme == methodDecl.name.lexeme)
                      ?.isRequired ??
                  false,
            );
          })
          .toList(growable: false);

      final AnnotationValueExtractor dataClassAnnotationValueExtractor =
          AnnotationValueExtractor(classDeclaration.dataClassAnnotation);

      final bool generateUnmodifiableCollections =
          dataClassAnnotationValueExtractor.getBool('unmodifiableCollections') ??
              pluginOptions.dataClass.effectiveUnmodifiableCollections(targetFileRelativePath);

      codeWriter.writeln(
          'class $generatedClassName$classTypeParametersSource extends $className$classTypeParametersWithoutConstraints {');

      ConstructorGenerator(
        codeWriter: codeWriter,
        constructor: defaultFactoryConstructor,
        fields: fields,
        generatedClassName: generatedClassName,
        superConstructorName: superConstructorName,
        generateUnmodifiableCollections: generateUnmodifiableCollections,
      ).execute();

      if (dataClassAnnotationValueExtractor.getBool('fromJson') ??
          pluginOptions.dataClass.effectiveFromJson(targetFileRelativePath)) {
        await FromJsonGenerator(
          codeWriter: codeWriter,
          fields: fields,
          generatedClassName: generatedClassName,
          classTypeParametersWithoutConstraints: classTypeParametersWithoutConstraints,
          jsonKeyNameConventionGetter: jsonKeyNameConventionGetter,
          classDeclarationFinder: declarationFinder.findClassOrEnum,
          logger: logger,
        ).execute();
      }

      if (dataClassAnnotationValueExtractor.getBool('toJson') ??
          pluginOptions.dataClass.effectiveToJson(targetFileRelativePath)) {
        await ToJsonGenerator(
          codeWriter: codeWriter,
          fields: fields,
          jsonKeyNameConventionGetter: jsonKeyNameConventionGetter,
          classDeclarationFinder: declarationFinder.findClassOrEnum,
          logger: logger,
        ).execute();
      }

      if (dataClassAnnotationValueExtractor.getBool('hashAndEquals') ??
          pluginOptions.dataClass.effectiveHashAndEquals(targetFileRelativePath)) {
        EqualsGenerator(
          codeWriter: codeWriter,
          className: className,
          classTypeParametersWithoutConstraints: classTypeParametersWithoutConstraints,
          fields: fields,
        ).execute();

        HashGenerator(
          codeWriter: codeWriter,
          fields: fields,
          skipCollections: generateUnmodifiableCollections,
        ).execute();
      }

      if (dataClassAnnotationValueExtractor.getBool('toString') ??
          pluginOptions.dataClass.effectiveToString(targetFileRelativePath)) {
        ToStringGenerator(
          codeWriter: codeWriter,
          className: className,
          fields: fields,
        ).execute();
      }

      codeWriter
        ..writeln('')
        ..writeln('@override')
        ..writeln('Type get runtimeType => $className$classTypeParametersWithoutConstraints;');

      codeWriter.writeln('}');

      bool? supportsCopyWith;
      // Check if super class is a data class and supports copyWith
      // If that case is true then override the config for copyWith for the current class
      // as it would not make sense to have copyWith for super class and not a subclass
      if (classDeclaration.extendsClause?.superclass != null) {
        final String superClassName = classDeclaration.extendsClause!.superclass.name2.lexeme;
        final ClassOrEnumDeclarationMatch? superClassMatch =
            await declarationFinder.findClassOrEnum(superClassName);
        final NamedCompilationUnitMember? superClassDeclaration = superClassMatch?.node;

        if (superClassDeclaration is ClassDeclaration &&
            superClassDeclaration.hasDataClassAnnotation) {
          final AnnotationValueExtractor annotationValueExtractor = AnnotationValueExtractor(
              superClassDeclaration.metadata.getAnnotation(AnnotationType.dataClass));

          if (annotationValueExtractor.getBool('copyWith') == true ||
              pluginOptions.dataClass.effectiveCopyWith(superClassMatch!.filePath)) {
            supportsCopyWith = true;
          }
        }

        if (supportsCopyWith != null) {
          logger.warning(
              '~ Overriden copyWith configuration for class <$className> based on super class <$superClassName>');
        }
      }
      supportsCopyWith ??= dataClassAnnotationValueExtractor.getBool('copyWith') ??
          pluginOptions.dataClass.effectiveCopyWith(targetFileRelativePath);

      if (supportsCopyWith) {
        await CopyWithGenerator(
          codeWriter: codeWriter,
          fields: fields,
          className: className,
          generatedClassName: generatedClassName,
          classTypeParametersSource: classTypeParametersSource,
          classTypeParametersWithoutConstraints: classTypeParametersWithoutConstraints,
          classDeclarationFinder: declarationFinder.findClassOrEnum,
          projectDirectoryPath: buildInfo.projectDirectoryPath,
          pluginOptions: pluginOptions,
        ).execute();

        codeWriter
          ..writeln(
              'extension \$${className}Extension$classTypeParametersSource on $className$classTypeParametersWithoutConstraints {')
          ..writeln(
              '_${className}CopyWithProxy$classTypeParametersWithoutConstraints get copyWith => _${className}CopyWithProxyImpl$classTypeParametersWithoutConstraints(this);')
          ..writeln('}');
      }
    }
  }

  Future<void> _generateUnionClasses({
    required final FileChangeBuildInfo buildInfo,
    required final TachyonDeclarationFinder declarationFinder,
    required final CodeWriter codeWriter,
    required final DataClassPluginOptions pluginOptions,
    required final CompilationUnit compilationUnit,
    required final List<ClassDeclaration> classDeclarations,
    required final String targetFilePath,
    required final String targetFileRelativePath,
    required final JsonKeyNameConventionGetter jsonKeyNameConventionGetter,
    required final Logger logger,
  }) async {
    for (final ClassDeclaration classDeclaration in classDeclarations) {
      final String className = classDeclaration.name.lexeme;
      final List<ConstructorDeclaration> factoriesWithRedirectedConstructors =
          classDeclaration.members
              .where((ClassMember element) {
                return element is ConstructorDeclaration &&
                    element.factoryKeyword != null &&
                    element.name != null &&
                    element.redirectedConstructor != null;
              })
              .toList(growable: false)
              .cast<ConstructorDeclaration>();

      if (factoriesWithRedirectedConstructors.isEmpty) {
        continue;
      }

      final String classTypeParametersWithoutConstraints = <String>[
        for (final TypeParameter typeParam
            in (classDeclaration.typeParameters?.typeParameters ?? const <TypeParameter>[]))
          typeParam.name.lexeme
      ].join(', ').wrapWithAngleBracketsIfNotEmpty();
      final String classTypeParametersSource = classDeclaration.typeParameters?.toSource() ?? '';
      final AnnotationValueExtractor unionAnnotationValueExtractor =
          AnnotationValueExtractor(classDeclaration.unionAnnotation);

      if (unionAnnotationValueExtractor.getBool('when') ??
          pluginOptions.union.effectiveWhen(targetFileRelativePath)) {
        UnionWhenGenerator(
          codeWriter: codeWriter,
          className: className,
          classTypeParametersSource: classTypeParametersSource,
          classTypeParametersWithoutConstraints: classTypeParametersWithoutConstraints,
          factoriesWithRedirectedConstructors: factoriesWithRedirectedConstructors,
        ).execute();
      }

      if (unionAnnotationValueExtractor.getBool('fromJson') ??
          pluginOptions.union.effectiveFromJson(targetFileRelativePath)) {
        UnionFromJsonGenerator(
          codeWriter: codeWriter,
          className: className,
          classTypeParametersSource: classTypeParametersSource,
          classTypeParametersWithoutConstraints: classTypeParametersWithoutConstraints,
          factoriesWithRedirectedConstructors: factoriesWithRedirectedConstructors,
          unionAnnotationValueExtractor: unionAnnotationValueExtractor,
        ).execute();
      }

      for (final ConstructorDeclaration ctor in factoriesWithRedirectedConstructors) {
        final String generatedClassName = ctor.redirectedConstructor!.beginToken.lexeme;

        final List<DeclarationInfo> fields = <DeclarationInfo>[
          for (final FormalParameter parameter in ctor.parameters.parameters)
            if (parameter is SimpleFormalParameter)
              DeclarationInfo(
                name: parameter.name!.lexeme,
                type: parameter.type,
                metadata: parameter.metadata,
                isNamed: parameter.isNamed,
                isRequired: parameter.isRequired,
                isPositional: parameter.isPositional,
              )
            else if (parameter is DefaultFormalParameter &&
                parameter.parameter is SimpleFormalParameter)
              DeclarationInfo(
                name: parameter.name!.lexeme,
                type: (parameter.parameter as SimpleFormalParameter).type,
                metadata: parameter.metadata,
                isNamed: parameter.isNamed,
                isRequired: parameter.isRequired,
                isPositional: parameter.isPositional,
              )
        ];

        final bool generateUnmodifiableCollections =
            unionAnnotationValueExtractor.getBool('unmodifiableCollections') ??
                pluginOptions.union.effectiveUnmodifiableCollections(targetFileRelativePath);

        codeWriter.writeln(
            'class $generatedClassName$classTypeParametersSource extends $className$classTypeParametersWithoutConstraints {');

        ConstructorGenerator(
          codeWriter: codeWriter,
          constructor: ctor,
          fields: fields,
          generatedClassName: generatedClassName,
          shouldAnnotateFieldsWithOverride: false,
          superConstructorName: '_',
          generateUnmodifiableCollections: generateUnmodifiableCollections,
        ).execute();

        if (unionAnnotationValueExtractor.getBool('fromJson') ??
            pluginOptions.union.effectiveFromJson(targetFileRelativePath)) {
          await FromJsonGenerator(
            codeWriter: codeWriter,
            fields: fields,
            generatedClassName: generatedClassName,
            classTypeParametersWithoutConstraints: classTypeParametersWithoutConstraints,
            jsonKeyNameConventionGetter: jsonKeyNameConventionGetter,
            classDeclarationFinder: declarationFinder.findClassOrEnum,
            logger: logger,
          ).execute();
        }

        if (unionAnnotationValueExtractor.getBool('toJson') ??
            pluginOptions.union.effectiveToJson(targetFileRelativePath)) {
          final String? toJsonNamedKeyToFactoryName =
              unionAnnotationValueExtractor.getString('toJsonNamedKeyToFactoryName');
          await ToJsonGenerator(
            codeWriter: codeWriter,
            fields: fields,
            jsonKeyNameConventionGetter: jsonKeyNameConventionGetter,
            namedKeyToFactoryEntry: toJsonNamedKeyToFactoryName != null
                ? "'$toJsonNamedKeyToFactoryName': '${ctor.name!.lexeme}'"
                : null,
            classDeclarationFinder: declarationFinder.findClassOrEnum,
            logger: logger,
          ).execute();
        }

        if (unionAnnotationValueExtractor.getBool('hashAndEquals') ??
            pluginOptions.union.effectiveHashAndEquals(targetFileRelativePath)) {
          HashGenerator(
            codeWriter: codeWriter,
            fields: fields,
            skipCollections: generateUnmodifiableCollections,
          ).execute();

          EqualsGenerator(
            codeWriter: codeWriter,
            className: generatedClassName,
            classTypeParametersWithoutConstraints: classTypeParametersWithoutConstraints,
            fields: fields,
          ).execute();
        }

        if (unionAnnotationValueExtractor.getBool('\$toString') ??
            pluginOptions.union.effectiveToString(targetFileRelativePath)) {
          ToStringGenerator(
            codeWriter: codeWriter,
            className: generatedClassName,
            fields: fields,
          ).execute();
        }

        codeWriter.writeln('}');

        if (unionAnnotationValueExtractor.getBool('copyWith') ??
            pluginOptions.union.effectiveCopyWith(targetFileRelativePath)) {
          await CopyWithGenerator(
            codeWriter: codeWriter,
            fields: fields,
            className: generatedClassName,
            generatedClassName: generatedClassName,
            classTypeParametersSource: classTypeParametersSource,
            classTypeParametersWithoutConstraints: classTypeParametersWithoutConstraints,
            classDeclarationFinder: declarationFinder.findClassOrEnum,
            projectDirectoryPath: buildInfo.projectDirectoryPath,
            pluginOptions: pluginOptions,
          ).execute();

          codeWriter
            ..writeln(
                'extension \$${generatedClassName}Extension$classTypeParametersSource on $generatedClassName$classTypeParametersWithoutConstraints {')
            ..writeln(
                '_${generatedClassName}CopyWithProxy$classTypeParametersWithoutConstraints get copyWith => _${generatedClassName}CopyWithProxyImpl$classTypeParametersWithoutConstraints(this);')
            ..writeln('}');
        }
      }
    }
  }
}
