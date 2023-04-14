import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'simple.gen.dart';

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

@Union(
  toJson: true,
  // when generating a fromJson factory for unions
  // the unionJsonKey is required
  // this field specific which key to use to select a factory constructor
  // in addition you can use `unionFallbackJsonValue` to specify a default constructor if there is no match
  unionJsonKey: 'code',
  unionFallbackJsonValue: 'error',
)
sealed class GetPostsResponse {
  const GetPostsResponse._();

  // You can use @UnionJsonKeyValue(key) to specific a custom value for the constructor to match
  // Also you can specify multiple @UnionJsonKeyValue(key) annotation to have multiple matches
  // E.g.
  // @UnionJsonKeyValue('error')
  // @UnionJsonKeyValue('ERROR')
  // @UnionJsonKeyValue('__error__')
  // will use the error constructor to parse the content
  factory GetPostsResponse.error() = GetPostsResponseError;

  factory GetPostsResponse.ok(List<Post> posts) = GetPostsResponseOk;

  /// Converts [GetPostsResponse] to [Map] json
  Map<String, dynamic> toJson();
}

void main() {
  prettyPrint(
    'GetPostsResponse.ok toJson',
    GetPostsResponse.ok(<Post>[
      Post(id: '1', title: 'title1'),
      Post(id: '2', title: 'title2'),
    ]).toJson(),
  );
}
