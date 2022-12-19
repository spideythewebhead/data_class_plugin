// AUTO GENERATED - DO NOT MODIFY

part of 'data_class_options.dart';

class _$DataClassOptionsImpl extends DataClassOptions {
  const _$DataClassOptionsImpl({
    this.optionsConfig = const <String, OptionConfig>{},
  }) : super._();

  @override
  final Map<String, OptionConfig> optionsConfig;

  factory _$DataClassOptionsImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$DataClassOptionsImpl(
      optionsConfig: json['options_config'] == null
          ? const <String, OptionConfig>{}
          : <String, OptionConfig>{
              for (final MapEntry<dynamic, dynamic> e0
                  in (json['options_config'] as Map<dynamic, dynamic>).entries)
                e0.key: OptionConfig.fromJson(e0.value),
            },
    );
  }
}
