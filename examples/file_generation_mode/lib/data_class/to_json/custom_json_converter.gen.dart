// AUTO GENERATED - DO NOT MODIFY

// ignore_for_file: library_private_types_in_public_api, unused_element, unused_field

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

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'text': text,
      'datetime': const _DateTimeFromSecondsJsonConverter().toJson(datetime),
    };
  }

  @override
  bool operator ==(Object? other) {
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

class _$LogRecordCopyWithProxy {
  _$LogRecordCopyWithProxy(this._value);

  final LogRecord _value;

  @pragma('vm:prefer-inline')
  LogRecord text(String newValue) => this(text: newValue);

  @pragma('vm:prefer-inline')
  LogRecord datetime(DateTime newValue) => this(datetime: newValue);

  @pragma('vm:prefer-inline')
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

class $LogRecordCopyWithProxyChain<$Result> {
  $LogRecordCopyWithProxyChain(this._value, this._chain);

  final LogRecord _value;
  final $Result Function(LogRecord update) _chain;

  @pragma('vm:prefer-inline')
  $Result text(String newValue) => this(text: newValue);

  @pragma('vm:prefer-inline')
  $Result datetime(DateTime newValue) => this(datetime: newValue);

  @pragma('vm:prefer-inline')
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
  _$LogRecordCopyWithProxy get copyWith => _$LogRecordCopyWithProxy(this);
}
