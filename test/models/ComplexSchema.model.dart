import 'dart:convert';
import 'package:json_serializable_generator/json_serializable.dart';
import "./SimpleSchema.model.dart";
import "./ExternalResource.model.dart";
import "./subFolder/SecondExternalResource.dart";

class ComplexSchema implements JsonSerializable {
  final String _id;
  final bool _isRequired;
  final int _count;
  final SimpleSchema _simpleSchema;
  final ExternalResource _someExternal;
  final SecondExternalResource _anotherExternal;
  final List<String> _someList;
  final Map<String, int> _someMapping;

  ComplexSchema({
    String id,
    bool isRequired,
    int count,
    SimpleSchema simpleSchema,
    ExternalResource someExternal,
    SecondExternalResource anotherExternal,
    List<String> someList,
    Map<String, int> someMapping,
  }) :
    this._id = id,
    this._isRequired = isRequired,
    this._count = count,
    this._simpleSchema = simpleSchema,
    this._someExternal = someExternal,
    this._anotherExternal = anotherExternal,
    this._someList = someList,
    this._someMapping = someMapping;


  String get id => this._id;
  bool get isRequired => this._isRequired;
  int get count => this._count;
  SimpleSchema get simpleSchema => this._simpleSchema;
  ExternalResource get someExternal => this._someExternal;
  SecondExternalResource get anotherExternal => this._anotherExternal;
  List<String> get someList => this._someList;
  Map<String, int> get someMapping => this._someMapping;

  ComplexSchema.fromJson(Map<String, dynamic> json) :
    _id = JsonSerializable.fromJson<String>(json["id"].toString()),
    _isRequired = JsonSerializable.fromJson<bool>(json["isRequired"].toString()),
    _count = JsonSerializable.fromJson<int>(json["count"].toString()),
    _simpleSchema = JsonSerializable.fromJson<SimpleSchema>(jsonEncode(json["simpleSchema"])),
    _someExternal = ExternalResource.prettyRead(json["someExternal"]),
    _anotherExternal = SecondExternalResource.prettyRead(json["anotherExternal"]),
    _someList = JsonSerializable.fromJsArray<String>(jsonEncode(json["someList"])),
    _someMapping = JsonSerializable.typedMapFromObject< int>(jsonEncode(json["someMapping"]));

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "id": this._id,
    "isRequired": this._isRequired,
    "count": this._count,
    "simpleSchema": this._simpleSchema.toJson(),
    "someExternal": this._someExternal.prettyWrite(),
    "anotherExternal": this._anotherExternal.prettyWrite(),
    "someList": this._someList,
    "someMapping": this._someMapping,
  };
}
