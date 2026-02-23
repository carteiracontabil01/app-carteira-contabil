import '../database.dart';

class BusinessTable extends SupabaseTable<BusinessRow> {
  @override
  String get tableName => 'business';

  @override
  BusinessRow createRow(Map<String, dynamic> data) => BusinessRow(data);
}

class BusinessRow extends SupabaseDataRow {
  BusinessRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BusinessTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get address => getField<String>('address');
  set address(String? value) => setField<String>('address', value);

  String? get latlng => getField<String>('latlng');
  set latlng(String? value) => setField<String>('latlng', value);

  String? get cep => getField<String>('cep');
  set cep(String? value) => setField<String>('cep', value);

  String? get number => getField<String>('number');
  set number(String? value) => setField<String>('number', value);

  String? get district => getField<String>('district');
  set district(String? value) => setField<String>('district', value);

  String? get complement => getField<String>('complement');
  set complement(String? value) => setField<String>('complement', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  String? get logo => getField<String>('logo');
  set logo(String? value) => setField<String>('logo', value);

  String? get inscEstadual => getField<String>('inscEstadual');
  set inscEstadual(String? value) => setField<String>('inscEstadual', value);

  String? get cnpj => getField<String>('cnpj');
  set cnpj(String? value) => setField<String>('cnpj', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  String? get whatsApp => getField<String>('whatsApp');
  set whatsApp(String? value) => setField<String>('whatsApp', value);

  String? get mail => getField<String>('mail');
  set mail(String? value) => setField<String>('mail', value);

  String? get url => getField<String>('url');
  set url(String? value) => setField<String>('url', value);

  PostgresTime? get timeDelivery => getField<PostgresTime>('timeDelivery');
  set timeDelivery(PostgresTime? value) =>
      setField<PostgresTime>('timeDelivery', value);

  PostgresTime? get timeCollect => getField<PostgresTime>('timeCollect');
  set timeCollect(PostgresTime? value) =>
      setField<PostgresTime>('timeCollect', value);

  bool? get delivery => getField<bool>('delivery');
  set delivery(bool? value) => setField<bool>('delivery', value);

  bool? get collect => getField<bool>('collect');
  set collect(bool? value) => setField<bool>('collect', value);

  String? get website => getField<String>('website');
  set website(String? value) => setField<String>('website', value);

  String? get idUserAdm => getField<String>('idUserAdm');
  set idUserAdm(String? value) => setField<String>('idUserAdm', value);

  String? get socialReason => getField<String>('socialReason');
  set socialReason(String? value) => setField<String>('socialReason', value);

  String? get fantasyName => getField<String>('fantasyName');
  set fantasyName(String? value) => setField<String>('fantasyName', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  List<int> get idClients => getListField<int>('idClients');
  set idClients(List<int>? value) => setListField<int>('idClients', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get responsible => getField<String>('responsible');
  set responsible(String? value) => setField<String>('responsible', value);

  String? get cpf => getField<String>('cpf');
  set cpf(String? value) => setField<String>('cpf', value);

  String? get place => getField<String>('place');
  set place(String? value) => setField<String>('place', value);

  String? get facebook => getField<String>('facebook');
  set facebook(String? value) => setField<String>('facebook', value);

  String? get instagram => getField<String>('instagram');
  set instagram(String? value) => setField<String>('instagram', value);

  String? get linkedin => getField<String>('linkedin');
  set linkedin(String? value) => setField<String>('linkedin', value);

  String? get google => getField<String>('google');
  set google(String? value) => setField<String>('google', value);

  String? get youtube => getField<String>('youtube');
  set youtube(String? value) => setField<String>('youtube', value);

  String? get pinterest => getField<String>('pinterest');
  set pinterest(String? value) => setField<String>('pinterest', value);

  String? get tiktok => getField<String>('tiktok');
  set tiktok(String? value) => setField<String>('tiktok', value);

  String? get kwai => getField<String>('kwai');
  set kwai(String? value) => setField<String>('kwai', value);

  String? get imagecapa => getField<String>('imagecapa');
  set imagecapa(String? value) => setField<String>('imagecapa', value);
}
