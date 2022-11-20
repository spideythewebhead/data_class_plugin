@DataClass(
  fromJson: true,
  copyWith: true,
  hashAndEquals: false,
  toJson: false,
  $toString: false,
)
class User {
  /// Shorthand constructor
  const User();

  /// Creates a new instance of [User] with optional new values
  User copyWith() {
    // ignore: prefer_const_constructors
    return User();
  }

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<dynamic, dynamic> json) {
    return const User();
  }
}
