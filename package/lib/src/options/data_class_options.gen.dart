// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
// coverage:ignore-file

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
