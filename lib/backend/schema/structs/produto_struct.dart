// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProdutoStruct extends BaseStruct {
  ProdutoStruct({
    String? id,
    String? nome,
    String? dataOfertaIni,
    String? dataOfertaFim,
    bool? isFavorito,
    double? valor,
    double? valorOferta,
    String? codigoSku,
    String? unidadeVenda,
    int? diteste,
  })  : _id = id,
        _nome = nome,
        _dataOfertaIni = dataOfertaIni,
        _dataOfertaFim = dataOfertaFim,
        _isFavorito = isFavorito,
        _valor = valor,
        _valorOferta = valorOferta,
        _codigoSku = codigoSku,
        _unidadeVenda = unidadeVenda,
        _diteste = diteste;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "data_oferta_ini" field.
  String? _dataOfertaIni;
  String get dataOfertaIni => _dataOfertaIni ?? '';
  set dataOfertaIni(String? val) => _dataOfertaIni = val;

  bool hasDataOfertaIni() => _dataOfertaIni != null;

  // "data_oferta_fim" field.
  String? _dataOfertaFim;
  String get dataOfertaFim => _dataOfertaFim ?? '';
  set dataOfertaFim(String? val) => _dataOfertaFim = val;

  bool hasDataOfertaFim() => _dataOfertaFim != null;

  // "isFavorito" field.
  bool? _isFavorito;
  bool get isFavorito => _isFavorito ?? false;
  set isFavorito(bool? val) => _isFavorito = val;

  bool hasIsFavorito() => _isFavorito != null;

  // "valor" field.
  double? _valor;
  double get valor => _valor ?? 0.0;
  set valor(double? val) => _valor = val;

  void incrementValor(double amount) => valor = valor + amount;

  bool hasValor() => _valor != null;

  // "valor_oferta" field.
  double? _valorOferta;
  double get valorOferta => _valorOferta ?? 0.0;
  set valorOferta(double? val) => _valorOferta = val;

  void incrementValorOferta(double amount) =>
      valorOferta = valorOferta + amount;

  bool hasValorOferta() => _valorOferta != null;

  // "codigo_sku" field.
  String? _codigoSku;
  String get codigoSku => _codigoSku ?? '';
  set codigoSku(String? val) => _codigoSku = val;

  bool hasCodigoSku() => _codigoSku != null;

  // "unidade_venda" field.
  String? _unidadeVenda;
  String get unidadeVenda => _unidadeVenda ?? '';
  set unidadeVenda(String? val) => _unidadeVenda = val;

  bool hasUnidadeVenda() => _unidadeVenda != null;

  // "diteste" field.
  int? _diteste;
  int get diteste => _diteste ?? 0;
  set diteste(int? val) => _diteste = val;

  void incrementDiteste(int amount) => diteste = diteste + amount;

  bool hasDiteste() => _diteste != null;

  static ProdutoStruct fromMap(Map<String, dynamic> data) => ProdutoStruct(
        id: data['id'] as String?,
        nome: data['nome'] as String?,
        dataOfertaIni: data['data_oferta_ini'] as String?,
        dataOfertaFim: data['data_oferta_fim'] as String?,
        isFavorito: data['isFavorito'] as bool?,
        valor: castToType<double>(data['valor']),
        valorOferta: castToType<double>(data['valor_oferta']),
        codigoSku: data['codigo_sku'] as String?,
        unidadeVenda: data['unidade_venda'] as String?,
        diteste: castToType<int>(data['diteste']),
      );

  static ProdutoStruct? maybeFromMap(dynamic data) =>
      data is Map ? ProdutoStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'nome': _nome,
        'data_oferta_ini': _dataOfertaIni,
        'data_oferta_fim': _dataOfertaFim,
        'isFavorito': _isFavorito,
        'valor': _valor,
        'valor_oferta': _valorOferta,
        'codigo_sku': _codigoSku,
        'unidade_venda': _unidadeVenda,
        'diteste': _diteste,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'data_oferta_ini': serializeParam(
          _dataOfertaIni,
          ParamType.String,
        ),
        'data_oferta_fim': serializeParam(
          _dataOfertaFim,
          ParamType.String,
        ),
        'isFavorito': serializeParam(
          _isFavorito,
          ParamType.bool,
        ),
        'valor': serializeParam(
          _valor,
          ParamType.double,
        ),
        'valor_oferta': serializeParam(
          _valorOferta,
          ParamType.double,
        ),
        'codigo_sku': serializeParam(
          _codigoSku,
          ParamType.String,
        ),
        'unidade_venda': serializeParam(
          _unidadeVenda,
          ParamType.String,
        ),
        'diteste': serializeParam(
          _diteste,
          ParamType.int,
        ),
      }.withoutNulls;

  static ProdutoStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProdutoStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        dataOfertaIni: deserializeParam(
          data['data_oferta_ini'],
          ParamType.String,
          false,
        ),
        dataOfertaFim: deserializeParam(
          data['data_oferta_fim'],
          ParamType.String,
          false,
        ),
        isFavorito: deserializeParam(
          data['isFavorito'],
          ParamType.bool,
          false,
        ),
        valor: deserializeParam(
          data['valor'],
          ParamType.double,
          false,
        ),
        valorOferta: deserializeParam(
          data['valor_oferta'],
          ParamType.double,
          false,
        ),
        codigoSku: deserializeParam(
          data['codigo_sku'],
          ParamType.String,
          false,
        ),
        unidadeVenda: deserializeParam(
          data['unidade_venda'],
          ParamType.String,
          false,
        ),
        diteste: deserializeParam(
          data['diteste'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'ProdutoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ProdutoStruct &&
        id == other.id &&
        nome == other.nome &&
        dataOfertaIni == other.dataOfertaIni &&
        dataOfertaFim == other.dataOfertaFim &&
        isFavorito == other.isFavorito &&
        valor == other.valor &&
        valorOferta == other.valorOferta &&
        codigoSku == other.codigoSku &&
        unidadeVenda == other.unidadeVenda &&
        diteste == other.diteste;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        nome,
        dataOfertaIni,
        dataOfertaFim,
        isFavorito,
        valor,
        valorOferta,
        codigoSku,
        unidadeVenda,
        diteste
      ]);
}

ProdutoStruct createProdutoStruct({
  String? id,
  String? nome,
  String? dataOfertaIni,
  String? dataOfertaFim,
  bool? isFavorito,
  double? valor,
  double? valorOferta,
  String? codigoSku,
  String? unidadeVenda,
  int? diteste,
}) =>
    ProdutoStruct(
      id: id,
      nome: nome,
      dataOfertaIni: dataOfertaIni,
      dataOfertaFim: dataOfertaFim,
      isFavorito: isFavorito,
      valor: valor,
      valorOferta: valorOferta,
      codigoSku: codigoSku,
      unidadeVenda: unidadeVenda,
      diteste: diteste,
    );
