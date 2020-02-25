import 'dart:convert';

import 'package:json_serializable_generator/json_model.dart';

/// This abstract class is the base class for all generated models.
class JsonSerializable {
  JsonSerializable();

  /// Invoked for List<T> types and needs a json array string as input.
  static List<T> fromJsArray<T>(String json) =>
      (jsonDecode(json) as List<dynamic>)
          .map<T>((dynamic v) => v as T)
          .toList();

  /// Invoked for Map<String, T> types and needs a json object string as input.
  static Map<String, T> typedMapFromObject<T>(String json) => (jsonDecode(json)
          as Map<String, dynamic>)
      .map<String, T>((String k, dynamic v) => MapEntry<String, T>(k, v as T));

  /// Invoked for core types and for unknown ones having no explicit write method specified.
  static T fromJson<T>(String json, { T seed }) {
    if (T == String) return json as T;

    if (seed is JsonModel) {
      return seed.fromJson(jsonDecode(json)) as T;
    } else {
      dynamic decoded = jsonDecode(json);
      if(decoded is int && T == double) return decoded.toDouble() as T;
      if(decoded is double && T == int) return decoded.toInt() as T;
      return jsonDecode(json) as T;
    }
  }
}
