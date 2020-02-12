import 'dart:convert';
import 'dart:mirrors';

abstract class JsonSerializable {
  Map<String, dynamic> toJson();

  static List<T> fromJsArray<T>(String json) => (jsonDecode(json) as List<dynamic>)
    .map<T>((dynamic v) => v as T)
    .toList();
  
  
  static Map<String, T> typedMapFromObject<T>(String json) => (jsonDecode(json) as Map<String, dynamic>)
    .map<String, T>((String k, dynamic v) => MapEntry<String, T>(k, v as T));

  static T fromJson<T>(String json) {
    if(T == String) return json as T;

    try {
      var classMirror = reflectClass(T);
      var instanceMirror = classMirror.newInstance(Symbol("fromJson"), <dynamic>[jsonDecode(json)]);
      T instance = instanceMirror.reflectee;
      return instance;
    } on NoSuchMethodError {
      return jsonDecode(json) as T;
    }
  }
}
