import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'shared_fields.gen.dart';

@Union()
sealed class HttpResponse<T> {
  const HttpResponse._();

  factory HttpResponse.ok({
    required int statusCode,
    required T data,
  }) = HttpResponseOk<T>;

  factory HttpResponse.badRequest({
    required int statusCode,
    String? message,
  }) = HttpResponseBadRequest<T>;

  int get statusCode;
}

void main(List<String> args) {
  final HttpResponse<String> httpResponse =
      HttpResponse<String>.ok(statusCode: 200, data: 'response data');

  prettyPrint('HttpResponse statusCode shared field', httpResponse.statusCode);
}
