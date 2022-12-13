import 'dart:io';

import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('JsonOptions', () {
    const DataClassPluginOptions options = DataClassPluginOptions();

    test('provides correct default value', () {
      expect(options.json, equals(const JsonOptions()));
    });

    group('options from file', () {
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
  });
}
