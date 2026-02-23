import '../database.dart';

class DeliveryZonesTable extends SupabaseTable<DeliveryZonesRow> {
  @override
  String get tableName => 'delivery_zones';

  @override
  DeliveryZonesRow createRow(Map<String, dynamic> data) =>
      DeliveryZonesRow(data);
}

class DeliveryZonesRow extends SupabaseDataRow {
  DeliveryZonesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DeliveryZonesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get tenantId => getField<String>('tenant_id')!;
  set tenantId(String value) => setField<String>('tenant_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  double get freightPrice => getField<double>('freight_price')!;
  set freightPrice(double value) => setField<double>('freight_price', value);

  bool? get isFree => getField<bool>('is_free');
  set isFree(bool? value) => setField<bool>('is_free', value);

  int? get estimatedTimeMin => getField<int>('estimated_time_min');
  set estimatedTimeMin(int? value) =>
      setField<int>('estimated_time_min', value);

  int? get estimatedTimeMax => getField<int>('estimated_time_max');
  set estimatedTimeMax(int? value) =>
      setField<int>('estimated_time_max', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

