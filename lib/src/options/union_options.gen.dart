// AUTO GENERATED - DO NOT MODIFY

part of 'union_options.dart';

class _$UnionOptionsImpl with UnionOptions {
  const _$UnionOptionsImpl({
    this.optionsConfig = const <String, OptionConfig>{},
  });

  @override
  final Map<String, OptionConfig> optionsConfig;

  factory _$UnionOptionsImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$UnionOptionsImpl(
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
