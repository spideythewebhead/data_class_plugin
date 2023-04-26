// AUTO GENERATED - DO NOT MODIFY

// ignore_for_file: library_private_types_in_public_api, unused_element, unused_field

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

class _$CartCopyWithProxy {
  _$CartCopyWithProxy(this._value);

  final Cart _value;

  @pragma('vm:prefer-inline')
  Cart products(List<Product> newValue) => this(products: newValue);

  @pragma('vm:prefer-inline')
  Cart call({
    final List<Product>? products,
  }) {
    return _$CartImpl(
      products: products ?? _value.products,
    );
  }
}

class $CartCopyWithProxyChain<$Result> {
  $CartCopyWithProxyChain(this._value, this._chain);

  final Cart _value;
  final $Result Function(Cart update) _chain;

  @pragma('vm:prefer-inline')
  $Result products(List<Product> newValue) => this(products: newValue);

  @pragma('vm:prefer-inline')
  $Result call({
    final List<Product>? products,
  }) {
    return _chain(_$CartImpl(
      products: products ?? _value.products,
    ));
  }
}

extension $CartExtension on Cart {
  _$CartCopyWithProxy get copyWith => _$CartCopyWithProxy(this);
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

class _$ProductCopyWithProxy {
  _$ProductCopyWithProxy(this._value);

  final Product _value;

  @pragma('vm:prefer-inline')
  Product id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  Product price(double newValue) => this(price: newValue);

  @pragma('vm:prefer-inline')
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

class $ProductCopyWithProxyChain<$Result> {
  $ProductCopyWithProxyChain(this._value, this._chain);

  final Product _value;
  final $Result Function(Product update) _chain;

  @pragma('vm:prefer-inline')
  $Result id(int newValue) => this(id: newValue);

  @pragma('vm:prefer-inline')
  $Result price(double newValue) => this(price: newValue);

  @pragma('vm:prefer-inline')
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
  _$ProductCopyWithProxy get copyWith => _$ProductCopyWithProxy(this);
}
