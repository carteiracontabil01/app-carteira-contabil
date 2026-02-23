// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class IdGrupoOfertaStruct extends BaseStruct {
  IdGrupoOfertaStruct({
    String? idGrupoOfert,
  }) : _idGrupoOfert = idGrupoOfert;

  // "id_grupo_ofert" field.
  String? _idGrupoOfert;
  String get idGrupoOfert => _idGrupoOfert ?? '';
  set idGrupoOfert(String? val) => _idGrupoOfert = val;

  bool hasIdGrupoOfert() => _idGrupoOfert != null;

  static IdGrupoOfertaStruct fromMap(Map<String, dynamic> data) =>
      IdGrupoOfertaStruct(
        idGrupoOfert: data['id_grupo_ofert'] as String?,
      );

  static IdGrupoOfertaStruct? maybeFromMap(dynamic data) => data is Map
      ? IdGrupoOfertaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id_grupo_ofert': _idGrupoOfert,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id_grupo_ofert': serializeParam(
          _idGrupoOfert,
          ParamType.String,
        ),
      }.withoutNulls;

  static IdGrupoOfertaStruct fromSerializableMap(Map<String, dynamic> data) =>
      IdGrupoOfertaStruct(
        idGrupoOfert: deserializeParam(
          data['id_grupo_ofert'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'IdGrupoOfertaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is IdGrupoOfertaStruct && idGrupoOfert == other.idGrupoOfert;
  }

  @override
  int get hashCode => const ListEquality().hash([idGrupoOfert]);
}

IdGrupoOfertaStruct createIdGrupoOfertaStruct({
  String? idGrupoOfert,
}) =>
    IdGrupoOfertaStruct(
      idGrupoOfert: idGrupoOfert,
    );
