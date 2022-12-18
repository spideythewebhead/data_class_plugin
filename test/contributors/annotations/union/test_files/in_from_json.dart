import 'package:data_class_plugin/data_class_plugin.dart';

@Union(
  hashAndEquals: false,
  $toString: false,
  fromJson: true,
  toJson: false,
)
class Response {
  const factory Response.ok({
    required int data,
  }) = ResponseOk;

  const factory Response.unauthorized() = ResponseUnauthorized;

  const factory Response.error({
    required Object type,
    @JsonKey(ignore: true) StackTrace? stackTrace,
  }) = ResponseError;
}
