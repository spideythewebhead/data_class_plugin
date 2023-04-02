import 'dart:io' as io;

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:dart_style/dart_style.dart';
import 'package:data_class_plugin/src/analyzer_plugin/analyzer_plugin.dart';
import 'package:data_class_plugin/src/analyzer_plugin/web_socket_plugin_server.dart';
import 'package:data_class_plugin/src/backend/code_generator.dart';
import 'package:data_class_plugin/src/cli/commands/arguments.dart';
import 'package:data_class_plugin/src/cli/commands/base_command.dart';
import 'package:data_class_plugin/src/cli/commands/mixins.dart';
import 'package:data_class_plugin/src/cli/commands/resync/resync_argument.dart';
import 'package:data_class_plugin/src/common/utils.dart';
import 'package:data_class_plugin/src/contributors/class/class_contributors.dart';
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:data_class_plugin/src/tools/logger/ansi.dart';

class ResyncCommand extends BaseCommand with UtilsCommandMixin {
  ResyncCommand({
    required super.logger,
    io.Directory? directory,
  }) : directory = directory ?? io.Directory.current {
    argParser.addArgumentOptions(ResyncArgument.values);
  }

  @override
  final io.Directory directory;

  late final CodeGenerator _codeGenerator = CodeGenerator(
    directory: directory,
    logger: logger,
  );

  @override
  String get name => 'resync';

  @override
  String get description => 'Resync project'.bold();

  @override
  Future<void> execute() async {
    final Stopwatch stopwatch = Stopwatch()..start();

    ensureHasPubspec();

    final DataClassPlugin plugin = DataClassPlugin(PhysicalResourceProvider.INSTANCE);

    final DataClassPluginOptions pluginOptions = await DataClassPluginOptions.fromFile(
        getDataClassPluginOptionsFile(_codeGenerator.directory.path));

    await _codeGenerator.indexProject();

    final List<String> includedPaths = _codeGenerator.registeredFiles;

    plugin.start(WebSocketPluginServer(logger: logger));

    Future<void> generate() async {
      final AnalysisContextCollection analysis = AnalysisContextCollection(
        includedPaths: includedPaths,
        resourceProvider: PhysicalResourceProvider.INSTANCE,
      );

      await plugin.handleAnalysisSetContextRoots(
        AnalysisSetContextRootsParams(<ContextRoot>[
          for (final String path in includedPaths) ContextRoot(path, <String>[]),
        ]),
      );

      for (final String path in includedPaths) {
        final io.File file = io.File(path);

        final AssistRequest request = await plugin.getAssistRequest(
          EditGetAssistsParams(path, 0, file.lengthSync()),
        );

        final _SimpleAssistCollector collector = _SimpleAssistCollector();
        final DataClassAssistContributor dataClassContributor =
            DataClassAssistContributor(path, pluginOptions: pluginOptions);

        final ResolvedUnitResult resolvedUnitResult = await analysis
            .contextFor(path)
            .currentSession
            .getResolvedUnit(path)
            .then((SomeResolvedUnitResult value) => value as ResolvedUnitResult);

        await dataClassContributor.computeAssists(
          _SimpleAssistRequest(
            length: request.length,
            offset: request.offset,
            resourceProvider: request.resourceProvider,
            result: resolvedUnitResult,
          ),
          collector,
        );

        String content = file.readAsStringSync();
        for (final PrioritizedSourceChange assist in collector.assists) {
          for (final SourceFileEdit sourceFileEdit in assist.change.edits) {
            for (final SourceEdit edit in sourceFileEdit.edits) {
              content = content.replaceRange(edit.offset, edit.end, edit.replacement);
            }
          }
        }
        file.writeAsStringSync(DartFormatter(
          pageWidth: pluginOptions.generatedFileLineLength,
        ).format(content));
      }

      await _codeGenerator.indexProject(forceClear: true);
      await _codeGenerator.buildProject();
    }

    await generate();

    // a second generate is necessary as code generation might depend on code which needs to be generated
    // example: super classes with DataClass annotation
    await generate();

    stopwatch.stop();
    logger.info('~ Resync completed in ${stopwatch.elapsedMilliseconds / 1000}s');
    io.exit(0);
  }

  @override
  Future<void> dispose() async {
    await _codeGenerator.dispose();
    return super.dispose();
  }
}

class _SimpleAssistRequest extends DartAssistRequest {
  _SimpleAssistRequest({
    required this.length,
    required this.offset,
    required this.resourceProvider,
    required this.result,
  });

  @override
  final int length;

  @override
  final int offset;

  @override
  final ResourceProvider resourceProvider;

  @override
  final ResolvedUnitResult result;
}

class _SimpleAssistCollector extends AssistCollector {
  final List<PrioritizedSourceChange> assists = <PrioritizedSourceChange>[];

  @override
  void addAssist(PrioritizedSourceChange assist) => assists.add(assist);
}
