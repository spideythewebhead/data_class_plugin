// AUTO GENERATED - DO NOT MODIFY

part of 'find_package_path_by_import.dart';

class _$NoDartToolDirectoryFoundExceptionImpl extends NoDartToolDirectoryFoundException {
  const _$NoDartToolDirectoryFoundExceptionImpl() : super.ctor();

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is NoDartToolDirectoryFoundException && runtimeType == other.runtimeType;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'NoDartToolDirectoryFoundException{<optimized out>}';
    assert(() {
      toStringOutput = 'NoDartToolDirectoryFoundException@<$hexIdentity>{}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => NoDartToolDirectoryFoundException;
}

class _$PackageNotInstalledExceptionImpl extends PackageNotInstalledException {
  _$PackageNotInstalledExceptionImpl({
    required this.packageName,
  }) : super.ctor();

  @override
  final String packageName;

  @override
  String toString() {
    String toStringOutput = 'PackageNotInstalledException{<optimized out>}';
    assert(() {
      toStringOutput = 'PackageNotInstalledException@<$hexIdentity>{packageName: $packageName}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => PackageNotInstalledException;
}

class _$PackageInfoImpl extends PackageInfo {
  _$PackageInfoImpl({
    required this.name,
    required this.rootUri,
    required this.packageUri,
    required this.languageVersion,
  }) : super.ctor();

  @override
  final String name;

  @override
  final Uri rootUri;

  @override
  final Uri packageUri;

  @override
  final String languageVersion;

  factory _$PackageInfoImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$PackageInfoImpl(
      name: json['name'] as String,
      rootUri: jsonConverterRegistrant.find(Uri).fromJson(json['rootUri'], json, 'rootUri') as Uri,
      packageUri:
          jsonConverterRegistrant.find(Uri).fromJson(json['packageUri'], json, 'packageUri') as Uri,
      languageVersion: json['languageVersion'] as String,
    );
  }

  @override
  String toString() {
    String toStringOutput = 'PackageInfo{<optimized out>}';
    assert(() {
      toStringOutput =
          'PackageInfo@<$hexIdentity>{name: $name, rootUri: $rootUri, packageUri: $packageUri, languageVersion: $languageVersion}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => PackageInfo;
}
