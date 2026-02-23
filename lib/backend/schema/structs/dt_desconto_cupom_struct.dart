// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DtDescontoCupomStruct extends BaseStruct {
  DtDescontoCupomStruct({
    double? valorDesc,
    String? cupom,
  })  : _valorDesc = valorDesc,
        _cupom = cupom;

  // "valorDesc" field.
  double? _valorDesc;
  double get valorDesc => _valorDesc ?? 0.0;
  set valorDesc(double? val) => _valorDesc = val;

  void incrementValorDesc(double amount) => valorDesc = valorDesc + amount;

  bool hasValorDesc() => _valorDesc != null;

  // "cupom" field.
  String? _cupom;
  String get cupom => _cupom ?? '';
  set cupom(String? val) => _cupom = val;

  bool hasCupom() => _cupom != null;

  static DtDescontoCupomStruct fromMap(Map<String, dynamic> data) =>
      DtDescontoCupomStruct(
        valorDesc: castToType<double>(data['valorDesc']),
        cupom: data['cupom'] as String?,
      );

  static DtDescontoCupomStruct? maybeFromMap(dynamic data) => data is Map
      ? DtDescontoCupomStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'valorDesc': _valorDesc,
        'cupom': _cupom,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'valorDesc': serializeParam(
          _valorDesc,
          ParamType.double,
        ),
        'cupom': serializeParam(
          _cupom,
          ParamType.String,
        ),
      }.withoutNulls;

  static DtDescontoCupomStruct fromSerializableMap(Map<String, dynamic> data) =>
      DtDescontoCupomStruct(
        valorDesc: deserializeParam(
          data['valorDesc'],
          ParamType.double,
          false,
        ),
        cupom: deserializeParam(
          data['cupom'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DtDescontoCupomStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DtDescontoCupomStruct &&
        valorDesc == other.valorDesc &&
        cupom == other.cupom;
  }

  @override
  int get hashCode => const ListEquality().hash([valorDesc, cupom]);
}

DtDescontoCupomStruct createDtDescontoCupomStruct({
  double? valorDesc,
  String? cupom,
}) =>
    DtDescontoCupomStruct(
      valorDesc: valorDesc,
      cupom: cupom,
    );
