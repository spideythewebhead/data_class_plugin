import 'package:data_class_plugin/data_class_plugin.dart';

part 'exceptions.gen.dart';

@Union()
abstract class DcpException implements Exception {
  const DcpException._();

  const factory DcpException.pubspecYamlNotFound() = DcpExceptionPubspecYamlNotFound;

  const factory DcpException.requiresFileGenerationMode() = DcpExceptionRequiresFileGenerationMode;

  const factory DcpException.dartToolFolderNotFound() = DcpExceptionDartToolFolderNotFound;

  factory DcpException.packageNotFound({
    required String packageName,
  }) = DcpExceptionPackageNotFound;

  const factory DcpException.missingDataClassPluginImport({
    required String relativeFilePath,
  }) = DcpExceptionMissingDataClassPluginImport;
}
