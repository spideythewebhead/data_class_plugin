import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:test/test.dart';

class UserJsonConverter implements JsonConverter<User, Map<String, dynamic>> {
  const UserJsonConverter();

  @override
  User fromJson(Map<String, dynamic> value, Map<dynamic, dynamic> json, String keyName) {
    return User(
      id: value['id'] as String,
      username: value['username'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson(User user) {
    return <String, dynamic>{
      'id': user.id,
      'username': user.username,
    };
  }
}

void main() {
  jsonConverterRegistrant.register(const UserJsonConverter());

  const User user1 = User(
    id: 'test_user_1',
    username: 'MockUser1',
  );
  const User user2 = User(
    id: 'test_user_2',
    username: 'MockUser2',
  );

  final UserResponse response = UserResponse(users: <User>[
    user1,
    user2,
  ]);

  final Map<String, dynamic> json = <String, dynamic>{
    'users': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 'test_user_1',
        'username': 'MockUser1',
      },
      <String, dynamic>{
        'id': 'test_user_2',
        'username': 'MockUser2',
      },
    ]
  };

  test('fromJson', () {
    expect(response.toJson(), equals(json));
  });

  test('toJson', () {
    expect(UserResponse.fromJson(json), equals(response));
  });
}

@DataClass(
  fromJson: true,
  toJson: true,
  copyWith: false,
  $toString: false,
)
class UserResponse {
  /// Shorthand constructor
  UserResponse({
    required this.users,
  });

  final List<User> users;

  /// Converts [UserResponse] to a [Map] json
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'users': <dynamic>[
        for (final User i0 in users) jsonConverterRegistrant.find(User).toJson(i0),
      ],
    };
  }

  /// Creates an instance of [UserResponse] from [json]
  factory UserResponse.fromJson(Map<dynamic, dynamic> json) {
    return UserResponse(
      users: <User>[
        for (final dynamic i0 in (json['users'] as List<dynamic>))
          jsonConverterRegistrant.find(User).fromJson(i0, json, 'users') as User,
      ],
    );
  }

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      users,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is UserResponse && deepEquality(users, other.users);
  }
}

@DataClass(
  copyWith: false,
  $toString: false,
)
class User {
  /// Shorthand constructor
  const User({
    required this.id,
    required this.username,
  });

  final String id;
  final String username;

  /// Returns a hash code based on [this] properties
  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      username,
    ]);
  }

  /// Compares [this] with [other] on identity, class type, and properties
  /// *with deep comparison on collections*
  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is User && id == other.id && username == other.username;
  }
}
