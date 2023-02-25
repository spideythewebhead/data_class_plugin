import 'package:data_class_plugin/src/cli/commands/arguments.dart';

class AnalyzeArgument extends ArgumentOption {
  const AnalyzeArgument._({
    required super.name,
    super.abbr,
    super.defaultsTo,
    super.help,
    super.mandatory,
  });

  static const AnalyzeArgument file = AnalyzeArgument._(
    name: 'file',
    abbr: 'f',
    help: 'The file to analyze.',
    mandatory: false,
    defaultsTo: null,
  );

  static const AnalyzeArgument path = AnalyzeArgument._(
    name: 'path',
    abbr: 'p',
    help: 'The path to analyze.',
    mandatory: false,
    defaultsTo: null,
  );

  static const AnalyzeArgument recursive = AnalyzeArgument._(
    name: 'recursive',
    abbr: 'r',
    help: 'Analyze sub-directories recursively.',
    defaultsTo: false,
  );

  static const AnalyzeArgument log = AnalyzeArgument._(
    name: 'log',
    abbr: 'l',
    help: 'Log messages to file.',
    defaultsTo: false,
  );

  static const List<AnalyzeArgument> values = <AnalyzeArgument>[
    file,
    path,
    recursive,
    log,
  ];
}
