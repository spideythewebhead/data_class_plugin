// AUTO GENERATED - DO NOT MODIFY

part of 'data_class_plugin_options.dart';

class _$DataClassPluginOptionsImpl extends DataClassPluginOptions {
  const _$DataClassPluginOptionsImpl({
    this.json = const JsonOptions(),
    this.dataClass = const DataClassOptions(),
  }) : super._();

  @override
  final JsonOptions json;

  @override
  final DataClassOptions dataClass;

  factory _$DataClassPluginOptionsImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$DataClassPluginOptionsImpl(
      json: json['json'] == null
          ? const JsonOptions()
          : JsonOptions.fromJson(json['json']),
      dataClass: json['data_class'] == null
          ? const DataClassOptions()
          : DataClassOptions.fromJson(json['data_class']),
    );
  }

  @override
  String toString() {
    String value = 'DataClassPluginOptions{<optimized out>}';
    assert(() {
      value =
          'DataClassPluginOptions@<$hexIdentity>{json: $json, dataClass: $dataClass}';
      return true;
    }());
    return value;
  }
}

class _$JsonOptionsImpl extends JsonOptions {
  const _$JsonOptionsImpl({
    this.keyNameConvention,
    this.nameConventionGlobs = const <String, List<String>>{},
  }) : super._();

  @override
  final String? keyNameConvention;

  @override
  final Map<String, List<String>> nameConventionGlobs;

  factory _$JsonOptionsImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$JsonOptionsImpl(
      keyNameConvention: json['key_name_convention'] == null
          ? null
          : json['key_name_convention'] as String,
      nameConventionGlobs: json['key_name_conventions'] == null
          ? const <String, List<String>>{}
          : Map<String, List<String>>.unmodifiable(<String, List<String>>{
              for (final MapEntry<dynamic, dynamic> e0
                  in (json['key_name_conventions'] as Map<dynamic, dynamic>)
                      .entries)
                e0.key: List<String>.unmodifiable(<String>[
                  for (final dynamic i1 in (e0.value as List<dynamic>))
                    i1 as String,
                ]),
            }),
    );
  }

  @override
  String toString() {
    String value = 'JsonOptions{<optimized out>}';
    assert(() {
      value =
          'JsonOptions@<$hexIdentity>{keyNameConvention: $keyNameConvention, nameConventionGlobs: $nameConventionGlobs}';
      return true;
    }());
    return value;
  }
}

class _$DataClassOptionsImpl extends DataClassOptions {
  const _$DataClassOptionsImpl({
    this.optionsConfig = const <String, DataClassOptionConfig>{},
  }) : super._();

  @override
  final Map<String, DataClassOptionConfig> optionsConfig;

  factory _$DataClassOptionsImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$DataClassOptionsImpl(
      optionsConfig: json['options_config'] == null
          ? const <String, DataClassOptionConfig>{}
          : Map<String, DataClassOptionConfig>.unmodifiable(<String,
              DataClassOptionConfig>{
              for (final MapEntry<dynamic, dynamic> e0
                  in (json['options_config'] as Map<dynamic, dynamic>).entries)
                e0.key: DataClassOptionConfig.fromJson(e0.value),
            }),
    );
  }

  @override
  String toString() {
    String value = 'DataClassOptions{<optimized out>}';
    assert(() {
      value = 'DataClassOptions@<$hexIdentity>{optionsConfig: $optionsConfig}';
      return true;
    }());
    return value;
  }
}

class _$DataClassOptionConfigImpl extends DataClassOptionConfig {
  const _$DataClassOptionConfigImpl({
    this.defaultValue,
    this.enabled = const <String>[],
    this.disabled = const <String>[],
  }) : super._();

  @override
  final bool? defaultValue;

  @override
  final List<String> enabled;

  @override
  final List<String> disabled;

  factory _$DataClassOptionConfigImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$DataClassOptionConfigImpl(
      defaultValue: json['default'] == null ? null : json['default'] as bool,
      enabled: json['enabled'] == null
          ? const <String>[]
          : List<String>.unmodifiable(<String>[
              for (final dynamic i0 in (json['enabled'] as List<dynamic>))
                i0 as String,
            ]),
      disabled: json['disabled'] == null
          ? const <String>[]
          : List<String>.unmodifiable(<String>[
              for (final dynamic i0 in (json['disabled'] as List<dynamic>))
                i0 as String,
            ]),
    );
  }

  @override
  String toString() {
    String value = 'DataClassOptionConfig{<optimized out>}';
    assert(() {
      value =
          'DataClassOptionConfig@<$hexIdentity>{defaultValue: $defaultValue, enabled: $enabled, disabled: $disabled}';
      return true;
    }());
    return value;
  }
}
