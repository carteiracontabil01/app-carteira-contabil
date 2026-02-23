import '../database.dart';

class UserAddressTable extends SupabaseTable<UserAddressRow> {
  @override
  String get tableName => 'user_address';

  @override
  UserAddressRow createRow(Map<String, dynamic> data) => UserAddressRow(data);
}

class UserAddressRow extends SupabaseDataRow {
  UserAddressRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserAddressTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get tenantId => getField<String>('tenant_id')!;
  set tenantId(String value) => setField<String>('tenant_id', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String get address => getField<String>('address')!;
  set address(String value) => setField<String>('address', value);

  String? get number => getField<String>('number');
  set number(String? value) => setField<String>('number', value);

  String? get complement => getField<String>('complement');
  set complement(String? value) => setField<String>('complement', value);

  String? get district => getField<String>('district');
  set district(String? value) => setField<String>('district', value);

  String get city => getField<String>('city')!;
  set city(String value) => setField<String>('city', value);

  String get state => getField<String>('state')!;
  set state(String value) => setField<String>('state', value);

  String get zipCode => getField<String>('zip_code')!;
  set zipCode(String value) => setField<String>('zip_code', value);

  double? get lat => getField<double>('lat');
  set lat(double? value) => setField<double>('lat', value);

  double? get lng => getField<double>('lng');
  set lng(double? value) => setField<double>('lng', value);

  bool? get isDefault => getField<bool>('is_default');
  set isDefault(bool? value) => setField<bool>('is_default', value);

  bool? get isBilling => getField<bool>('is_billing');
  set isBilling(bool? value) => setField<bool>('is_billing', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

