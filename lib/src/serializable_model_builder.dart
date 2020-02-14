import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:json_serializable_generator/src/type_definition.dart';
import 'package:json_serializable_generator/src/type_analysis.dart';

class SerializableModelBuilder extends Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final outputId = buildStep.inputId.changeExtension('.dart');
    final source = await buildStep.readAsString(buildStep.inputId);
    final name =
        buildStep.inputId.path.split('/').last.replaceAll('.model.json', '');
    final output = writeModelClass(name, source);
    await buildStep.writeAsString(outputId, output);
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        '.model.json': ['.model.dart']
      };

  MapEntry<String, TypeDefinition> analyzeJson(String key, dynamic value) {
    if (value is String) {
      return MapEntry<String, TypeDefinition>(
          key,
          TypeDefinition(
            name: key,
            type: value,
          ));
    }
    final typeDefinition = (value as Map<String, dynamic>).map<String, String>(
        (String k, dynamic v) => MapEntry<String, String>(k, v as String));
    return MapEntry<String, TypeDefinition>(
        key,
        TypeDefinition(
          name: key,
          type: typeDefinition['type'],
          read: typeDefinition['readMethod'] ?? '',
          write: typeDefinition['writeMethod'] ?? '',
          import: typeDefinition['importPath'] ?? '',
        ));
  }

  String writeModelClass(String name, String model) {
    List<TypeDefinition> types = jsonDecode(model)
        .map<String, TypeDefinition>(
            (dynamic k, dynamic v) => analyzeJson(k as String, v))
        .values
        .toList();

    final imports = types
        .where((td) =>
            !(isBasicType(td.type) || isList(td.type) || isMap(td.type)))
        .map((td) => td.importLine)
        .join('\n');

    final classVariables = types
        .map((typeDefinition) => typeDefinition.variableCodeLine)
        .join('\n  ');

    final generatedReadLines = types
        .map((typeDefinition) => typeDefinition.readCodeLine)
        .join('\n    ');

    final reads =
        generatedReadLines.substring(0, generatedReadLines.length - 1) + ';';

    final writes = types
        .map((typeDefinition) => typeDefinition.writeCodeLine)
        .join('\n    ');

    final constructorParams = types
        .map((typeDefinition) => typeDefinition.constructorParameter)
        .join('\n    ');

    final generatedConstructorInits = types
        .map((typeDefinition) => typeDefinition.constructorInitializer)
        .join('\n    ');

    final constructorInits = generatedConstructorInits.substring(
            0, generatedConstructorInits.length - 1) +
        ';';

    final getter =
        types.map((typeDefinition) => typeDefinition.getter).join('\n  ');

    final copyParams =
        types.map((typeDefinition) => typeDefinition.copyParam).join('\n    ');
    final copySetter =
        types.map((typeDefinition) => typeDefinition.copySetter).join('\n    ');

    final needsConvert = reads.contains('jsonEncode(');

    final unnamedConstructor = '''$name({
    $constructorParams
  }) :
    $constructorInits
''';
    return """
import 'package:json_serializable_generator/json_serializable.dart';
${needsConvert ? "import 'dart:convert';" : ""}
$imports

class $name implements JsonSerializable {
  $classVariables

  $unnamedConstructor

  $getter

  $name.fromJson(Map<String, dynamic> json) :
    $reads

  $name copy({
    $copyParams
  }) => $name(
    $copySetter
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    $writes
  };
}
""";
  }
}
