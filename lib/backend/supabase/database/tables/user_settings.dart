import '../database.dart';

class UserSettingsTable extends SupabaseTable<UserSettingsRow> {
  @override
  String get tableName => 'user_settings';

  @override
  UserSettingsRow createRow(Map<String, dynamic> data) => UserSettingsRow(data);
}

class UserSettingsRow extends SupabaseDataRow {
  UserSettingsRow(super.data);

  @override
  SupabaseTable get table => UserSettingsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get tenantId => getField<String>('tenant_id');
  set tenantId(String? value) => setField<String>('tenant_id', value);

  // NOTIFICAÇÕES
  bool get notificationsOrders =>
      getField<bool>('notifications_orders') ?? true;
  set notificationsOrders(bool value) =>
      setField<bool>('notifications_orders', value);

  bool get notificationsPromotions =>
      getField<bool>('notifications_promotions') ?? true;
  set notificationsPromotions(bool value) =>
      setField<bool>('notifications_promotions', value);

  bool get notificationsOffers =>
      getField<bool>('notifications_offers') ?? false;
  set notificationsOffers(bool value) =>
      setField<bool>('notifications_offers', value);

  // APARÊNCIA
  bool get darkMode => getField<bool>('dark_mode') ?? false;
  set darkMode(bool value) => setField<bool>('dark_mode', value);

  // SOM E VIBRAÇÃO
  bool get appSounds => getField<bool>('app_sounds') ?? true;
  set appSounds(bool value) => setField<bool>('app_sounds', value);

  bool get vibration => getField<bool>('vibration') ?? true;
  set vibration(bool value) => setField<bool>('vibration', value);

  // METADADOS
  DateTime get createdAt => getField<DateTime>('created_at')!;
  DateTime get updatedAt => getField<DateTime>('updated_at')!;
}
