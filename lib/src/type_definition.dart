import 'package:meta/meta.dart';
import 'package:json_serializable_generator/src/type_analysis.dart';

class TypeDefinition {
  final String name;
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
  });

  String get importLine =>
      import.isEmpty ? "import './$type.model.dart';" : "import '$import';";

  String get constructorParameter => '$type $name,';
  String get constructorInitializer => '_$name = $name,';

  String get getter => '$type get $name => _$name;';

  String get copyParam => '$type $name = _$name,';
  String get copySetter => '$name: $name,';

  String get variableCodeLine => 'final $type _$name;';

  String get readCodeLine {
    if (read.trim().isEmpty) {
      if (isBasicType(type)) {
        //jsonEncode will ruin it for basic types
        return "_$name = JsonSerializable.fromJson<$type>(json['$name'].toString()),";
      }
      if (isList(type)) {
        return "_$name = JsonSerializable.fromJsArray<${extractListTypeName(type)}>(jsonEncode(json['$name'])),";
      }
      if (isMap(type)) {
        return "_$name = JsonSerializable.typedMapFromObject<${extractMapValueTypeName(type)}>(jsonEncode(json['$name'])),";
      }
      return "_$name = JsonSerializable.fromJson<$type>(jsonEncode(json['$name'])),";
    }
    return "_$name = $type.$read(json['$name']),";
  }

  String get writeCodeLine {
    if (write.trim().isEmpty) {
      if (!(isBasicType(type) || isMap(type) || isList(type))) {
        return "'$name': _$name.toJson(),";
      }
      return "'$name': _$name,";
    }
    return "'$name': _$name.$write(),";
  }
}
