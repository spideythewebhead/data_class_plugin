import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'simple.gen.dart';

@DataClass(fromJson: true)
abstract class Post {
  Post.ctor();

  /// Default constructor
  factory Post({
    required String id,
    required String title,
  }) = _$PostImpl;

  /// Creates an instance of [Post] from [json]
  factory Post.fromJson(Map<dynamic, dynamic> json) = _$PostImpl.fromJson;

  String get id;
  String get title;
}

@Union(
  fromJson: true,
  // when generating a fromJson factory for unions
  // the unionJsonKey is required
  // this field specific which key to use to select a factory constructor
  // in addition you can use `unionFallbackJsonValue` to specify a default constructor if there is no match
  unionJsonKey: 'code',
  unionFallbackJsonValue: 'error',
)
sealed class GetPostsResponse {
  const GetPostsResponse._();

  /// Creates an instance of [GetPostsResponse] from [json]
  factory GetPostsResponse.fromJson(Map<dynamic, dynamic> json) => _$GetPostsResponseFromJson(json);

  // You can use @UnionJsonKeyValue(key) to specific a custom value for the constructor to match
  // Also you can specify multiple @UnionJsonKeyValue(key) annotation to have multiple matches
  // E.g.
  // @UnionJsonKeyValue('error')
  // @UnionJsonKeyValue('ERROR')
  // @UnionJsonKeyValue('__error__')
  // will use the error constructor to parse the content
  factory GetPostsResponse.error() = GetPostsResponseError;

  factory GetPostsResponse.ok(List<Post> posts) = GetPostsResponseOk;
}

void main() {
  final GetPostsResponse getPostsResponse = GetPostsResponse.fromJson(<String, dynamic>{
    'code': 'ok',
    'posts': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': '1',
        'title': 'Post1',
      },
      <String, dynamic>{
        'id': '2',
        'title': 'Post2',
      }
    ]
  });

  prettyPrint('GetPostsResponse with code "ok"', getPostsResponse);

  prettyPrint(
    'GetPostsResponse with code "error"',
    GetPostsResponse.fromJson(<String, dynamic>{'code': 'error'}),
  );

  prettyPrint(
    'GetPostsResponse with code "unknown"',
    GetPostsResponse.fromJson(<String, dynamic>{'code': 'unknown'}),
  );
}
