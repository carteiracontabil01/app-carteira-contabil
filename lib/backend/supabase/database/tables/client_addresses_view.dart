import '../database.dart';

class ClientAddressesViewTable extends SupabaseTable<ClientAddressesViewRow> {
  @override
  String get tableName => 'client_addresses_view';

  @override
  ClientAddressesViewRow createRow(Map<String, dynamic> data) =>
      ClientAddressesViewRow(data);
}

class ClientAddressesViewRow extends SupabaseDataRow {
  ClientAddressesViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ClientAddressesViewTable();

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

  int? get addressId => getField<int>('address_id');
  set addressId(int? value) => setField<int>('address_id', value);

  String? get addressCep => getField<String>('address_cep');
  set addressCep(String? value) => setField<String>('address_cep', value);

  String? get addressAddress => getField<String>('address_address');
  set addressAddress(String? value) =>
      setField<String>('address_address', value);

  String? get addressNumber => getField<String>('address_number');
  set addressNumber(String? value) => setField<String>('address_number', value);

  String? get addressComplement => getField<String>('address_complement');
  set addressComplement(String? value) =>
      setField<String>('address_complement', value);

  String? get addressDistrict => getField<String>('address_district');
  set addressDistrict(String? value) =>
      setField<String>('address_district', value);

  String? get addressCity => getField<String>('address_city');
  set addressCity(String? value) => setField<String>('address_city', value);

  String? get addressState => getField<String>('address_state');
  set addressState(String? value) => setField<String>('address_state', value);

  String? get addressLatlng => getField<String>('address_latlng');
  set addressLatlng(String? value) => setField<String>('address_latlng', value);

  String? get addressPlace => getField<String>('address_place');
  set addressPlace(String? value) => setField<String>('address_place', value);

  bool? get addressDefault => getField<bool>('address_default');
  set addressDefault(bool? value) => setField<bool>('address_default', value);

  String? get addressNameAddress => getField<String>('address_name_address');
  set addressNameAddress(String? value) =>
      setField<String>('address_name_address', value);

  String? get addressTag => getField<String>('address_tag');
  set addressTag(String? value) => setField<String>('address_tag', value);
}
