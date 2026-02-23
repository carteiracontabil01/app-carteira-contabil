import '../database.dart';

class SupportFaqTable extends SupabaseTable<SupportFaqRow> {
  @override
  String get tableName => 'support_faq';

  @override
  SupportFaqRow createRow(Map<String, dynamic> data) => SupportFaqRow(data);
}

class SupportFaqRow extends SupabaseDataRow {
  SupportFaqRow(super.data);

  @override
  SupabaseTable get table => SupportFaqTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get tenantId => getField<String>('tenant_id')!;
  set tenantId(String value) => setField<String>('tenant_id', value);

  String get category => getField<String>('category')!;
  set category(String value) => setField<String>('category', value);

  String get questionPt => getField<String>('question_pt')!;
  set questionPt(String value) => setField<String>('question_pt', value);

  String get answerPt => getField<String>('answer_pt')!;
  set answerPt(String value) => setField<String>('answer_pt', value);

  String? get questionEn => getField<String>('question_en');
  set questionEn(String? value) => setField<String>('question_en', value);

  String? get answerEn => getField<String>('answer_en');
  set answerEn(String? value) => setField<String>('answer_en', value);

  String? get questionEs => getField<String>('question_es');
  set questionEs(String? value) => setField<String>('question_es', value);

  String? get answerEs => getField<String>('answer_es');
  set answerEs(String? value) => setField<String>('answer_es', value);

  int get orderIndex => getField<int>('order_index') ?? 0;
  set orderIndex(int value) => setField<int>('order_index', value);

  bool get isActive => getField<bool>('is_active') ?? true;
  set isActive(bool value) => setField<bool>('is_active', value);

  int get viewCount => getField<int>('view_count') ?? 0;
  set viewCount(int value) => setField<int>('view_count', value);

  DateTime get createdAt => DateTime.parse(getField<String>('created_at')!);
  set createdAt(DateTime value) =>
      setField<String>('created_at', value.toIso8601String());

  DateTime get updatedAt => DateTime.parse(getField<String>('updated_at')!);
  set updatedAt(DateTime value) =>
      setField<String>('updated_at', value.toIso8601String());
}
