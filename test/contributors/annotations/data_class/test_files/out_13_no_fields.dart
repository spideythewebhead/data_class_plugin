@DataClass(
  fromJson: true,
  copyWith: true,
  hashAndEquals: false,
  toJson: false,
  $toString: false,
)
class User {
  /// Shorthand constructor
  User();

  /// Creates a new instance of [User] with optional new values
  User copyWith() {
    return User();
  }

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User();
  }
}
