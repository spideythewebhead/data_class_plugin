import 'package:data_class_plugin/src/commands/arguments.dart';

class AnalyzeArguments extends ArgumentOption {
  const AnalyzeArguments._({
    required super.name,
    super.abbr,
    super.defaultsTo,
    super.help,
    super.mandatory,
  });

  static const AnalyzeArguments file = AnalyzeArguments._(
    name: 'file',
    abbr: 'f',
    help: 'The file to analyze.',
    mandatory: false,
    defaultsTo: null,
  );

  static const AnalyzeArguments path = AnalyzeArguments._(
    name: 'path',
    abbr: 'p',
    help: 'The path to analyze.',
    mandatory: false,
    defaultsTo: null,
  );

  static const AnalyzeArguments recursive = AnalyzeArguments._(
    name: 'recursive',
    abbr: 'r',
    help: 'Analyze sub-directories recursively.',
    defaultsTo: false,
  );

  static const AnalyzeArguments log = AnalyzeArguments._(
    name: 'log',
    abbr: 'l',
    help: 'Log messages to file.',
    defaultsTo: false,
  );

  static const List<AnalyzeArguments> values = <AnalyzeArguments>[
    file,
    path,
    recursive,
    log,
  ];
}
