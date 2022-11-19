extension DataClassPluginObjectX on Object? {
  String get hexIdentity => '0x${identityHashCode(this).toRadixString(16)}';
}
