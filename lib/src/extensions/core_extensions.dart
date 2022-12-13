import 'dart:async';
import 'dart:core';
import 'dart:io' as io show File;

import 'package:analyzer/dart/ast/ast.dart';
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

  T? lastWhereOrNull(bool Function(T element) test) {
    try {
      return lastWhere(test);
    } catch (_) {
      return null;
    }
  }

  T? get lastOrNull => isEmpty ? null : last;
}

extension FolderX on Folder {
  Future<DataClassPluginOptions> getPluginOptions() async {
    return await DataClassPluginOptions.fromFile((io.File(
      utils.getDataClassPluginOptionsPath(path),
    )));
  }
}

extension DateTimeX on DateTime {
  Duration getElapsedDuration() {
    return DateTime.now().difference(this);
  }
}

extension CompleterX<T> on Completer<T> {
  void safeComplete([T? value]) {
    if (!isCompleted) {
      complete(value);
    }
  }
}

extension ListClassMemberX on List<ClassMember> {
  bool hasFactory(String factoryName) {
    return null !=
        firstWhereOrNull((ClassMember member) {
          return member is ConstructorDeclaration &&
              member.factoryKeyword != null &&
              member.name?.lexeme == factoryName;
        });
  }
}
