// AUTO GENERATED - DO NOT MODIFY

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
