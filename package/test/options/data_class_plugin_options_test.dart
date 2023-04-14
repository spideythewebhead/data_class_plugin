import 'dart:io';

import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  group('DataClassPluginOptions', () {
    test('returns DataClassPluginOptions from file', () async {
      final File optionsFile = File(join(
        Directory.current.path,
        'test',
        'options',
        'mock_data_class_plugin_options.yaml',
      ));

      final DataClassPluginOptions options = DataClassPluginOptions.fromFile(optionsFile);

      expect(options, isNotNull);
      expect(options.dataClass, isNotNull);
      expect(options.dataClass.optionsConfig, isNotEmpty);
      expect(options.union, isNotNull);
      expect(options.union.optionsConfig, isNotEmpty);
      expect(options.json, isNotNull);
      expect(options.json.nameConventionGlobs, isNotEmpty);
      expect(options.$enum, isNotNull);
      expect(options.$enum.optionsConfig, isNotEmpty);
    });
  });
}
