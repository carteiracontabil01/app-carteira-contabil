import '../database.dart';

class OrderSummaryTable extends SupabaseTable<OrderSummaryRow> {
  @override
  String get tableName => 'order_summary';

  @override
  OrderSummaryRow createRow(Map<String, dynamic> data) => OrderSummaryRow(data);
}

class OrderSummaryRow extends SupabaseDataRow {
  OrderSummaryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrderSummaryTable();

  String get id => getField<String>('id')!;

  String? get orderNumber => getField<String>('order_number');

  String get userId => getField<String>('user_id')!;

  String get tenantId => getField<String>('tenant_id')!;

  String get status => getField<String>('status')!;

  String get paymentStatus => getField<String>('payment_status')!;

  String? get paymentMethod => getField<String>('payment_method');

  double get totalAmount => getField<double>('total_amount')!;

  double? get shippingAmount => getField<double>('shipping_amount');

  double? get discountAmount => getField<double>('discount_amount');

  bool get isDraft => getField<bool>('is_draft')!;

  DateTime get createdAt => getField<DateTime>('created_at')!;

  DateTime get updatedAt => getField<DateTime>('updated_at')!;

  int? get itemsCount => getField<int>('items_count');

  int? get modifiersCount => getField<int>('modifiers_count');

  double? get totalItemsQuantity => getField<double>('total_items_quantity');

  String? get userEmail => getField<String>('user_email');

  String? get userName => getField<String>('user_name');
}
