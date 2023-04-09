import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/src/backend/core/find_package_path_by_import.dart';
import 'package:data_class_plugin/src/backend/core/packages_dependency_graph.dart';
import 'package:data_class_plugin/src/backend/core/parse_file_extension.dart';
import 'package:data_class_plugin/src/backend/core/parsed_file_data.dart';
import 'package:data_class_plugin/src/backend/core/parsed_files_registry.dart';
import 'package:path/path.dart' as path;

class DeclarationFinder {
  DeclarationFinder({
    required final String projectDirectoryPath,
    required final ParsedFilesRegistry parsedFilesRegistry,
    required final DependencyGraph dependencyGraph,
  })  : _projectDirectoryPath = projectDirectoryPath,
        _parsedFilesRegistry = parsedFilesRegistry,
        _dependencyGraph = dependencyGraph;

  final String _projectDirectoryPath;
  final ParsedFilesRegistry _parsedFilesRegistry;
  final DependencyGraph _dependencyGraph;

  Future<ClassOrEnumDeclarationMatch?> findClassOrEnumDeclarationByName(
    String name, {
    required CompilationUnit compilationUnit,
    required String targetFilePath,
  }) async {
    return await _findClassOrEnumDeclarationByName(
      name,
      compilationUnit: compilationUnit,
      targetFilePath: targetFilePath,
      currentDirectoryPath: File(targetFilePath).parent.absolute.path,
    );
  }

  Future<ClassOrEnumDeclarationMatch?> _findClassOrEnumDeclarationByName(
    String name, {
    required CompilationUnit compilationUnit,
    required String targetFilePath,
    required String currentDirectoryPath,
  }) async {
    NamedCompilationUnitMember? nodeDeclaration =
        _findClassOrEnumDeclaration(name: name, unit: compilationUnit);
    if (nodeDeclaration != null) {
      return ClassOrEnumDeclarationMatch(
        node: nodeDeclaration,
        filePath: targetFilePath,
      );
    }

    final List<ParsedFileData> parsedFiles = <ParsedFileData>[];

    for (final Directive directive in compilationUnit.directives) {
      String? directiveUri;

      if (directive is ImportDirective) {
        directiveUri = directive.uri.stringValue;
      }

      if (directiveUri == null) {
        continue;
      }

      final String? dartFilePath = await findDartFileFromUri(
        projectDirectoryPath: _projectDirectoryPath,
        currentDirectoryPath: currentDirectoryPath,
        uri: directiveUri,
      );

      if (dartFilePath == null || !path.isWithin(_projectDirectoryPath, dartFilePath)) {
        continue;
      }

      final File dartFile = File(dartFilePath);
      if (!await dartFile.exists()) {
        continue;
      }

      final DateTime lastModifiedAt = await dartFile.lastModified();

      if (!_dependencyGraph.hasDependency(targetFilePath, dartFilePath)) {
        _dependencyGraph.add(targetFilePath, dartFilePath);
      }

      if (!_parsedFilesRegistry.containsKey(dartFilePath) ||
          lastModifiedAt.isAfter(_parsedFilesRegistry[dartFilePath]!.lastModifiedAt)) {
        _parsedFilesRegistry[dartFilePath] = ParsedFileData(
          absolutePath: dartFilePath,
          compilationUnit: dartFilePath.parse(featureSet: FeatureSet.latestLanguageVersion()).unit,
          lastModifiedAt: lastModifiedAt,
        );
      }

      parsedFiles.add(_parsedFilesRegistry[dartFilePath]!);
    }

    for (final ParsedFileData parsedFileData in parsedFiles) {
      nodeDeclaration = _findClassOrEnumDeclaration(
        name: name,
        unit: parsedFileData.compilationUnit,
      );
      if (nodeDeclaration != null) {
        return ClassOrEnumDeclarationMatch(
          node: nodeDeclaration,
          filePath: parsedFileData.absolutePath,
        );
      }

      final ClassOrEnumDeclarationMatch? match = await _recursivelyExploreExports(
        name,
        currentDirectoryPath: File(parsedFileData.absolutePath).parent.absolute.path,
        compilationUnit: parsedFileData.compilationUnit,
      );
      if (match != null) {
        return match;
      }
    }

    return null;
  }

  Future<ClassOrEnumDeclarationMatch?> _recursivelyExploreExports(
    String name, {
    required String currentDirectoryPath,
    required CompilationUnit compilationUnit,
  }) async {
    for (final Directive directive in compilationUnit.directives) {
      if (directive is! ExportDirective) {
        continue;
      }

      final String? exportDartFilePath = await findDartFileFromUri(
        projectDirectoryPath: _projectDirectoryPath,
        currentDirectoryPath: currentDirectoryPath,
        uri: directive.uri.stringValue!,
      );

      if (exportDartFilePath == null) {
        continue;
      }

      final ParsedFileData parsedFileData = _parsedFilesRegistry[exportDartFilePath]!;

      NamedCompilationUnitMember? nodeDeclaration =
          _findClassOrEnumDeclaration(name: name, unit: parsedFileData.compilationUnit);
      if (nodeDeclaration != null) {
        return ClassOrEnumDeclarationMatch(
          node: nodeDeclaration,
          filePath: parsedFileData.absolutePath,
        );
      }

      final ClassOrEnumDeclarationMatch? match = await _recursivelyExploreExports(
        name,
        currentDirectoryPath: File(exportDartFilePath).parent.absolute.path,
        compilationUnit: parsedFileData.compilationUnit,
      );
      if (match != null) {
        return match;
      }
    }

    return null;
  }

  NamedCompilationUnitMember? _findClassOrEnumDeclaration({
    required String name,
    required CompilationUnit unit,
  }) {
    for (final CompilationUnitMember declaration in unit.declarations) {
      if (declaration is ClassDeclaration && declaration.name.lexeme == name) {
        return declaration;
      }

      if (declaration is EnumDeclaration && declaration.name.lexeme == name) {
        return declaration;
      }
    }
    return null;
  }
}

class ClassOrEnumDeclarationMatch {
  /// Shorthand constructor
  ClassOrEnumDeclarationMatch({
    required this.node,
    required this.filePath,
  });

  final NamedCompilationUnitMember node;
  final String filePath;
}
