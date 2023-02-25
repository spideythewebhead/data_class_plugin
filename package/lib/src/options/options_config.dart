import 'package:data_class_plugin/data_class_plugin.dart';

part 'options_config.gen.dart';

@DataClass()
abstract class OptionConfig {
  const OptionConfig.ctor();

  /// Default constructor
  const factory OptionConfig({
    bool? defaultValue,
    List<String> enabled,
    List<String> disabled,
  }) = _$OptionConfigImpl;

  /// Creates an instance of [OptionConfig] from [json]
  factory OptionConfig.fromJson(Map<dynamic, dynamic> json) = _$OptionConfigImpl.fromJson;

  @JsonKey(name: 'default')
  bool? get defaultValue;

  @DefaultValue(<String>[])
  List<String> get enabled;

  @DefaultValue(<String>[])
  List<String> get disabled;
}
