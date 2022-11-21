// AUTO GENERATED - DO NOT MODIFY

part of 'simple_usage.dart';

class _$UserImpl extends User {
  _$UserImpl({
    required this.thisIsAVariable,
    required this.thisIsADifferentVariable,
  }) : super._();

  @override
  final String thisIsAVariable;

  @override
  final String thisIsADifferentVariable;

  factory _$UserImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$UserImpl(
      thisIsAVariable: json['thisIsAVariable'] as String,
      thisIsADifferentVariable: json['thisIsADifferentVariable'] as String,
    );
  }
}
