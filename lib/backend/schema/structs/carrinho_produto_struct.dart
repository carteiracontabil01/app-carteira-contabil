// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CarrinhoProdutoStruct extends BaseStruct {
  CarrinhoProdutoStruct({
    double? valor,
    double? valorUnit,
    int? quantidade,
    int? idCarrinho,
    String? nome,
    String? descricao,
    String? idproduto,
    List<String>? images,
  })  : _valor = valor,
        _valorUnit = valorUnit,
        _quantidade = quantidade,
        _idCarrinho = idCarrinho,
        _nome = nome,
        _descricao = descricao,
        _idproduto = idproduto,
        _images = images;

  // "valor" field.
  double? _valor;
  double get valor => _valor ?? 0.0;
  set valor(double? val) => _valor = val;

  void incrementValor(double amount) => valor = valor + amount;

  bool hasValor() => _valor != null;

  // "valor_unit" field.
  double? _valorUnit;
  double get valorUnit => _valorUnit ?? 0.0;
  set valorUnit(double? val) => _valorUnit = val;

  void incrementValorUnit(double amount) => valorUnit = valorUnit + amount;

  bool hasValorUnit() => _valorUnit != null;

  // "quantidade" field.
  int? _quantidade;
  int get quantidade => _quantidade ?? 0;
  set quantidade(int? val) => _quantidade = val;

  void incrementQuantidade(int amount) => quantidade = quantidade + amount;

  bool hasQuantidade() => _quantidade != null;

  // "id_carrinho" field.
  int? _idCarrinho;
  int get idCarrinho => _idCarrinho ?? 0;
  set idCarrinho(int? val) => _idCarrinho = val;

  void incrementIdCarrinho(int amount) => idCarrinho = idCarrinho + amount;

  bool hasIdCarrinho() => _idCarrinho != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "idproduto" field.
  String? _idproduto;
  String get idproduto => _idproduto ?? '';
  set idproduto(String? val) => _idproduto = val;

  bool hasIdproduto() => _idproduto != null;

  // "images" field.
  List<String>? _images;
  List<String> get images => _images ?? const [];
  set images(List<String>? val) => _images = val;

  void updateImages(Function(List<String>) updateFn) {
    updateFn(_images ??= []);
  }

  bool hasImages() => _images != null;

  static CarrinhoProdutoStruct fromMap(Map<String, dynamic> data) =>
      CarrinhoProdutoStruct(
        valor: castToType<double>(data['valor']),
        valorUnit: castToType<double>(data['valor_unit']),
        quantidade: castToType<int>(data['quantidade']),
        idCarrinho: castToType<int>(data['id_carrinho']),
        nome: data['nome'] as String?,
        descricao: data['descricao'] as String?,
        idproduto: data['idproduto'] as String?,
        images: getDataList(data['images']),
      );

  static CarrinhoProdutoStruct? maybeFromMap(dynamic data) => data is Map
      ? CarrinhoProdutoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'valor': _valor,
        'valor_unit': _valorUnit,
        'quantidade': _quantidade,
        'id_carrinho': _idCarrinho,
        'nome': _nome,
        'descricao': _descricao,
        'idproduto': _idproduto,
        'images': _images,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'valor': serializeParam(
          _valor,
          ParamType.double,
        ),
        'valor_unit': serializeParam(
          _valorUnit,
          ParamType.double,
        ),
        'quantidade': serializeParam(
          _quantidade,
          ParamType.int,
        ),
        'id_carrinho': serializeParam(
          _idCarrinho,
          ParamType.int,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'idproduto': serializeParam(
          _idproduto,
          ParamType.String,
        ),
        'images': serializeParam(
          _images,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static CarrinhoProdutoStruct fromSerializableMap(Map<String, dynamic> data) =>
      CarrinhoProdutoStruct(
        valor: deserializeParam(
          data['valor'],
          ParamType.double,
          false,
        ),
        valorUnit: deserializeParam(
          data['valor_unit'],
          ParamType.double,
          false,
        ),
        quantidade: deserializeParam(
          data['quantidade'],
          ParamType.int,
          false,
        ),
        idCarrinho: deserializeParam(
          data['id_carrinho'],
          ParamType.int,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        idproduto: deserializeParam(
          data['idproduto'],
          ParamType.String,
          false,
        ),
        images: deserializeParam<String>(
          data['images'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'CarrinhoProdutoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CarrinhoProdutoStruct &&
        valor == other.valor &&
        valorUnit == other.valorUnit &&
        quantidade == other.quantidade &&
        idCarrinho == other.idCarrinho &&
        nome == other.nome &&
        descricao == other.descricao &&
        idproduto == other.idproduto &&
        listEquality.equals(images, other.images);
  }

  @override
  int get hashCode => const ListEquality().hash([
        valor,
        valorUnit,
        quantidade,
        idCarrinho,
        nome,
        descricao,
        idproduto,
        images
      ]);
}

CarrinhoProdutoStruct createCarrinhoProdutoStruct({
  double? valor,
  double? valorUnit,
  int? quantidade,
  int? idCarrinho,
  String? nome,
  String? descricao,
  String? idproduto,
}) =>
    CarrinhoProdutoStruct(
      valor: valor,
      valorUnit: valorUnit,
      quantidade: quantidade,
      idCarrinho: idCarrinho,
      nome: nome,
      descricao: descricao,
      idproduto: idproduto,
    );
