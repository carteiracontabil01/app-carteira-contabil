import '../database.dart';

class ClientAddressTable extends SupabaseTable<ClientAddressRow> {
  @override
  String get tableName => 'client_address';

  @override
  ClientAddressRow createRow(Map<String, dynamic> data) =>
      ClientAddressRow(data);
}

class ClientAddressRow extends SupabaseDataRow {
  ClientAddressRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ClientAddressTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get cep => getField<String>('cep');
  set cep(String? value) => setField<String>('cep', value);

  String? get address => getField<String>('address');
  set address(String? value) => setField<String>('address', value);

  String? get number => getField<String>('number');
  set number(String? value) => setField<String>('number', value);

  String? get complement => getField<String>('complement');
  set complement(String? value) => setField<String>('complement', value);

  String? get district => getField<String>('district');
  set district(String? value) => setField<String>('district', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  String? get latlng => getField<String>('latlng');
  set latlng(String? value) => setField<String>('latlng', value);

  String? get place => getField<String>('place');
  set place(String? value) => setField<String>('place', value);

  bool? get defaultField => getField<bool>('default');
  set defaultField(bool? value) => setField<bool>('default', value);

  int? get idClient => getField<int>('idClient');
  set idClient(int? value) => setField<int>('idClient', value);

  String? get nameaddress => getField<String>('nameaddress');
  set nameaddress(String? value) => setField<String>('nameaddress', value);

  String? get tag => getField<String>('tag');
  set tag(String? value) => setField<String>('tag', value);
}
