// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
// coverage:ignore-file

part of 'custom_json_converter.dart';

class _$LogRecordImpl extends LogRecord {
  _$LogRecordImpl({
    required this.text,
    required this.datetime,
  }) : super.ctor();

  @override
  final String text;

  @override
  final DateTime datetime;

  factory _$LogRecordImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$LogRecordImpl(
      text: json['text'] as String,
      datetime: const _DateTimeFromSecondsJsonConverter()
          .fromJson(json['timestampInSeconds'], json, 'timestampInSeconds'),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LogRecord &&
            runtimeType == other.runtimeType &&
            text == other.text &&
            datetime == other.datetime;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      text,
      datetime,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'LogRecord{<optimized out>}';
    assert(() {
      toStringOutput = 'LogRecord@<$hexIdentity>{text: $text, datetime: $datetime}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => LogRecord;
}

abstract interface class _LogRecordCopyWithProxy {
  LogRecord text(String newValue);

  LogRecord datetime(DateTime newValue);

  LogRecord call({
    final String? text,
    final DateTime? datetime,
  });
}

class _LogRecordCopyWithProxyImpl implements _LogRecordCopyWithProxy {
  _LogRecordCopyWithProxyImpl(this._value);

  final LogRecord _value;

  @pragma('vm:prefer-inline')
  @override
  LogRecord text(String newValue) => this(text: newValue);

  @pragma('vm:prefer-inline')
  @override
  LogRecord datetime(DateTime newValue) => this(datetime: newValue);

  @pragma('vm:prefer-inline')
  @override
  LogRecord call({
    final String? text,
    final DateTime? datetime,
  }) {
    return _$LogRecordImpl(
      text: text ?? _value.text,
      datetime: datetime ?? _value.datetime,
    );
  }
}

sealed class $LogRecordCopyWithProxyChain<$Result> {
  factory $LogRecordCopyWithProxyChain(
          final LogRecord value, final $Result Function(LogRecord update) chain) =
      _LogRecordCopyWithProxyChainImpl<$Result>;

  $Result text(String newValue);

  $Result datetime(DateTime newValue);

  $Result call({
    final String? text,
    final DateTime? datetime,
  });
}

class _LogRecordCopyWithProxyChainImpl<$Result> implements $LogRecordCopyWithProxyChain<$Result> {
  _LogRecordCopyWithProxyChainImpl(this._value, this._chain);

  final LogRecord _value;
  final $Result Function(LogRecord update) _chain;

  @pragma('vm:prefer-inline')
  @override
  $Result text(String newValue) => this(text: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result datetime(DateTime newValue) => this(datetime: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result call({
    final String? text,
    final DateTime? datetime,
  }) {
    return _chain(_$LogRecordImpl(
      text: text ?? _value.text,
      datetime: datetime ?? _value.datetime,
    ));
  }
}

extension $LogRecordExtension on LogRecord {
  _LogRecordCopyWithProxy get copyWith => _LogRecordCopyWithProxyImpl(this);
}
