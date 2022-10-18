# Dart Data Class Plugin

A way to a dart data class without needing code generation.

### How it works

This plugin uses the [analyzer](https://pub.dev/packages/analyzer) system and [analyzer plugin](https://pub.dev/packages/analyzer_plugin) to get access on the source code and provide actions based on that.

### How to install

1. In your project's pubspec.yaml add on `dependencies` the following
   ```yaml
   dependencies:
     data_class_plugin: 0.0.1
   ```
1. Update your `analysis_options.yaml` (in case you don't have one, just create)
   Minimal analysis_options.yaml
   ```yaml
   include: package:lints/recommended.yaml
   # You need to register the plugin under analyzer>plugins
   analyzer:
     plugins:
       - data_class_plugin
   ```
1. Restart the analysis server
   1. VSCode: Command Panel > Type "Restart Analysis Server"
   2. Intellij: Restart IDE

### Verify it works

1. Create a simple class that contains `final public fields` and a `default constructor` with those fields as `named arguments`.

   ```dart
   class User {
       const User({
           required this.id,
           required this.username,
       });

       final String id;
       final String username;
   }
   ```

1. Place the cursor on top of the `User` string in class declaration
1. Run code actions on your IDE
1. You should a list with the following actions
   1. Generate 'fromMap'
   1. Generate 'toMap'
   1. Generate 'hashCode' and 'equals'
   1. Generate 'toString

### Notes

If the generated method doesn't exist it will be placed in the end of the class (before `}`).
If the generated method exists, it will update in place the existing code with the new one.
