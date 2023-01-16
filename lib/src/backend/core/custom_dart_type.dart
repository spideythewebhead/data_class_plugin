import 'package:analyzer/dart/ast/ast.dart';

class CustomDartType {
  CustomDartType(
    this.name,
    this.fullTypeName,
    this.typeArguments,
  );

  factory CustomDartType._fromTypeAnnotation(TypeAnnotation? typeAnnotation) {
    final List<CustomDartType> typeArguments = <CustomDartType>[];

    if (typeAnnotation is NamedType) {
      final List<TypeAnnotation> arguments =
          typeAnnotation.typeArguments?.arguments ?? const <TypeAnnotation>[];
      for (final TypeAnnotation argument in arguments) {
        typeArguments.add(argument.customDartType);
      }
    }

    return CustomDartType(
      typeAnnotation?.beginToken.lexeme ?? 'dynamic',
      typeAnnotation?.toSource() ?? 'dynamic',
      List<CustomDartType>.unmodifiable(typeArguments),
    );
  }

  final String name;
  final String fullTypeName;
  final List<CustomDartType> typeArguments;

  static final CustomDartType dynamic = CustomDartType(
    'dynamic',
    'dynamic',
    List<CustomDartType>.unmodifiable(const <CustomDartType>[]),
  );

  bool get isInt => name == 'int';

  bool get isDouble => name == 'double';

  bool get isDynamic => name == 'dynamic';

  bool get isNum => name == 'num';

  bool get isList => name == 'List';

  bool get isMap => name == 'Map';

  bool get isString => name == 'String';

  bool get isBool => name == 'bool';

  bool get isDuration => name == 'Duration';

  bool get isDateTime => name == 'DateTime';

  bool get isUri => name == 'Uri';

  bool get isNullable => name == 'dynamic' || fullTypeName.endsWith('?');

  bool get isPrimary {
    return isString || isBool || isDouble || isInt || isNum;
  }

  bool get isCollection {
    return isList || isMap;
  }
}

extension CoreTypeOnTypeAnnotationX on TypeAnnotation? {
  CustomDartType get customDartType => CustomDartType._fromTypeAnnotation(this);
}
