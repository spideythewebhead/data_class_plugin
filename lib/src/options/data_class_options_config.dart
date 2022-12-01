import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass()
class OptionConfig {
  /// Shorthand constructor
  const OptionConfig({
    this.defaultValue,
    this.enabled = const <String>[],
    this.disabled = const <String>[],
  });

  @JsonKey(name: 'default')
  final bool? defaultValue;
  final List<String> enabled;
  final List<String> disabled;

  /// Creates an instance of [OptionConfig] from [json]
  factory OptionConfig.fromJson(Map<dynamic, dynamic> json) {
    return OptionConfig(
      defaultValue: json['default'] == null ? null : json['default'] as bool,
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
}
