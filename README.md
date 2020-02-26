# json_serializable_generator

Provides Dart Build System builders for handling JSON.

This library reads `.model.json` files and automatically generates the dart model classes (`.model.dart`) for them.

Right now the models should be in one directory because otherwise you would need to specify the paths explicitly as described later.

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
| type        |  YES        | The Type Name (class name)                                                                           | -                                                                |
| readMethod  |   No        | Method which is getting called with the json (`Function(String)`) and should return a class instance | named constructor or static method `fromJson(Map<String, dynamic> json)` |
| writeMethod |   No        | Method to "write" the class to String, int, double, bool, Map or List                                | `toJson()` method on an instance                |
| importPath  |   No        | path from which the resulting model class file can import this class. Should be an "absolute" path.  | falls back to the generated `.model.dart` import                 |

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

# Build configuration (`build.yaml`)

## build to cache (default; not working with Flutter)

```
targets:
  $default:
    builders:
      json_serializable_generator:
        generate_for:
          include:
            - lib/**
```

## build to source (necessary for Flutter)

```
targets:
  $default:
    builders:
      _generator:
        generate_for:
          include:
            - lib/**
      json_serializable_generator:
        enabled: false

builders:
  _generator:
    import: "package:json_serializable_generator/json_serializable_generator.dart"
    builder_factories:
      - "jsonSerializableGenerator"
    build_extensions: {".model.json": [".model.dart"]}
    auto_apply: root_package
    build_to: source
```
