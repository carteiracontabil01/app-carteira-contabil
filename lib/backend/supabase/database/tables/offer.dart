import '../database.dart';

class OfferTable extends SupabaseTable<OfferRow> {
  @override
  String get tableName => 'offer';

  @override
  OfferRow createRow(Map<String, dynamic> data) => OfferRow(data);
}

class OfferRow extends SupabaseDataRow {
  OfferRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OfferTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get regulation => getField<String>('regulation');
  set regulation(String? value) => setField<String>('regulation', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);

  DateTime? get dateStart => getField<DateTime>('dateStart');
  set dateStart(DateTime? value) => setField<DateTime>('dateStart', value);

  DateTime? get dateEnd => getField<DateTime>('dateEnd');
  set dateEnd(DateTime? value) => setField<DateTime>('dateEnd', value);

  int? get idBusiness => getField<int>('idBusiness');
  set idBusiness(int? value) => setField<int>('idBusiness', value);

  String? get local => getField<String>('local');
  set local(String? value) => setField<String>('local', value);
}
