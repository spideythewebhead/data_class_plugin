// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
// coverage:ignore-file

part of 'options_config.dart';

class _$OptionConfigImpl extends OptionConfig {
  const _$OptionConfigImpl({
    this.defaultValue,
    List<String> enabled = const <String>[],
    List<String> disabled = const <String>[],
  })  : _enabled = enabled,
        _disabled = disabled,
        super.ctor();

  @override
  final bool? defaultValue;

  @override
  List<String> get enabled => List<String>.unmodifiable(_enabled);
  final List<String> _enabled;

  @override
  List<String> get disabled => List<String>.unmodifiable(_disabled);
  final List<String> _disabled;

  factory _$OptionConfigImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$OptionConfigImpl(
      defaultValue: json['default'] as bool?,
      enabled: json['enabled'] == null
          ? const <String>[]
          : <String>[
              for (final dynamic i0 in (json['enabled'] as List<dynamic>)) i0 as String,
            ],
      disabled: json['disabled'] == null
          ? const <String>[]
          : <String>[
              for (final dynamic i0 in (json['disabled'] as List<dynamic>)) i0 as String,
            ],
    );
  }

  @override
  Type get runtimeType => OptionConfig;
}
