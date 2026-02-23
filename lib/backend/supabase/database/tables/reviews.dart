import '../database.dart';

class ReviewsTable extends SupabaseTable<ReviewsRow> {
  @override
  String get tableName => 'reviews';

  @override
  ReviewsRow createRow(Map<String, dynamic> data) => ReviewsRow(data);
}

class ReviewsRow extends SupabaseDataRow {
  ReviewsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReviewsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get uid => getField<String>('uid');
  set uid(String? value) => setField<String>('uid', value);

  int? get idProduct => getField<int>('idProduct');
  set idProduct(int? value) => setField<int>('idProduct', value);

  int? get rating => getField<int>('rating');
  set rating(int? value) => setField<int>('rating', value);

  String? get review => getField<String>('review');
  set review(String? value) => setField<String>('review', value);

  int? get idBusiness => getField<int>('idBusiness');
  set idBusiness(int? value) => setField<int>('idBusiness', value);

  String? get nameClient => getField<String>('nameClient');
  set nameClient(String? value) => setField<String>('nameClient', value);
}
