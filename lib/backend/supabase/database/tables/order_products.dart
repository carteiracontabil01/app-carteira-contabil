import '../database.dart';

class OrderProductsTable extends SupabaseTable<OrderProductsRow> {
  @override
  String get tableName => 'orderProducts';

  @override
  OrderProductsRow createRow(Map<String, dynamic> data) =>
      OrderProductsRow(data);
}

class OrderProductsRow extends SupabaseDataRow {
  OrderProductsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrderProductsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  int? get idOrder => getField<int>('idOrder');
  set idOrder(int? value) => setField<int>('idOrder', value);

  int? get idProduct => getField<int>('idProduct');
  set idProduct(int? value) => setField<int>('idProduct', value);

  int? get quantity => getField<int>('quantity');
  set quantity(int? value) => setField<int>('quantity', value);

  double? get priceSingle => getField<double>('priceSingle');
  set priceSingle(double? value) => setField<double>('priceSingle', value);

  double? get priceSubTotal => getField<double>('priceSubTotal');
  set priceSubTotal(double? value) => setField<double>('priceSubTotal', value);
}
