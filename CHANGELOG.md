### 0.0.2

Changelog:

1. Fix enum assists not being displayed when there are no fields declared [issue #118](https://github.com/spideythewebhead/data_class_plugin/pull/119)
1. Add `// ignore: prefer_const_constructors` on copyWith method if there no fields declared and constructor is const [issue #103](https://github.com/spideythewebhead/data_class_plugin/pull/111)
1. Update `fromJson` json parameter type from `Map<String, dynamic>` to `Map<dynamic, dynamic>` [issue #120](https://github.com/spideythewebhead/data_class_plugin/pull/122)
1. Fix Union assist creating a `fromJson` method instead of a factory constructor [#101](https://github.com/spideythewebhead/data_class_plugin/pull/121)

Other:

1. Updates for README.md
1. Updated examples


### 0.0.1

- Initial release