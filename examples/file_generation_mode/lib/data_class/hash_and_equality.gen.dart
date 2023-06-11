// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// coverage:ignore-file

part of 'hash_and_equality.dart';

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
    final int id,
    final String username,
    final String? email,
    final bool isVerified,
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
    final int id,
    final String username,
    final String? email,
    final bool isVerified,
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

class _$CartImpl extends Cart {
  _$CartImpl({
    required List<Product> products,
  })  : _products = products,
        super.ctor();

  @override
  List<Product> get products => List<Product>.unmodifiable(_products);
  final List<Product> _products;

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is Cart && runtimeType == other.runtimeType && deepEquality(products, other.products);
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'Cart{<optimized out>}';
    assert(() {
      toStringOutput = 'Cart@<$hexIdentity>{products: $products}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => Cart;
}

abstract interface class _CartCopyWithProxy {
  Cart products(List<Product> newValue);

  Cart call({
    final List<Product> products,
  });
}

class _CartCopyWithProxyImpl implements _CartCopyWithProxy {
  _CartCopyWithProxyImpl(this._value);

  final Cart _value;

  @pragma('vm:prefer-inline')
  @override
  Cart products(List<Product> newValue) => this(products: newValue);

  @pragma('vm:prefer-inline')
  @override
  Cart call({
    final List<Product>? products,
  }) {
    return _$CartImpl(
      products: products ?? _value.products,
    );
  }
}

sealed class $CartCopyWithProxyChain<$Result> {
  factory $CartCopyWithProxyChain(final Cart value, final $Result Function(Cart update) chain) =
      _CartCopyWithProxyChainImpl<$Result>;

  $Result products(List<Product> newValue);

  $Result call({
    final List<Product> products,
  });
}

class _CartCopyWithProxyChainImpl<$Result> implements $CartCopyWithProxyChain<$Result> {
  _CartCopyWithProxyChainImpl(this._value, this._chain);

  final Cart _value;
  final $Result Function(Cart update) _chain;

  @pragma('vm:prefer-inline')
  @override
  $Result products(List<Product> newValue) => this(products: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result call({
    final List<Product>? products,
  }) {
    return _chain(_$CartImpl(
      products: products ?? _value.products,
    ));
  }
}

extension $CartExtension on Cart {
  _CartCopyWithProxy get copyWith => _CartCopyWithProxyImpl(this);
}

class _$ProductImpl extends Product {
  _$ProductImpl({
    required this.id,
    required this.price,
  }) : super.ctor();

  @override
  final int id;

  @override
  final double price;

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is Product &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            price == other.price;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      price,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'Product{<optimized out>}';
    assert(() {
      toStringOutput = 'Product@<$hexIdentity>{id: $id, price: $price}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => Product;
}

abstract interface class _ProductCopyWithProxy {
  Product id(int newValue);

  Product price(double newValue);

  Product call({
    final int id,
    final double price,
  });
}

class _ProductCopyWithProxyImpl implements _ProductCopyWithProxy {
  _ProductCopyWithProxyImpl(this._value);

  final Product _value;

  @pragma('vm:prefer-inline')
  @override
  Product id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  @override
  Product price(double newValue) => this(price: newValue);

  @pragma('vm:prefer-inline')
  @override
  Product call({
    final int? id,
    final double? price,
  }) {
    return _$ProductImpl(
      id: id ?? _value.id,
      price: price ?? _value.price,
    );
  }
}

sealed class $ProductCopyWithProxyChain<$Result> {
  factory $ProductCopyWithProxyChain(
          final Product value, final $Result Function(Product update) chain) =
      _ProductCopyWithProxyChainImpl<$Result>;

  $Result id(int newValue);

  $Result price(double newValue);

  $Result call({
    final int id,
    final double price,
  });
}

class _ProductCopyWithProxyChainImpl<$Result> implements $ProductCopyWithProxyChain<$Result> {
  _ProductCopyWithProxyChainImpl(this._value, this._chain);

  final Product _value;
  final $Result Function(Product update) _chain;

  @pragma('vm:prefer-inline')
  @override
  $Result id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result price(double newValue) => this(price: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result call({
    final int? id,
    final double? price,
  }) {
    return _chain(_$ProductImpl(
      id: id ?? _value.id,
      price: price ?? _value.price,
    ));
  }
}

extension $ProductExtension on Product {
  _ProductCopyWithProxy get copyWith => _ProductCopyWithProxyImpl(this);
}
