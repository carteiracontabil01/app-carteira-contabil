import '../database.dart';

class MotoboyWithdrawalsTable extends SupabaseTable<MotoboyWithdrawalsRow> {
  @override
  String get tableName => 'motoboy_withdrawals';

  @override
  MotoboyWithdrawalsRow createRow(Map<String, dynamic> data) =>
      MotoboyWithdrawalsRow(data);
}

class MotoboyWithdrawalsRow extends SupabaseDataRow {
  MotoboyWithdrawalsRow(super.data);

  @override
  SupabaseTable get table => MotoboyWithdrawalsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get deliveryPersonId => getField<String>('delivery_person_id')!;
  set deliveryPersonId(String value) =>
      setField<String>('delivery_person_id', value);

  String? get tenantId => getField<String>('tenant_id');
  set tenantId(String? value) => setField<String>('tenant_id', value);

  double get amount => getField<double>('amount') ?? 0.0;
  set amount(double value) => setField<double>('amount', value);

  double get fee => getField<double>('fee') ?? 0.0;
  set fee(double value) => setField<double>('fee', value);

  double get netAmount => getField<double>('net_amount') ?? 0.0;
  set netAmount(double value) => setField<double>('net_amount', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  String get pixKey => getField<String>('pix_key')!;
  set pixKey(String value) => setField<String>('pix_key', value);

  String? get pixKeyType => getField<String>('pix_key_type');
  set pixKeyType(String? value) => setField<String>('pix_key_type', value);

  String? get bankName => getField<String>('bank_name');
  set bankName(String? value) => setField<String>('bank_name', value);

  DateTime? get processedAt => getField<DateTime>('processed_at');
  DateTime get createdAt => getField<DateTime>('created_at')!;
}

