import '../database.dart';

class BusinessSettingsTable extends SupabaseTable<BusinessSettingsRow> {
  @override
  String get tableName => 'business_settings';

  @override
  BusinessSettingsRow createRow(Map<String, dynamic> data) =>
      BusinessSettingsRow(data);
}

class BusinessSettingsRow extends SupabaseDataRow {
  BusinessSettingsRow(super.data);

  @override
  SupabaseTable get table => BusinessSettingsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get tenantId => getField<String>('tenant_id')!;
  set tenantId(String value) => setField<String>('tenant_id', value);

  int get deliveryTimeMin => getField<int>('delivery_time_min') ?? 30;
  set deliveryTimeMin(int value) => setField<int>('delivery_time_min', value);

  int get deliveryTimeMax => getField<int>('delivery_time_max') ?? 45;
  set deliveryTimeMax(int value) => setField<int>('delivery_time_max', value);

  double get minimumOrderValue =>
      getField<double>('minimum_order_value') ?? 25.00;
  set minimumOrderValue(double value) =>
      setField<double>('minimum_order_value', value);

  String get businessType => getField<String>('business_type') ?? 'delivery';
  set businessType(String value) => setField<String>('business_type', value);

  String? get termsUse => getField<String>('terms_use');
  set termsUse(String? value) => setField<String>('terms_use', value);

  String? get privacyPolicy => getField<String>('privacy_policy');
  set privacyPolicy(String? value) => setField<String>('privacy_policy', value);

  String? get returnPolicy => getField<String>('return_policy');
  set returnPolicy(String? value) => setField<String>('return_policy', value);

  DateTime get createdAt => DateTime.parse(getField<String>('created_at')!);
  set createdAt(DateTime value) =>
      setField<String>('created_at', value.toIso8601String());

  DateTime get updatedAt => DateTime.parse(getField<String>('updated_at')!);
  set updatedAt(DateTime value) =>
      setField<String>('updated_at', value.toIso8601String());
}
