import '../database.dart';

class GatewayBusinessTable extends SupabaseTable<GatewayBusinessRow> {
  @override
  String get tableName => 'gatewayBusiness';

  @override
  GatewayBusinessRow createRow(Map<String, dynamic> data) =>
      GatewayBusinessRow(data);
}

class GatewayBusinessRow extends SupabaseDataRow {
  GatewayBusinessRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GatewayBusinessTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  int? get idBusiness => getField<int>('idBusiness');
  set idBusiness(int? value) => setField<int>('idBusiness', value);

  int? get idGateway => getField<int>('idGateway');
  set idGateway(int? value) => setField<int>('idGateway', value);

  bool? get active => getField<bool>('active');
  set active(bool? value) => setField<bool>('active', value);
}
