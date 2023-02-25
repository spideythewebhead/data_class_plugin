@Union(
  hashAndEquals: false,
  $toString: false,
  fromJson: true,
  toJson: false,
)
abstract class Response {
  const Response._();

  /// Creates an instance of [Response] from [json]
  factory Response.fromJson(Map<dynamic, dynamic> json) {
    throw UnimplementedError();
  }

  const factory Response.ok({
    required int data,
  }) = ResponseOk;

  const factory Response.unauthorized() = ResponseUnauthorized;

  const factory Response.error({
    required Object type,
    @JsonKey(ignore: true) StackTrace? stackTrace,
  }) = ResponseError;

  /// Executes one of the provided callbacks based on a type match
  R when<R>({
    required R Function(ResponseOk value) ok,
    required R Function() unauthorized,
    required R Function(ResponseError value) error,
  }) {
    if (this is ResponseOk) {
      return ok(this as ResponseOk);
    }
    if (this is ResponseUnauthorized) {
      return unauthorized();
    }
    if (this is ResponseError) {
      return error(this as ResponseError);
    }
    throw UnimplementedError('Unknown instance of $this used in when(..)');
  }

  /// Executes one of the provided callbacks if a type is matched
  ///
  /// If no match is found [orElse] is executed
  R maybeWhen<R>({
    R Function(ResponseOk value)? ok,
    R Function()? unauthorized,
    R Function(ResponseError value)? error,
    required R Function() orElse,
  }) {
    if (this is ResponseOk) {
      return ok?.call(this as ResponseOk) ?? orElse();
    }
    if (this is ResponseUnauthorized) {
      return unauthorized?.call() ?? orElse();
    }
    if (this is ResponseError) {
      return error?.call(this as ResponseError) ?? orElse();
    }
    throw UnimplementedError('Unknown instance of $this used in maybeWhen(..)');
  }
}

class ResponseOk extends Response {
  const ResponseOk({
    required this.data,
  }) : super._();

  final int data;

  /// Creates an instance of [ResponseOk] from [json]
  factory ResponseOk.fromJson(Map<dynamic, dynamic> json) {
    return ResponseOk(
      data: json['data'] as int,
    );
  }
}

class ResponseUnauthorized extends Response {
  const ResponseUnauthorized() : super._();

  /// Creates an instance of [ResponseUnauthorized] from [json]
  factory ResponseUnauthorized.fromJson(Map<dynamic, dynamic> json) {
    return const ResponseUnauthorized();
  }
}

class ResponseError extends Response {
  const ResponseError({
    required this.type,
    this.stackTrace,
  }) : super._();

  final Object type;
  final StackTrace? stackTrace;

  /// Creates an instance of [ResponseError] from [json]
  factory ResponseError.fromJson(Map<dynamic, dynamic> json) {
    return ResponseError(
      type: jsonConverterRegistrant.find(Object).fromJson(json['type'], json, 'type') as Object,
    );
  }
}
