import 'package:analyzer/dart/ast/ast.dart';

class DeclarationInfo {
  DeclarationInfo({
    required this.name,
    required this.type,
    required this.metadata,
    required this.isRequired,
  });

  final String name;
  final TypeAnnotation? type;
  final List<Annotation> metadata;
  final bool isRequired;
}
