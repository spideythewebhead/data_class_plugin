import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:data_class_plugin/src/utils/logger/plugin_logger.dart';

abstract class BaseCommand extends Command<void> {
  late final PluginLogger logger;
  IOSink? get sink;

  Future<void> init() async {
    logger.logHeader(PluginLogger.pluginHeader());
  }

  Future<void> execute();

  @override
  Future<void> run() async {
    await init();
    await execute();
  }
}
