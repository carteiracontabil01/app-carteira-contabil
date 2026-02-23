import '../database.dart';

class DeliverySettingsTable extends SupabaseTable<DeliverySettingsRow> {
  @override
  String get tableName => 'delivery_settings';

  @override
  DeliverySettingsRow createRow(Map<String, dynamic> data) =>
      DeliverySettingsRow(data);
}

class DeliverySettingsRow extends SupabaseDataRow {
  DeliverySettingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DeliverySettingsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get tenantId => getField<String>('tenant_id')!;
  set tenantId(String value) => setField<String>('tenant_id', value);

  bool get isDeliveryEnabled => getField<bool>('is_delivery_enabled')!;
  set isDeliveryEnabled(bool value) =>
      setField<bool>('is_delivery_enabled', value);

  double? get minimumOrderValue => getField<double>('minimum_order_value');
  set minimumOrderValue(double? value) =>
      setField<double>('minimum_order_value', value);

  double? get freeDeliveryAbove => getField<double>('free_delivery_above');
  set freeDeliveryAbove(double? value) =>
      setField<double>('free_delivery_above', value);

  String get freightCalculationType =>
      getField<String>('freight_calculation_type')!;
  set freightCalculationType(String value) =>
      setField<String>('freight_calculation_type', value);

  double? get baseFreightPrice => getField<double>('base_freight_price');
  set baseFreightPrice(double? value) =>
      setField<double>('base_freight_price', value);

  double? get pricePerKm => getField<double>('price_per_km');
  set pricePerKm(double? value) => setField<double>('price_per_km', value);

  int? get estimatedDeliveryTimeMin =>
      getField<int>('estimated_delivery_time_min');
  set estimatedDeliveryTimeMin(int? value) =>
      setField<int>('estimated_delivery_time_min', value);

  int? get estimatedDeliveryTimeMax =>
      getField<int>('estimated_delivery_time_max');
  set estimatedDeliveryTimeMax(int? value) =>
      setField<int>('estimated_delivery_time_max', value);

  int? get deliveryRadiusKm => getField<int>('delivery_radius_km');
  set deliveryRadiusKm(int? value) =>
      setField<int>('delivery_radius_km', value);

  String? get deliveryStartTime => getField<String>('delivery_start_time');
  set deliveryStartTime(String? value) =>
      setField<String>('delivery_start_time', value);

  String? get deliveryEndTime => getField<String>('delivery_end_time');
  set deliveryEndTime(String? value) =>
      setField<String>('delivery_end_time', value);

  List<int>? get deliveryDays => getField<List<int>>('delivery_days');
  set deliveryDays(List<int>? value) =>
      setField<List<int>>('delivery_days', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

