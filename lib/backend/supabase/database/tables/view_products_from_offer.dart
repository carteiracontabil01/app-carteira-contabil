import '../database.dart';

class ViewProductsFromOfferTable
    extends SupabaseTable<ViewProductsFromOfferRow> {
  @override
  String get tableName => 'view_products_from_offer';

  @override
  ViewProductsFromOfferRow createRow(Map<String, dynamic> data) =>
      ViewProductsFromOfferRow(data);
}

class ViewProductsFromOfferRow extends SupabaseDataRow {
  ViewProductsFromOfferRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewProductsFromOfferTable();

  String? get productId => getField<String>('product_id');
  set productId(String? value) => setField<String>('product_id', value);

  DateTime? get productCreatedAt => getField<DateTime>('product_created_at');
  set productCreatedAt(DateTime? value) =>
      setField<DateTime>('product_created_at', value);

  String? get productName => getField<String>('product_name');
  set productName(String? value) => setField<String>('product_name', value);

  String? get productDescription => getField<String>('product_description');
  set productDescription(String? value) =>
      setField<String>('product_description', value);

  int? get productCategorie => getField<int>('product_categorie');
  set productCategorie(int? value) => setField<int>('product_categorie', value);

  List<String> get productImages => getListField<String>('product_images');
  set productImages(List<String>? value) =>
      setListField<String>('product_images', value);

  double? get productPrice => getField<double>('product_price');
  set productPrice(double? value) => setField<double>('product_price', value);

  double? get productPriceOffer => getField<double>('product_price_offer');
  set productPriceOffer(double? value) =>
      setField<double>('product_price_offer', value);

  String? get productType => getField<String>('product_type');
  set productType(String? value) => setField<String>('product_type', value);

  String? get unit => getField<String>('unit');
  set unit(String? value) => setField<String>('unit', value);

  String? get productSkuCode => getField<String>('product_sku_code');
  set productSkuCode(String? value) =>
      setField<String>('product_sku_code', value);

  String? get productBarCode => getField<String>('product_bar_code');
  set productBarCode(String? value) =>
      setField<String>('product_bar_code', value);

  bool? get productOffer => getField<bool>('product_offer');
  set productOffer(bool? value) => setField<bool>('product_offer', value);

  bool? get productFeatured => getField<bool>('product_featured');
  set productFeatured(bool? value) => setField<bool>('product_featured', value);

  bool? get productActive => getField<bool>('product_active');
  set productActive(bool? value) => setField<bool>('product_active', value);

  int? get productStock => getField<int>('product_stock');
  set productStock(int? value) => setField<int>('product_stock', value);

  String? get productRegulation => getField<String>('product_regulation');
  set productRegulation(String? value) =>
      setField<String>('product_regulation', value);

  DateTime? get productOfferStart => getField<DateTime>('product_offer_start');
  set productOfferStart(DateTime? value) =>
      setField<DateTime>('product_offer_start', value);

  DateTime? get productOfferEnd => getField<DateTime>('product_offer_end');
  set productOfferEnd(DateTime? value) =>
      setField<DateTime>('product_offer_end', value);

  int? get offerId => getField<int>('offer_id');
  set offerId(int? value) => setField<int>('offer_id', value);

  DateTime? get offerCreatedAt => getField<DateTime>('offer_created_at');
  set offerCreatedAt(DateTime? value) =>
      setField<DateTime>('offer_created_at', value);

  String? get offerName => getField<String>('offer_name');
  set offerName(String? value) => setField<String>('offer_name', value);

  String? get offerDescription => getField<String>('offer_description');
  set offerDescription(String? value) =>
      setField<String>('offer_description', value);

  String? get offerRegulation => getField<String>('offer_regulation');
  set offerRegulation(String? value) =>
      setField<String>('offer_regulation', value);

  String? get offerImage => getField<String>('offer_image');
  set offerImage(String? value) => setField<String>('offer_image', value);

  DateTime? get offerDateStart => getField<DateTime>('offer_date_start');
  set offerDateStart(DateTime? value) =>
      setField<DateTime>('offer_date_start', value);

  DateTime? get offerDateEnd => getField<DateTime>('offer_date_end');
  set offerDateEnd(DateTime? value) =>
      setField<DateTime>('offer_date_end', value);

  int? get offerIdBusiness => getField<int>('offer_id_business');
  set offerIdBusiness(int? value) => setField<int>('offer_id_business', value);

  String? get offerLocal => getField<String>('offer_local');
  set offerLocal(String? value) => setField<String>('offer_local', value);
}
