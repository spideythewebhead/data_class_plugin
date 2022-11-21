## 0.0.3-prerelease

- Update README.md
- Mark package version as `prerelease`

## 0.0.2

#### Resolved issues

- Fix enum assists not being displayed when there are no fields declared [issue #118](https://github.com/spideythewebhead/data_class_plugin/pull/119)
- Add `// ignore: prefer_const_constructors` on copyWith method if there no fields declared and constructor is const [issue #103](https://github.com/spideythewebhead/data_class_plugin/pull/111)
- Update `fromJson` json parameter type from `Map<String, dynamic>` to `Map<dynamic, dynamic>` [issue #120](https://github.com/spideythewebhead/data_class_plugin/pull/122)
- Fix Union assist creating a `fromJson` method instead of a factory constructor [#101](https://github.com/spideythewebhead/data_class_plugin/pull/121)

#### Other changes

- Updates for README.md
- Updated examples


## 0.0.1

- Initial release