import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'hash_and_equality.gen.dart';

@DataClass()
abstract class User {
  User.ctor();

  /// Default constructor
  factory User({
    required int id,
    required String username,
    String? email,
    required bool isVerified,
  }) = _$UserImpl;

  int get id;

  String get username;

  String? get email;

  bool get isVerified;
}

@DataClass()
abstract class Cart {
  Cart.ctor();

  /// Default constructor
  factory Cart({
    required List<Product> products,
  }) = _$CartImpl;

  List<Product> get products;
}

@DataClass()
abstract class Product {
  Product.ctor();

  /// Default constructor
  factory Product({
    required int id,
    required double price,
  }) = _$ProductImpl;

  int get id;
  double get price;
}

void main(List<String> args) {
  final User user1 = User(
    id: 11,
    username: 'myusername',
    isVerified: true,
  );
  final User user1Copy = User(
    id: 11,
    username: 'myusername',
    isVerified: true,
  );

  final User user2 = User(
    id: 11,
    username: 'myusername',
    isVerified: false,
  );

  prettyPrint('equality <user1 == user1Copy>', user1 == user1Copy);
  prettyPrint('user1 hash code', user1.hashCode);
  prettyPrint('user1Copy hash code', user1Copy.hashCode);

  prettyPrint('equality <user1 == user2>', user1 == user2);
  prettyPrint('user1 hash code', user1.hashCode);
  prettyPrint('user2 hash code', user2.hashCode);

  final Cart cart1 = Cart(
    products: <Product>[
      Product(id: 1, price: 1.00),
      Product(id: 2, price: 2.00),
    ],
  );
  final Cart cart1Copy = cart1.copyWith();

  // deep equality
  prettyPrint('Deep equality <cart1 == cart1Copy>', cart1 == cart1Copy);
  prettyPrint('cart1 hash code', cart1.hashCode);
  prettyPrint('cart1Copy hash code', cart1Copy.hashCode);

  final Cart cart2 = Cart(
    products: <Product>[
      Product(id: 1, price: 1.00),
      Product(id: 2, price: 1.00),
    ],
  );

  // deep equality
  prettyPrint('Deep equality <cart1 == cart2>', cart1 == cart2);
  prettyPrint('cart1 hash code', cart1.hashCode);
  prettyPrint('cart2 hash code', cart2.hashCode);
}
