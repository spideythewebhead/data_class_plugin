// AUTO GENERATED - DO NOT MODIFY

part of 'data_class_options.dart';

class _$DataClassOptionsImpl extends DataClassOptions {
  const _$DataClassOptionsImpl({
    Map<String, OptionConfig> optionsConfig = const <String, OptionConfig>{},
  })  : _optionsConfig = optionsConfig,
        super.ctor();

  @override
  Map<String, OptionConfig> get optionsConfig =>
      Map<String, OptionConfig>.unmodifiable(_optionsConfig);
  final Map<String, OptionConfig> _optionsConfig;

  factory _$DataClassOptionsImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$DataClassOptionsImpl(
      optionsConfig: json['options_config'] == null
          ? const <String, OptionConfig>{}
          : <String, OptionConfig>{
              for (final MapEntry<dynamic, dynamic> e0
                  in (json['options_config'] as Map<dynamic, dynamic>).entries)
                e0.key as String: OptionConfig.fromJson(e0.value),
            },
    );
  }

  @override
  Type get runtimeType => DataClassOptions;
}
