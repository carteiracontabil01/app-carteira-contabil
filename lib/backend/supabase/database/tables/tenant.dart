import '../database.dart';

class TenantTable extends SupabaseTable<TenantRow> {
  @override
  String get tableName => 'tenants';

  @override
  TenantRow createRow(Map<String, dynamic> data) => TenantRow(data);
}

class TenantRow extends SupabaseDataRow {
  TenantRow(super.data);

  @override
  SupabaseTable get table => TenantTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get slug => getField<String>('slug');
  set slug(String? value) => setField<String>('slug', value);

  String? get logo => getField<String>('logo');
  set logo(String? value) => setField<String>('logo', value);

  String? get termsUse => getField<String>('terms_use');
  set termsUse(String? value) => setField<String>('terms_use', value);

  String? get privacyPolicy => getField<String>('privacy_policy');
  set privacyPolicy(String? value) => setField<String>('privacy_policy', value);

  String? get returnPolicy => getField<String>('return_policy');
  set returnPolicy(String? value) => setField<String>('return_policy', value);

  DateTime? get createdAt => getField<String>('created_at') != null
      ? DateTime.parse(getField<String>('created_at')!)
      : null;
  set createdAt(DateTime? value) =>
      setField<String>('created_at', value?.toIso8601String());

  DateTime? get updatedAt => getField<String>('updated_at') != null
      ? DateTime.parse(getField<String>('updated_at')!)
      : null;
  set updatedAt(DateTime? value) =>
      setField<String>('updated_at', value?.toIso8601String());
}
