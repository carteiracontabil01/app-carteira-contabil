import '../database.dart';

class ProductsTable extends SupabaseTable<ProductsRow> {
  @override
  String get tableName => 'products';

  @override
  ProductsRow createRow(Map<String, dynamic> data) => ProductsRow(data);
}

class ProductsRow extends SupabaseDataRow {
  ProductsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProductsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name_pt');
  set name(String? value) => setField<String>('name_pt', value);

  String? get description => getField<String>('description_pt');
  set description(String? value) => setField<String>('description_pt', value);

  int? get categorie => getField<int>('categorie');
  set categorie(int? value) => setField<int>('categorie', value);

  List<String> get images => getListField<String>('images');
  set images(List<String>? value) => setListField<String>('images', value);

  double? get price => getField<double>('price');
  set price(double? value) => setField<double>('price', value);

  double? get priceOffer => getField<double>('priceOffer');
  set priceOffer(double? value) => setField<double>('priceOffer', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get unit => getField<String>('unit');
  set unit(String? value) => setField<String>('unit', value);

  String? get skuCode => getField<String>('skuCode');
  set skuCode(String? value) => setField<String>('skuCode', value);

  String? get barCode => getField<String>('barCode');
  set barCode(String? value) => setField<String>('barCode', value);

  bool? get offer => getField<bool>('offer');
  set offer(bool? value) => setField<bool>('offer', value);

  bool? get featured => getField<bool>('featured');
  set featured(bool? value) => setField<bool>('featured', value);

  bool? get active => getField<bool>('active');
  set active(bool? value) => setField<bool>('active', value);

  int? get stock => getField<int>('stock');
  set stock(int? value) => setField<int>('stock', value);

  String? get regulation => getField<String>('regulation');
  set regulation(String? value) => setField<String>('regulation', value);

  DateTime? get offerStart => getField<DateTime>('offerStart');
  set offerStart(DateTime? value) => setField<DateTime>('offerStart', value);

  DateTime? get offerEnd => getField<DateTime>('offerEnd');
  set offerEnd(DateTime? value) => setField<DateTime>('offerEnd', value);

  int? get idOffer => getField<int>('idOffer');
  set idOffer(int? value) => setField<int>('idOffer', value);

  int? get idBusiness => getField<int>('idBusiness');
  set idBusiness(int? value) => setField<int>('idBusiness', value);
}
