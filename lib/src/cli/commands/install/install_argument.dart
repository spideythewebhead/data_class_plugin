import 'package:data_class_plugin/src/cli/commands/arguments.dart';

class InstallArgument extends ArgumentOption {
  const InstallArgument._({
    required super.name,
    super.abbr,
    super.defaultsTo,
    super.help,
    super.mandatory,
  });

  static const InstallArgument path = InstallArgument._(
    name: 'path',
    abbr: 'p',
    help: 'The path where the pubspec.yaml is.',
    mandatory: true,
  );

  static const InstallArgument recursive = InstallArgument._(
    name: 'recursive',
    abbr: 'r',
    help: 'Install Data Class Plugin for all projects '
        'found in the subdirectories of the given path.',
    defaultsTo: false,
  );

  static const InstallArgument log = InstallArgument._(
    name: 'log',
    abbr: 'l',
    help: 'Log messages to file.',
    defaultsTo: false,
  );

  static const List<InstallArgument> values = <InstallArgument>[
    path,
    recursive,
    log,
  ];
}
