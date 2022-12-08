import 'package:data_class_plugin/src/commands/arguments.dart';
import 'package:data_class_plugin/src/commands/base_command.dart';
import 'package:data_class_plugin/src/commands/generate/generate_argument.dart';
import 'package:data_class_plugin/src/tools/logger/ansi.dart';

class GenerateCommand extends BaseCommand {
  @override
  String get name => 'generate';

  @override
  String get description => 'Generate code as specified by annotations'.bold();

  GenerateCommand(super.logger) {
    argParser.addArgumentOptions(GenerateArgument.values);
  }

  @override
  Future<void> init() async {
    await super.init();
  }

  @override
  Future<void> execute() async {
    // TODO
  }
}
