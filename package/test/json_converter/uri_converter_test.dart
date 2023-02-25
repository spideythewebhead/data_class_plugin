import 'dart:convert';

import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:test/test.dart';

@DataClass(
  copyWith: false,
  $toString: false,
  hashAndEquals: false,
  fromJson: true,
  toJson: true,
)
class _TestModel {
  /// Shorthand constructor
  _TestModel({
    required this.uri,
  });

  final Uri uri;

  /// Creates an instance of [_TestModel] from [json]
  factory _TestModel.fromJson(Map<dynamic, dynamic> json) {
    return _TestModel(
      uri: jsonConverterRegistrant.find(Uri).fromJson(json['uri'], json, 'uri') as Uri,
    );
  }

  /// Converts [_TestModel] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uri': jsonConverterRegistrant.find(Uri).toJson(uri),
    };
  }
}

void main() {
  final Uri httpsUri = Uri(
    scheme: 'https',
    host: 'github.com',
    path: 'spideythewebhead/dart_data_class_plugin',
    fragment: 'how-to-install',
  );

  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'John.Doe@example.com',
    queryParameters: <String, dynamic>{'subject': 'Example'},
  );

  const Map<String, dynamic> httpsJson = <String, dynamic>{
    'uri': 'https://github.com/spideythewebhead/dart_data_class_plugin#how-to-install',
  };

  const Map<String, dynamic> emailJson = <String, dynamic>{
    'uri': 'mailto:John.Doe@example.com?subject=Example',
  };

  group('Uri json converter', () {
    test('toJson', () {
      final _TestModel httpsModel = _TestModel(uri: httpsUri);
      final _TestModel emailModel = _TestModel(uri: emailUri);

      expect(httpsModel.toJson(), httpsJson);
      expect(emailModel.toJson(), emailJson);

      expect(jsonEncode(httpsModel), jsonEncode(httpsJson));
      expect(jsonEncode(emailModel), jsonEncode(emailJson));
    });

    test('fromJson', () {
      expect(_TestModel.fromJson(httpsJson).uri, httpsUri);
      expect(_TestModel.fromJson(emailJson).uri, emailUri);
    });
  });
}
