import 'package:data_class_plugin/src/commands/arguments.dart';

class InstallArguments extends ArgumentOption {
  const InstallArguments._({
    required super.name,
    super.abbr,
    super.defaultsTo,
    super.help,
    super.mandatory,
  });

  static const InstallArguments path = InstallArguments._(
    name: 'path',
    abbr: 'p',
    help: 'The path where the pubspec.yaml is.',
    mandatory: true,
  );

  static const InstallArguments recursive = InstallArguments._(
    name: 'recursive',
    abbr: 'r',
    help: 'Install Data Class Plugin for all projects '
        'found in the subdirectories of the given path.',
    defaultsTo: false,
  );

  static const List<InstallArguments> values = <InstallArguments>[
    path,
    recursive,
  ];
}
