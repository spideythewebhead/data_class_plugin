// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// coverage:ignore-file

part of 'data_class_plugin_options.dart';

class _$DataClassPluginOptionsImpl extends DataClassPluginOptions {
  const _$DataClassPluginOptionsImpl({
    this.json = const JsonOptions(),
    this.dataClass = const DataClassOptions(),
    this.$enum = const EnumOptions(),
    this.union = const UnionOptions(),
  }) : super.ctor();

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
