import 'dart:convert';
import 'package:json_serializable_generator/json_model.dart';
import 'package:json_serializable_generator/json_serializable.dart';
import './ExternalResource.model.dart';
import './SimpleSchema.model.dart';
import './subFolder/SecondExternalResource.dart';

class Example extends JsonModel {
  final String _id;
  final bool _isRequired;
  final int _count;
  final SimpleSchema _simpleSchema;
  final ExternalResource _someExternal;
  final SecondExternalResource _anotherExternal;
  final List<String> _someList;
  final Map<String, int> _someMapping;

  Example({
    String id,
    bool isRequired,
    int count,
    SimpleSchema simpleSchema,
    ExternalResource someExternal,
    SecondExternalResource anotherExternal,
    List<String> someList,
    Map<String, int> someMapping,
  }) :
    _id = id,
    _isRequired = isRequired,
    _count = count,
    _simpleSchema = simpleSchema,
    _someExternal = someExternal,
    _anotherExternal = anotherExternal,
    _someList = someList,
    _someMapping = someMapping;


  String get id => _id;
  bool get isRequired => _isRequired;
  int get count => _count;
  SimpleSchema get simpleSchema => _simpleSchema;
  ExternalResource get someExternal => _someExternal;
  SecondExternalResource get anotherExternal => _anotherExternal;
  List<String> get someList => _someList;
  Map<String, int> get someMapping => _someMapping;
  
  @override
  Example fromJson(Map<String, dynamic> json) => Example(
    id: JsonSerializable.fromJson<String>(json['id'].toString()),
    isRequired: JsonSerializable.fromJson<bool>(json['isRequired'].toString()),
    count: JsonSerializable.fromJson<int>(json['count'].toString()),
    simpleSchema: JsonSerializable.fromJson<SimpleSchema>(jsonEncode(json['simpleSchema']), seed: SimpleSchema()),
    someExternal: ExternalResource.prettyRead(json['someExternal']),
    anotherExternal: SecondExternalResource.prettyRead(json['anotherExternal']),
    someList: JsonSerializable.fromJsArray<String>(jsonEncode(json['someList'])),
    someMapping: JsonSerializable.typedMapFromObject< int>(jsonEncode(json['someMapping'])),
  );

  Example copy({
    String id,
    bool isRequired,
    int count,
    SimpleSchema simpleSchema,
    ExternalResource someExternal,
    SecondExternalResource anotherExternal,
    List<String> someList,
    Map<String, int> someMapping,
  }) => Example(
    id: id ?? _id,
    isRequired: isRequired ?? _isRequired,
    count: count ?? _count,
    simpleSchema: simpleSchema ?? _simpleSchema,
    someExternal: someExternal ?? _someExternal,
    anotherExternal: anotherExternal ?? _anotherExternal,
    someList: someList ?? _someList,
    someMapping: someMapping ?? _someMapping,
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': _id,
    'isRequired': _isRequired,
    'count': _count,
    'simpleSchema': _simpleSchema.toJson(),
    'someExternal': _someExternal.prettyWrite(),
    'anotherExternal': _anotherExternal.prettyWrite(),
    'someList': _someList,
    'someMapping': _someMapping,
  };
}
