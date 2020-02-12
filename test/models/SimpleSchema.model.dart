import 'dart:convert';
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
    this._id = id,
    this._isRequired = isRequired,
    this._name = name;


  int get id => this._id;
  bool get isRequired => this._isRequired;
  String get name => this._name;

  SimpleSchema.fromJson(Map<String, dynamic> json) :
    _id = JsonSerializable.fromJson<int>(json["id"].toString()),
    _isRequired = JsonSerializable.fromJson<bool>(json["isRequired"].toString()),
    _name = JsonSerializable.fromJson<String>(json["name"].toString());

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "id": this._id,
    "isRequired": this._isRequired,
    "name": this._name,
  };
}
