import '../database.dart';

class ClientTable extends SupabaseTable<ClientRow> {
  @override
  String get tableName => 'users';

  @override
  ClientRow createRow(Map<String, dynamic> data) => ClientRow(data);
}

class ClientRow extends SupabaseDataRow {
  ClientRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ClientTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get displayName => getField<String>('display_name')!;
  set displayName(String value) => setField<String>('display_name', value);

  String get email => getField<String>('email')!;
  set email(String value) => setField<String>('email', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  String? get document => getField<String>('document');
  set document(String? value) => setField<String>('document', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  String? get lastName => getField<String>('last_name');
  set lastName(String? value) => setField<String>('last_name', value);

  DateTime? get birthday => getField<DateTime>('birthday');
  set birthday(DateTime? value) => setField<DateTime>('birthday', value);

  String? get preferredLanguage => getField<String>('preferred_language');
  set preferredLanguage(String? value) =>
      setField<String>('preferred_language', value);

  String? get fcmToken => getField<String>('fcm_token');
  set fcmToken(String? value) => setField<String>('fcm_token', value);

  // Aliases para compatibilidade
  String? get name => displayName;
  set name(String? value) => displayName = value ?? '';

  String? get cpf => document;
  set cpf(String? value) => document = value;

  String? get iduser => id;
  set iduser(String? value) => id = value ?? '';
}
