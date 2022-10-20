import 'package:analyzer_plugin/utilities/assist/assist.dart';

int _id = 1000;
int _nextId() {
  return _id--;
}

abstract class AvailableAssists {
  static AssistKind constructorWithNamedParameters = AssistKind(
    'constructorWithNamedParameters',
    _nextId(),
    'Generate constructor with named parameters',
  );

  static AssistKind fromMap =
      AssistKind('fromMap', _nextId(), "Generate 'fromMap'");

  static AssistKind toMap = AssistKind('toMap', _nextId(), "Generate 'toMap'");

  static AssistKind copyWith =
      AssistKind('copyWith', _nextId(), "Generate 'copyWith'");

  static AssistKind hashCodeAndEquals = AssistKind(
      'hashCodeAndEquals', _nextId(), "Generate 'hashCode' and 'equals'");

  static AssistKind toString2 =
      AssistKind('toString', _nextId(), "Generate 'toString'");
}
