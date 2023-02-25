import 'dart:collection';

import 'package:data_class_plugin/src/backend/core/parsed_file_data.dart';

class ParsedFilesRegistry with MapMixin<String, ParsedFileData> {
  final Map<String, ParsedFileData> _registry = <String, ParsedFileData>{};

  @override
  Iterable<String> get keys => _registry.keys;

  @override
  ParsedFileData? operator [](Object? key) => _registry[key];

  @override
  void operator []=(String key, ParsedFileData value) => _registry[key] = value;

  @override
  ParsedFileData? remove(Object? key) => _registry.remove(key);

  @override
  void clear() {
    _registry.clear();
  }
}
