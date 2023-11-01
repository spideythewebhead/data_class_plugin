// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
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

abstract interface class _UserCopyWithProxy {
  User id(int newValue);

  User username(String newValue);

  User email(String? newValue);

  User isVerified(bool newValue);

  User call({
    final int? id,
    final String? username,
    final String? email,
    final bool? isVerified,
  });
}

class _UserCopyWithProxyImpl implements _UserCopyWithProxy {
  _UserCopyWithProxyImpl(this._value);

  final User _value;

  @pragma('vm:prefer-inline')
  @override
  User id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  @override
  User username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
  @override
  User email(String? newValue) => this(email: newValue);

  @pragma('vm:prefer-inline')
  @override
  User isVerified(bool newValue) => this(isVerified: newValue);

  @pragma('vm:prefer-inline')
  @override
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

sealed class $UserCopyWithProxyChain<$Result> {
  factory $UserCopyWithProxyChain(final User value, final $Result Function(User update) chain) =
      _UserCopyWithProxyChainImpl<$Result>;

  $Result id(int newValue);

  $Result username(String newValue);

  $Result email(String? newValue);

  $Result isVerified(bool newValue);

  $Result call({
    final int? id,
    final String? username,
    final String? email,
    final bool? isVerified,
  });
}

class _UserCopyWithProxyChainImpl<$Result> implements $UserCopyWithProxyChain<$Result> {
  _UserCopyWithProxyChainImpl(this._value, this._chain);

  final User _value;
  final $Result Function(User update) _chain;

  @pragma('vm:prefer-inline')
  @override
  $Result id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result username(String newValue) => this(username: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result email(String? newValue) => this(email: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result isVerified(bool newValue) => this(isVerified: newValue);

  @pragma('vm:prefer-inline')
  @override
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
  _UserCopyWithProxy get copyWith => _UserCopyWithProxyImpl(this);
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

abstract interface class _CompanyCopyWithProxy {
  Company id(String newValue);

  $UserCopyWithProxyChain<Company> get ceo;

  Company call({
    final String? id,
    final User? ceo,
  });
}

class _CompanyCopyWithProxyImpl implements _CompanyCopyWithProxy {
  _CompanyCopyWithProxyImpl(this._value);

  final Company _value;

  @pragma('vm:prefer-inline')
  @override
  Company id(String newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  @override
  $UserCopyWithProxyChain<Company> get ceo =>
      $UserCopyWithProxyChain<Company>(_value.ceo, (User update) => this(ceo: update));

  @pragma('vm:prefer-inline')
  @override
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

sealed class $CompanyCopyWithProxyChain<$Result> {
  factory $CompanyCopyWithProxyChain(
          final Company value, final $Result Function(Company update) chain) =
      _CompanyCopyWithProxyChainImpl<$Result>;

  $Result id(String newValue);

  $Result ceo(User newValue);

  $Result call({
    final String? id,
    final User? ceo,
  });
}

class _CompanyCopyWithProxyChainImpl<$Result> implements $CompanyCopyWithProxyChain<$Result> {
  _CompanyCopyWithProxyChainImpl(this._value, this._chain);

  final Company _value;
  final $Result Function(Company update) _chain;

  @pragma('vm:prefer-inline')
  @override
  $Result id(String newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result ceo(User newValue) => this(ceo: newValue);

  @pragma('vm:prefer-inline')
  @override
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
  _CompanyCopyWithProxy get copyWith => _CompanyCopyWithProxyImpl(this);
}
