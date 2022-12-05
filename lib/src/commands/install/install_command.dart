import 'dart:io';
import 'package:data_class_plugin/src/commands/arguments.dart';
import 'package:data_class_plugin/src/commands/base_command.dart';
import 'package:data_class_plugin/src/commands/install/install_arguments.dart';
import 'package:data_class_plugin/src/utils/logger/ansi.dart';
import 'package:data_class_plugin/src/utils/logger/plugin_logger.dart';

class InstallCommand extends BaseCommand {
  @override
  String get name => 'install';

  @override
  String get description => 'Install Data Class Plugin';

  InstallCommand(this.sink) {
    argParser.addArgumentOptions(InstallArguments.values);
  }

  @override
  final IOSink? sink;

  static const String dependencyName = 'data_class_plugin';

  // late final Map<String, dynamic> _pubspecYaml;

  @override
  Future<void> init() async {
    super.logger = PluginLogger(
      ioSink: sink,
      writeToFile: argResults!.getValue(
        InstallArguments.log,
      ),
    );

    await super.init();
  }

  @override
  Future<void> execute() async {
    super.logger.writeln('Installing Data Class Plugin'.blue());

    final String path = argResults![InstallArguments.path.name] ?? Directory.current.path;
    super.logger.writeln("Target path: '$path'");
    try {
      // _pubspec(path);
      // _analysisOptions(path);
      // _pluginOptions(path);
    } catch (e, st) {
      super.logger.error(e, st);
    }
  }

  // void _pubspec(String path) {
  //   super.logger.writeln();
  //   super.logger.writeln('> Installing dependency in pubspec.yaml'.bold());
  //   final String filepath = join(path, pubspecYaml);
  //
  //   final File pubspecFile = File(filepath);
  //   if (!pubspecFile.existsSync()) {
  //     throw Exception('$pubspecYaml not found in $path');
  //   }
  //
  //   _pubspecYaml = Yamler.mapFromYamlFile(pubspecFile);
  //
  //   _pubspecYaml['dependencies']['data_class_plugin'] = <String, Map<String, String>>{
  //     'git': <String, String>{
  //       'url': 'https://github.com/spideythewebhead/dart_data_class_plugin',
  //       'ref': 'main',
  //     },
  //   };
  //
  //   super.logger.writeln(_pubspecYaml);
  //   super.logger.writeln();
  //
  //   File output = File(join(path, 'generated_pubspec.yaml'));
  //   output.createSync();
  //   output.writeAsStringSync(
  //     restoreEmptyLines(
  //       source: pubspecFile.readAsStringSync().replaceAll('\r', ''),
  //       target: Yamler.mapToYamlString(_pubspecYaml),
  //     ),
  //     flush: true,
  //   );
  // }

  /// Handle 'analysis_options.yaml'
  ///
  /// - Adds the 'lints' dev dependency in the pubspec.yaml
  ///
  /// -
  // void _analysisOptions(String path) async {
  //   super.logger.writeln();
  //   super.logger.writeln('> Installing plugin in analysis_options.yaml'.bold());
  //
  //   final String filepath = join(path, analysisOptionsYaml);
  //
  //   if (_pubspecYaml['dev_dependencies']['lints'] == null) {
  //     DartCommands.addPubDev(
  //       dependencyName: 'lints',
  //       path: path,
  //       isDev: true,
  //     );
  //     super.logger.writeln("added 'lints' dev dependency in pubspec.yaml");
  //   } else {
  //     super.logger.writeln("'lints' dev dependency is already added in pubspec.yaml");
  //   }
  //
  //   final File analysisOptionsFile = File(filepath);
  //   if (!analysisOptionsFile.existsSync()) {
  //     super.logger.warning('$analysisOptionsYaml not found in $path');
  //
  //     analysisOptionsFile.createSync(recursive: true);
  //
  //     analysisOptionsFile.writeAsStringSync(
  //       'include: package:lints/recommended.yaml\n\n'
  //       'analyzer:\n'
  //       '  plugins:\n'
  //       '    - data_class_plugin\n',
  //       flush: true,
  //     );
  //
  //     return;
  //   }
  //
  //   // final AnalysisOptions analysisOptions = (await AnalysisOptionsYaml.fromFile(filepath)).yaml;
  //
  //   final Map<String, dynamic> analysisOptions = Yamler.mapFromYamlFile(analysisOptionsFile);
  //
  //   print(analysisOptions['analyzer']['plugins'].runtimeType);
  //   analysisOptions['analyzer']['plugins'] =
  //       Yamler.addValueToYamlList(analysisOptions['analyzer']['plugins'], 'data_class_plugin');
  //
  //   final File generatedAnalysisOptionsFile = File(join(path, 'generated_analysis_options.yaml'));
  //   generatedAnalysisOptionsFile.createSync(recursive: true);
  //   generatedAnalysisOptionsFile.writeAsStringSync(
  //     Yamler.mapToYamlString(analysisOptions),
  //     flush: true,
  //   );
  //   // (analysisOptions['analyzer']['plugins'] as List<String>).add('    - data_class_plugin');
  // }

  // void _pluginOptions(String path) {
  //   super.logger.writeln();
  //   super
  //       .logger
  //       .writeln('> Creating plugin configuration in data_class_plugin_options.yaml'.bold());
  // }

  String restoreEmptyLines({
    required String source,
    required String target,
  }) {
    final List<String> sourceLines = source.split('\n');
    final List<String> targetLines = target.split('\n');
    final List<String> outputLines = <String>[];

    int targetIndex = 0;
    for (int i = 0; i < sourceLines.length; i++) {
      // Check if source line is equal with the target line
      if (sourceLines[i] == targetLines[targetIndex]) {
        outputLines.add(sourceLines[i]);
        targetIndex++;
      } else {
        // Check if source line is empty
        if (sourceLines[i].isEmpty) {
          // Add empty line
          outputLines.add(sourceLines[i]);
        } else {
          if (sourceLines[i] != targetLines[targetIndex]) {
            // outputLines.add(sourceLines[i]);
          }

          do {
            outputLines.add(targetLines[targetIndex]);
            if (targetIndex < targetLines.length) {
              targetIndex++;
            }
          } while (targetLines[targetIndex] != sourceLines[i] && targetIndex < targetLines.length);
        }
      }
    }

    // // Add any remaining lines from the target file
    // if (targetIndex < targetLines.length) {
    //   for (int i = targetIndex; i < targetLines.length; i++) {
    //     outputLines.add(targetLines[targetIndex]);
    //   }
    // }

    return outputLines.join('\n');
  }
}
