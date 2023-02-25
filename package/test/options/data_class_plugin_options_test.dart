import 'dart:io';

import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  group('DataClassPluginOptions', () {
    test('returns default DataClassPluginOptions() if file not found', () async {
      final DataClassPluginOptions options = await DataClassPluginOptions.fromFile(File(''));

      expect(options, isNotNull);
      expect(options.dataClass, isNotNull);
      expect(options.dataClass.optionsConfig, isEmpty);
      expect(options.union, isNotNull);
      expect(options.union.optionsConfig, isEmpty);
      expect(options.json, isNotNull);
      expect(options.json.nameConventionGlobs, isEmpty);
      expect(options.$enum, isNotNull);
      expect(options.$enum.optionsConfig, isEmpty);
    });

    test('returns DataClassPluginOptions from file', () async {
      final File optionsFile = File(join(
        Directory.current.path,
        'test',
        'options',
        'mock_data_class_plugin_options.yaml',
      ));

      final DataClassPluginOptions options = await DataClassPluginOptions.fromFile(optionsFile);

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
