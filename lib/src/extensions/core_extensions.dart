import 'dart:core';
import 'dart:io' as io show File;

import 'package:analyzer/file_system/file_system.dart';
import 'package:data_class_plugin/src/contributors/class/utils.dart' as utils;
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';

extension IterableX<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }

  T? get firstOrNull => isEmpty ? null : elementAt(0);
}

extension FolderX on Folder {
  Future<DataClassPluginOptions> getPluginOptions() async {
    return await DataClassPluginOptions.fromFile((io.File(
      utils.getDataClassPluginOptionsPath(path),
    )));
  }
}