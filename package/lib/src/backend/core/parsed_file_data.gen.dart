// AUTO GENERATED - DO NOT MODIFY

part of 'parsed_file_data.dart';

class _$ParsedFileDataImpl extends ParsedFileData {
  _$ParsedFileDataImpl({
    required this.absolutePath,
    required this.compilationUnit,
    required this.lastModifiedAt,
  }) : super.ctor();

  @override
  final String absolutePath;

  @override
  final CompilationUnit compilationUnit;

  @override
  final DateTime lastModifiedAt;

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is ParsedFileData &&
            runtimeType == other.runtimeType &&
            absolutePath == other.absolutePath &&
            compilationUnit == other.compilationUnit &&
            lastModifiedAt == other.lastModifiedAt;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      absolutePath,
      compilationUnit,
      lastModifiedAt,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'ParsedFileData{<optimized out>}';
    assert(() {
      toStringOutput =
          'ParsedFileData@<$hexIdentity>{absolutePath: $absolutePath, compilationUnit: $compilationUnit, lastModifiedAt: $lastModifiedAt}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => ParsedFileData;
}
