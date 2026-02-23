import '../database.dart';

class BannersTable extends SupabaseTable<BannersRow> {
  @override
  String get tableName => 'banners';

  @override
  BannersRow createRow(Map<String, dynamic> data) => BannersRow(data);
}

class BannersRow extends SupabaseDataRow {
  BannersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BannersTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  int? get idBusiness => getField<int>('idBusiness');
  set idBusiness(int? value) => setField<int>('idBusiness', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get locationApp => getField<String>('locationApp');
  set locationApp(String? value) => setField<String>('locationApp', value);

  String? get link => getField<String>('link');
  set link(String? value) => setField<String>('link', value);

  DateTime? get dateStart => getField<DateTime>('dateStart');
  set dateStart(DateTime? value) => setField<DateTime>('dateStart', value);

  DateTime? get dateEnd => getField<DateTime>('dateEnd');
  set dateEnd(DateTime? value) => setField<DateTime>('dateEnd', value);

  int? get idCategorie => getField<int>('idCategorie');
  set idCategorie(int? value) => setField<int>('idCategorie', value);

  int? get idOffer => getField<int>('idOffer');
  set idOffer(int? value) => setField<int>('idOffer', value);

  int? get idProduct => getField<int>('idProduct');
  set idProduct(int? value) => setField<int>('idProduct', value);
}
