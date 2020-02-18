abstract class JsonModel {
  /// Returns a map representing the json output which will be used by dart to serialize the class.
  ///
  /// Invoked recursively on generated Models.
  Map<String, dynamic> toJson();

  /// Deserializes the json string into the class.
  JsonModel fromJson(Map<String, dynamic> json);
}