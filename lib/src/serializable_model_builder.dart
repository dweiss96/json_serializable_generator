import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:json_serializable_generator/src/type_definition.dart';
import 'package:json_serializable_generator/src/type_analysis.dart';

class SerializableModelBuilder extends Builder{
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final AssetId outputId = buildStep.inputId.changeExtension('.dart');
    String source = await buildStep.readAsString(buildStep.inputId);
    String name = buildStep.inputId.path.split('/').last.replaceAll(".model.json", "");
    String output = writeModelClass(name, source);
    await buildStep.writeAsString(outputId, output);
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
    '.model.json': ['.model.dart']
  };


  MapEntry<String, TypeDefinition> analyzeJson(String key, dynamic value) {
    if(value is String) {
      return MapEntry<String, TypeDefinition>(key, TypeDefinition(
        name: key,
        type: value,
      ));
    }
    Map<String, String> typeDefinition = (value as Map<String, dynamic>).map<String, String>((String k, dynamic v) => MapEntry<String, String>(k, v as String)); 
    return MapEntry<String, TypeDefinition>(key, TypeDefinition(
      name  : key,
      type  : typeDefinition["type"],
      read  : typeDefinition["readMethod"] == null ? "" : typeDefinition["readMethod"],
      write : typeDefinition["writeMethod"] == null ? "" : typeDefinition["writeMethod"],
      import: typeDefinition["importPath"] == null ? "" : typeDefinition["importPath"],
    ));
  }

  String writeModelClass(String name, String model) {
    List<TypeDefinition> types = jsonDecode(model).map<String, TypeDefinition>((dynamic k, dynamic v) => analyzeJson(k as String, v)).values.toList();

    String imports = types
      .where((td) => !(isBasicType(td.type) || isList(td.type) || isMap(td.type)))
      .map((td) => td.importLine).join("\n");

    String classVariables = types.map((typeDefinition) => typeDefinition.variableCodeLine).join("\n  ");
    
    String generatedReadLines = types.map((typeDefinition) => typeDefinition.readCodeLine).join("\n    ");

    String reads = generatedReadLines.substring(0, generatedReadLines.length-1) + ";";

    String writes = types.map((typeDefinition) => typeDefinition.writeCodeLine).join("\n    ");

    String constructorParams = types.map((typeDefinition) => typeDefinition.constructorParameter).join("\n    ");

    String generatedConstructorInits = types.map((typeDefinition) => typeDefinition.constructorInitializer).join("\n    ");

    String constructorInits = generatedConstructorInits.substring(0, generatedConstructorInits.length-1) + ";";

    String getter = types.map((typeDefinition) => typeDefinition.getter).join("\n  ");

    String copyParams = types.map((typeDefinition) => typeDefinition.copyParam).join("\n    ");
    String copySetter = types.map((typeDefinition) => typeDefinition.copySetter).join("\n    ");

    String unnamedConstructor = """$name({
    $constructorParams
  }) :
    $constructorInits
""";
    return """
import 'dart:convert';
import 'package:json_serializable_generator/json_serializable.dart';
$imports

class $name implements JsonSerializable {
  $classVariables

  $unnamedConstructor

  $getter

  $name.fromJson(Map<String, dynamic> json) :
    $reads

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    $writes
  };
}
""";
  }
} 