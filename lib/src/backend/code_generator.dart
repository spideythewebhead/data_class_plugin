import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_style/dart_style.dart';
import 'package:data_class_plugin/src/backend/core/declaration_finder.dart';
import 'package:data_class_plugin/src/backend/core/find_package_path_by_import.dart';
import 'package:data_class_plugin/src/backend/core/generators/generators.dart';
import 'package:data_class_plugin/src/backend/core/packages_dependency_graph.dart';
import 'package:data_class_plugin/src/backend/core/parse_file_extension.dart';
import 'package:data_class_plugin/src/backend/core/parsed_file_data.dart';
import 'package:data_class_plugin/src/backend/core/parsed_files_registry.dart';
import 'package:data_class_plugin/src/backend/core/utils.dart' as utils;
import 'package:data_class_plugin/src/common/code_writer.dart';
import 'package:data_class_plugin/src/common/utils.dart' as common_utils;
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:data_class_plugin/src/typedefs.dart';
import 'package:data_class_plugin/src/visitors/visitors.dart';
import 'package:path/path.dart' as path;
import 'package:rxdart/rxdart.dart';
import 'package:watcher/watcher.dart';

final RegExp _dartFileNameMatcher = RegExp(r'^[a-zA-Z0-9_]+.dart$');

class CodeGenerator {
  CodeGenerator({
    required this.directory,
  }) : _watcher = DirectoryWatcher(directory.path);

  final Directory directory;
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
    print('~ Indexing project..');

    final Stopwatch stopwatch = Stopwatch()..start();
    final Iterable<File> dartFiles = directory
        .listSync(recursive: true) //
        .whereType<File>()
        .where((FileSystemEntity entity) =>
            entity is File && _dartFileNameMatcher.hasMatch(path.basename(entity.path)));

    Future<void> index({
      required String targetFilePath,
      required CompilationUnit compilationUnit,
    }) async {
      for (final Directive directive in compilationUnit.directives) {
        String? directiveUri;
        if (directive is NamespaceDirective) {
          directiveUri = directive.uri.stringValue;
        }

        if (directiveUri != null) {
          final String? dartFilePath = await findDartFileForImport(
            projectDirectoryPath: directory.path,
            currentDirectoryPath: File(targetFilePath).parent.absolute.path,
            importUri: directiveUri,
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
    }

    for (final File file in dartFiles) {
      final String targetFilePath = file.absolute.path;

      if (_filesRegistry.containsKey(targetFilePath)) {
        continue;
      }

      _filesRegistry[targetFilePath] = ParsedFileData(
        compilationUnit: targetFilePath.parse(featureSet: FeatureSet.latestLanguageVersion()).unit,
        lastModifiedAt: file.lastModifiedSync(),
      );

      await index(
        targetFilePath: targetFilePath,
        compilationUnit: _filesRegistry[targetFilePath]!.compilationUnit,
      );
    }

    stopwatch.stop();
    print('~ Indexed ${_filesRegistry.length} files in ${stopwatch.elapsedMilliseconds}ms');
  }

  /// Builds the project
  ///
  /// **Project must be indexed before it can correctly build**
  Future<void> buildProject() async {
    print('~ Builting project..');
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
    print('~ Completed built in ${stopwatch.elapsed.inMilliseconds}ms..');
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
      print('> Error start');
      print(error);
      print(stackTrace);
      print('< Error end');
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
    print('$indent~ Checking $relativeFilePath');

    late final Stopwatch? stopwatch;
    if (reportTime) {
      stopwatch = Stopwatch()..start();
    } else {
      stopwatch = null;
    }

    CodeWriter codeWriter = CodeWriter.stringBuffer();

    if (compilationUnit == null) {
      _filesRegistry[targetFilePath] = ParsedFileData(
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

    final List<ClassDeclaration> classDeclarations = classCollectorVisitor.classNodes;

    if (classDeclarations.isEmpty) {
      try {
        await File(outputFilePath).delete();
      } catch (_) {
      } finally {
        print('$indent~ Skipping $relativeFilePath');
      }
      stopwatch?.stop();
      return;
    }

    final List<ClassDeclaration> dataClasses = classDeclarations
        .where((ClassDeclaration classDecl) => classDecl.hasDataClassAnnotation)
        .toList(growable: false);
    final List<ClassDeclaration> unionClasses = classDeclarations
        .where((ClassDeclaration classDecl) => classDecl.hasUnionAnnotation)
        .toList(growable: false);

    print('$indent~ Starting build for $relativeFilePath');

    final DataClassPluginOptions pluginOptions = await DataClassPluginOptions.fromFile(
      common_utils.getDataClassPluginOptionsFile(directory.path),
    );
    final JsonKeyNameConventionGetter jsonKeyNameConventionGetter = utils.getJsonKeyNameConvention(
      targetFileRelativePath: path.relative(targetFilePath),
      pluginOptions: pluginOptions,
    );

    codeWriter
      ..writeln('// AUTO GENERATED - DO NOT MODIFY')
      ..writeln()
      ..writeln("part of '${path.basename(targetFilePath)}';")
      ..writeln();

    await Future.wait(<Future<void>>[
      _generateDataClasses(
        codeWriter: codeWriter,
        compilationUnit: compilationUnit,
        classDeclarations: dataClasses,
        targetFilePath: targetFilePath,
        jsonKeyNameConventionGetter: jsonKeyNameConventionGetter,
      ),
      _generateUnionClasses(
        codeWriter: codeWriter,
        compilationUnit: compilationUnit,
        classDeclarations: unionClasses,
        targetFilePath: targetFilePath,
        jsonKeyNameConventionGetter: jsonKeyNameConventionGetter,
      ),
    ]);

    final String content = codeWriter.content;
    if (content.isEmpty) {
      try {
        await File(outputFilePath).delete();
      } catch (_) {}
    } else {
      await File(outputFilePath).writeAsString(DartFormatter().format(content));
    }

    final List<String> dependants = _dependencyGraph.getDependants(targetFilePath);
    if (!skipDependencies && dependants.isNotEmpty) {
      print('  Rebuilding ${dependants.length} depandants..');

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

    if (reportTime) {
      stopwatch!.stop();
      print('$indent~ Built done for $relativeFilePath in ${stopwatch.elapsed.inMilliseconds}ms');
    }
  }

  Future<void> _generateDataClasses({
    required CodeWriter codeWriter,
    required CompilationUnit compilationUnit,
    required List<ClassDeclaration> classDeclarations,
    required String targetFilePath,
    required JsonKeyNameConventionGetter jsonKeyNameConventionGetter,
  }) async {
    for (final ClassDeclaration classDeclaration in classDeclarations) {
      final String className = classDeclaration.name.lexeme;
      final String classTypeParametersSource = classDeclaration.typeParameters?.toSource() ?? '';
      final String generatedClassName = '_\$${className}Impl';

      final List<MethodDeclaration> fields = classDeclaration.members
          .where((ClassMember member) {
            return member is MethodDeclaration &&
                member.name.lexeme != 'hashCode' &&
                member.isGetter &&
                member.isAbstract;
          })
          .cast<MethodDeclaration>()
          .toList(growable: false);

      final ConstructorDeclaration? defaultConstructor =
          classDeclaration.members.firstWhereOrNull((ClassMember member) {
        return member is ConstructorDeclaration && member.name == null;
      }) as ConstructorDeclaration?;

      codeWriter.writeln(
          'class $generatedClassName$classTypeParametersSource extends $className$classTypeParametersSource {');

      createConstructor(
        codeWriter: codeWriter,
        defaultConstructor: defaultConstructor,
        fields: fields,
        generatedClassName: generatedClassName,
      );

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
        ).execute();
      }

      if (classDeclaration.hasMethod('copyWith')) {
        createCopyWith(
          codeWriter: codeWriter,
          fields: fields,
          generatedClassName: '$generatedClassName$classTypeParametersSource',
        );
      }

      if (classDeclaration.hasMethod('hashCode')) {
        HashAndEqualsGenerator(
          codeWriter: codeWriter,
          className: '$className$classTypeParametersSource',
          fields: fields,
        ).execute();
      }

      if (classDeclaration.hasMethod('toString')) {
        createToString(
          codeWriter: codeWriter,
          className: className,
          genericTypeArguments: classDeclaration.typeParameters?.toString() ?? '',
          fields: fields,
        );
      }

      codeWriter.writeln('}');
    }
  }

  Future<void> _generateUnionClasses({
    required CodeWriter codeWriter,
    required CompilationUnit compilationUnit,
    required List<ClassDeclaration> classDeclarations,
    required String targetFilePath,
    required JsonKeyNameConventionGetter jsonKeyNameConventionGetter,
  }) async {
    for (final ClassDeclaration classDeclaration in classDeclarations) {
      final String className = classDeclaration.name.lexeme;
      final String classTypeParametersSource = classDeclaration.typeParameters?.toSource() ?? '';
      final String generatedClassName = '_\$${className}Impl';

      final List<MethodDeclaration> fields = classDeclaration.members
          .where((ClassMember member) {
            return member is MethodDeclaration &&
                member.name.lexeme != 'hashCode' &&
                member.isGetter &&
                member.isAbstract;
          })
          .cast<MethodDeclaration>()
          .toList(growable: false);

      final ConstructorDeclaration? defaultConstructor =
          classDeclaration.members.firstWhereOrNull((ClassMember member) {
        return member is ConstructorDeclaration && member.name == null;
      }) as ConstructorDeclaration?;

      codeWriter.writeln(
          'class $generatedClassName$classTypeParametersSource extends $className$classTypeParametersSource {');

      createConstructor(
        codeWriter: codeWriter,
        defaultConstructor: defaultConstructor,
        fields: fields,
        generatedClassName: generatedClassName,
      );

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
        ).execute();
      }

      if (classDeclaration.hasMethod('copyWith')) {
        createCopyWith(
          codeWriter: codeWriter,
          fields: fields,
          generatedClassName: '$generatedClassName$classTypeParametersSource',
        );
      }

      if (classDeclaration.hasMethod('hashCode')) {
        HashAndEqualsGenerator(
          codeWriter: codeWriter,
          className: '$className$classTypeParametersSource',
          fields: fields,
        ).execute();
      }

      if (classDeclaration.hasMethod('toString')) {
        createToString(
          codeWriter: codeWriter,
          className: className,
          genericTypeArguments: classDeclaration.typeParameters?.toString() ?? '',
          fields: fields,
        );
      }

      codeWriter.writeln('}');
    }
  }
}
