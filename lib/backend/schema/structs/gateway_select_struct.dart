// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GatewaySelectStruct extends BaseStruct {
  GatewaySelectStruct({
    int? id,
    String? name,
    String? image,
  })  : _id = id,
        _name = name,
        _image = image;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  set image(String? val) => _image = val;

  bool hasImage() => _image != null;

  static GatewaySelectStruct fromMap(Map<String, dynamic> data) =>
      GatewaySelectStruct(
        id: castToType<int>(data['id']),
        name: data['name'] as String?,
        image: data['image'] as String?,
      );

  static GatewaySelectStruct? maybeFromMap(dynamic data) => data is Map
      ? GatewaySelectStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'image': _image,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'image': serializeParam(
          _image,
          ParamType.String,
        ),
      }.withoutNulls;

  static GatewaySelectStruct fromSerializableMap(Map<String, dynamic> data) =>
      GatewaySelectStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        image: deserializeParam(
          data['image'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'GatewaySelectStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is GatewaySelectStruct &&
        id == other.id &&
        name == other.name &&
        image == other.image;
  }

  @override
  int get hashCode => const ListEquality().hash([id, name, image]);
}

GatewaySelectStruct createGatewaySelectStruct({
  int? id,
  String? name,
  String? image,
}) =>
    GatewaySelectStruct(
      id: id,
      name: name,
      image: image,
    );
