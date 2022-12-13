import 'dart:io';

import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('DataClassOptions', () {
    const DataClassPluginOptions options = DataClassPluginOptions();

    test('provides correct default values', () {
      expect(options.dataClass, equals(const DataClassOptions()));
      expect(options.dataClass.effectiveCopyWith(''), equals(true));
      expect(options.dataClass.effectiveHashAndEquals(''), equals(true));
      expect(options.dataClass.effectiveToString(''), equals(true));
      expect(options.dataClass.effectiveFromJson(''), equals(false));
      expect(options.dataClass.effectiveToJson(''), equals(false));
    });

    group('options from file', () {
      test('default values', () async {
        final File file = getFileWithContent('''
data_class:
  options_config:
    copy_with:
      default: false
    hash_and_equals:
      default: false
    to_string: 
      default: false
    from_json:
      default: true
    to_json:
      default: true
''');

        final DataClassPluginOptions options = await DataClassPluginOptions.fromFile(file);

        expect(options.dataClass.optionsConfig['copy_with']?.defaultValue, equals(false));
        expect(options.dataClass.optionsConfig['hash_and_equals']?.defaultValue, equals(false));
        expect(options.dataClass.optionsConfig['to_string']?.defaultValue, equals(false));
        expect(options.dataClass.optionsConfig['from_json']?.defaultValue, equals(true));
        expect(options.dataClass.optionsConfig['to_json']?.defaultValue, equals(true));
      });

      test('enabled/disabled', () async {
        const String enabledPath = 'a1/b1/c1';
        const String disabledPath = 'a2/b2/c2';

        final File file = getFileWithContent('''
data_class:
  options_config:
    copy_with:
      enabled:
        - $enabledPath
      disabled:
        - $disabledPath
    hash_and_equals:
      enabled:
        - $enabledPath
      disabled:
        - $disabledPath
    to_string:
      enabled:
        - $enabledPath
      disabled:
        - $disabledPath
    to_json:
      enabled:
        - $enabledPath
      disabled:
        - $disabledPath
    from_json:
      enabled:
        - $enabledPath
      disabled:
        - $disabledPath
''');

        final DataClassPluginOptions options = await DataClassPluginOptions.fromFile(file);

        for (final String option in <String>[
          'copy_with',
          'hash_and_equals',
          'to_string',
          'to_json',
          'from_json',
        ]) {
          expect(
            options.dataClass.optionsConfig[option]?.enabled,
            hasLength(1),
          );
          expect(
            options.dataClass.optionsConfig[option]?.enabled.first,
            equals(enabledPath),
          );

          expect(
            options.dataClass.optionsConfig[option]?.disabled,
            hasLength(1),
          );
          expect(
            options.dataClass.optionsConfig[option]?.disabled.first,
            equals(disabledPath),
          );
        }
      });
    });
  });
}
