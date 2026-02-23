import '../database.dart';

class InsertsTable extends SupabaseTable<InsertsRow> {
  @override
  String get tableName => 'inserts';

  @override
  InsertsRow createRow(Map<String, dynamic> data) => InsertsRow(data);
}

class InsertsRow extends SupabaseDataRow {
  InsertsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => InsertsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  int? get idBusiness => getField<int>('idBusiness');
  set idBusiness(int? value) => setField<int>('idBusiness', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  DateTime? get dateStart => getField<DateTime>('dateStart');
  set dateStart(DateTime? value) => setField<DateTime>('dateStart', value);

  DateTime? get dateEnd => getField<DateTime>('dateEnd');
  set dateEnd(DateTime? value) => setField<DateTime>('dateEnd', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);
}
