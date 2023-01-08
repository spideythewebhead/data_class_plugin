// AUTO GENERATED - DO NOT MODIFY

part of 'enum_options.dart';

class _$EnumOptionsImpl extends EnumOptions {
  const _$EnumOptionsImpl({
    this.optionsConfig = const <String, OptionConfig>{},
  }) : super.ctor();

  @override
  final Map<String, OptionConfig> optionsConfig;

  factory _$EnumOptionsImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$EnumOptionsImpl(
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
