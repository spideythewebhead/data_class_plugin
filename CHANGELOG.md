## 0.0.7

- Bug fix multiple part directives being added [(issue #175)](https://github.com/spideythewebhead/data_class_plugin/issues/175)
- Add example for file generation mode [(issue #177)](https://github.com/spideythewebhead/data_class_plugin/issues/177)

## 0.0.6

- Introduce new code generation mode: "file" (like build runner). See [README](README.md#new-mode-file-generation)
- Add CLI command [(issue #156)](https://github.com/spideythewebhead/data_class_plugin/issues/156)
- Code cleanup

## 0.0.5

- General
  - Update the supported versions of analyzer and analyzer_plugin [(issue #143)](https://github.com/spideythewebhead/data_class_plugin/issues/143)
- Annotations
  - Create enum annotation [(issue #136)](https://github.com/spideythewebhead/data_class_plugin/issues/136)
- Configuration
  - Add options for enums [(issue #138)](https://github.com/spideythewebhead/data_class_plugin/issues/138)
  - Add options for unions [(issue #139)](https://github.com/spideythewebhead/data_class_plugin/issues/139)
- Update README.md [(issue #139)](https://github.com/spideythewebhead/data_class_plugin/issues/139)
  - Fix issue with the table of contents links
  - Link sample project from meetup
- Testing
  - Speed up contributor tests [(issue #145)](https://github.com/spideythewebhead/data_class_plugin/issues/145)
  - Add missing tests [(issue #148)](https://github.com/spideythewebhead/data_class_plugin/issues/148)

## 0.0.4

- Update README.md [(issue #130)](https://github.com/spideythewebhead/data_class_plugin/issues/130)
- Fix --no-warnings argument in Publish Package workflow [(issue #128)](https://github.com/spideythewebhead/data_class_plugin/pull/129)

## 0.0.3

- Update README.md

## 0.0.2

#### Resolved issues

- Fix enum assists not being displayed when there are no fields declared [(issue #118)](https://github.com/spideythewebhead/data_class_plugin/pull/119)
- Add `// ignore: prefer_const_constructors` on copyWith method if there no fields declared and constructor is const [(issue #103)](https://github.com/spideythewebhead/data_class_plugin/pull/111)
- Update `fromJson` json parameter type from `Map<String, dynamic>` to `Map<dynamic, dynamic>` [(issue #120)](https://github.com/spideythewebhead/data_class_plugin/pull/122)
- Fix Union assist creating a `fromJson` method instead of a factory constructor [(issue #101)](https://github.com/spideythewebhead/data_class_plugin/pull/121)

#### Other changes

- Updates for README.md
- Updated examples


## 0.0.1

- Initial release