import 'package:data_class_plugin/data_class_plugin.dart';

part 'json_options.gen.dart';

@DataClass()
abstract class JsonOptions {
  const JsonOptions.ctor();

  /// Default constructor
  const factory JsonOptions({
    String? keyNameConvention,
    Map<String, List<String>> nameConventionGlobs,
  }) = _$JsonOptionsImpl;

  /// Creates an instance of [JsonOptions] from [json]
  factory JsonOptions.fromJson(Map<dynamic, dynamic> json) = _$JsonOptionsImpl.fromJson;

  String? get keyNameConvention;

  @JsonKey(name: 'key_name_conventions')
  @DefaultValue(<String, List<String>>{})
  Map<String, List<String>> get nameConventionGlobs;
}
