import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'json_key.gen.dart';

@DataClass(toJson: true)
abstract class Post {
  Post.ctor();

  /// Default constructor
  factory Post({
    required String id,
    required String title,
  }) = _$PostImpl;

  String get id;
  String get title;

  /// Converts [Post] to a [Map] json
  Map<String, dynamic> toJson();
}

@Union()
sealed class GetPostsResponse {
  const GetPostsResponse._();

  factory GetPostsResponse.error() = GetPostsResponseError;

  factory GetPostsResponse.ok(
    @JsonKey(name: 'posts_array') List<Post> posts, {
    @JsonKey(nameConvention: JsonKeyNameConvention.kebabCase) required String authorName,
  }) = GetPostsResponseOk;

  /// Converts [GetPostsResponse] to [Map] json
  Map<String, dynamic> toJson();
}

void main() {
  prettyPrint(
    'GetPostsResponse.ok toJson',
    GetPostsResponse.ok(
      <Post>[
        Post(id: '1', title: 'title1'),
        Post(id: '2', title: 'title2'),
      ],
      authorName: 'author',
    ).toJson(),
  );
}
