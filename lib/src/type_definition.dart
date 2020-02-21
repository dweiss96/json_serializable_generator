import 'package:meta/meta.dart';
import 'package:json_serializable_generator/src/type_analysis.dart';
import 'utils.dart' as utils;

class TypeDefinition {
  final String name;
  final String formattedName;
  final String type;
  final String read;
  final String write;
  final String import;

  TypeDefinition({
    @required this.name,
    @required this.type,
    this.read = '',
    this.write = '',
    this.import = '',
  }) : formattedName = utils.toLowerCamelCase(name);

  String get importLine =>
      import.isEmpty ? "import './$type.model.dart';" : "import '$import';";

  String get constructorParameter => '$type $formattedName,';
  String get constructorInitializer => '_$formattedName = $formattedName,';

  String get getter => '$type get $formattedName => _$formattedName;';

  String get copyParam => '$type $formattedName,';
  String get copySetter => '$formattedName: $formattedName ?? _$formattedName,';

  String get variableCodeLine => 'final $type _$formattedName;';

  String get readCodeLine {
    if (read.trim().isEmpty) {
      if (isBasicType(type)) {
        //jsonEncode will ruin it for basic types
        return "$formattedName: JsonSerializable.fromJson<$type>(json['$name'].toString()),";
      }
      if (isList(type)) {
        return "$formattedName: JsonSerializable.fromJsArray<${extractListTypeName(type)}>(jsonEncode(json['$name'])),";
      }
      if (isMap(type)) {
        return "$formattedName: JsonSerializable.typedMapFromObject<${extractMapValueTypeName(type)}>(jsonEncode(json['$name'])),";
      }
      return "$formattedName: JsonSerializable.fromJson<$type>(jsonEncode(json['$name']), seed: $type()),";
    }
    return "$formattedName: $type.$read(json['$name']),";
  }

  String get writeCodeLine {
    if (write.trim().isEmpty) {
      if (!(isBasicType(type) || isMap(type) || isList(type))) {
        return "'$name': _$formattedName.toJson(),";
      }
      return "'$name': _$formattedName,";
    }
    return "'$name': _$formattedName.$write(),";
  }
}
