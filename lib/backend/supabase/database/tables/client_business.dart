import '../database.dart';

class ClientBusinessTable extends SupabaseTable<ClientBusinessRow> {
  @override
  String get tableName => 'clientBusiness';

  @override
  ClientBusinessRow createRow(Map<String, dynamic> data) =>
      ClientBusinessRow(data);
}

class ClientBusinessRow extends SupabaseDataRow {
  ClientBusinessRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ClientBusinessTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  int? get idClient => getField<int>('idClient');
  set idClient(int? value) => setField<int>('idClient', value);

  int? get idBusiness => getField<int>('idBusiness');
  set idBusiness(int? value) => setField<int>('idBusiness', value);
}
