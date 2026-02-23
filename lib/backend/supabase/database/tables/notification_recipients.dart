import '../database.dart';

class NotificationRecipientsTable extends SupabaseTable<NotificationRecipientsRow> {
  @override
  String get tableName => 'notification_recipients';

  @override
  NotificationRecipientsRow createRow(Map<String, dynamic> data) =>
      NotificationRecipientsRow(data);
}

class NotificationRecipientsRow extends SupabaseDataRow {
  NotificationRecipientsRow(super.data);

  @override
  SupabaseTable get table => NotificationRecipientsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;

  String? get notificationId => getField<String>('notification_id');
  set notificationId(String? value) => setField<String>('notification_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  bool get isRead => getField<bool>('is_read') ?? false;
  set isRead(bool value) => setField<bool>('is_read', value);

  DateTime? get readAt => getField<DateTime>('read_at');
  set readAt(DateTime? value) => setField<DateTime>('read_at', value);
}

