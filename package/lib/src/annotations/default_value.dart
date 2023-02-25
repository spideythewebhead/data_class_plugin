import 'package:meta/meta_meta.dart';

@Target(<TargetKind>{
  TargetKind.getter,
  TargetKind.parameter,
})
class DefaultValue<T> {
  const DefaultValue(this.value);

  final T value;
}
