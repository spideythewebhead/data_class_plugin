bool deepEquality(dynamic a, dynamic b) {
  if (identical(a, b)) {
    return true;
  }

  if (a is Iterable && b is Iterable) {
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

    for (final String key in a.keys) {
      if (!b.containsKey(key) || !deepEquality(a[key], b[key])) {
        return false;
      }
    }

    return true;
  }

  return a == b;
}
