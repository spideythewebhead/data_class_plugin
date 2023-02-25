import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_style/dart_style.dart';
import 'package:data_class_plugin/src/backend/core/custom_dart_object.dart';
import 'package:data_class_plugin/src/backend/core/declaration_finder.dart';
import 'package:data_class_plugin/src/backend/core/declaration_info.dart';
import 'package:data_class_plugin/src/backend/core/find_package_path_by_import.dart';
import 'package:data_class_plugin/src/backend/core/generators/generators.dart';
import 'package:data_class_plugin/src/backend/core/generators/union_from_json.dart';
import 'package:data_class_plugin/src/backend/core/generators/union_when.dart';
import 'package:data_class_plugin/src/backend/core/packages_dependency_graph.dart';
import 'package:data_class_plugin/src/backend/core/parse_file_extension.dart';
import 'package:data_class_plugin/src/backend/core/parsed_file_data.dart';
import 'package:data_class_plugin/src/backend/core/parsed_files_registry.dart';
import 'package:data_class_plugin/src/backend/core/utils.dart' as utils;
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/common/utils.dart' as common_utils;
import 'package:data_class_plugin/src/common/utils.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:data_class_plugin/src/tools/logger/plugin_logger.dart';
import 'package:data_class_plugin/src/typedefs.dart';
import 'package:data_class_plugin/src/visitors/visitors.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as path;
import 'package:rxdart/rxdart.dart';
import 'package:watcher/watcher.dart';

final RegExp _dartFileNameMatcher = RegExp(r'^[a-zA-Z0-9_]+.dart$');

class CodeGenerator {
  CodeGenerator({
    required this.directory,
    PluginLogger? logger,
  })  : _watcher = DirectoryWatcher(directory.path),
        _logger = logger ?? PluginLogger();

  final Directory directory;
  final PluginLogger _logger;
  final Watcher _watcher;

  final Map<String, Completer<void>?> _activeWrites = <String, Completer<void>?>{};
  final DependencyGraph _dependencyGraph = DependencyGraph();
  final ParsedFilesRegistry _filesRegistry = ParsedFilesRegistry();

  late final DeclarationFinder _declarationFinder = DeclarationFinder(
    projectDirectoryPath: directory.path,
    parsedFilesRegistry: _filesRegistry,
  );

  StreamSubscription<WatchEvent>? _watchSubscription;

  /// Watches this project for any files changes and rebuilds when necessary
  Future<void> watchProject({
    void Function()? onReady,
  }) async {
    final Completer<void> completer = Completer<void>();
    await indexProject();
    await buildProject();
    _watchSubscription = _watcher.events
        .debounceTime(const Duration(milliseconds: 100))
        .listen(_onWatchEvent, onDone: () {
      completer.complete();
    });
    await _watcher.ready;
    onReady?.call();
    return completer.future;
  }

  void dispose() {
    _watchSubscription?.cancel();
  }

  /// Indexes the project and creates links between source files
  Future<void> indexProject() async {
    _logger.info('~ Indexing project..');

    final Stopwatch stopwatch = Stopwatch()..start();

    final DataClassPluginOptions pluginOptions =
        await DataClassPluginOptions.fromFile(getDataClassPluginOptionsFile(directory.path));

    final Iterable<File> dartFiles = directory
        .listSync(recursive: true) //
        .where((FileSystemEntity entity) {
      if (entity is! File || !_dartFileNameMatcher.hasMatch(path.basename(entity.path))) {
        return false;
      }

      return pluginOptions.allowedFilesGenerationPaths.any((Glob glob) {
        return glob.matches(
          path.relative(entity.absolute.path, from: directory.absolute.path),
        );
      });
    }).cast<File>();

    Future<void> index({
      required String targetFilePath,
      required CompilationUnit compilationUnit,
    }) async {
      for (final Directive directive in compilationUnit.directives) {
        String? directiveUri;
        if (directive is NamespaceDirective) {
          directiveUri = directive.uri.stringValue;
        }

        if (directiveUri == null) {
          continue;
        }

        final String? dartFilePath = await findDartFileFromUri(
          projectDirectoryPath: directory.path,
          currentDirectoryPath: File(targetFilePath).parent.absolute.path,
          uri: directiveUri,
        );

        if (dartFilePath == null || !File(dartFilePath).existsSync()) {
          continue;
        }

        if (_filesRegistry.containsKey(dartFilePath)) {
          _dependencyGraph.add(
            targetFilePath,
            dartFilePath,
          );
          continue;
        }

        if (path.isWithin(directory.path, dartFilePath)) {
          _dependencyGraph.add(targetFilePath, dartFilePath);
          _filesRegistry[dartFilePath] = ParsedFileData(
            absolutePath: dartFilePath,
            compilationUnit:
                dartFilePath.parse(featureSet: FeatureSet.latestLanguageVersion()).unit,
            lastModifiedAt: File(dartFilePath).lastModifiedSync(),
          );

          await index(
            targetFilePath: dartFilePath,
            compilationUnit: _filesRegistry[dartFilePath]!.compilationUnit,
          );
        }
      }
    }

    for (final File file in dartFiles) {
      final String targetFilePath = file.absolute.path;

      if (_filesRegistry.containsKey(targetFilePath)) {
        continue;
      }

      _filesRegistry[targetFilePath] = ParsedFileData(
        absolutePath: targetFilePath,
        compilationUnit: targetFilePath.parse(featureSet: FeatureSet.latestLanguageVersion()).unit,
        lastModifiedAt: file.lastModifiedSync(),
      );

      await index(
        targetFilePath: targetFilePath,
        compilationUnit: _filesRegistry[targetFilePath]!.compilationUnit,
      );
    }

    stopwatch.stop();
    _logger.info('~ Indexed ${_filesRegistry.length} files in ${stopwatch.elapsedMilliseconds}ms');
  }

  /// Builds the project
  ///
  /// **Project must be indexed before it can correctly build**
  Future<void> buildProject() async {
    _logger.info('~ Building project..');
    final Stopwatch stopwatch = Stopwatch()..start();

    for (final MapEntry<String, ParsedFileData> entry in _filesRegistry.entries) {
      final String targetFilePath = entry.key;
      await _generateCode(
        targetFilePath: targetFilePath,
        outputFilePath: targetFilePath.replaceFirst('.dart', '.gen.dart'),
        compilationUnit: entry.value.compilationUnit,
      );
    }

    stopwatch.stop();
    _logger.info('~ Completed build in ${stopwatch.elapsed.inMilliseconds}ms..');
  }

  void _onWatchEvent(WatchEvent event) async {
    final String targetFilePath = path.normalize(event.path);
    Completer<void>? completer;

    try {
      if (!_dartFileNameMatcher.hasMatch(path.basename(targetFilePath))) {
        return;
      }

      final String outputFilePath = targetFilePath.replaceFirst('.dart', '.gen.dart');
      await _activeWrites[outputFilePath]?.future;

      completer = Completer<void>();
      _activeWrites[outputFilePath] = completer;

      if (event.type == ChangeType.REMOVE) {
        try {
          await File(outputFilePath).delete();
        } catch (_) {}

        return;
      }

      await _generateCode(targetFilePath: targetFilePath, outputFilePath: outputFilePath);
    } catch (error, stackTrace) {
      _logger.exception(error, stackTrace);
    } finally {
      completer?.safeComplete();
    }
  }

  Future<void> _generateCode({
    required String targetFilePath,
    required String outputFilePath,
    bool skipDependencies = false,
    CompilationUnit? compilationUnit,
    String indent = '',
    bool reportTime = true,
  }) async {
    final String relativeFilePath = path.relative(targetFilePath, from: directory.path);
    final DataClassPluginOptions pluginOptions = await DataClassPluginOptions.fromFile(
        common_utils.getDataClassPluginOptionsFile(directory.path));

    if (!pluginOptions.allowedFilesGenerationPaths
        .any((Glob glob) => glob.matches(relativeFilePath))) {
      return;
    }

    _logger.debug('$indent~ Checking $relativeFilePath');

    late final Stopwatch? stopwatch;
    if (reportTime) {
      stopwatch = Stopwatch()..start();
    } else {
      stopwatch = null;
    }

    CodeWriter codeWriter = CodeWriter.stringBuffer();

    if (compilationUnit == null) {
      _filesRegistry[targetFilePath] = ParsedFileData(
        absolutePath: targetFilePath,
        compilationUnit: targetFilePath.parse(featureSet: FeatureSet.latestLanguageVersion()).unit,
        lastModifiedAt: await File(targetFilePath).lastModified(),
      );
    }

    compilationUnit ??= _filesRegistry[targetFilePath]!.compilationUnit;

    final ClassCollectorAstVisitor classCollectorVisitor =
        ClassCollectorAstVisitor(matcher: (ClassDeclaration node) {
      return node.metadata
          .any((Annotation meta) => meta.isDataClassAnnotation || meta.isUnionAnnotation);
    });
    compilationUnit.visitChildren(classCollectorVisitor);

    final List<ClassDeclaration> classDeclarations = classCollectorVisitor.matchedNodes;

    if (classDeclarations.isEmpty) {
      final File outputFile = File(outputFilePath);
      if (await outputFile.exists()) {
        try {
          await outputFile.delete();
        } catch (_) {}
      }

      if (!skipDependencies) {
        await _rebuildDependants(targetFilePath: targetFilePath, indent: indent);
      }

      if (reportTime) {
        stopwatch!.stop();
        _logger.info(
            '$indent~ Finished building $relativeFilePath in ${stopwatch.elapsed.inMilliseconds}ms');
      }
      return;
    }

    final List<ClassDeclaration> dataClasses = classDeclarations
        .where((ClassDeclaration classDecl) => classDecl.hasDataClassAnnotation)
        .toList(growable: false);
    final List<ClassDeclaration> unionClasses = classDeclarations
        .where((ClassDeclaration classDecl) => classDecl.hasUnionAnnotation)
        .toList(growable: false);

    _logger.debug('$indent~ Starting build for $relativeFilePath');

    final JsonKeyNameConventionGetter jsonKeyNameConventionGetter = utils.getJsonKeyNameConvention(
      targetFileRelativePath: path.relative(targetFilePath),
      pluginOptions: pluginOptions,
    );

    codeWriter
      ..writeln('// AUTO GENERATED - DO NOT MODIFY')
      ..writeln()
      ..writeln("part of '${path.basename(targetFilePath)}';")
      ..writeln();

    await _generateDataClasses(
      codeWriter: codeWriter,
      pluginOptions: pluginOptions,
      compilationUnit: compilationUnit,
      classDeclarations: dataClasses,
      targetFilePath: targetFilePath,
      targetFileRelativePath: relativeFilePath,
      jsonKeyNameConventionGetter: jsonKeyNameConventionGetter,
    );

    await _generateUnionClasses(
      codeWriter: codeWriter,
      pluginOptions: pluginOptions,
      compilationUnit: compilationUnit,
      classDeclarations: unionClasses,
      targetFilePath: targetFilePath,
      targetFileRelativePath: relativeFilePath,
      jsonKeyNameConventionGetter: jsonKeyNameConventionGetter,
    );

    final String content = codeWriter.content;
    if (content.isEmpty) {
      try {
        await File(outputFilePath).delete();
      } catch (_) {}
    } else {
      try {
        await File(outputFilePath).writeAsString(DartFormatter(
          pageWidth: pluginOptions.generatedFileLineLength,
        ).format(content));
      } on FormatterException catch (e) {
        _logger
          ..error('Invalid code generation for $relativeFilePath')
          ..writeln(e);
      }
    }

    if (!skipDependencies) {
      await _rebuildDependants(targetFilePath: targetFilePath, indent: indent);
    }

    if (reportTime) {
      stopwatch!.stop();
      _logger.info(
          '$indent~ Finished building $relativeFilePath in ${stopwatch.elapsed.inMilliseconds}ms');
    }
  }

  Future<void> _rebuildDependants({
    required final String targetFilePath,
    required final String indent,
  }) async {
    final List<String> dependants = _dependencyGraph.getDependants(targetFilePath);
    if (dependants.isEmpty) {
      return;
    }

    _logger.debug('  Rebuilding ${dependants.length} depandants..');
    await Future.wait(<Future<void>>[
      for (final String dependency in dependants)
        _generateCode(
          targetFilePath: dependency,
          outputFilePath: dependency.replaceFirst('.dart', '.gen.dart'),
          compilationUnit: _filesRegistry[dependency]?.compilationUnit,
          indent: '  $indent',
          skipDependencies: true,
          reportTime: false,
        )
    ]);
  }

  Future<void> _generateDataClasses({
    required CodeWriter codeWriter,
    required DataClassPluginOptions pluginOptions,
    required CompilationUnit compilationUnit,
    required List<ClassDeclaration> classDeclarations,
    required String targetFilePath,
    required String targetFileRelativePath,
    required JsonKeyNameConventionGetter jsonKeyNameConventionGetter,
  }) async {
    for (final ClassDeclaration classDeclaration in classDeclarations) {
      final String className = classDeclaration.name.lexeme;
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

      final bool unmodifiableCollections =
          dataClassAnnotationValueExtractor.getBool('unmodifiableCollections') ??
              pluginOptions.dataClass.effectiveUnmodifiableCollections(targetFileRelativePath);

      codeWriter.writeln(
          'class $generatedClassName$classTypeParametersSource extends $className$classTypeParametersSource {');

      ConstructorGenerator(
        codeWriter: codeWriter,
        constructor: defaultFactoryConstructor,
        fields: fields,
        generatedClassName: generatedClassName,
        superConstructorName: superConstructorName,
        unmodifiableCollections: unmodifiableCollections,
      ).execute();

      if (classDeclaration.members.hasFactory('fromJson')) {
        await FromJsonGenerator(
          codeWriter: codeWriter,
          fields: fields,
          generatedClassName: generatedClassName,
          classTypeParametersSource: classTypeParametersSource,
          jsonKeyNameConventionGetter: jsonKeyNameConventionGetter,
          classDeclarationFinder: (String name) {
            return _declarationFinder.findClassOrEnumDeclarationByName(
              name,
              dependencyGraph: _dependencyGraph,
              compilationUnit: compilationUnit,
              targetFilePath: targetFilePath,
            );
          },
          logger: _logger,
        ).execute();
      }

      if (classDeclaration.hasMethod('toJson')) {
        await ToJsonGenerator(
          codeWriter: codeWriter,
          fields: fields,
          jsonKeyNameConventionGetter: jsonKeyNameConventionGetter,
          classDeclarationFinder: (String name) {
            return _declarationFinder.findClassOrEnumDeclarationByName(
              name,
              dependencyGraph: _dependencyGraph,
              compilationUnit: compilationUnit,
              targetFilePath: targetFilePath,
            );
          },
          logger: _logger,
        ).execute();
      }

      if (dataClassAnnotationValueExtractor.getBool('copyWith') ??
          pluginOptions.dataClass.effectiveCopyWith(targetFileRelativePath)) {
        CopyWithGenerator(
          codeWriter: codeWriter,
          fields: fields,
          generatedClassName: '$generatedClassName$classTypeParametersSource',
        ).execute();
      }

      if (dataClassAnnotationValueExtractor.getBool('hashAndEquals') ??
          pluginOptions.dataClass.effectiveHashAndEquals(targetFileRelativePath)) {
        EqualsGenerator(
          codeWriter: codeWriter,
          className: '$className$classTypeParametersSource',
          fields: fields,
        ).execute();

        HashGenerator(
          codeWriter: codeWriter,
          fields: fields,
          skipCollections: unmodifiableCollections,
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
        ..writeln('Type get runtimeType => $className$classTypeParametersSource;');

      codeWriter.writeln('}');
    }
  }

  Future<void> _generateUnionClasses({
    required CodeWriter codeWriter,
    required DataClassPluginOptions pluginOptions,
    required CompilationUnit compilationUnit,
    required List<ClassDeclaration> classDeclarations,
    required String targetFilePath,
    required String targetFileRelativePath,
    required JsonKeyNameConventionGetter jsonKeyNameConventionGetter,
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

      final String classTypeParametersSource = classDeclaration.typeParameters?.toSource() ?? '';
      final AnnotationValueExtractor unionAnnotationValueExtractor =
          AnnotationValueExtractor(classDeclaration.unionAnnotation);

      UnionWhenGenerator(
        codeWriter: codeWriter,
        className: className,
        classTypeParametersSource: classTypeParametersSource,
        factoriesWithRedirectedConstructors: factoriesWithRedirectedConstructors,
      ).execute();

      if (unionAnnotationValueExtractor.getBool('fromJson') ??
          pluginOptions.union.effectiveFromJson(targetFileRelativePath)) {
        UnionFromJsonGenerator(
          codeWriter: codeWriter,
          className: className,
          classTypeParametersSource: classTypeParametersSource,
          factoriesWithRedirectedConstructors: factoriesWithRedirectedConstructors,
          unionAnnotationValueExtractor: unionAnnotationValueExtractor,
        ).execute();
      }

      for (final ConstructorDeclaration ctor in factoriesWithRedirectedConstructors) {
        final String generatedClassName = ctor.redirectedConstructor!.beginToken.lexeme;
        final List<DeclarationInfo> fields = ctor.parameters.parameters
            .where((FormalParameter parameter) =>
                parameter.isNamed &&
                parameter.isExplicitlyTyped &&
                parameter is DefaultFormalParameter)
            .cast<DefaultFormalParameter>()
            .map((DefaultFormalParameter parameter) {
          TypeAnnotation? type;
          if (parameter.parameter is SimpleFormalParameter) {
            type = (parameter.parameter as SimpleFormalParameter).type;
          }

          return DeclarationInfo(
            name: parameter.name!.lexeme,
            type: type,
            metadata: parameter.metadata,
            isRequired: parameter.isRequired,
          );
        }).toList(growable: false);

        final bool unmodifiableCollections =
            unionAnnotationValueExtractor.getBool('unmodifiableCollections') ??
                pluginOptions.union.effectiveUnmodifiableCollections(targetFileRelativePath);

        codeWriter.writeln(
            'class $generatedClassName$classTypeParametersSource extends $className$classTypeParametersSource {');

        ConstructorGenerator(
          codeWriter: codeWriter,
          constructor: ctor,
          fields: fields,
          generatedClassName: generatedClassName,
          shouldAnnotateFieldsWithOverride: false,
          superConstructorName: '_',
          unmodifiableCollections: unmodifiableCollections,
        ).execute();

        if (unionAnnotationValueExtractor.getBool('fromJson') ??
            pluginOptions.union.effectiveFromJson(targetFileRelativePath)) {
          await FromJsonGenerator(
            codeWriter: codeWriter,
            fields: fields,
            generatedClassName: generatedClassName,
            classTypeParametersSource: classTypeParametersSource,
            jsonKeyNameConventionGetter: jsonKeyNameConventionGetter,
            classDeclarationFinder: (String name) {
              return _declarationFinder.findClassOrEnumDeclarationByName(
                name,
                dependencyGraph: _dependencyGraph,
                compilationUnit: compilationUnit,
                targetFilePath: targetFilePath,
              );
            },
            logger: _logger,
          ).execute();
        }

        if (unionAnnotationValueExtractor.getBool('toJson') ??
            pluginOptions.union.effectiveToJson(targetFileRelativePath)) {
          await ToJsonGenerator(
            codeWriter: codeWriter,
            fields: fields,
            jsonKeyNameConventionGetter: jsonKeyNameConventionGetter,
            classDeclarationFinder: (String name) {
              return _declarationFinder.findClassOrEnumDeclarationByName(
                name,
                dependencyGraph: _dependencyGraph,
                compilationUnit: compilationUnit,
                targetFilePath: targetFilePath,
              );
            },
            logger: _logger,
          ).execute();
        }

        if (unionAnnotationValueExtractor.getBool('copyWith') ??
            pluginOptions.union.effectiveCopyWith(targetFileRelativePath)) {
          CopyWithGenerator(
            codeWriter: codeWriter,
            fields: fields,
            generatedClassName: '$generatedClassName$classTypeParametersSource',
            shouldAnnotateWithOverride: false,
          ).execute();
        }

        if (unionAnnotationValueExtractor.getBool('hashAndEquals') ??
            pluginOptions.union.effectiveHashAndEquals(targetFileRelativePath)) {
          HashGenerator(
            codeWriter: codeWriter,
            fields: fields,
            skipCollections: unmodifiableCollections,
          ).execute();

          EqualsGenerator(
            codeWriter: codeWriter,
            className: '$generatedClassName$classTypeParametersSource',
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
      }
    }
  }
}
