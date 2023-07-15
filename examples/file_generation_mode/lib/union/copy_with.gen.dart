// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// coverage:ignore-file

part of 'copy_with.dart';

extension $AsyncResult on AsyncResult {
  R when<R>({
    required R Function(AsyncResultError value) error,
  }) {
    if (this is AsyncResultError) {
      return error(this as AsyncResultError);
    }
    throw UnimplementedError('$runtimeType is not generated by this plugin');
  }

  R maybeWhen<R>({
    R Function(AsyncResultError value)? error,
    required R Function() orElse,
  }) {
    if (error != null && this is AsyncResultError) {
      return error(this as AsyncResultError);
    }
    return orElse();
  }
}

class AsyncResultError extends AsyncResult {
  AsyncResultError(
    this.error, {
    this.stackTrace,
  }) : super._();

  final Object error;

  final StackTrace? stackTrace;

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      error,
      stackTrace,
    ]);
  }

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is AsyncResultError &&
            runtimeType == other.runtimeType &&
            error == other.error &&
            stackTrace == other.stackTrace;
  }

  @override
  String toString() {
    String toStringOutput = 'AsyncResultError{<optimized out>}';
    assert(() {
      toStringOutput = 'AsyncResultError@<$hexIdentity>{error: $error, stackTrace: $stackTrace}';
      return true;
    }());
    return toStringOutput;
  }
}

abstract interface class _AsyncResultErrorCopyWithProxy {
  AsyncResultError error(Object newValue);

  AsyncResultError stackTrace(StackTrace? newValue);

  AsyncResultError call({
    final Object? error,
    final StackTrace? stackTrace,
  });
}

class _AsyncResultErrorCopyWithProxyImpl implements _AsyncResultErrorCopyWithProxy {
  _AsyncResultErrorCopyWithProxyImpl(this._value);

  final AsyncResultError _value;

  @pragma('vm:prefer-inline')
  @override
  AsyncResultError error(Object newValue) => this(error: newValue);

  @pragma('vm:prefer-inline')
  @override
  AsyncResultError stackTrace(StackTrace? newValue) => this(stackTrace: newValue);

  @pragma('vm:prefer-inline')
  @override
  AsyncResultError call({
    final Object? error,
    final Object? stackTrace = const Object(),
  }) {
    return AsyncResultError(
      error ?? _value.error,
      stackTrace:
          identical(stackTrace, const Object()) ? _value.stackTrace : (stackTrace as StackTrace?),
    );
  }
}

sealed class $AsyncResultErrorCopyWithProxyChain<$Result> {
  factory $AsyncResultErrorCopyWithProxyChain(
          final AsyncResultError value, final $Result Function(AsyncResultError update) chain) =
      _AsyncResultErrorCopyWithProxyChainImpl<$Result>;

  $Result error(Object newValue);

  $Result stackTrace(StackTrace? newValue);

  $Result call({
    final Object? error,
    final StackTrace? stackTrace,
  });
}

class _AsyncResultErrorCopyWithProxyChainImpl<$Result>
    implements $AsyncResultErrorCopyWithProxyChain<$Result> {
  _AsyncResultErrorCopyWithProxyChainImpl(this._value, this._chain);

  final AsyncResultError _value;
  final $Result Function(AsyncResultError update) _chain;

  @pragma('vm:prefer-inline')
  @override
  $Result error(Object newValue) => this(error: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result stackTrace(StackTrace? newValue) => this(stackTrace: newValue);

  @pragma('vm:prefer-inline')
  @override
  $Result call({
    final Object? error,
    final Object? stackTrace = const Object(),
  }) {
    return _chain(AsyncResultError(
      error ?? _value.error,
      stackTrace:
          identical(stackTrace, const Object()) ? _value.stackTrace : (stackTrace as StackTrace?),
    ));
  }
}

extension $AsyncResultErrorExtension on AsyncResultError {
  _AsyncResultErrorCopyWithProxy get copyWith => _AsyncResultErrorCopyWithProxyImpl(this);
}
