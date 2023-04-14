// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// coverage:ignore-file

part of 'copy_with.dart';

class _$UserImpl extends User {
  _$UserImpl({
    required this.id,
    required this.username,
    this.email,
    required this.isVerified,
  }) : super.ctor();

  @override
  final int id;

  @override
  final String username;

  @override
  final String? email;

  @override
  final bool isVerified;

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is User &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            username == other.username &&
            email == other.email &&
            isVerified == other.isVerified;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      username,
      email,
      isVerified,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'User{<optimized out>}';
    assert(() {
      toStringOutput =
          'User@<$hexIdentity>{id: $id, username: $username, email: $email, isVerified: $isVerified}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => User;
}

class _$UserCopyWithProxy {
  _$UserCopyWithProxy(this._value);

  final User _value;

  @pragma('vm:prefer-inline')
  User id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  User username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
  User email(String? newValue) => this(email: newValue);

  @pragma('vm:prefer-inline')
  User isVerified(bool newValue) => this(isVerified: newValue);

  @pragma('vm:prefer-inline')
  User call({
    final int? id,
    final String? username,
    final Object? email = const Object(),
    final bool? isVerified,
  }) {
    return _$UserImpl(
      id: id ?? _value.id,
      username: username ?? _value.username,
      email: identical(email, const Object()) ? _value.email : (email as String?),
      isVerified: isVerified ?? _value.isVerified,
    );
  }
}

class $UserCopyWithProxyChain<$Result> {
  $UserCopyWithProxyChain(this._value, this._chain);

  final User _value;
  final $Result Function(User update) _chain;

  @pragma('vm:prefer-inline')
  $Result id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  $Result username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
  $Result email(String? newValue) => this(email: newValue);

  @pragma('vm:prefer-inline')
  $Result isVerified(bool newValue) => this(isVerified: newValue);

  @pragma('vm:prefer-inline')
  $Result call({
    final int? id,
    final String? username,
    final Object? email = const Object(),
    final bool? isVerified,
  }) {
    return _chain(_$UserImpl(
      id: id ?? _value.id,
      username: username ?? _value.username,
      email: identical(email, const Object()) ? _value.email : (email as String?),
      isVerified: isVerified ?? _value.isVerified,
    ));
  }
}

extension $UserExtension on User {
  _$UserCopyWithProxy get copyWith => _$UserCopyWithProxy(this);
}

class _$CompanyImpl extends Company {
  _$CompanyImpl({
    required this.id,
    required this.ceo,
  }) : super.ctor();

  @override
  final String id;

  @override
  final User ceo;

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is Company && runtimeType == other.runtimeType && id == other.id && ceo == other.ceo;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      ceo,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'Company{<optimized out>}';
    assert(() {
      toStringOutput = 'Company@<$hexIdentity>{id: $id, ceo: $ceo}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => Company;
}

class _$CompanyCopyWithProxy {
  _$CompanyCopyWithProxy(this._value);

  final Company _value;

  @pragma('vm:prefer-inline')
  Company id(String newValue) => this(id: newValue);
  @pragma('vm:prefer-inline')
  $UserCopyWithProxyChain<Company> get ceo =>
      $UserCopyWithProxyChain<Company>(_value.ceo, (User update) => this(ceo: update));

  @pragma('vm:prefer-inline')
  Company call({
    final String? id,
    final User? ceo,
  }) {
    return _$CompanyImpl(
      id: id ?? _value.id,
      ceo: ceo ?? _value.ceo,
    );
  }
}

class $CompanyCopyWithProxyChain<$Result> {
  $CompanyCopyWithProxyChain(this._value, this._chain);

  final Company _value;
  final $Result Function(Company update) _chain;

  @pragma('vm:prefer-inline')
  $Result id(String newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  $Result ceo(User newValue) => this(ceo: newValue);

  @pragma('vm:prefer-inline')
  $Result call({
    final String? id,
    final User? ceo,
  }) {
    return _chain(_$CompanyImpl(
      id: id ?? _value.id,
      ceo: ceo ?? _value.ceo,
    ));
  }
}

extension $CompanyExtension on Company {
  _$CompanyCopyWithProxy get copyWith => _$CompanyCopyWithProxy(this);
}
