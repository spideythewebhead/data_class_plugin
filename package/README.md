# Data Class Plugin

[![CI Workflow](https://github.com/spideythewebhead/dart_data_class_plugin/actions/workflows/ci.yml/badge.svg)](https://github.com/spideythewebhead/dart_data_class_plugin/actions/workflows/ci.yml)
[![Pub Version](https://img.shields.io/pub/v/data_class_plugin?color=blue&logo=dart)](https://pub.dev/packages/data_class_plugin)

<!---
[![Pub Points](https://img.shields.io/pub/points/data_class_plugin?color=blue&logo=dart)](https://pub.dev/packages/data_class_plugin)
[![Pub Publisher](https://img.shields.io/pub/publisher/data_class_plugin)](https://github.com/spideythewebhead)
-->

**Data Class Plugin** code generator powered by [Tachyon](https://pub.dev/packages/tachyon).

---

### Table of contents

- [How it works](#how-it-works)
- [Installation](#installation)
- [Generate the code you want](#generate-the-code-you-want)
  - [DataClass Annotation](#dataclass-annotation)
  - [Union Annotation](#union-annotation)
  - [Enum Annotation](#enum-annotation)
  - [Enums](#enums)
- [Configuration](#configuration)
  - [Configuration file](#configuration-file)
  - [Available options](#available-options)
  - [Configuration examples](#configuration-supported-values)
- [Notes](#notes)
- [Examples](#examples)
- [Development](#development)
- [Known Issues](#known-issues)

---

## How it works

**Data Class Plugin** uses `Tachyon` as it's build engine to provide fast code generation. Also this plugin uses the [analyzer](https://pub.dev/packages/analyzer) system and [analyzer plugin](https://pub.dev/packages/analyzer_plugin)
to get access on the source code, parse it and provide `code actions` based on that.

These `code actions` are similar to the ones provide by the language - e.g. `wrap with try/catch` - so you don't need to rely on snippets or manually typing any boilerplate code.

## Installation

1. In your project's `pubspec.yaml` add

   ```yaml
   dependencies:
     data_class_plugin: any

   dev_dependencies:
     tachyon: any
   ```

1. Create `tachyon_config.yaml` on the project's root folder

   ```yaml
   file_generation_paths: # which files/paths to include for build
     - "file/path/to/watch"
     - "another/one"

   generated_file_line_length: 80 # default line length

   plugins:
     - data_class_plugin # register data_class_plugin
   ```

1. Update your `analysis_options.yaml` (to enable `code action`)

   **Minimal analysis_options.yaml**

   ```yaml
   include: package:lints/recommended.yaml

   # You need to register the plugin under analyzer > plugins
   analyzer:
     plugins:
       - data_class_plugin
   ```

1. Restart the analysis server

   **VSCode**

   1. Open the Command Palette
      1. **Windows/Linux:** Ctrl + Shift + P
      1. **MacOS:** ⌘ + Shift + P
   1. Type and select "Dart: Restart Analysis Server"

   **IntelliJ**

   1. Open Find Action
      1. **Windows/Linux:** Ctrl + Shift + A
      1. **MacOS:** ⌘ + Shift + A
   1. Type and select "Restart Dart Analysis Server"

## Generate the code you want!

### DataClass Annotation

1. Create a simple class, annotate it with `@DataClass()` and provide `abstract getter` fields for your model.

   ```dart
   import 'package:data_class_plugin/data_class_plugin.dart';

   @DataClass()
   class User {
      String get id;
      String get username;
   }
   ```

   Generated code:

   ```dart
   class _$UserImpl extends User {
      _$UserImpl({
         required this.id,
         required this.username,
      }) : super.ctor();

      @override
      final String id;

      @override
      final String username;

      @override
      bool operator ==(Object? other) {
         return identical(this, other) ||
            other is User &&
                  runtimeType == other.runtimeType &&
                  id == other.id &&
                  username == other.username;
      }

      @override
      int get hashCode {
         return Object.hashAll(<Object?>[
            runtimeType,
            id,
            username,
         ]);
      }

      @override
      String toString() {
         String toStringOutput = 'User{<optimized out>}';
         assert(() {
            toStringOutput = 'User@<$hexIdentity>{id: $id, username: $username}';
            return true;
         }());
         return toStringOutput;
      }

      @override
      Type get runtimeType => User;
   }
   ```

1. Run code actions on your IDE

   VSCode

   1. **Windows/Linux:** Ctrl + .
   1. **MacOS:** ⌘ + .

   Intellij

   1. **Windows/Linux:** Alt + Enter
   1. **MacOS:** ⌘ + Enter

1. Select `Generate data/union classes`

<img src="https://raw.githubusercontent.com/spideythewebhead/data_class_plugin/main/assets/screenshots/dataclass.png" width="400">

This will generate all the boilerplate code on the source file.

Hint: _Fields declared with final (e.g. final String id;) will be automatically coverters to abstract getters._

Now to generate the part file code (part directive inserted by the code action) you need to run tachyon.

Executing tachyon:

`dart run tachyon build`

See more options about tachyon by executing: `dart run tachyon --help`

**Note**: _As you can see on the screenshot `@DataClass` annotations provides a variety of options to choose from. While this is ok, in many cases you might prefer to set these options on `path match` or `project level`._

_Check [Configuration](#Configuration) section to find more option about `data_class_plugin_options.yaml`_

### Union Annotation

Adding this annotation to a class enables it to create union types.

<img src="https://raw.githubusercontent.com/spideythewebhead/data_class_plugin/main/assets/screenshots/union.png" width="450">

_This configuration can be overriden in `data_class_plugin_options.yaml`, see [Configuration](#Configuration)_.

### Enum Annotation

1. Create an enumeration with the last field closed by semicolon and annotate it with the `@Enum()` annotation.

   ```dart
   @Enum()
   enum Category {
      science,
      sports;
   }
   ```

1. Select `Generate enum`

<img src="https://raw.githubusercontent.com/spideythewebhead/data_class_plugin/main/assets/screenshots/enum.png" width="400">

_This configuration can be overriden in `data_class_plugin_options.yaml`, see [Configuration](#Configuration)_.

### Enums

Even if you don't use the `@Enum()` annotation, you can still generate methods in enums.

1. Create an enumeration with the last field closed by semicolon

   ```dart
   enum Category {
      science,
      sports;
   }
   ```

1. Place the cursor anywhere inside the `Category` enum

1. Run code actions on your IDE

1. A list with the following actions will be displayed
   1. Generate constructor
   1. Generate 'fromJson'
   1. Generate 'toJson'
   1. Generate 'toString'

> Enums can have an optional single field of primitive type to be used in the _fromJson_ or _toJson_ transforms,
> if not provided then the `.name` is used as the default json value.

```dart
enum Category {
   science(0),
   sports(1);

   final int value;
}
```

## Json Converters

The plugin exposes a json converter registrant that be used through out the app to register your custom converters. This eliminates the need to annotate every single field with a custom converter like (json_serializable).

By default the plugin provides 3 converters for the following classes: Duration, DateTime, Uri.  
In case you want to override the default implementation of these converters you can do it by registering your custom converter with `jsonConverterRegistrant.register(const MyCustomConverter())`. For more info on how to create and register a converter, see this [example](examples/file_generation_mode/lib/data_class/from_json/custom_json_converter.dart)

In case you want to provide a custom implementation for a single field that might contain complex logic for parsing/conversion you can use a [JsonConverter](lib/src/json_converter/json_converter.dart) implementation and annotate the specific field with the implementer class.
See [example](example/lib/json_converter.dart) on `ClassWithLatLngConverterAnnotation` class.

If implementing a `JsonConverter` is too complex for your case you can use the `JsonKey` `fromJson/toJson` functions.

## Configuration

You can customize the generated code produced by **Data Class Plugin**.

#### Configuration file

To create a custom configuration you need to add a file named `data_class_plugin_options.yaml` in the root folder of your project.

#### Available options

1. auto_delete_code_from_annotation

   To automatically remove code which can be generated by an action in the source file
   if the annotation value and the code are in matching.

   Based on this example :

   ```dart
   @DataClass(toJson: false)
   class User {
      Map<String, dynamic> toJson() {
         // ...
      }
   }
   ```

   When `auto_delete_code_from_annotation` is `true` => `toJson` will be removed because is set as `false` in the `@DataClass`.

   When `auto_delete_code_from_annotation` is `false` => `toJson` will be kept as it is even when `toJson` is set as `false` in the `@DataClass`. This allows to create custom `fromJson/toJson` implementations.

1. `json`

   Set the default naming convention for json keys.

   You can also override the default naming convention for the specified directories.

   > Supported naming conventions: `camelCase`, `snake_case`, `kebab-case` & `PascalCase`.

1. `data_class`

   Set the default values for the provided methods of the `@DataClass` annotation,
   by specifying the directories where they will be enabled or disabled.

1. `union`

   Set the default values for the provided methods of the `@Union` annotation,
   by specifying the directories where they will be enabled or disabled.

1. `enum`

   Set the default values for the provided methods of the `@Enum` annotation,
   by specifying the directories where they will be enabled or disabled.

#### Configuration supported values

```yaml
# To automatically remove code generated from an annotation or code that can be generated by an annotation action. (commonly fromJson / toJson)
auto_delete_code_from_annotation: true | false

json:
  # Default naming convention for json keys
  key_name_convention: camel_case (default) | snake_case | kebab_case | pascal_case

  # Maps naming conventions to globs
  # You can provide a map of all the conventions you need and then a list with all the globs
  # key_name_conventions glob match takes precedence over key_name_convention
  key_name_conventions:
    <camel_case | snake_case | kebab_case | pascal_case>:
      - "a/glob/here"
      - "another/glob/here"

  # Allows to configure "toJson" code generation
  # If no config is provided, null values will be dropped by default
  to_json:
    options_config:
      drop_null_values:
        default: boolean # default value is there is no match in enabled or disabled lists
        enabled: # list of globs
          - "a/glob/here"
          - "another/glob/here"
        disabled: # list of globs
          - "a/glob/here"
          - "another/glob/here"

data_class:
  options_config:
    # For each of the provided methods you can provide a configuration
    # The configuration can be an enabled or disabled field that contains a list of globs
    # Default values for each options
    # copy_with (true), hash_and_equals (true), to_string (true), from_json (false),to_json (false), unmodifiable_collections (true)
    <copy_with | hash_and_equals | to_string | from_json | to_json | unmodifiable_collections>:
      default: boolean # default value is there is no match in enabled or disabled lists
      enabled: # list of globs
        - "a/glob/here"
        - "another/glob/here"
      disabled: # list of globs
        - "a/glob/here"
        - "another/glob/here"

union:
  options_config:
    # For each of the provided methods you can provide a configuration
    # The configuration can be an enabled or disabled field that contains a list of globs
    # Default values for each options
    # copy_with (false), hash_and_equals (true), to_string (true)  from_json(false), to_json (false), unmodifiable_collections (true), when (true)
    <copy_with | hash_and_equals | to_string | from_json | to_json | unmodifiable_collections | when>:
      default: boolean # default value is there is no match in enabled or disabled lists
      enabled: # list of globs
        - "a/glob/here"
        - "another/glob/here"
      disabled: # list of globs
        - "a/glob/here"
        - "another/glob/here"

enum:
  options_config:
    # For each of the provided methods you can provide a configuration
    # The configuration can be an enabled or disabled field that contains a list of globs
    # Default values for each options
    # to_string (false), from_json(false), to_json (false)
    <to_string | from_json | to_json>:
      default: boolean # default value is there is no match in enabled or disabled lists
      enabled: # list of globs
        - "a/glob/here"
        - "another/glob/here"
      disabled: # list of globs
        - "a/glob/here"
        - "another/glob/here"
```

## Notes

> If the generated method doesn't exist it will be placed in the end of the class/enum body (before `}`), otherwise it will be re-generated to be up-to-date with current snapshot of the code (fields, annotations configuration).

> The constructor is always generated at the start of the body (after `{`) for classes.
>
> ```dart
> class MyClass {
>   // constructor will be generated here
>
>   final int a;
> }
> ```

> The constructor is always generated after the semicolon (`;`) in the values declaration for enums.
>
> ```dart
> enum MyEnum {
>   a,
>   b,
>   c;
>
>   // constructor will be generated here
> }
> ```

## Examples

You can find a variety of examples in the [examples](https://github.com/spideythewebhead/dart_data_class_plugin/tree/main/examples) folder and the source code from the Live Demo, as it was presented in the Flutter Greek Community, [here](https://github.com/spideythewebhead/fluttergr).

## Development

In order to see your changes in the plugin you need to modify `tools/analyzer_plugin/pubspec.yaml` and add the following section:

```yaml
dependency_overrides:
  data_class_plugin:
    path: /absolute/path/to/root_project
```

And restart the analysis server _(in case that fails run pub_get.sh)_.

## Known Issues

1. When using IntelliJ/Android Studio the `$toString` parameter of the **@DataClass** annotation is not visible in the Suggestions list.
   However, you can still use it by typing it.
