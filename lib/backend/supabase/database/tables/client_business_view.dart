import '../database.dart';

class ClientBusinessViewTable extends SupabaseTable<ClientBusinessViewRow> {
  @override
  String get tableName => 'client_business_view';

  @override
  ClientBusinessViewRow createRow(Map<String, dynamic> data) =>
      ClientBusinessViewRow(data);
}

class ClientBusinessViewRow extends SupabaseDataRow {
  ClientBusinessViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ClientBusinessViewTable();

  int? get clientId => getField<int>('client_id');
  set clientId(int? value) => setField<int>('client_id', value);

  DateTime? get clientCreatedAt => getField<DateTime>('client_created_at');
  set clientCreatedAt(DateTime? value) =>
      setField<DateTime>('client_created_at', value);

  String? get clientIduser => getField<String>('client_iduser');
  set clientIduser(String? value) => setField<String>('client_iduser', value);

  String? get clientName => getField<String>('client_name');
  set clientName(String? value) => setField<String>('client_name', value);

  String? get clientPhone => getField<String>('client_phone');
  set clientPhone(String? value) => setField<String>('client_phone', value);

  String? get clientMail => getField<String>('client_mail');
  set clientMail(String? value) => setField<String>('client_mail', value);

  DateTime? get clientBirthday => getField<DateTime>('client_birthday');
  set clientBirthday(DateTime? value) =>
      setField<DateTime>('client_birthday', value);

  String? get clientCpf => getField<String>('client_cpf');
  set clientCpf(String? value) => setField<String>('client_cpf', value);

  bool? get clientActive => getField<bool>('client_active');
  set clientActive(bool? value) => setField<bool>('client_active', value);

  int? get businessId => getField<int>('business_id');
  set businessId(int? value) => setField<int>('business_id', value);

  String? get businessName => getField<String>('business_name');
  set businessName(String? value) => setField<String>('business_name', value);
}
