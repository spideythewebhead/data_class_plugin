import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:file_generation_mode/pretty_print.dart';

part 'copy_with.gen.dart';

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
abstract class Company {
  Company.ctor();

  /// Default constructor
  factory Company({
    required String id,
    required User ceo,
  }) = _$CompanyImpl;

  String get id;

  User get ceo;
}

void main(List<String> args) {
  final User ceo = User(id: 11, username: 'myusername', isVerified: true);
  final Company company = Company(id: '12', ceo: ceo);

  // copy with multiple fields available to change
  prettyPrint('ceo copyWith email', ceo.copyWith(email: 'ceo@email.com'));
  // deep copy with
  prettyPrint('ceo deep copyWith email', ceo.copyWith.email('ceo@email.com'));

  // normal copy with multiple fields
  prettyPrint('company copyWith ceo', company.copyWith(ceo: ceo.copyWith.id(22)));
  // deep copy with with nested class
  prettyPrint('company deep copyWith ceo', company.copyWith.ceo.id(22));

  final User user = User(
    id: 11,
    username: 'myusername',
    isVerified: true,
    email: 'user@email.com',
  );

  // copy with null
  prettyPrint('user copyWith with null value', user.copyWith.email(null));
}
