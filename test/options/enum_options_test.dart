import 'dart:io';

import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('EnumOptions', () {
    const DataClassPluginOptions options = DataClassPluginOptions();

    test('provides correct default values', () {
      expect(options.$enum, equals(const EnumOptions()));
      expect(options.$enum.effectiveToString(''), equals(false));
      expect(options.$enum.effectiveFromJson(''), equals(false));
      expect(options.$enum.effectiveToJson(''), equals(false));
    });

    group('options from file', () {
      test('default values', () async {
        final File file = getFileWithContent('''
enum:
  options_config:
    to_string: 
      default: true
    from_json:
      default: true
    to_json:
      default: true
''');

        final DataClassPluginOptions options = await DataClassPluginOptions.fromFile(file);

        expect(options.$enum.optionsConfig['to_string']?.defaultValue, equals(true));
        expect(options.$enum.optionsConfig['from_json']?.defaultValue, equals(true));
        expect(options.$enum.optionsConfig['to_json']?.defaultValue, equals(true));
      });

      test('enabled/disabled', () async {
        const String enabledPath = 'a1/b1/c1';
        const String disabledPath = 'a2/b2/c2';

        final File file = getFileWithContent('''
enum:
  options_config:
    to_string:
      enabled:
        - $enabledPath
      disabled:
        - $disabledPath
    from_json:
      enabled:
        - $enabledPath
      disabled:
        - $disabledPath
    to_json:
      enabled:
        - $enabledPath
      disabled:
        - $disabledPath
''');

        final DataClassPluginOptions options = await DataClassPluginOptions.fromFile(file);

        for (final String option in <String>[
          'to_string',
          'to_json',
          'from_json',
        ]) {
          expect(
            options.$enum.optionsConfig[option]?.enabled,
            hasLength(1),
          );
          expect(
            options.$enum.optionsConfig[option]?.enabled.first,
            equals(enabledPath),
          );

          expect(
            options.$enum.optionsConfig[option]?.disabled,
            hasLength(1),
          );
          expect(
            options.$enum.optionsConfig[option]?.disabled.first,
            equals(disabledPath),
          );
        }
      });
    });
  });
}
