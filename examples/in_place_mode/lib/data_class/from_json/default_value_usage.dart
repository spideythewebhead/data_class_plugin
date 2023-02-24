import 'package:data_class_plugin/data_class_plugin.dart';

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
  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      friends: json['friends'] == null
          ? const <String, User>{}
          : <String, User>{
              for (final MapEntry<dynamic, dynamic> e0
                  in (json['friends'] as Map<dynamic, dynamic>).entries)
                e0.key: User.fromJson(e0.value),
            },
    );
  }
}
