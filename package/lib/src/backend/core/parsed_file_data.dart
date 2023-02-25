import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/data_class_plugin.dart';

part 'parsed_file_data.gen.dart';

@DataClass(copyWith: false)
abstract class ParsedFileData {
  ParsedFileData.ctor();

  /// Default constructor
  factory ParsedFileData({
    required String absolutePath,
    required CompilationUnit compilationUnit,
    required DateTime lastModifiedAt,
  }) = _$ParsedFileDataImpl;

  String get absolutePath;
  CompilationUnit get compilationUnit;
  DateTime get lastModifiedAt;
}
