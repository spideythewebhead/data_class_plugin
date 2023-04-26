import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'json_key.gen.dart';

@DataClass(
  fromJson: true,
)
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

@Union(unionJsonKey: 'code')
abstract class GetPostsResponse {
  const GetPostsResponse._();

  /// Creates an instance of [GetPostsResponse] from [json]
  factory GetPostsResponse.fromJson(Map<dynamic, dynamic> json) => _$GetPostsResponseFromJson(json);

  factory GetPostsResponse.error() = GetPostsResponseError;

  factory GetPostsResponse.ok(
    @JsonKey(name: 'posts_array') List<Post> posts,
    @JsonKey(nameConvention: JsonKeyNameConvention.kebabCase) String authorName,
  ) = GetPostsResponseOk;
}

void main() {
  final GetPostsResponse getPostsResponse = GetPostsResponse.fromJson(<String, dynamic>{
    'code': 'ok',
    'posts_array': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': '1',
        'title': 'Post1',
      },
      <String, dynamic>{
        'id': '2',
        'title': 'Post2',
      }
    ],
    'author-name': 'authorName'
  });

  prettyPrint('GetPostsResponse with code "ok"', getPostsResponse);
}
