// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PerfilUserStruct extends BaseStruct {
  PerfilUserStruct({
    String? tipo,
  }) : _tipo = tipo;

  // "tipo" field.
  String? _tipo;
  String get tipo => _tipo ?? '';
  set tipo(String? val) => _tipo = val;

  bool hasTipo() => _tipo != null;

  static PerfilUserStruct fromMap(Map<String, dynamic> data) =>
      PerfilUserStruct(
        tipo: data['tipo'] as String?,
      );

  static PerfilUserStruct? maybeFromMap(dynamic data) => data is Map
      ? PerfilUserStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'tipo': _tipo,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'tipo': serializeParam(
          _tipo,
          ParamType.String,
        ),
      }.withoutNulls;

  static PerfilUserStruct fromSerializableMap(Map<String, dynamic> data) =>
      PerfilUserStruct(
        tipo: deserializeParam(
          data['tipo'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PerfilUserStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PerfilUserStruct && tipo == other.tipo;
  }

  @override
  int get hashCode => const ListEquality().hash([tipo]);
}

PerfilUserStruct createPerfilUserStruct({
  String? tipo,
}) =>
    PerfilUserStruct(
      tipo: tipo,
    );
