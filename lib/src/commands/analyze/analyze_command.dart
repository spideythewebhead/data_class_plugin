import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:data_class_plugin/src/analyzer_plugin/analyzer_plugin.dart';
import 'package:data_class_plugin/src/analyzer_plugin/web_socket_plugin_server.dart';
import 'package:data_class_plugin/src/commands/analyze/analyze_arguments.dart';
import 'package:data_class_plugin/src/commands/arguments.dart';
import 'package:data_class_plugin/src/commands/base_command.dart';
import 'package:data_class_plugin/src/extensions/core_extensions.dart';
import 'package:data_class_plugin/src/utils/file_tools.dart';
import 'package:data_class_plugin/src/utils/logger/ansi.dart';
import 'package:data_class_plugin/src/utils/logger/plugin_logger.dart';

class AnalyzeCommand extends BaseCommand {
  AnalyzeCommand(this.sink) {
    argParser.addArgumentOptions(AnalyzeArguments.values);
  }

  @override
  String get description => 'Analyze files with Plugin Linter';

  @override
  String get name => 'analyze';

  @override
  String get invocation => '${runner?.executableName} $name [arguments]';

  late final DataClassPlugin plugin;

  @override
  final IOSink? sink;

  @override
  Future<void> init() async {
    super.logger = PluginLogger(
      ioSink: sink,
      writeToFile: argResults!.getValue(
        AnalyzeArguments.log,
      ),
    );

    await super.init();
  }

  @override
  Future<void> execute() async {
    final DateTime startedOn = DateTime.now();
    late final int exitCode;

    logger.info('Running plugin analyzer');
    try {
      // Initialize plugin
      plugin = DataClassPlugin(
        PhysicalResourceProvider.INSTANCE,
        logger,
      );

      // Start plugin
      plugin.start(
        WebSocketPluginServer(logger: logger),
      );

      final List<String> includedPaths = await _includedPaths();

      final AnalysisContextCollection analysis = AnalysisContextCollection(
        includedPaths: includedPaths,
        resourceProvider: PhysicalResourceProvider.INSTANCE,
      );

      logger.writeln();
      logger.info('Analysis context collection files: ${includedPaths.length}');

      for (final String path in includedPaths) {
        logger.writeln('🔍 Analyzing file $path');

        // String filepath = path;
        // if (!File(path).isAbsolute) {
        //   filepath = File(path).absolute.path;
        // }

        try {
          await plugin.checkLints(
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
      logger.error('Plugin analyzer failed after ${startedOn.getElapsedDuration()}');
      logger.exception(e, st);
      exitCode = -1;
    }

    await logger.dispose();
    exit(exitCode);
  }

  Future<List<String>> _includedPaths() async {
    final List<String> includedPaths = <String>[];

    final String? file = argResults!.getValue(AnalyzeArguments.file);
    final String? path = argResults!.getValue(AnalyzeArguments.path);
    final bool recursive = argResults!.getValue(AnalyzeArguments.recursive);

    if (file != null && File(file).existsSync()) {
      includedPaths.add(file);
    }
    if (path != null) {
      final List<String> files = await FileTools.findFile(
        '*.dart',
        path,
        recursive,
      );
      includedPaths.addAll(files);
    }

    if (includedPaths.isEmpty) {
      final List<String> files = await FileTools.findFile(
        '*.dart',
        Directory.current.path,
        true,
      );
      includedPaths.addAll(files);
    }

    return includedPaths;
  }
}
