import 'dart:convert';
import 'dart:io';
import 'package:json_serializable_generator/json_serializable.dart';
import './Example.model.dart';

void main() {
  String json = '''{
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

  Example deserializedModelInstance = JsonSerializable.fromJson<Example>(json);
  String serializedModelJson = jsonEncode(deserializedModelInstance.toJson());
  print(serializedModelJson);

  exit(0);
}