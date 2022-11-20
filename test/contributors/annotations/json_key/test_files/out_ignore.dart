@DataClass(
  fromJson: true,
  toJson: true,
  copyWith: false,
  hashAndEquals: false,
  $toString: false,
)
class User {
  /// Shorthand constructor
  User({
    required this.id,
    this.ignoredField,
  });

  final String id;

  @JsonKey(ignore: true)
  final String? ignoredField;

  /// Converts [User] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
    };
  }

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      id: json['id'] as String,
    );
  }
}
