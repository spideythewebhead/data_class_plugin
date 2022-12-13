// AUTO GENERATED - DO NOT MODIFY

part of 'parsed_file_data.dart';

class _$ParsedFileDataImpl extends ParsedFileData {
  _$ParsedFileDataImpl({
    required this.compilationUnit,
    required this.lastModifiedAt,
  }) : super._();

  @override
  final CompilationUnit compilationUnit;

  @override
  final DateTime lastModifiedAt;

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is ParsedFileData &&
            runtimeType == other.runtimeType &&
            compilationUnit == other.compilationUnit &&
            lastModifiedAt == other.lastModifiedAt;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      compilationUnit,
      lastModifiedAt,
    ]);
  }

  @override
  String toString() {
    String value = 'ParsedFileData{<optimized out>}';
    assert(() {
      value =
          'ParsedFileData@<$hexIdentity>{compilationUnit: $compilationUnit, lastModifiedAt: $lastModifiedAt}';
      return true;
    }());
    return value;
  }
}
