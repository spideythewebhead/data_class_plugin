import 'package:analyzer/dart/ast/ast.dart';

class DeclarationInfo {
  DeclarationInfo({
    required this.name,
    required this.type,
    required this.metadata,
    required this.isNamed,
    required this.isRequired,
    required this.isPositional,
  });

  final String name;
  final TypeAnnotation? type;
  final List<Annotation> metadata;
  final bool isNamed;
  final bool isRequired;
  final bool isPositional;

  bool get isRequiredNamed => isRequired && isNamed;
  bool get isRequiredPositional => isRequired && isPositional;
}
