import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:data_class_plugin/src/analyzer_plugin/analyzer_plugin.dart';
import 'package:data_class_plugin/src/analyzer_plugin/web_socket_plugin_server.dart';
import 'package:data_class_plugin/src/cli/commands/analyze/analyze_argument.dart';
import 'package:data_class_plugin/src/cli/commands/arguments.dart';
import 'package:data_class_plugin/src/cli/commands/base_command.dart';
import 'package:data_class_plugin/src/extensions/core_extensions.dart';
import 'package:data_class_plugin/src/tools/file_tools.dart';
import 'package:data_class_plugin/src/tools/logger/ansi.dart';

class AnalyzeCommand extends BaseCommand {
  AnalyzeCommand({required super.logger}) {
    argParser.addArgumentOptions(AnalyzeArgument.values);
  }

  @override
  String get name => 'analyze';

  @override
  String get description => 'Analyze files with Plugin Linter'.bold();

  late final DataClassPlugin plugin;

  @override
  Future<void> init() async {
    super.logger.writeToFile = argResults!.getValue(
      AnalyzeArgument.log,
    );

    await super.init();
  }

  @override
  Future<void> execute() async {
    final DateTime startedOn = DateTime.now();

    logger.info('Running plugin analyzer');
    try {
      // Initialize plugin
      plugin = DataClassPlugin(PhysicalResourceProvider.INSTANCE);

      // Start plugin
      plugin.start(
        WebSocketPluginServer(logger: logger),
      );

      final List<String> includedPaths = await _findIncludedPaths();

      final AnalysisContextCollection analysis = AnalysisContextCollection(
        includedPaths: includedPaths,
        resourceProvider: PhysicalResourceProvider.INSTANCE,
      );

      logger.writeln();
      logger.info('Analysis context collection files: ${includedPaths.length}');

      for (final String path in includedPaths) {
        logger.writeln('🔍 Analyzing file $path');

        try {
          await plugin.analyzeFile(
            analysisContext: analysis.contextFor(path),
            path: path,
          );
        } catch (e, st) {
          logger.exception(e, st);
        }

        logger.writeln(Ansi.horizontalLine(length: 100));
      }

      logger.writeln();
      logger.info(
          'Plugin linter analyzed ${includedPaths.length} files in ${startedOn.getElapsedDuration()}');

      exitCode = 0;
    } catch (e, st) {
      logger.exception('Plugin analyzer failed after ${startedOn.getElapsedDuration()}');
      logger.exception(e, st);
      exitCode = 1;
    }

    await logger.dispose();
  }

  Future<List<String>> _findIncludedPaths() async {
    final List<String> includedPaths = <String>[];

    final String? file = argResults!.getValue(AnalyzeArgument.file);
    final String? path = argResults!.getValue(AnalyzeArgument.path);
    final bool recursive = argResults!.getValue(AnalyzeArgument.recursive);

    if (file != null && File(file).existsSync()) {
      includedPaths.add(file);
    }

    if (path != null) {
      final List<String> files = FileTools.findFiles(
        matchingPattern: FileTools.dartFileNameMatcher,
        path: path,
        recursive: recursive,
      );
      includedPaths.addAll(files);
    }

    if (includedPaths.isEmpty) {
      final List<String> files = FileTools.findFiles(
        matchingPattern: FileTools.dartFileNameMatcher,
        path: Directory.current.path,
        recursive: true,
      );
      includedPaths.addAll(files);
    }

    return includedPaths;
  }
}
