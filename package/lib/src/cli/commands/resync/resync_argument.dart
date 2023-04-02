import 'package:data_class_plugin/src/cli/commands/arguments.dart';

class ResyncArgument extends ArgumentOption {
  const ResyncArgument._({
    required super.name,
    super.abbr,
    super.help,
    super.mandatory,
  });

  static const ResyncArgument lineLength = ResyncArgument._(
    name: 'lineLength',
    abbr: 'l',
    help: 'The line length used to format the code. '
        'Uses the data_class_plugin_options.yaml generated_file_line_length property, '
        'if no value is provided',
    mandatory: true,
  );

  static const List<ResyncArgument> values = <ResyncArgument>[
    lineLength,
  ];
}
