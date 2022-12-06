import 'package:data_class_plugin/src/json_key_name_convention.dart';
import 'package:test/test.dart';

void main() {
  const String key = 'thisIsAVariable';
  const String notEligibleKey = 'this-Is-A-Variable';

  Map<JsonKeyNameConvention, String> expectedValues = <JsonKeyNameConvention, String>{
    JsonKeyNameConvention.camelCase: key,
    JsonKeyNameConvention.kebabCase: 'this-is-a-variable',
    JsonKeyNameConvention.pascalCase: 'ThisIsAVariable',
    JsonKeyNameConvention.snakeCase: 'this_is_a_variable',
  };

  group('Json Key Name Convention', () {
    for (final JsonKeyNameConvention convention in JsonKeyNameConvention.values) {
      test(convention.name, () {
        expect(
          convention.transform(key),
          equals(expectedValues[convention]),
        );

        expect(
          convention.transform(notEligibleKey) != expectedValues[convention],
          true,
        );
      });
    }
  });
}
