import 'package:data_class_plugin/data_class_plugin.dart';

@Union(
  dataClass: false,
  fromJson: true,
  toJson: false,
)
abstract class Response {
  const Response._();

  const factory Response.ok({
    required int data,
  }) = Ok;

  const factory Response.unauthorized() = Unauthorized;

  const factory Response.error({
    required Object type,
    @JsonKey(ignore: true) StackTrace? stackTrace,
  }) = Error;

  /// Executes one of the provided callbacks based on a type match
  R when<R>({
    required R Function(Ok value) ok,
    required R Function(Unauthorized value) unauthorized,
    required R Function(Error value) error,
  }) {
    if (this is Ok) {
      return ok(this as Ok);
    }
    if (this is Unauthorized) {
      return unauthorized(this as Unauthorized);
    }
    if (this is Error) {
      return error(this as Error);
    }
    throw UnimplementedError('Unknown instance of $this used in when(..)');
  }

  /// Executes one of the provided callbacks if a type is matched
  ///
  /// If no match is found [orElse] is executed
  R maybeWhen<R>({
    R Function(Ok value)? ok,
    R Function(Unauthorized value)? unauthorized,
    R Function(Error value)? error,
    required R Function() orElse,
  }) {
    if (this is Ok) {
      return ok?.call(this as Ok) ?? orElse();
    }
    if (this is Unauthorized) {
      return unauthorized?.call(this as Unauthorized) ?? orElse();
    }
    if (this is Error) {
      return error?.call(this as Error) ?? orElse();
    }
    throw UnimplementedError('Unknown instance of $this used in maybeWhen(..)');
  }

  /// Creates an instance of [Response] from [json]
  Response fromJson(Map<String, dynamic> json) {
// TODO: Implement
    throw UnimplementedError();
  }
}

class Ok extends Response {
  const Ok({
    required this.data,
  }) : super._();

  final int data;

  /// Creates an instance of [Ok] from [json]
  factory Ok.fromJson(Map<String, dynamic> json) {
    return Ok(
      data: json['data'] as int,
    );
  }
}

class Unauthorized extends Response {
  const Unauthorized() : super._();

  /// Creates an instance of [Unauthorized] from [json]
  factory Unauthorized.fromJson(Map<String, dynamic> json) {
    return Unauthorized();
  }
}

class Error extends Response {
  const Error({
    required this.type,
    this.stackTrace,
  }) : super._();

  final Object type;
  final StackTrace? stackTrace;

  /// Creates an instance of [Error] from [json]
  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      type: jsonConverterRegistrant.find(Object).fromJson(json['type']) as Object,
    );
  }
}
