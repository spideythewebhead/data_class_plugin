import 'dart:convert';
import 'dart:io';

import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:data_class_plugin/src/exceptions.dart';
import 'package:data_class_plugin/src/extensions/extensions.dart';
import 'package:path/path.dart' as path;

part 'find_package_path_by_import.gen.dart';

const String _dartPrefix = 'dart:';
const String _packagePrefix = 'package:';

Future<String?> findDartFileFromUri({
  required String projectDirectoryPath,
  required String currentDirectoryPath,
  required String uri,
}) async {
  if (uri.startsWith(_dartPrefix)) {
    return null;
  }

  if (!uri.startsWith(_packagePrefix)) {
    return path.normalize(path.join(
      currentDirectoryPath,
      uri.toString(),
    ));
  }

  final List<PackageInfo> packages = <PackageInfo>[];

  final File packageConfigFile =
      File(path.join(projectDirectoryPath, '.dart_tool', 'package_config.json'));

  if (!await packageConfigFile.exists()) {
    throw const DcpException.dartToolFolderNotFound();
  }

  final Map<dynamic, dynamic> packageConfigJson =
      await packageConfigFile.readAsString().then((String value) => jsonDecode(value));

  packages.addAll(<PackageInfo>[
    for (final Map<dynamic, dynamic> packageJson in packageConfigJson['packages'])
      PackageInfo.fromJson(packageJson)
  ]);

  final String packageName = uri.substring(_packagePrefix.length, uri.indexOf('/'));
  final PackageInfo? targetPackage =
      packages.firstWhereOrNull((PackageInfo package) => package.name == packageName);

  if (targetPackage == null) {
    throw DcpException.packageNotFound(packageName: packageName);
  }

  return path.join(
    path.isRelative(targetPackage.rootUri.path) ? projectDirectoryPath : targetPackage.rootUri.path,
    path.normalize(targetPackage.packageUri.path),
    // uri format = package:package_name/path/to/file.dart
    // we need to extract the 'path/to/file.dart'
    uri.substring(1 + uri.indexOf('/')),
  );
}

@DataClass(
  fromJson: true,
  $toString: false,
  copyWith: false,
  hashAndEquals: false,
)
abstract class PackageInfo {
  PackageInfo.ctor();

  /// Default constructor
  factory PackageInfo({
    required String name,
    required Uri rootUri,
    required Uri packageUri,
    required String languageVersion,
  }) = _$PackageInfoImpl;

  String get name;
  Uri get rootUri;
  Uri get packageUri;
  String get languageVersion;

  /// Creates an instance of [PackageInfo] from [json]
  factory PackageInfo.fromJson(Map<dynamic, dynamic> json) = _$PackageInfoImpl.fromJson;
}
