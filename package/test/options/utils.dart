import 'dart:io';
import 'package:file/memory.dart';

final MemoryFileSystem memoryFs = MemoryFileSystem.test();

File getFileWithContent(String content) =>
    memoryFs.file('/data_class_plugin_options.yaml')..writeAsString(content);
