// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
// coverage:ignore-file

part of 'data_class_plugin_options.dart';

class _$DataClassPluginOptionsImpl extends DataClassPluginOptions {
  const _$DataClassPluginOptionsImpl({
    this.autoDeleteCodeFromAnnotation = false,
    this.json = const JsonOptions(),
    this.dataClass = const DataClassOptions(),
    this.$enum = const EnumOptions(),
    this.union = const UnionOptions(),
  }) : super.ctor();

  @override
  final bool autoDeleteCodeFromAnnotation;

  @override
  final JsonOptions json;

  @override
  final DataClassOptions dataClass;

  @override
  final EnumOptions $enum;

  @override
  final UnionOptions union;

  factory _$DataClassPluginOptionsImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$DataClassPluginOptionsImpl(
      autoDeleteCodeFromAnnotation: json['auto_delete_code_from_annotation'] as bool? ?? false,
      json: json['json'] == null ? const JsonOptions() : JsonOptions.fromJson(json['json']),
      dataClass: json['data_class'] == null
          ? const DataClassOptions()
          : DataClassOptions.fromJson(json['data_class']),
      $enum: json['enum'] == null ? const EnumOptions() : EnumOptions.fromJson(json['enum']),
      union: json['union'] == null ? const UnionOptions() : UnionOptions.fromJson(json['union']),
    );
  }

  @override
  Type get runtimeType => DataClassPluginOptions;
}
