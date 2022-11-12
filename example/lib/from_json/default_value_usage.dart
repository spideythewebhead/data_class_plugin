import 'package:data_class_plugin/public/annotations.dart';

@DataClass(
  fromJson: true,
  toJson: false,
  copyWith: false,
  hashAndEquals: false,
  $toString: false,
)
class User {
  /// Shorthand constructor
  User({
    this.friends = const <String, User>{},
  });

  final Map<String, User> friends;

  /// Creates an instance of [User] from [json]
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      friends: json['friends'] == null
          ? const <String, User>{}
          : <String, User>{
              for (final MapEntry<String, dynamic> e0
                  in (json['friends'] as Map<String, dynamic>).entries)
                e0.key: User.fromJson(e0.value),
            },
    );
  }
}
