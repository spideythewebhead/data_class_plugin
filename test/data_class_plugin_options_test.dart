import 'package:data_class_plugin/src/data_class_plugin_options.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:test/test.dart';

final MemoryFileSystem memoryFs = MemoryFileSystem.test();

File getFileWithContent(String content) =>
    memoryFs.file('/data_class_plugin_options.dart')..writeAsString(content);

void main() {
  test('provides correct default value', () {
    const DataClassPluginOptions options = DataClassPluginOptions();

    expect(options.json, equals(const JsonOptions()));
    expect(options.dataClass, equals(const DataClassOptions()));
    expect(options.dataClass.effectiveCopyWith(''), equals(true));
    expect(options.dataClass.effectiveHashAndEquals(''), equals(true));
    expect(options.dataClass.effectiveToString(''), equals(true));
    expect(options.dataClass.effectiveFromJson(''), equals(false));
    expect(options.dataClass.effectiveToJson(''), equals(false));
  });

  group('options from file', () {
    group('json', () {
      test('key_name_convention', () async {
        final File file = getFileWithContent('''
json:
  key_name_convention: snake_case
''');

        final DataClassPluginOptions options = await DataClassPluginOptions.fromFile(file);
        expect(options.json.keyNameConvention, equals('snake_case'));
      });

      test('key_name_conventions', () async {
        final File file = getFileWithContent('''
json:
  key_name_conventions:
    snake_case:
      - "/a"
    pascal_case:
      - /a/**
    kebab_case:
      - /a/*
      - /b/c/**
''');

        final DataClassPluginOptions options = await DataClassPluginOptions.fromFile(file);
        expect(options.json.nameConventionGlobs['camel_case'], isNull);
        expect(options.json.nameConventionGlobs['snake_case'], hasLength(1));
        expect(options.json.nameConventionGlobs['pascal_case'], hasLength(1));
        expect(options.json.nameConventionGlobs['kebab_case'], hasLength(2));
      });
    });

    group('data_class', () {
      test('default options', () async {
        final File file = getFileWithContent('''
data_class:
  options_config:
    copy_with:
      default: true
    hash_and_equals:
      default: false
    to_string: 
      default: false
    from_json:
      default: true
    to_json:
      default: false
''');

        final DataClassPluginOptions options = await DataClassPluginOptions.fromFile(file);

        expect(options.dataClass.optionsConfig['copy_with']?.defaultValue, equals(true));
        expect(options.dataClass.optionsConfig['hash_and_equals']?.defaultValue, equals(false));
        expect(options.dataClass.optionsConfig['to_string']?.defaultValue, equals(false));
        expect(options.dataClass.optionsConfig['from_json']?.defaultValue, equals(true));
        expect(options.dataClass.optionsConfig['to_json']?.defaultValue, equals(false));
      });

      test('default options', () async {
        final File file = getFileWithContent('''
data_class:
  options_config:
    copy_with:
      enabled:
        - a/b/c
    hash_and_equals:
      disabled:
        - a/b/c
''');

        final DataClassPluginOptions options = await DataClassPluginOptions.fromFile(file);

        expect(options.dataClass.optionsConfig['copy_with']?.enabled.first, equals('a/b/c'));
        expect(options.dataClass.optionsConfig['hash_and_equals']?.disabled.first, equals('a/b/c'));
      });
    });
  });
}
