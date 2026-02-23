import '../database.dart';

class DeliveryZoneCepsTable extends SupabaseTable<DeliveryZoneCepsRow> {
  @override
  String get tableName => 'delivery_zone_ceps';

  @override
  DeliveryZoneCepsRow createRow(Map<String, dynamic> data) =>
      DeliveryZoneCepsRow(data);
}

class DeliveryZoneCepsRow extends SupabaseDataRow {
  DeliveryZoneCepsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DeliveryZoneCepsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get deliveryZoneId => getField<String>('delivery_zone_id')!;
  set deliveryZoneId(String value) =>
      setField<String>('delivery_zone_id', value);

  String get cepStart => getField<String>('cep_start')!;
  set cepStart(String value) => setField<String>('cep_start', value);

  String get cepEnd => getField<String>('cep_end')!;
  set cepEnd(String value) => setField<String>('cep_end', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

