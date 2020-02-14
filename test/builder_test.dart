import 'package:json_serializable_generator/json_serializable.dart';
import 'package:test/test.dart';
import 'dart:convert';
import './models/subFolder/SecondExternalResource.dart';
import './models/ExternalResource.model.dart';
import './models/ComplexSchema.model.dart';
import './models/SimpleSchema.model.dart';

void main() {
  test('should create a class which can be copied', () {
    final instance = SimpleSchema(
      id: 123456,
      isRequired: false,
      name: 'Test Model Simple'
    );

    final copied = instance.copy(
      id: 456
    );

    final anotherCopied = instance.copy(
      id: 789,
      isRequired: true
    );

    expect(copied.id, equals(456));
    expect(copied.isRequired, equals(instance.isRequired));
    expect(copied.name, equals(instance.name));

    expect(anotherCopied.id, equals(789));
    expect(anotherCopied.isRequired, equals(true));
    expect(anotherCopied.name, equals(instance.name));
  });

  test('should correctly serialize and deserialize simple types', () {
    final json = '''{
      "id": 123456,
      "isRequired": false,
      "name": "Test Model Simple"
    }''';

    final instance = SimpleSchema(
      id: 123456,
      isRequired: false,
      name: 'Test Model Simple'
    );

    final deserialized = JsonSerializable.fromJson<SimpleSchema>(json);

    expect(deserialized.id, equals(instance.id));
    expect(deserialized.isRequired, equals(instance.isRequired));
    expect(deserialized.name, equals(instance.name));

    expect(instance.toJson(), equals(jsonDecode(json)));
  });

  test('should correctly serialize and deserialize complex types', () {
    final json = '''{
      "id": "abcdefg",
      "isRequired": true,
      "count": 42,
      "simpleSchema": {
        "id": 123456,
        "isRequired": false,
        "name": "Test Model Simple"
      },
      "someExternal": "some-id;string;false;123;",
      "anotherExternal": "another-id;string;false;123;",
      "someList": ["Adam", "Benjamin"],
      "someMapping": {
        "Adam": 1,
        "Benjamin": 2
      }
    }''';

    final simpleSchema = SimpleSchema(
      id: 123456,
      isRequired: false,
      name: 'Test Model Simple'
    );

    final someExternal = ExternalResource(
      id: 'some-id',
      stringValue: 'string',
      intValue: 123,
      boolValue: false,
    );
    final anotherExternal = SecondExternalResource(
      id: 'another-id',
      stringValue: 'string',
      intValue: 123,
      boolValue: false,
    );
    final someList = ['Adam', 'Benjamin'];
    final someMapping = {
      'Adam': 1,
      'Benjamin': 2
    };

    final instance = ComplexSchema(
      id: 'abcdefg',
      isRequired: true,
      count: 42,
      simpleSchema: simpleSchema,
      someExternal: someExternal,
      anotherExternal: anotherExternal,
      someList: someList,
      someMapping: someMapping,
    );

    final deserialized = JsonSerializable.fromJson<ComplexSchema>(json);

    expect(deserialized.id, equals(instance.id));
    expect(deserialized.isRequired, equals(instance.isRequired));
    expect(deserialized.count, equals(instance.count));
    expect(deserialized.someList, equals(instance.someList));
    expect(deserialized.someMapping, equals(instance.someMapping));

    expect(deserialized.simpleSchema.id, equals(instance.simpleSchema.id));
    expect(deserialized.simpleSchema.isRequired, equals(instance.simpleSchema.isRequired));
    expect(deserialized.simpleSchema.name, equals(instance.simpleSchema.name));

    expect(deserialized.someExternal.id, equals(instance.someExternal.id));
    expect(deserialized.someExternal.stringValue, equals(instance.someExternal.stringValue));
    expect(deserialized.someExternal.boolValue, equals(instance.someExternal.boolValue));
    expect(deserialized.someExternal.intValue, equals(instance.someExternal.intValue));
    
    expect(deserialized.anotherExternal.id, equals(instance.anotherExternal.id));
    expect(deserialized.anotherExternal.stringValue, equals(instance.anotherExternal.stringValue));
    expect(deserialized.anotherExternal.boolValue, equals(instance.anotherExternal.boolValue));
    expect(deserialized.anotherExternal.intValue, equals(instance.anotherExternal.intValue));

    expect(instance.toJson(), equals(jsonDecode(json)));
  });
}
