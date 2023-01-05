// AUTO GENERATED - DO NOT MODIFY

part of 'options_config.dart';

class _$OptionConfigImpl with OptionConfig {
  const _$OptionConfigImpl({
    this.defaultValue,
    this.enabled = const <String>[],
    this.disabled = const <String>[],
  });

  @override
  final bool? defaultValue;

  @override
  final List<String> enabled;

  @override
  final List<String> disabled;

  factory _$OptionConfigImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$OptionConfigImpl(
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
