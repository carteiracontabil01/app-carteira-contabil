// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BannersStruct extends BaseStruct {
  BannersStruct({
    String? localapp,
    String? imagem,
    String? idOfertagrupo,
  })  : _localapp = localapp,
        _imagem = imagem,
        _idOfertagrupo = idOfertagrupo;

  // "localapp" field.
  String? _localapp;
  String get localapp => _localapp ?? '';
  set localapp(String? val) => _localapp = val;

  bool hasLocalapp() => _localapp != null;

  // "imagem" field.
  String? _imagem;
  String get imagem => _imagem ?? '';
  set imagem(String? val) => _imagem = val;

  bool hasImagem() => _imagem != null;

  // "id_ofertagrupo" field.
  String? _idOfertagrupo;
  String get idOfertagrupo => _idOfertagrupo ?? '';
  set idOfertagrupo(String? val) => _idOfertagrupo = val;

  bool hasIdOfertagrupo() => _idOfertagrupo != null;

  static BannersStruct fromMap(Map<String, dynamic> data) => BannersStruct(
        localapp: data['localapp'] as String?,
        imagem: data['imagem'] as String?,
        idOfertagrupo: data['id_ofertagrupo'] as String?,
      );

  static BannersStruct? maybeFromMap(dynamic data) =>
      data is Map ? BannersStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'localapp': _localapp,
        'imagem': _imagem,
        'id_ofertagrupo': _idOfertagrupo,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'localapp': serializeParam(
          _localapp,
          ParamType.String,
        ),
        'imagem': serializeParam(
          _imagem,
          ParamType.String,
        ),
        'id_ofertagrupo': serializeParam(
          _idOfertagrupo,
          ParamType.String,
        ),
      }.withoutNulls;

  static BannersStruct fromSerializableMap(Map<String, dynamic> data) =>
      BannersStruct(
        localapp: deserializeParam(
          data['localapp'],
          ParamType.String,
          false,
        ),
        imagem: deserializeParam(
          data['imagem'],
          ParamType.String,
          false,
        ),
        idOfertagrupo: deserializeParam(
          data['id_ofertagrupo'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'BannersStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is BannersStruct &&
        localapp == other.localapp &&
        imagem == other.imagem &&
        idOfertagrupo == other.idOfertagrupo;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([localapp, imagem, idOfertagrupo]);
}

BannersStruct createBannersStruct({
  String? localapp,
  String? imagem,
  String? idOfertagrupo,
}) =>
    BannersStruct(
      localapp: localapp,
      imagem: imagem,
      idOfertagrupo: idOfertagrupo,
    );
