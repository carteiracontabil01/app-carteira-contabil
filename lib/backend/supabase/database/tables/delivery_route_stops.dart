import '../database.dart';

class DeliveryRouteStopsTable
    extends SupabaseTable<DeliveryRouteStopsRow> {
  @override
  String get tableName => 'delivery_route_stops';

  @override
  DeliveryRouteStopsRow createRow(Map<String, dynamic> data) =>
      DeliveryRouteStopsRow(data);
}

class DeliveryRouteStopsRow extends SupabaseDataRow {
  DeliveryRouteStopsRow(super.data);

  @override
  SupabaseTable get table => DeliveryRouteStopsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get routeId => getField<String>('route_id')!;
  set routeId(String value) => setField<String>('route_id', value);

  String get orderId => getField<String>('order_id')!;
  set orderId(String value) => setField<String>('order_id', value);

  String get stopType => getField<String>('stop_type')!;
  set stopType(String value) => setField<String>('stop_type', value);

  int get sequenceOrder => getField<int>('sequence_order')!;
  set sequenceOrder(int value) => setField<int>('sequence_order', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  String get address => getField<String>('address')!;
  set address(String value) => setField<String>('address', value);

  double? get latitude => getField<double>('latitude');
  set latitude(double? value) => setField<double>('latitude', value);

  double? get longitude => getField<double>('longitude');
  set longitude(double? value) =>
      setField<double>('longitude', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  String? get customerId => getField<String>('customer_id');
  set customerId(String? value) =>
      setField<String>('customer_id', value);

  String? get orderCode => getField<String>('order_code');
  set orderCode(String? value) => setField<String>('order_code', value);

  DateTime? get arrivedAt => getField<DateTime>('arrived_at');
  DateTime? get completedAt => getField<DateTime>('completed_at');
  DateTime get createdAt => getField<DateTime>('created_at')!;
}


