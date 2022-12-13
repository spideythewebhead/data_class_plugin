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
    required String projectDirectoryPath,
    required ParsedFilesRegistry parsedFilesRegistry,
  })  : _projectDirectoryPath = projectDirectoryPath,
        _parsedFilesRegistry = parsedFilesRegistry;

  final String _projectDirectoryPath;
  final ParsedFilesRegistry _parsedFilesRegistry;

  Future<NamedCompilationUnitMember?> findClassOrEnumDeclarationByName(
    String name, {
    required DependencyGraph dependencyGraph,
    required CompilationUnit compilationUnit,
    required String targetFilePath,
  }) async {
    return await _findClassOrEnumDeclarationByName(
      name,
      dependencyGraph: dependencyGraph,
      compilationUnit: compilationUnit,
      targetFilePath: targetFilePath,
      currentDirectoryPath: File(targetFilePath).parent.absolute.path,
    );
  }

  Future<NamedCompilationUnitMember?> _findClassOrEnumDeclarationByName(
    String name, {
    required DependencyGraph dependencyGraph,
    required CompilationUnit compilationUnit,
    required String targetFilePath,
    required String currentDirectoryPath,
  }) async {
    NamedCompilationUnitMember? nodeDeclaration =
        await _findClassOrEnumDeclaration(name: name, unit: compilationUnit);

    if (nodeDeclaration != null) {
      return nodeDeclaration;
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

      if (!dependencyGraph.hasDependency(targetFilePath, dartFilePath)) {
        dependencyGraph.add(targetFilePath, dartFilePath);
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
      nodeDeclaration = await _findClassOrEnumDeclaration(
        name: name,
        unit: parsedFileData.compilationUnit,
      );

      if (nodeDeclaration != null) {
        break;
      }

      nodeDeclaration = await _recursivelyExploreExports(
        name,
        currentDirectoryPath: File(parsedFileData.absolutePath).parent.absolute.path,
        compilationUnit: parsedFileData.compilationUnit,
      );

      if (nodeDeclaration != null) {
        break;
      }
    }

    return nodeDeclaration;
  }

  Future<NamedCompilationUnitMember?> _recursivelyExploreExports(
    String name, {
    required String currentDirectoryPath,
    required CompilationUnit compilationUnit,
  }) async {
    NamedCompilationUnitMember? nodeDeclaration;

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

      nodeDeclaration =
          await _findClassOrEnumDeclaration(name: name, unit: parsedFileData.compilationUnit);

      if (nodeDeclaration != null) {
        break;
      }

      nodeDeclaration = await _recursivelyExploreExports(
        name,
        currentDirectoryPath: File(exportDartFilePath).parent.absolute.path,
        compilationUnit: parsedFileData.compilationUnit,
      );

      if (nodeDeclaration != null) {
        break;
      }
    }

    return nodeDeclaration;
  }

  Future<NamedCompilationUnitMember?> _findClassOrEnumDeclaration({
    required String name,
    required CompilationUnit unit,
  }) async {
    for (final CompilationUnitMember member in unit.declarations) {
      if (member is ClassDeclaration && member.name.lexeme == name) {
        return member;
      }

      if (member is EnumDeclaration && member.name.lexeme == name) {
        return member;
      }
    }

    return null;
  }
}
