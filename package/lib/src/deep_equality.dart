bool deepEquality(dynamic a, dynamic b) {
  if (identical(a, b)) {
    return true;
  }

  if (a is Iterable && b is Iterable) {
    if (a is Set || b is Set) {
      return a is Set && b is Set && _setEquality(a, b);
    }

    final Iterator<dynamic> it1 = a.iterator;
    final Iterator<dynamic> it2 = b.iterator;

    while (it1.moveNext()) {
      if (!it2.moveNext() || !deepEquality(it1.current, it2.current)) {
        return false;
      }
    }

    // checks if both iterators have the same length
    return !(it1.moveNext() || it2.moveNext());
  } else if (a is Map && b is Map) {
    if (a.length != b.length) {
      return false;
    }

    for (final dynamic key in a.keys) {
      if (!b.containsKey(key) || !deepEquality(a[key], b[key])) {
        return false;
      }
    }

    return true;
  }

  return a == b;
}

// Sets are equal when they have the same elements, in any order.
bool _setEquality(final Set<dynamic> a, final Set<dynamic> b) {
  if (a.length != b.length) {
    return false;
  }

  for (final dynamic element in a) {
    if (!b.contains(element) && !b.any((final dynamic other) => deepEquality(element, other))) {
      return false;
    }
  }

  return true;
}

/// Returns a hash code of [value] that is consistent with [deepEquality].
///
/// Values that are equal according to [deepEquality] always get the same hash
/// code: lists depend on the order of their elements, while sets and maps do
/// not.
int deepHash(final dynamic value) {
  if (value is Set) {
    return Object.hashAllUnordered(value.map(deepHash));
  }

  if (value is Iterable) {
    return Object.hashAll(value.map(deepHash));
  }

  if (value is Map) {
    return Object.hashAllUnordered(
      value.entries.map((final MapEntry<dynamic, dynamic> entry) {
        return Object.hash(entry.key, deepHash(entry.value));
      }),
    );
  }

  return value.hashCode;
}
