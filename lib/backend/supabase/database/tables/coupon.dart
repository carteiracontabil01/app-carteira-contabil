import '../database.dart';

class CouponTable extends SupabaseTable<CouponRow> {
  @override
  String get tableName => 'discounts';

  @override
  CouponRow createRow(Map<String, dynamic> data) => CouponRow(data);
}

class CouponRow extends SupabaseDataRow {
  CouponRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CouponTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get code => getField<String>('code');
  set code(String? value) => setField<String>('code', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  double? get value => getField<double>('value');
  set value(double? val) => setField<double>('value', val);

  double? get minimumAmount => getField<double>('minimum_amount');
  set minimumAmount(double? value) => setField<double>('minimum_amount', value);

  int? get usageLimit => getField<int>('usage_limit');
  set usageLimit(int? value) => setField<int>('usage_limit', value);

  int? get usedCount => getField<int>('used_count');
  set usedCount(int? value) => setField<int>('used_count', value);

  DateTime? get validFrom => getField<DateTime>('valid_from');
  set validFrom(DateTime? value) => setField<DateTime>('valid_from', value);

  DateTime? get validUntil => getField<DateTime>('valid_until');
  set validUntil(DateTime? value) => setField<DateTime>('valid_until', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  String? get titlePt => getField<String>('title_pt');
  set titlePt(String? value) => setField<String>('title_pt', value);

  String? get titleEn => getField<String>('title_en');
  set titleEn(String? value) => setField<String>('title_en', value);

  String? get titleEs => getField<String>('title_es');
  set titleEs(String? value) => setField<String>('title_es', value);

  String? get descriptionPt => getField<String>('description_pt');
  set descriptionPt(String? value) => setField<String>('description_pt', value);

  String? get descriptionEn => getField<String>('description_en');
  set descriptionEn(String? value) => setField<String>('description_en', value);

  String? get descriptionEs => getField<String>('description_es');
  set descriptionEs(String? value) => setField<String>('description_es', value);

  String? get categoryId => getField<String>('category_id');
  set categoryId(String? value) => setField<String>('category_id', value);

  int? get orderIndex => getField<int>('order_index');
  set orderIndex(int? value) => setField<int>('order_index', value);

  int? get discountPercentage => getField<int>('discount_percentage');
  set discountPercentage(int? value) =>
      setField<int>('discount_percentage', value);

  String? get termsPt => getField<String>('terms_pt');
  set termsPt(String? value) => setField<String>('terms_pt', value);

  String? get termsEn => getField<String>('terms_en');
  set termsEn(String? value) => setField<String>('terms_en', value);

  String? get termsEs => getField<String>('terms_es');
  set termsEs(String? value) => setField<String>('terms_es', value);

  int? get maxUsesPerUser => getField<int>('max_uses_per_user');
  set maxUsesPerUser(int? value) => setField<int>('max_uses_per_user', value);

  bool? get appliesToFirstPurchaseOnly =>
      getField<bool>('applies_to_first_purchase_only');
  set appliesToFirstPurchaseOnly(bool? value) =>
      setField<bool>('applies_to_first_purchase_only', value);

  bool? get stackable => getField<bool>('stackable');
  set stackable(bool? value) => setField<bool>('stackable', value);

  String? get tenantId => getField<String>('tenant_id');
  set tenantId(String? value) => setField<String>('tenant_id', value);
}
