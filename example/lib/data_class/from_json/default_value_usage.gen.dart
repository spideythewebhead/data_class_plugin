// AUTO GENERATED - DO NOT MODIFY

part of 'default_value_usage.dart';

class _$UserImpl extends User {
  _$UserImpl({
    this.friends = const <String, User>{},
  }) : super._();

  @override
  final Map<String, User> friends;

  factory _$UserImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$UserImpl(
      friends: json['friends'] == null
          ? const <String, User>{}
          : Map<String, User>.unmodifiable(<String, User>{
              for (final MapEntry<dynamic, dynamic> e0
                  in (json['friends'] as Map<dynamic, dynamic>).entries)
                e0.key: User.fromJson(e0.value),
            }),
    );
  }
}
