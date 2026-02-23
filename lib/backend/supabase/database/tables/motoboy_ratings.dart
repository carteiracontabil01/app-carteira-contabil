import '../database.dart';

class MotoboyRatingsTable extends SupabaseTable<MotoboyRatingsRow> {
  @override
  String get tableName => 'motoboy_ratings';

  @override
  MotoboyRatingsRow createRow(Map<String, dynamic> data) =>
      MotoboyRatingsRow(data);
}

class MotoboyRatingsRow extends SupabaseDataRow {
  MotoboyRatingsRow(super.data);

  @override
  SupabaseTable get table => MotoboyRatingsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get deliveryPersonId =>
      getField<String>('delivery_person_id')!;
  set deliveryPersonId(String value) =>
      setField<String>('delivery_person_id', value);

  String get orderId => getField<String>('order_id')!;
  set orderId(String value) => setField<String>('order_id', value);

  String? get customerId => getField<String>('customer_id');
  set customerId(String? value) => setField<String>('customer_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  int get rating => getField<int>('rating')!;
  set rating(int value) => setField<int>('rating', value);

  String? get comment => getField<String>('comment');
  set comment(String? value) => setField<String>('comment', value);

  String get ratedBy => getField<String>('rated_by')!;
  set ratedBy(String value) => setField<String>('rated_by', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
}

