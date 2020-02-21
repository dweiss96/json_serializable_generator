import 'package:json_serializable_generator/src/utils.dart';
import 'package:test/test.dart';

void main() {
  test('should create trimmed lower camel-case identifiers from strings', () {
    expect(toLowerCamelCase('someGoodVariable'), equals('someGoodVariable'));
    expect(toLowerCamelCase('SomeGoodVariable'), equals('someGoodVariable'));
    expect(toLowerCamelCase('some good variable'), equals('someGoodVariable'));
    expect(toLowerCamelCase('some  good    variable'), equals('someGoodVariable'));
    expect(toLowerCamelCase('someGoodVariable  '), equals('someGoodVariable'));
    expect(toLowerCamelCase('  someGoodVariable'), equals('someGoodVariable'));
    expect(toLowerCamelCase('some-Good-Variable'), equals('someGoodVariable'));
    expect(toLowerCamelCase('some---Good-Variable'), equals('someGoodVariable'));
    expect(toLowerCamelCase('some_Good_Variable'), equals('someGoodVariable'));
    expect(toLowerCamelCase('some-Good-Variable'), equals('someGoodVariable'));
    expect(toLowerCamelCase('SOME_GOOD_VARIABLE'), equals('someGoodVariable'));
  });
}
