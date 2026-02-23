import '../database.dart';

class DeliveryRoutesTable extends SupabaseTable<DeliveryRoutesRow> {
  @override
  String get tableName => 'delivery_routes';

  @override
  DeliveryRoutesRow createRow(Map<String, dynamic> data) =>
      DeliveryRoutesRow(data);
}

class DeliveryRoutesRow extends SupabaseDataRow {
  DeliveryRoutesRow(super.data);

  @override
  SupabaseTable get table => DeliveryRoutesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get deliveryPersonId => getField<String>('delivery_person_id')!;
  set deliveryPersonId(String value) =>
      setField<String>('delivery_person_id', value);

  String? get tenantId => getField<String>('tenant_id');
  set tenantId(String? value) => setField<String>('tenant_id', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  double get totalEarnings => getField<double>('total_earnings') ?? 0.0;
  set totalEarnings(double value) => setField<double>('total_earnings', value);

  double get totalDistanceKm => getField<double>('total_distance_km') ?? 0.0;
  set totalDistanceKm(double value) =>
      setField<double>('total_distance_km', value);

  int get estimatedTimeMinutes => getField<int>('estimated_time_minutes') ?? 0;
  set estimatedTimeMinutes(int value) =>
      setField<int>('estimated_time_minutes', value);

  DateTime? get startedAt => getField<DateTime>('started_at');
  DateTime? get completedAt => getField<DateTime>('completed_at');
  DateTime? get cancelledAt => getField<DateTime>('cancelled_at');
  DateTime get createdAt => getField<DateTime>('created_at')!;
  DateTime get updatedAt => getField<DateTime>('updated_at')!;
}
