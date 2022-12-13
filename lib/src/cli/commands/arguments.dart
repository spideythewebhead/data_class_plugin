import 'package:args/args.dart';

abstract class ArgumentOption {
  /// Default constructor of [ArgumentOption]
  const ArgumentOption({
    required this.name,
    this.abbr,
    this.help,
    this.defaultsTo,
    this.allowed,
    this.mandatory = false,
  });

  final String name;
  final String? abbr;
  final String? help;
  final dynamic defaultsTo;
  final List<String>? allowed;
  final bool mandatory;

  static Map<ArgumentOption, dynamic> fromArguments(
    final ArgResults results,
    final List<ArgumentOption> arguments,
  ) {
    return <ArgumentOption, dynamic>{
      for (final ArgumentOption value in arguments) value: results[value.name] ?? value.defaultsTo
    };
  }
}

extension ArgParserX on ArgParser {
  void addArgumentOptions(List<ArgumentOption> arguments) {
    for (final ArgumentOption option in arguments) {
      if (option.defaultsTo.runtimeType == bool) {
        addArgumentFlag(option);
      } else {
        addArgumentOption(option);
      }
    }
  }

  void addArgumentOption(ArgumentOption option) {
    addOption(
      option.name,
      abbr: option.abbr,
      help: option.help,
      defaultsTo: option.defaultsTo == null ? null : '${option.defaultsTo}',
      mandatory: false,
      allowed: option.allowed,
    );
  }

  void addArgumentFlag(ArgumentOption option) {
    addFlag(
      option.name,
      abbr: option.abbr,
      help: option.help,
      defaultsTo: option.defaultsTo,
    );
  }
}

extension ArgResultsX on ArgResults {
  dynamic getValue(ArgumentOption option) {
    return this[option.name] ?? option.defaultsTo;
  }
}
