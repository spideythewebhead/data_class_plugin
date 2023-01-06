import 'package:args/command_runner.dart';
import 'package:data_class_plugin/src/tools/logger/plugin_logger.dart';

abstract class BaseCommand extends Command<void> {
  BaseCommand({required this.logger});

  final PluginLogger logger;

  @override
  String get invocation => '${runner?.executableName} $name [arguments]';

  Future<void> init() async {
    logger.info('> Running command: $name');
  }

  Future<void> execute();

  @override
  Future<void> run() async {
    await init();
    await execute();
  }

  Future<void> dispose() async {}
}
