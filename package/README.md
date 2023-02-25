# Data Class Plugin

[![CI Workflow](https://github.com/spideythewebhead/dart_data_class_plugin/actions/workflows/ci.yml/badge.svg)](https://github.com/spideythewebhead/dart_data_class_plugin/actions/workflows/ci.yml)
[![Pub Version](https://img.shields.io/pub/v/data_class_plugin?color=blue&logo=dart)](https://pub.dev/packages/data_class_plugin)

<!---
[![Pub Points](https://img.shields.io/pub/points/data_class_plugin?color=blue&logo=dart)](https://pub.dev/packages/data_class_plugin)
[![Pub Publisher](https://img.shields.io/pub/publisher/data_class_plugin)](https://github.com/spideythewebhead)
-->

**Data Class Plugin** is a tool that uses the Dart Analysis Server to generate code on-the-fly.

> This package is experimental and still under development, thus do not use it for applications in production.

---

### Table of contents

- [How it works](#how-it-works)
- [Installation](#installation)
- [Generate the code you want](#generate-the-code-you-want)
   - [DataClass Annotation](#dataclass-annotation)
   - [Union Annotation](#union-annotation)
   - [Enum Annotation](#enum-annotation)
   - [Enums](#enums)
- [New mode (File generation)](#new-mode-file-generation)
- [Configuration](#configuration)
   - [Configuration file](#configuration-file)
   - [Available options](#available-options)
   - [Configuration examples](#configuration-examples)
- [Notes](#notes)
- [Examples](#examples)
- [Development](#development)
- [Known Issues](#known-issues)

---

## How it works

**Data Class Plugin** uses the [analyzer](https://pub.dev/packages/analyzer) system and [analyzer plugin](https://pub.dev/packages/analyzer_plugin) 
to get access on the source code, parse it and provide actions based on that.

## Installation

1. In your project's pubspec.yaml add on `dependencies` the following
   ```yaml
   dependencies:
     data_class_plugin: ^0.2.0
   ```
1. Update your `analysis_options.yaml` _(in case you don't have it, just create a new one)_

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

1. Create a simple class, annotate it with `@DataClass()` and provide `final public` fields for your model.

   ```dart
   @DataClass()
   class User {
      final String id;
      final String username;
   }
   ```

1. Place the cursor anywhere inside the `User` class
1. Run code actions on your IDE

   VSCode

   1. **Windows/Linux:** Ctrl + .
   1. **MacOS:** ⌘ + .

   Intellij

   1. **Windows/Linux:** Alt + Enter
   1. **MacOS:** ⌘ + Enter

1. Select `Generate data class`

<img src="https://raw.githubusercontent.com/spideythewebhead/data_class_plugin/main/assets/screenshots/010.png" width="400">

Available methods are:

1. **copyWith**

   Generates a new instance of the class with optionally provide new fields values.

   _If no value is provided (default), then **true** is assumed._

   ```dart
   MyClass copyWith(...) { ... }
   ```

1. **hashAndEquals**

   Implements hashCode and equals methods.

   _If no value is provided (default), then **true** is assumed._

   ```dart
   @override
   bool operator ==(Object other) { ... }

   @override
   int get hashCode { ... }
   ```

1. **$toString**

   Implements toString method.

   _If no value is provided (default), then **true** is assumed._

   ```dart
   @override
   String toString() { ... }
   ```

1. **fromJson**

   Generates a factory constructor that creates a new instance from a Map.

   _If no value is provided (default), then **false** is assumed._

   ```dart
   factory MyClass.fromJson(Map<dynamic, dynamic> json) { ... }
   ```

1. **toJson**

   Generates a function that coverts this instance to a Map.

   _If no value is provided (default), then **false** is assumed._

   ```dart
   Map<String, dynamic> toJson() { ... }
   ```

_This configuration can be overriden in `data_class_plugin_options.yaml`, see [Configuration](#Configuration)_.

### Union Annotation

Adding this annotation to a class enables it to create union types.

<img src="https://raw.githubusercontent.com/spideythewebhead/data_class_plugin/main/assets/screenshots/009.png" width="450">

Available union annotation toggles are:

1. **dataClass**

   Toggles code generation for **toString**, **copyWith**, **equals** and **hashCode**.

   _If no value is provided (default), then **true** is assumed._

1. **toJson**

   Toggles code generation for **fromJson**.

   _If no value is provided (default), then **true** is assumed._

1. **fromJson**

   Toggles code generation for **toJson**.

   _If no value is provided (default), then **true** is assumed._

### Enum Annotation


1. Create an enumeration with the last field closed by semicolon and annotate it with the `@Enum()` annotation.

   ```dart
   @Enum()
   enum Category {
      science,
      sports;
   }
   ```

1. Place the cursor anywhere inside the `Category` enum

1. Run code actions on your IDE

   VSCode

   1. **Windows/Linux:** Ctrl + .
   1. **MacOS:** ⌘ + .

   Intellij

   1. **Windows/Linux:** Alt + Enter
   1. **MacOS:** ⌘ + Enter

1. Select `Generate enum`

<img src="https://raw.githubusercontent.com/spideythewebhead/data_class_plugin/main/assets/screenshots/011.png" width="400">

Available methods are:

1. **$toString**

   Implements toString method.

   _If no value is provided (default), then **true** is assumed._

   ```dart
   @override
   String toString() { ... }
   ```

1. **fromJson**

   Generates a factory constructor that creates a new instance from a Map.

   _If no value is provided (default), then **false** is assumed._

   ```dart
   factory MyClass.fromJson(Map<dynamic, dynamic> json) { ... }
   ```

1. **toJson**

   Generates a function that coverts this instance to a Map.

   _If no value is provided (default), then **false** is assumed._

   ```dart
   Map<String, dynamic> toJson() { ... }
   ```

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

   VSCode

   1. **Windows/Linux:** Ctrl + .
   1. **MacOS:** ⌘ + .

   Intellij

   1. **Windows/Linux:** Alt + Enter
   1. **MacOS:** ⌘ + Enter

1. A list with the following actions will be displayed
   1. Generate constructor
   1. Generate 'fromJson'
   1. Generate 'toJson'
   1. Generate 'toString'

> Enums can have an optional single field of primary type to be used in the _fromJson_ or _toJson_ transforms,
> if not provided then the `.name` is used as the default json value.

```dart
enum Category {
   science(0),
   sports(1);

   final int value;
}
```

<img src="https://raw.githubusercontent.com/spideythewebhead/data_class_plugin/main/assets/screenshots/007.png" width="400">

## Json Converters

The plugin exposes a json converter registrant that be used through out the app to register your custom converters. This eliminates the need to annotate every single field with a custom converter like (json_serializable).

By default the plugin provides 3 converters for the following classes: Duration, DateTime, Uri.  
In case you want to override the default implementation of these converters you can do it by registering your custom converter with `jsonConverterRegistrant.register(cosnt MyCustomConverter())`. For more info on how to create and register a converter, see this [example](example/lib/json_converter.dart)

In case you want to provide a custom implementation for a single field that might contain complex logic for parsing/conversion you can use a [JsonConverter](lib/src/json_converter/json_converter.dart) implementation and annotate the specific field with the implementer class.
See [example](example/lib/json_converter.dart) on `ClassWithLatLngConverterAnnotation` class.

If implementing a `JsonConverter` is too complex for your case you can use the `JsonKey` `fromJson/toJson` functions.

## New mode (File generation)

In this mode most of the code generation happens on a generated file.

You still need to generate some boilerplate code on the main class via actions,
but most of the code now is generated into a different file (like build_runner).

The generated file has the format of `base_filename.gen.dart`

To start with this mode you need to:

1. Update data_class_plugin_options.yaml (See more options)

```yaml
generation_mode: file (default in_place)

# This option is **required** if **generation_mode** is "file"
# Specify which path matches should generate files
# If you update this option, you should re-run the generator
# or if it's for a specific folder/file(s) you are working on, you can update this without restarting
file_generation_paths:
  - "a/glob/here"
  - "an/oth/er/*.dart"

# If you commit the generated files in git
# You can set the line length for the generated code too, so it won't fail in potential CI/CD workflows
generated_file_line_length: 80 (default)
```

1. Add a class

```dart
@DataClass()
class User {

   String get id;
   String get username;

   @DefaultValue<String>('')
   String get email;
}
```

Run the code actions like described previously.

The actions will generate for you the constructor, methods and the part directive.

Save the file and run the data_class_plugin CLI to generate
`dart run data_class_plugin generate <build | watch>`

## Configuration

You can customize the generated code produced by **Data Class Plugin**.

#### Configuration file

To create a custom configuration you need to add a file named `data_class_plugin_options.yaml` in the root folder of your project.

#### Available options

1. `json`
   
   Set the default naming convention for json keys.

   You can also override the default naming convention for the specified directories.

   > Supported naming conventions: `camelCase`, `snake_case`, `kebab-case` & `PascalCase`.

1. `data_class`

   Set the default values for the provided methods of the `@DataClass` annotation, 
   by specifying the directories where they will be enabled or disabled.

1. `enum`

   Set the default values for the provided methods of the `@Enum` annotation, 
   by specifying the directories where they will be enabled or disabled.

#### Configuration examples

```yaml

generation_mode: in_place (default) | file

# This option is **required** if **generation_mode** is "file"
# Which path matches should generate files
# If you update this option, you should re-run the genenator
# or if it's for a specific folder/file(s) you are working on, you can update this without restarting
file_generation_paths:
  - "a/glob/here"
  - "an/oth/er/*.dart"

# If you commit the generated files in git
# You can set the line length for the generated code too, so it won't fail in potential CI/CD workflows
generated_file_line_length: 80 (default)

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

data_class:
  options_config:
    # For each of the provided methods you can provide a configuration
    # The configuration can be an enabled or disabled field that contains a list of globs
    # Default values for each options
    # copy_with (true), hash_and_equals (true), to_string (true), from_json (false),to_json (false), unmodifiable_collections (true)
    <copy_with | hash_and_equals | to_string | from_json | to_json | unmodifiable_collections>:
      default: boolean
      enabled:
        - "a/glob/here"
        - "another/glob/here"
      disabled:
        - "a/glob/here"
        - "another/glob/here"

union:
  options_config:
    # For each of the provided methods you can provide a configuration
    # The configuration can be an enabled or disabled field that contains a list of globs
    # Default values for each options
    # copy_with (false), hash_and_equals (true), to_string (true)  from_json(false), to_json (false), unmodifiable_collections (true)
    <copy_with | hash_and_equals | to_string | from_json | to_json | unmodifiable_collections>:
      default: boolean
      enabled:
        - "a/glob/here"
        - "another/glob/here"
      disabled:
        - "a/glob/here"
        - "another/glob/here"

enum:
  options_config:
    # For each of the provided methods you can provide a configuration
    # The configuration can be an enabled or disabled field that contains a list of globs
    # Default values for each options
    # to_string (false), from_json(false), to_json (false)
    <to_string | from_json | to_json>:
      default: boolean
      enabled:
        - "a/glob/here"
        - "another/glob/here"
      disabled:
        - "a/glob/here"
        - "another/glob/here"
```

## Notes

> If the generated method doesn't exist it will be placed in the end of the class/enum body (before `}`), otherwise it will be re-generated to be up-to-date with current snapshot of the code (fields, annotations configuration).

> The constructor is always generated at the start of the body (after `{`) for classes.
>```dart
>class MyClass {
>   // constructor will be generated here
>   
>   final int a;
>}
>```

> The constructor is always generated after the semicolon (`;`) in the values declaration for enums.
>```dart
>enum MyEnum {
>   a,
>   b,
>   c;
>   
>   // constructor will be generated here
>}
>```

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
