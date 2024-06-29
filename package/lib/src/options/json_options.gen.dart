// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
// coverage:ignore-file

part of 'json_options.dart';

class _$JsonOptionsImpl extends JsonOptions {
  const _$JsonOptionsImpl({
    this.keyNameConvention,
    Map<String, List<String>> nameConventionGlobs = const <String, List<String>>{},
    this.toJson = const ToJsonOptions(),
  })  : _nameConventionGlobs = nameConventionGlobs,
        super.ctor();

  @override
  final String? keyNameConvention;

  @override
  Map<String, List<String>> get nameConventionGlobs =>
      Map<String, List<String>>.unmodifiable(_nameConventionGlobs);
  final Map<String, List<String>> _nameConventionGlobs;

  @override
  final ToJsonOptions toJson;

  factory _$JsonOptionsImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$JsonOptionsImpl(
      keyNameConvention: json['key_name_convention'] as String?,
      nameConventionGlobs: json['key_name_conventions'] == null
          ? const <String, List<String>>{}
          : <String, List<String>>{
              for (final MapEntry<dynamic, dynamic> e0
                  in (json['key_name_conventions'] as Map<dynamic, dynamic>).entries)
                e0.key as String: <String>[
                  for (final dynamic i1 in (e0.value as List<dynamic>)) i1 as String,
                ],
            },
      toJson:
          json['to_json'] == null ? const ToJsonOptions() : ToJsonOptions.fromJson(json['to_json']),
    );
  }

  @override
  Type get runtimeType => JsonOptions;
}

class _$ToJsonOptionsImpl extends ToJsonOptions {
  const _$ToJsonOptionsImpl({
    Map<String, OptionConfig> optionsConfig = const <String, OptionConfig>{},
  })  : _optionsConfig = optionsConfig,
        super.ctor();

  @override
  Map<String, OptionConfig> get optionsConfig =>
      Map<String, OptionConfig>.unmodifiable(_optionsConfig);
  final Map<String, OptionConfig> _optionsConfig;

  factory _$ToJsonOptionsImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$ToJsonOptionsImpl(
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
  Type get runtimeType => ToJsonOptions;
}
