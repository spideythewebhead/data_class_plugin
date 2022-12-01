import 'package:data_class_plugin/data_class_plugin.dart';

@DataClass()
class JsonOptions {
  /// Shorthand constructor
  const JsonOptions({
    this.keyNameConvention,
    this.nameConventionGlobs = const <String, List<String>>{},
  });

  final String? keyNameConvention;

  @JsonKey(name: 'key_name_conventions')
  final Map<String, List<String>> nameConventionGlobs;

  /// Creates an instance of [JsonOptions] from [json]
  factory JsonOptions.fromJson(Map<dynamic, dynamic> json) {
    return JsonOptions(
      keyNameConvention:
          json['key_name_convention'] == null ? null : json['key_name_convention'] as String,
      nameConventionGlobs: json['key_name_conventions'] == null
          ? const <String, List<String>>{}
          : <String, List<String>>{
              for (final MapEntry<dynamic, dynamic> e0
                  in (json['key_name_conventions'] as Map<dynamic, dynamic>).entries)
                e0.key: <String>[
                  for (final dynamic i1 in (e0.value as List<dynamic>)) i1 as String,
                ],
            },
    );
  }
}
