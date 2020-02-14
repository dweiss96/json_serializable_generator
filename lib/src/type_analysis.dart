bool isBasicType(String typeName) => [
      'bool',
      'double'
          'dynamic',
      'int',
      'null',
      'String',
    ].contains(typeName);

bool isList(String typeName) => RegExp(r'List<.*>').hasMatch(typeName);

bool isMap(String typeName) => RegExp(r'Map<.*, .*>').hasMatch(typeName);

String extractListTypeName(String typeName) =>
    RegExp(r'List<(.*)>').firstMatch(typeName).group(1);

String extractMapValueTypeName(String typeName) =>
    RegExp(r'Map<String,(.*)>').firstMatch(typeName).group(1);
