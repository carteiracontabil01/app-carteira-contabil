import '../database.dart';

class AvaliacoesEmpresaTable extends SupabaseTable<AvaliacoesEmpresaRow> {
  @override
  String get tableName => 'avaliacoes_empresa';

  @override
  AvaliacoesEmpresaRow createRow(Map<String, dynamic> data) =>
      AvaliacoesEmpresaRow(data);
}

class AvaliacoesEmpresaRow extends SupabaseDataRow {
  AvaliacoesEmpresaRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AvaliacoesEmpresaTable();

  int? get idEmpresa => getField<int>('id_empresa');
  set idEmpresa(int? value) => setField<int>('id_empresa', value);

  String? get nomeEmpresa => getField<String>('nome_empresa');
  set nomeEmpresa(String? value) => setField<String>('nome_empresa', value);

  int? get quantidadeAvaliacoes => getField<int>('quantidade_avaliacoes');
  set quantidadeAvaliacoes(int? value) =>
      setField<int>('quantidade_avaliacoes', value);

  double? get mediaAvaliacoes => getField<double>('media_avaliacoes');
  set mediaAvaliacoes(double? value) =>
      setField<double>('media_avaliacoes', value);
}
