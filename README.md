# json_serializable_generator

Provides Dart Build System builders for handling JSON.

This README is still WIP

This library reads `.model.json` files and automatically generates the dart model (`.model.dart`) for them.

Models should be in one directory

# Usage
## simple case
For the Types `int`, `double`, `bool`, `String`, `List`, `Map` the library relies on the default dart json serialization.
For other Types it is assumed that a named constructor `fromJson(Map<String, dynamic> json)` exists.

### Example
```
{
  ...,
  "reference": "SomeGeneratedResource",
  "some_other_prop": "String"
}
```

## complex types

| field       | is required | explanation                                                                                          | default                                                          |
|:-----------:|:-----------:|------------------------------------------------------------------------------------------------------|------------------------------------------------------------------|
| type        |  &#128505;  | The Type Name (class name)                                                                           | -                                                                |
| readMethod  |  &#128503;  | Method which is getting called with the json (`Function(String)`) and should return a class instance | named constructor or static method `fromJson(Map<String, dynamic> json)` |
| writeMethod |  &#128503;  | Method to "write" the class to String, int, double, bool, Map or List                                | `toJson()` method on an instance                |
| importPath  |  &#128503;  | path from which the resulting model class file can import this class. Should be an "absolute" path.  | falls back to the generated `.model.dart` import                 |

### Example
```
{
  ...,
  "externalResource": {
    "type": "ExternalResource",
    "writeMethod": "prettyWrite",
    "readMethod": "prettyRead",
    "importPath": "package:my_app/external_resources/ExternalResource.dart"
  }
}
```

# Build configuration

```
targets:
  $default:
    builders:
      json_serializable_generator:
        generate_for:
          include:
            - lib/**
```
