import 'package:analyzer_plugin/utilities/assist/assist.dart';

abstract class AvailableAssists {
  static const AssistKind shorthandConstructor = AssistKind(
    'shorthandConstructor',
    1000,
    'Generate shorthand constructor',
  );

  static const AssistKind fromMap =
      AssistKind('fromMap', 999, "Generate 'fromMap'");

  static const AssistKind toMap = AssistKind('toMap', 999, "Generate 'toMap'");

  static const AssistKind copyWith =
      AssistKind('copyWith', 998, "Generate 'copyWith'");

  static const AssistKind hashCodeAndEquals =
      AssistKind('hashCodeAndEquals', 997, "Generate 'hashCode' and 'equals'");

  static const AssistKind toString2 =
      AssistKind('toString', 996, "Generate 'toString'");
}
