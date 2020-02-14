import 'dart:convert';
import 'dart:mirrors';

/// This abstract class is the base class for all generated models.
abstract class JsonSerializable {
  /// Returns a map representing the json output which will be used by dart to serialize the class.
  ///
  /// Invoked recursively on generated Models.
  Map<String, dynamic> toJson();

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
  static T fromJson<T>(String json) {
    if (T == String) return json as T;

    try {
      var classMirror = reflectClass(T);
      var instanceMirror = classMirror
          .newInstance(Symbol('fromJson'), <dynamic>[jsonDecode(json)]);
      T instance = instanceMirror.reflectee;
      return instance;
    } on NoSuchMethodError {
      return jsonDecode(json) as T;
    }
  }
}
