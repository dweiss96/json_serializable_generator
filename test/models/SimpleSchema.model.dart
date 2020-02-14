import 'package:json_serializable_generator/json_serializable.dart';



class SimpleSchema implements JsonSerializable {
  final int _id;
  final bool _isRequired;
  final String _name;

  SimpleSchema({
    int id,
    bool isRequired,
    String name,
  }) :
    _id = id,
    _isRequired = isRequired,
    _name = name;


  int get id => _id;
  bool get isRequired => _isRequired;
  String get name => _name;

  SimpleSchema.fromJson(Map<String, dynamic> json) :
    _id = JsonSerializable.fromJson<int>(json['id'].toString()),
    _isRequired = JsonSerializable.fromJson<bool>(json['isRequired'].toString()),
    _name = JsonSerializable.fromJson<String>(json['name'].toString());

  SimpleSchema copy({
    int id,
    bool isRequired,
    String name,
  }) => SimpleSchema(
    id: id ?? _id,
    isRequired: isRequired ?? _isRequired,
    name: name ?? _name,
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': _id,
    'isRequired': _isRequired,
    'name': _name,
  };
}
