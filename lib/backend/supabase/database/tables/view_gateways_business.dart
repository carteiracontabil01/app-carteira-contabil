import '../database.dart';

class ViewGatewaysBusinessTable extends SupabaseTable<ViewGatewaysBusinessRow> {
  @override
  String get tableName => 'view_gateways_business';

  @override
  ViewGatewaysBusinessRow createRow(Map<String, dynamic> data) =>
      ViewGatewaysBusinessRow(data);
}

class ViewGatewaysBusinessRow extends SupabaseDataRow {
  ViewGatewaysBusinessRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewGatewaysBusinessTable();

  int? get gatewayId => getField<int>('gateway_id');
  set gatewayId(int? value) => setField<int>('gateway_id', value);

  DateTime? get gatewayCreatedAt => getField<DateTime>('gateway_created_at');
  set gatewayCreatedAt(DateTime? value) =>
      setField<DateTime>('gateway_created_at', value);

  String? get gatewayNome => getField<String>('gateway_nome');
  set gatewayNome(String? value) => setField<String>('gateway_nome', value);

  String? get gatewayDetalhes => getField<String>('gateway_detalhes');
  set gatewayDetalhes(String? value) =>
      setField<String>('gateway_detalhes', value);

  String? get gatewayImagem => getField<String>('gateway_imagem');
  set gatewayImagem(String? value) => setField<String>('gateway_imagem', value);

  bool? get gatewayOnline => getField<bool>('gateway_online');
  set gatewayOnline(bool? value) => setField<bool>('gateway_online', value);

  int? get gatewayBusinessId => getField<int>('gateway_business_id');
  set gatewayBusinessId(int? value) =>
      setField<int>('gateway_business_id', value);

  DateTime? get gatewayBusinessCreatedAt =>
      getField<DateTime>('gateway_business_created_at');
  set gatewayBusinessCreatedAt(DateTime? value) =>
      setField<DateTime>('gateway_business_created_at', value);

  int? get gatewayBusinessIdEmpresa =>
      getField<int>('gateway_business_id_empresa');
  set gatewayBusinessIdEmpresa(int? value) =>
      setField<int>('gateway_business_id_empresa', value);

  int? get gatewayBusinessIdGateway =>
      getField<int>('gateway_business_id_gateway');
  set gatewayBusinessIdGateway(int? value) =>
      setField<int>('gateway_business_id_gateway', value);

  bool? get gatewayBusinessAtivo => getField<bool>('gateway_business_ativo');
  set gatewayBusinessAtivo(bool? value) =>
      setField<bool>('gateway_business_ativo', value);
}
