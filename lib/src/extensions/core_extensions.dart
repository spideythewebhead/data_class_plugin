import 'dart:io' as io show File;

import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:data_class_plugin/src/contributors/class/utils.dart' as utils;
import 'package:data_class_plugin/src/options/data_class_plugin_options.dart';

extension DartTypeX on DartType {
  bool get isNullable {
    return nullabilitySuffix != NullabilitySuffix.none;
  }

  bool get isPrimary {
    return isDartCoreString ||
        isDartCoreBool ||
        isDartCoreDouble ||
        isDartCoreInt ||
        isDartCoreNum ||
        isDartCoreNull;
  }

  bool get isDateTime {
    return element!.name == 'DateTime';
  }

  bool get isUri {
    return element!.name == 'Uri';
  }

  bool get isJsonSupported {
    return isPrimary ||
        isDateTime ||
        isDartCoreMap ||
        isDartCoreList ||
        isDartCoreEnum ||
        !isDartCoreFunction ||
        alias == null;
  }

  String typeStringValue() {
    final StringBuffer buffer = StringBuffer();

    void visit(DartType type) {
      if (type is InterfaceType && type.typeArguments.isNotEmpty) {
        buffer
          ..write(type.element.name)
          ..write('<');

        for (int i = 0; i < type.typeArguments.length; i += 1) {
          final DartType typeArg = type.typeArguments[i];
          visit(typeArg);
          if (1 + i != type.typeArguments.length) {
            buffer.write(', ');
          }
        }

        buffer.write('>');

        if (type.isNullable) {
          buffer.write('?');
        }
        return;
      }

      buffer.write(type.element!.name);
      if (type.isNullable) {
        buffer.write('?');
      }
    }

    visit(this);
    return buffer.toString();
  }
}

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
  Future<DataClassPluginOptions> getOptions() async {
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
