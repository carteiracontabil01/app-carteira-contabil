import '../database.dart';

class GatewaysTable extends SupabaseTable<GatewaysRow> {
  @override
  String get tableName => 'gateways';

  @override
  GatewaysRow createRow(Map<String, dynamic> data) => GatewaysRow(data);
}

class GatewaysRow extends SupabaseDataRow {
  GatewaysRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GatewaysTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get details => getField<String>('details');
  set details(String? value) => setField<String>('details', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);

  bool? get online => getField<bool>('online');
  set online(bool? value) => setField<bool>('online', value);

  String? get tipo => getField<String>('tipo');
  set tipo(String? value) => setField<String>('tipo', value);
}
