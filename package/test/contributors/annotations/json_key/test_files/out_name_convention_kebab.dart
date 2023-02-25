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
    required this.thisIsATestVariable,
  });

  @JsonKey<String>(nameConvention: JsonKeyNameConvention.kebabCase)
  final String thisIsATestVariable;

  /// Converts [User] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'this-is-a-test-variable': thisIsATestVariable,
    };
  }

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      thisIsATestVariable: json['this-is-a-test-variable'] as String,
    );
  }
}
