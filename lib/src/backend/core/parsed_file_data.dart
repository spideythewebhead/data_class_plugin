import 'package:analyzer/dart/ast/ast.dart';
import 'package:data_class_plugin/data_class_plugin.dart';

part 'parsed_file_data.gen.dart';

@DataClass(copyWith: false)
abstract class ParsedFileData {
  ParsedFileData._();

  /// Default constructor
  factory ParsedFileData({
    required CompilationUnit compilationUnit,
    required DateTime lastModifiedAt,
  }) = _$ParsedFileDataImpl;

  CompilationUnit get compilationUnit;
  DateTime get lastModifiedAt;

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode;

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object? other);

  @override
  String toString();
}
