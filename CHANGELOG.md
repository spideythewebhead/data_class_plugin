## 0.2.0

- Override runtimeType for generated classes [(issue #228)](https://github.com/spideythewebhead/data_class_plugin/issues/228)
- Simplify the json methods for primitive types [(issue #231)](https://github.com/spideythewebhead/data_class_plugin/issues/231)
- Fix nullable immutable collections [(issue #227)](https://github.com/spideythewebhead/data_class_plugin/issues/227)
- Remove union parameter in when/maybeWhen when union has no fields [(issue #235)](https://github.com/spideythewebhead/data_class_plugin/issues/235)

Breaking change
- Improve from/to json in JsonKey [(issue #234)](https://github.com/spideythewebhead/data_class_plugin/issues/234)

## 0.1.0

- Fixes a crash on file generation mode when adding a new dependency to a target file [(issue #215)](https://github.com/spideythewebhead/data_class_plugin/issues/215)
- Regenerate all dataclasses/unions in a file [(issue #210)](https://github.com/spideythewebhead/data_class_plugin/issues/210)
- Lower "path" dependency to version 1.8.2 [(issue #214)](https://github.com/spideythewebhead/data_class_plugin/issues/214)

## 0.0.9

- General
  - Update README.md
  - Update pub packages
  - Improve logging for file gen mode
- Fixes/Enhancements
  - Add support for unmodifiable collections in file gen mode [(issue #196)](https://github.com/spideythewebhead/data_class_plugin/issues/196)
  - Add constructor name option for file gen mode [(issue #202)](https://github.com/spideythewebhead/data_class_plugin/issues/202)
  - Automatically convert final fields to getters [(issue #200)](https://github.com/spideythewebhead/data_class_plugin/issues/200)
  - Update generated code for file gen mode [(issue #198)](https://github.com/spideythewebhead/data_class_plugin/issues/198)
  - File gen watch mode not working on windows [(issue #194)](https://github.com/spideythewebhead/data_class_plugin/issues/194)
  - Actions for unions in file gen mode are not updating code correctly [(issue #191)](https://github.com/spideythewebhead/data_class_plugin/issues/191)
  - Fix nullability checks in toJson generation [(issue #190)](https://github.com/spideythewebhead/data_class_plugin/issues/190)
  - Main union classes should be abstract [(issue #188)](https://github.com/spideythewebhead/data_class_plugin/issues/188)
  - Missing '?' on nullable objects when generating 'toJson()' [(issue #186)](https://github.com/spideythewebhead/data_class_plugin/issues/186)
  - Add override annotation on 'toJson' method when extending a class that has it [(issue #184)](https://github.com/spideythewebhead/data_class_plugin/issues/184)
  - Fix error message for 'Exception: No json converter found for Type' [(issue #181)](https://github.com/spideythewebhead/data_class_plugin/issues/181)

## 0.0.8

- Bump data_class_plugin version in tools/analyzer_plugin

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