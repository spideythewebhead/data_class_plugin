@DataClass(
  toJson: true,
  fromJson: false,
  copyWith: false,
  hashAndEquals: false,
  $toString: false,
)
class User {
  /// Shorthand constructor
  User({
    required this.id,
    required this.username,
  });

  @JsonKey<String>(toJson: _toIdMapper)
  final String id;
  final String username;

  static String _toIdMapper(dynamic id) {
    return '__${id}__';
  }

  /// Converts [User] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': User._toIdMapper(id),
      'username': username,
    };
  }
}
