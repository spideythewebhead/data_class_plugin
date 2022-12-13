import 'package:data_class_plugin/src/cli/commands/arguments.dart';

class GenerateArgument extends ArgumentOption {
  const GenerateArgument._({
    required super.name,
    super.abbr,
    super.defaultsTo,
    super.help,
    super.mandatory,
    super.allowed,
  });

  static const GenerateArgument mode = GenerateArgument._(
    name: 'mode',
    abbr: 'm',
    help: 'Code generation mode.',
    mandatory: false,
    defaultsTo: 'build',
    allowed: <String>['build', 'watch'],
  );

  static const GenerateArgument file = GenerateArgument._(
    name: 'file',
    abbr: 'f',
    help: 'The file to generate.',
    mandatory: false,
    defaultsTo: null,
  );

  static const GenerateArgument path = GenerateArgument._(
    name: 'path',
    abbr: 'p',
    help: 'The path of files generate.',
    mandatory: false,
    defaultsTo: null,
  );

  static const GenerateArgument recursive = GenerateArgument._(
    name: 'recursive',
    abbr: 'r',
    help: 'Analyze sub-directories recursively.',
    defaultsTo: false,
  );

  static const GenerateArgument log = GenerateArgument._(
    name: 'log',
    abbr: 'l',
    help: 'Log messages to file.',
    defaultsTo: false,
  );

  static const List<GenerateArgument> values = <GenerateArgument>[
    mode,
    file,
    path,
    recursive,
    log,
  ];
}
