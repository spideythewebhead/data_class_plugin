import 'package:data_class_plugin/public/annotations.dart';

@Union(
  dataClass: false,
  fromJson: false,
  toJson: true,
)
abstract class ToJson {
  const ToJson._();

  const factory ToJson.json1({
    required int v1,
    required String v2,
  }) = Json1;

  const factory ToJson.json2({
    required Map<String, String> v1,
    required List<int> v2,
  }) = Json2;

  /// Executes one of the provided callbacks based on a type match
  R when<R>({
    required R Function(Json1 value) json1,
    required R Function(Json2 value) json2,
  }) {
    if (this is Json1) {
      return json1(this as Json1);
    }
    if (this is Json2) {
      return json2(this as Json2);
    }
    throw UnimplementedError('Unknown instance of $this used in when(..)');
  }

  /// Executes one of the provided callbacks if a type is matched
  ///
  /// If no match is found [orElse] is executed
  R maybeWhen<R>({
    R Function(Json1 value)? json1,
    R Function(Json2 value)? json2,
    required R Function() orElse,
  }) {
    if (this is Json1) {
      return json1?.call(this as Json1) ?? orElse();
    }
    if (this is Json2) {
      return json2?.call(this as Json2) ?? orElse();
    }
    throw UnimplementedError('Unknown instance of $this used in maybeWhen(..)');
  }

  /// Converts [ToJson] to [Map] json
  Map<String, dynamic> toJson();
}

class Json1 extends ToJson {
  const Json1({
    required this.v1,
    required this.v2,
  }) : super._();

  final int v1;
  final String v2;

  /// Converts [Json1] to a [Map] json
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'v1': v1,
      'v2': v2,
    };
  }
}

class Json2 extends ToJson {
  const Json2({
    required this.v1,
    required this.v2,
  }) : super._();

  final Map<String, String> v1;
  final List<int> v2;

  /// Converts [Json2] to a [Map] json
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'v1': <String, dynamic>{
        for (final MapEntry<String, String> e0 in v1.entries) e0.key: e0.value,
      },
      'v2': <dynamic>[
        for (final int i0 in v2) i0,
      ],
    };
  }
}
