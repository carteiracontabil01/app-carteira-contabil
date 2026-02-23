import '../database.dart';

class MotoboyEarningsTable extends SupabaseTable<MotoboyEarningsRow> {
  @override
  String get tableName => 'motoboy_earnings';

  @override
  MotoboyEarningsRow createRow(Map<String, dynamic> data) =>
      MotoboyEarningsRow(data);
}

class MotoboyEarningsRow extends SupabaseDataRow {
  MotoboyEarningsRow(super.data);

  @override
  SupabaseTable get table => MotoboyEarningsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get deliveryPersonId => getField<String>('delivery_person_id')!;
  set deliveryPersonId(String value) =>
      setField<String>('delivery_person_id', value);

  String? get routeId => getField<String>('route_id');
  set routeId(String? value) => setField<String>('route_id', value);

  String? get orderId => getField<String>('order_id');
  set orderId(String? value) => setField<String>('order_id', value);

  String? get tenantId => getField<String>('tenant_id');
  set tenantId(String? value) => setField<String>('tenant_id', value);

  double get deliveryFee => getField<double>('delivery_fee') ?? 0.0;
  set deliveryFee(double value) => setField<double>('delivery_fee', value);

  double get tip => getField<double>('tip') ?? 0.0;
  set tip(double value) => setField<double>('tip', value);

  double get total => getField<double>('total') ?? 0.0;
  set total(double value) => setField<double>('total', value);

  DateTime? get paidAt => getField<DateTime>('paid_at');
  DateTime get createdAt => getField<DateTime>('created_at')!;
}

