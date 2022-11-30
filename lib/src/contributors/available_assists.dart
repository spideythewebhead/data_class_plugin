import 'package:analyzer_plugin/utilities/assist/assist.dart';

abstract class AvailableAssists {
  static const AssistKind shorthandConstructor = AssistKind(
    'shorthandConstructor',
    1000,
    'Generate shorthand constructor',
  );

  static const AssistKind union = AssistKind(
    'union',
    1000,
    'Generate union',
  );

  static const AssistKind dataClass = AssistKind(
    'dataClass',
    1000,
    'Generate data class',
  );

  static const AssistKind fromJson = AssistKind(
    'fromJson',
    999,
    "Generate 'fromJson'",
  );

  static const AssistKind toJson = AssistKind(
    'toJson',
    999,
    "Generate 'toJson'",
  );

  static const AssistKind copyWith = AssistKind(
    'copyWith',
    998,
    "Generate 'copyWith'",
  );

  static const AssistKind hashCodeAndEquals = AssistKind(
    'hashCodeAndEquals',
    997,
    "Generate 'hashCode' and 'equals'",
  );

  static const AssistKind toString2 = AssistKind(
    'toString',
    996,
    "Generate 'toString'",
  );

  static const AssistKind enumConstructor = AssistKind(
    'enumConstructor',
    1000,
    'Generate constructor',
  );

  static const AssistKind enumAnnotation = AssistKind(
    'enumAnnotation',
    1000,
    'Generate enum',
  );
}
