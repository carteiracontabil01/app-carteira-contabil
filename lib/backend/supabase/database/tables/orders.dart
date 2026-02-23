import '../database.dart';

class OrdersTable extends SupabaseTable<OrdersRow> {
  @override
  String get tableName => 'orders';

  @override
  OrdersRow createRow(Map<String, dynamic> data) => OrdersRow(data);
}

class OrdersRow extends SupabaseDataRow {
  OrdersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrdersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get orderNumber => getField<String>('order_number');
  set orderNumber(String? value) => setField<String>('order_number', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  double get totalAmount => getField<double>('total_amount')!;
  set totalAmount(double value) => setField<double>('total_amount', value);

  double? get shippingAmount => getField<double>('shipping_amount');
  set shippingAmount(double? value) =>
      setField<double>('shipping_amount', value);

  double? get discountAmount => getField<double>('discount_amount');
  set discountAmount(double? value) =>
      setField<double>('discount_amount', value);

  String get paymentStatus => getField<String>('payment_status')!;
  set paymentStatus(String value) => setField<String>('payment_status', value);

  String? get paymentMethod => getField<String>('payment_method');
  set paymentMethod(String? value) => setField<String>('payment_method', value);

  Map<String, dynamic>? get shippingAddress =>
      getField<Map<String, dynamic>>('shipping_address');
  set shippingAddress(Map<String, dynamic>? value) =>
      setField<Map<String, dynamic>>('shipping_address', value);

  Map<String, dynamic>? get billingAddress =>
      getField<Map<String, dynamic>>('billing_address');
  set billingAddress(Map<String, dynamic>? value) =>
      setField<Map<String, dynamic>>('billing_address', value);

  String? get notes => getField<String>('notes');
  set notes(String? value) => setField<String>('notes', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  String get tenantId => getField<String>('tenant_id')!;
  set tenantId(String value) => setField<String>('tenant_id', value);

  bool get isDraft => getField<bool>('is_draft')!;
  set isDraft(bool value) => setField<bool>('is_draft', value);

  DateTime? get draftExpiresAt => getField<DateTime>('draft_expires_at');
  set draftExpiresAt(DateTime? value) =>
      setField<DateTime>('draft_expires_at', value);
}
