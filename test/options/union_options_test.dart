import 'dart:io';

import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('UnionOptions', () {
    const DataClassPluginOptions options = DataClassPluginOptions();

    test('provides correct default values', () {
      expect(options.union, equals(const UnionOptions()));
      expect(options.union.effectiveCopyWith(''), equals(false));
      expect(options.union.effectiveHashAndEquals(''), equals(true));
      expect(options.union.effectiveToString(''), equals(true));
      expect(options.union.effectiveFromJson(''), equals(false));
      expect(options.union.effectiveToJson(''), equals(false));
    });

    group('options from file', () {
      test('default values', () async {
        final File file = getFileWithContent('''
union:
  options_config:
    data_class: 
      default: false
    from_json:
      default: true
    to_json:
      default: true
''');

        final DataClassPluginOptions options = await DataClassPluginOptions.fromFile(file);

        expect(options.union.optionsConfig['data_class']?.defaultValue, equals(false));
        expect(options.union.optionsConfig['from_json']?.defaultValue, equals(true));
        expect(options.union.optionsConfig['to_json']?.defaultValue, equals(true));
      });

      test('enabled/disabled', () async {
        const String enabledPath = 'a1/b1/c1';
        const String disabledPath = 'a2/b2/c2';

        final File file = getFileWithContent('''
union:
  options_config:
    data_class:
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
          'data_class',
          'to_json',
          'from_json',
        ]) {
          expect(
            options.union.optionsConfig[option]?.enabled,
            hasLength(1),
          );
          expect(
            options.union.optionsConfig[option]?.enabled.first,
            equals(enabledPath),
          );

          expect(
            options.union.optionsConfig[option]?.disabled,
            hasLength(1),
          );
          expect(
            options.union.optionsConfig[option]?.disabled.first,
            equals(disabledPath),
          );
        }
      });
    });
  });
}
