import '../database.dart';

class MotoboyDocumentsTable extends SupabaseTable<MotoboyDocumentsRow> {
  @override
  String get tableName => 'motoboy_documents';

  @override
  MotoboyDocumentsRow createRow(Map<String, dynamic> data) =>
      MotoboyDocumentsRow(data);
}

class MotoboyDocumentsRow extends SupabaseDataRow {
  MotoboyDocumentsRow(super.data);

  @override
  SupabaseTable get table => MotoboyDocumentsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get deliveryPersonId => getField<String>('delivery_person_id')!;
  set deliveryPersonId(String value) =>
      setField<String>('delivery_person_id', value);

  String get documentType => getField<String>('document_type')!;
  set documentType(String value) => setField<String>('document_type', value);

  String get documentUrl => getField<String>('document_url')!;
  set documentUrl(String value) => setField<String>('document_url', value);

  bool get verified => getField<bool>('verified') ?? false;
  set verified(bool value) => setField<bool>('verified', value);

  DateTime? get verifiedAt => getField<DateTime>('verified_at');
  String? get verifiedBy => getField<String>('verified_by');

  DateTime? get expiresAt => getField<DateTime>('expires_at');

  DateTime get createdAt => getField<DateTime>('created_at')!;
  DateTime get updatedAt => getField<DateTime>('updated_at')!;
}

