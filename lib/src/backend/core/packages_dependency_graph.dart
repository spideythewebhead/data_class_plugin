class DependencyGraph {
  final Map<String, Set<String>> _dependencies = <String, Set<String>>{};
  final Map<String, Set<String>> _dependants = <String, Set<String>>{};

  void add(String dependant, String newDependency) {
    (_dependencies[dependant] ??= <String>{}).add(newDependency);
    (_dependants[newDependency] ??= <String>{}).add(dependant);
  }

  List<String> getDependants(String dependencyName) {
    return _dependants[dependencyName]?.toList(growable: false) ?? const <String>[];
  }

  bool hasDependency(String dependant, String dependencyName) {
    return _dependencies[dependant]?.contains(dependencyName) ?? false;
  }
}
