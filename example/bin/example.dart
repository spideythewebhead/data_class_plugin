import 'package:example/user.dart';

void main(List<String> arguments) {
  final userA = User(id: 'id', username: 'username');
  final userB = User(id: 'id', username: 'username');
  final userC = User(id: 'id2', username: 'username2');

  print('userA == userB = ${userA == userB}');
  print(
      'userA.hashCode = ${userA.hashCode} && userB.hashCode = ${userB.hashCode}');

  print('userA != userC = ${userA != userC}');
  print(
      'userA.hashCode = ${userA.hashCode} && userC.hashCode = ${userC.hashCode}');

  print(userA);
  print(userB);
  print(userC);
}
