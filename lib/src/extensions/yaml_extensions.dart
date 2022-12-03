import 'package:yaml/yaml.dart';

extension YamlMapConverter on YamlMap {
  // Yaml-Map conversions based on https://stackoverflow.com/a/67885082
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    nodes.forEach((dynamic k, YamlNode v) {
      if (k is YamlScalar) {
        map['${k.value}'] = _convertNode(v);
      } else {
        map['$k'] = _convertNode(v);
      }
    });
    return map;
  }

  dynamic _convertNode(dynamic v) {
    if (v is YamlMap) {
      return (v).toMap();
    } else if (v is YamlList) {
      List<dynamic> list = <dynamic>[];
      for (final dynamic e in v) {
        list.add(_convertNode(e));
      }
      return list;
    } else {
      return v;
    }
  }
}

extension StringExtension on String {
  String normalize() {
    return replaceAll('"', '\\"')
        .replaceAll(r'\', '\\')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r');
  }
}
