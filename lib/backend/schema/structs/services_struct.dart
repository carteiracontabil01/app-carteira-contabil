// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ServicesStruct extends BaseStruct {
  ServicesStruct({
    String? nome,
    String? descricao,
    double? valor,
    double? valorPromo,
    double? valorCusto,
    DateTime? inicioOferta,
    DateTime? fimOferta,
    String? descricaoOferta,
    String? tituloOferta,
    bool? ofertaStatus,
    bool? destaqueStatus,
    bool? aprovacaoAuto,
    String? codigo,
    DateTime? tempoExecucao,
    DateTime? diasAntecedencia,
    DateTime? recorrencia,
    String? imagem,
  })  : _nome = nome,
        _descricao = descricao,
        _valor = valor,
        _valorPromo = valorPromo,
        _valorCusto = valorCusto,
        _inicioOferta = inicioOferta,
        _fimOferta = fimOferta,
        _descricaoOferta = descricaoOferta,
        _tituloOferta = tituloOferta,
        _ofertaStatus = ofertaStatus,
        _destaqueStatus = destaqueStatus,
        _aprovacaoAuto = aprovacaoAuto,
        _codigo = codigo,
        _tempoExecucao = tempoExecucao,
        _diasAntecedencia = diasAntecedencia,
        _recorrencia = recorrencia,
        _imagem = imagem;

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

  // "valor" field.
  double? _valor;
  double get valor => _valor ?? 0.0;
  set valor(double? val) => _valor = val;

  void incrementValor(double amount) => valor = valor + amount;

  bool hasValor() => _valor != null;

  // "valorPromo" field.
  double? _valorPromo;
  double get valorPromo => _valorPromo ?? 0.0;
  set valorPromo(double? val) => _valorPromo = val;

  void incrementValorPromo(double amount) => valorPromo = valorPromo + amount;

  bool hasValorPromo() => _valorPromo != null;

  // "valorCusto" field.
  double? _valorCusto;
  double get valorCusto => _valorCusto ?? 0.0;
  set valorCusto(double? val) => _valorCusto = val;

  void incrementValorCusto(double amount) => valorCusto = valorCusto + amount;

  bool hasValorCusto() => _valorCusto != null;

  // "inicioOferta" field.
  DateTime? _inicioOferta;
  DateTime? get inicioOferta => _inicioOferta;
  set inicioOferta(DateTime? val) => _inicioOferta = val;

  bool hasInicioOferta() => _inicioOferta != null;

  // "fimOferta" field.
  DateTime? _fimOferta;
  DateTime? get fimOferta => _fimOferta;
  set fimOferta(DateTime? val) => _fimOferta = val;

  bool hasFimOferta() => _fimOferta != null;

  // "descricaoOferta" field.
  String? _descricaoOferta;
  String get descricaoOferta => _descricaoOferta ?? '';
  set descricaoOferta(String? val) => _descricaoOferta = val;

  bool hasDescricaoOferta() => _descricaoOferta != null;

  // "tituloOferta" field.
  String? _tituloOferta;
  String get tituloOferta => _tituloOferta ?? '';
  set tituloOferta(String? val) => _tituloOferta = val;

  bool hasTituloOferta() => _tituloOferta != null;

  // "ofertaStatus" field.
  bool? _ofertaStatus;
  bool get ofertaStatus => _ofertaStatus ?? false;
  set ofertaStatus(bool? val) => _ofertaStatus = val;

  bool hasOfertaStatus() => _ofertaStatus != null;

  // "destaqueStatus" field.
  bool? _destaqueStatus;
  bool get destaqueStatus => _destaqueStatus ?? false;
  set destaqueStatus(bool? val) => _destaqueStatus = val;

  bool hasDestaqueStatus() => _destaqueStatus != null;

  // "aprovacaoAuto" field.
  bool? _aprovacaoAuto;
  bool get aprovacaoAuto => _aprovacaoAuto ?? false;
  set aprovacaoAuto(bool? val) => _aprovacaoAuto = val;

  bool hasAprovacaoAuto() => _aprovacaoAuto != null;

  // "codigo" field.
  String? _codigo;
  String get codigo => _codigo ?? '';
  set codigo(String? val) => _codigo = val;

  bool hasCodigo() => _codigo != null;

  // "tempoExecucao" field.
  DateTime? _tempoExecucao;
  DateTime? get tempoExecucao => _tempoExecucao;
  set tempoExecucao(DateTime? val) => _tempoExecucao = val;

  bool hasTempoExecucao() => _tempoExecucao != null;

  // "diasAntecedencia" field.
  DateTime? _diasAntecedencia;
  DateTime? get diasAntecedencia => _diasAntecedencia;
  set diasAntecedencia(DateTime? val) => _diasAntecedencia = val;

  bool hasDiasAntecedencia() => _diasAntecedencia != null;

  // "recorrencia" field.
  DateTime? _recorrencia;
  DateTime? get recorrencia => _recorrencia;
  set recorrencia(DateTime? val) => _recorrencia = val;

  bool hasRecorrencia() => _recorrencia != null;

  // "imagem" field.
  String? _imagem;
  String get imagem => _imagem ?? '';
  set imagem(String? val) => _imagem = val;

  bool hasImagem() => _imagem != null;

  static ServicesStruct fromMap(Map<String, dynamic> data) => ServicesStruct(
        nome: data['nome'] as String?,
        descricao: data['descricao'] as String?,
        valor: castToType<double>(data['valor']),
        valorPromo: castToType<double>(data['valorPromo']),
        valorCusto: castToType<double>(data['valorCusto']),
        inicioOferta: data['inicioOferta'] as DateTime?,
        fimOferta: data['fimOferta'] as DateTime?,
        descricaoOferta: data['descricaoOferta'] as String?,
        tituloOferta: data['tituloOferta'] as String?,
        ofertaStatus: data['ofertaStatus'] as bool?,
        destaqueStatus: data['destaqueStatus'] as bool?,
        aprovacaoAuto: data['aprovacaoAuto'] as bool?,
        codigo: data['codigo'] as String?,
        tempoExecucao: data['tempoExecucao'] as DateTime?,
        diasAntecedencia: data['diasAntecedencia'] as DateTime?,
        recorrencia: data['recorrencia'] as DateTime?,
        imagem: data['imagem'] as String?,
      );

  static ServicesStruct? maybeFromMap(dynamic data) =>
      data is Map ? ServicesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'descricao': _descricao,
        'valor': _valor,
        'valorPromo': _valorPromo,
        'valorCusto': _valorCusto,
        'inicioOferta': _inicioOferta,
        'fimOferta': _fimOferta,
        'descricaoOferta': _descricaoOferta,
        'tituloOferta': _tituloOferta,
        'ofertaStatus': _ofertaStatus,
        'destaqueStatus': _destaqueStatus,
        'aprovacaoAuto': _aprovacaoAuto,
        'codigo': _codigo,
        'tempoExecucao': _tempoExecucao,
        'diasAntecedencia': _diasAntecedencia,
        'recorrencia': _recorrencia,
        'imagem': _imagem,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'valor': serializeParam(
          _valor,
          ParamType.double,
        ),
        'valorPromo': serializeParam(
          _valorPromo,
          ParamType.double,
        ),
        'valorCusto': serializeParam(
          _valorCusto,
          ParamType.double,
        ),
        'inicioOferta': serializeParam(
          _inicioOferta,
          ParamType.DateTime,
        ),
        'fimOferta': serializeParam(
          _fimOferta,
          ParamType.DateTime,
        ),
        'descricaoOferta': serializeParam(
          _descricaoOferta,
          ParamType.String,
        ),
        'tituloOferta': serializeParam(
          _tituloOferta,
          ParamType.String,
        ),
        'ofertaStatus': serializeParam(
          _ofertaStatus,
          ParamType.bool,
        ),
        'destaqueStatus': serializeParam(
          _destaqueStatus,
          ParamType.bool,
        ),
        'aprovacaoAuto': serializeParam(
          _aprovacaoAuto,
          ParamType.bool,
        ),
        'codigo': serializeParam(
          _codigo,
          ParamType.String,
        ),
        'tempoExecucao': serializeParam(
          _tempoExecucao,
          ParamType.DateTime,
        ),
        'diasAntecedencia': serializeParam(
          _diasAntecedencia,
          ParamType.DateTime,
        ),
        'recorrencia': serializeParam(
          _recorrencia,
          ParamType.DateTime,
        ),
        'imagem': serializeParam(
          _imagem,
          ParamType.String,
        ),
      }.withoutNulls;

  static ServicesStruct fromSerializableMap(Map<String, dynamic> data) =>
      ServicesStruct(
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
        valor: deserializeParam(
          data['valor'],
          ParamType.double,
          false,
        ),
        valorPromo: deserializeParam(
          data['valorPromo'],
          ParamType.double,
          false,
        ),
        valorCusto: deserializeParam(
          data['valorCusto'],
          ParamType.double,
          false,
        ),
        inicioOferta: deserializeParam(
          data['inicioOferta'],
          ParamType.DateTime,
          false,
        ),
        fimOferta: deserializeParam(
          data['fimOferta'],
          ParamType.DateTime,
          false,
        ),
        descricaoOferta: deserializeParam(
          data['descricaoOferta'],
          ParamType.String,
          false,
        ),
        tituloOferta: deserializeParam(
          data['tituloOferta'],
          ParamType.String,
          false,
        ),
        ofertaStatus: deserializeParam(
          data['ofertaStatus'],
          ParamType.bool,
          false,
        ),
        destaqueStatus: deserializeParam(
          data['destaqueStatus'],
          ParamType.bool,
          false,
        ),
        aprovacaoAuto: deserializeParam(
          data['aprovacaoAuto'],
          ParamType.bool,
          false,
        ),
        codigo: deserializeParam(
          data['codigo'],
          ParamType.String,
          false,
        ),
        tempoExecucao: deserializeParam(
          data['tempoExecucao'],
          ParamType.DateTime,
          false,
        ),
        diasAntecedencia: deserializeParam(
          data['diasAntecedencia'],
          ParamType.DateTime,
          false,
        ),
        recorrencia: deserializeParam(
          data['recorrencia'],
          ParamType.DateTime,
          false,
        ),
        imagem: deserializeParam(
          data['imagem'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ServicesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ServicesStruct &&
        nome == other.nome &&
        descricao == other.descricao &&
        valor == other.valor &&
        valorPromo == other.valorPromo &&
        valorCusto == other.valorCusto &&
        inicioOferta == other.inicioOferta &&
        fimOferta == other.fimOferta &&
        descricaoOferta == other.descricaoOferta &&
        tituloOferta == other.tituloOferta &&
        ofertaStatus == other.ofertaStatus &&
        destaqueStatus == other.destaqueStatus &&
        aprovacaoAuto == other.aprovacaoAuto &&
        codigo == other.codigo &&
        tempoExecucao == other.tempoExecucao &&
        diasAntecedencia == other.diasAntecedencia &&
        recorrencia == other.recorrencia &&
        imagem == other.imagem;
  }

  @override
  int get hashCode => const ListEquality().hash([
        nome,
        descricao,
        valor,
        valorPromo,
        valorCusto,
        inicioOferta,
        fimOferta,
        descricaoOferta,
        tituloOferta,
        ofertaStatus,
        destaqueStatus,
        aprovacaoAuto,
        codigo,
        tempoExecucao,
        diasAntecedencia,
        recorrencia,
        imagem
      ]);
}

ServicesStruct createServicesStruct({
  String? nome,
  String? descricao,
  double? valor,
  double? valorPromo,
  double? valorCusto,
  DateTime? inicioOferta,
  DateTime? fimOferta,
  String? descricaoOferta,
  String? tituloOferta,
  bool? ofertaStatus,
  bool? destaqueStatus,
  bool? aprovacaoAuto,
  String? codigo,
  DateTime? tempoExecucao,
  DateTime? diasAntecedencia,
  DateTime? recorrencia,
  String? imagem,
}) =>
    ServicesStruct(
      nome: nome,
      descricao: descricao,
      valor: valor,
      valorPromo: valorPromo,
      valorCusto: valorCusto,
      inicioOferta: inicioOferta,
      fimOferta: fimOferta,
      descricaoOferta: descricaoOferta,
      tituloOferta: tituloOferta,
      ofertaStatus: ofertaStatus,
      destaqueStatus: destaqueStatus,
      aprovacaoAuto: aprovacaoAuto,
      codigo: codigo,
      tempoExecucao: tempoExecucao,
      diasAntecedencia: diasAntecedencia,
      recorrencia: recorrencia,
      imagem: imagem,
    );
