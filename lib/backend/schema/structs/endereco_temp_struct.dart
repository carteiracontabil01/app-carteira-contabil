// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EnderecoTempStruct extends BaseStruct {
  EnderecoTempStruct({
    String? cep,
    String? logradouro,
    String? endNum,
    String? complemento,
    String? bairro,
    String? cidade,
    String? estado,
    LatLng? latlng,
    String? address,
  })  : _cep = cep,
        _logradouro = logradouro,
        _endNum = endNum,
        _complemento = complemento,
        _bairro = bairro,
        _cidade = cidade,
        _estado = estado,
        _latlng = latlng,
        _address = address;

  // "cep" field.
  String? _cep;
  String get cep => _cep ?? '';
  set cep(String? val) => _cep = val;

  bool hasCep() => _cep != null;

  // "logradouro" field.
  String? _logradouro;
  String get logradouro => _logradouro ?? '';
  set logradouro(String? val) => _logradouro = val;

  bool hasLogradouro() => _logradouro != null;

  // "endNum" field.
  String? _endNum;
  String get endNum => _endNum ?? '';
  set endNum(String? val) => _endNum = val;

  bool hasEndNum() => _endNum != null;

  // "complemento" field.
  String? _complemento;
  String get complemento => _complemento ?? '';
  set complemento(String? val) => _complemento = val;

  bool hasComplemento() => _complemento != null;

  // "bairro" field.
  String? _bairro;
  String get bairro => _bairro ?? '';
  set bairro(String? val) => _bairro = val;

  bool hasBairro() => _bairro != null;

  // "cidade" field.
  String? _cidade;
  String get cidade => _cidade ?? '';
  set cidade(String? val) => _cidade = val;

  bool hasCidade() => _cidade != null;

  // "estado" field.
  String? _estado;
  String get estado => _estado ?? '';
  set estado(String? val) => _estado = val;

  bool hasEstado() => _estado != null;

  // "latlng" field.
  LatLng? _latlng;
  LatLng? get latlng => _latlng;
  set latlng(LatLng? val) => _latlng = val;

  bool hasLatlng() => _latlng != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  set address(String? val) => _address = val;

  bool hasAddress() => _address != null;

  static EnderecoTempStruct fromMap(Map<String, dynamic> data) =>
      EnderecoTempStruct(
        cep: data['cep'] as String?,
        logradouro: data['logradouro'] as String?,
        endNum: data['endNum'] as String?,
        complemento: data['complemento'] as String?,
        bairro: data['bairro'] as String?,
        cidade: data['cidade'] as String?,
        estado: data['estado'] as String?,
        latlng: data['latlng'] as LatLng?,
        address: data['address'] as String?,
      );

  static EnderecoTempStruct? maybeFromMap(dynamic data) => data is Map
      ? EnderecoTempStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'cep': _cep,
        'logradouro': _logradouro,
        'endNum': _endNum,
        'complemento': _complemento,
        'bairro': _bairro,
        'cidade': _cidade,
        'estado': _estado,
        'latlng': _latlng,
        'address': _address,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'cep': serializeParam(
          _cep,
          ParamType.String,
        ),
        'logradouro': serializeParam(
          _logradouro,
          ParamType.String,
        ),
        'endNum': serializeParam(
          _endNum,
          ParamType.String,
        ),
        'complemento': serializeParam(
          _complemento,
          ParamType.String,
        ),
        'bairro': serializeParam(
          _bairro,
          ParamType.String,
        ),
        'cidade': serializeParam(
          _cidade,
          ParamType.String,
        ),
        'estado': serializeParam(
          _estado,
          ParamType.String,
        ),
        'latlng': serializeParam(
          _latlng,
          ParamType.LatLng,
        ),
        'address': serializeParam(
          _address,
          ParamType.String,
        ),
      }.withoutNulls;

  static EnderecoTempStruct fromSerializableMap(Map<String, dynamic> data) =>
      EnderecoTempStruct(
        cep: deserializeParam(
          data['cep'],
          ParamType.String,
          false,
        ),
        logradouro: deserializeParam(
          data['logradouro'],
          ParamType.String,
          false,
        ),
        endNum: deserializeParam(
          data['endNum'],
          ParamType.String,
          false,
        ),
        complemento: deserializeParam(
          data['complemento'],
          ParamType.String,
          false,
        ),
        bairro: deserializeParam(
          data['bairro'],
          ParamType.String,
          false,
        ),
        cidade: deserializeParam(
          data['cidade'],
          ParamType.String,
          false,
        ),
        estado: deserializeParam(
          data['estado'],
          ParamType.String,
          false,
        ),
        latlng: deserializeParam(
          data['latlng'],
          ParamType.LatLng,
          false,
        ),
        address: deserializeParam(
          data['address'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'EnderecoTempStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is EnderecoTempStruct &&
        cep == other.cep &&
        logradouro == other.logradouro &&
        endNum == other.endNum &&
        complemento == other.complemento &&
        bairro == other.bairro &&
        cidade == other.cidade &&
        estado == other.estado &&
        latlng == other.latlng &&
        address == other.address;
  }

  @override
  int get hashCode => const ListEquality().hash([
        cep,
        logradouro,
        endNum,
        complemento,
        bairro,
        cidade,
        estado,
        latlng,
        address
      ]);
}

EnderecoTempStruct createEnderecoTempStruct({
  String? cep,
  String? logradouro,
  String? endNum,
  String? complemento,
  String? bairro,
  String? cidade,
  String? estado,
  LatLng? latlng,
  String? address,
}) =>
    EnderecoTempStruct(
      cep: cep,
      logradouro: logradouro,
      endNum: endNum,
      complemento: complemento,
      bairro: bairro,
      cidade: cidade,
      estado: estado,
      latlng: latlng,
      address: address,
    );
