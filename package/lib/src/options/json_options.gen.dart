// AUTO GENERATED - DO NOT MODIFY

part of 'json_options.dart';

class _$JsonOptionsImpl extends JsonOptions {
  const _$JsonOptionsImpl({
    this.keyNameConvention,
    Map<String, List<String>> nameConventionGlobs = const <String, List<String>>{},
  })  : _nameConventionGlobs = nameConventionGlobs,
        super.ctor();

  @override
  final String? keyNameConvention;

  @override
  Map<String, List<String>> get nameConventionGlobs =>
      Map<String, List<String>>.unmodifiable(_nameConventionGlobs);
  final Map<String, List<String>> _nameConventionGlobs;

  factory _$JsonOptionsImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$JsonOptionsImpl(
      keyNameConvention: json['key_name_convention'] as String?,
      nameConventionGlobs: json['key_name_conventions'] == null
          ? const <String, List<String>>{}
          : <String, List<String>>{
              for (final MapEntry<dynamic, dynamic> e0
                  in (json['key_name_conventions'] as Map<dynamic, dynamic>).entries)
                e0.key as String: <String>[
                  for (final dynamic i1 in (e0.value as List<dynamic>)) i1 as String,
                ],
            },
    );
  }

  @override
  Type get runtimeType => JsonOptions;
}
