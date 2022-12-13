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

  Future<NamedCompilationUnitMember?> findClassDeclarationByName(
    String name, {
    required DependencyGraph dependencyGraph,
    required CompilationUnit compilationUnit,
    required String targetFilePath,
  }) async {
    return await _findClassDeclarationByName(
      name,
      dependencyGraph: dependencyGraph,
      compilationUnit: compilationUnit,
      targetFilePath: targetFilePath,
      currentDirectoryPath: File(targetFilePath).parent.absolute.path,
    );
  }

  Future<NamedCompilationUnitMember?> _findClassDeclarationByName(
    String name, {
    required DependencyGraph dependencyGraph,
    required CompilationUnit compilationUnit,
    required String targetFilePath,
    required String currentDirectoryPath,
    bool searchExports = false,
  }) async {
    NamedCompilationUnitMember? classDeclaration =
        _findClassDeclartion(name: name, unit: compilationUnit);

    if (classDeclaration != null) {
      return classDeclaration;
    }

    final List<CompilationUnit> compilationUnits = <CompilationUnit>[];

    for (final Directive directive in compilationUnit.directives) {
      String? directiveUri;
      if (searchExports) {
        directiveUri = directive is ExportDirective ? directive.uri.stringValue : null;
      } else if (directive is ImportDirective) {
        directiveUri = directive.uri.stringValue;
      }
      if (directiveUri != null) {
        final String? dartFilePath = await findDartFileForImport(
          projectDirectoryPath: _projectDirectoryPath,
          currentDirectoryPath: currentDirectoryPath,
          importUri: directiveUri,
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
            compilationUnit:
                dartFilePath.parse(featureSet: FeatureSet.latestLanguageVersion()).unit,
            lastModifiedAt: lastModifiedAt,
          );
        }

        compilationUnits.add(_parsedFilesRegistry[dartFilePath]!.compilationUnit);
      }
    }

    for (final CompilationUnit unit in compilationUnits) {
      classDeclaration = _findClassDeclartion(
        name: name,
        unit: unit,
      );

      if (classDeclaration != null) {
        return classDeclaration;
      }
    }

    return null;
  }

  NamedCompilationUnitMember? _findClassDeclartion({
    required String name,
    required CompilationUnit unit,
  }) {
    for (final CompilationUnitMember member in unit.declarations) {
      if (member is NamedCompilationUnitMember && member.name.lexeme == name) {
        return member;
      }
    }
    return null;
  }
}
