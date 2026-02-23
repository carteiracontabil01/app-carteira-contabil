import '../database.dart';

class ViewBannersAndOfferTable extends SupabaseTable<ViewBannersAndOfferRow> {
  @override
  String get tableName => 'view_banners_and_offer';

  @override
  ViewBannersAndOfferRow createRow(Map<String, dynamic> data) =>
      ViewBannersAndOfferRow(data);
}

class ViewBannersAndOfferRow extends SupabaseDataRow {
  ViewBannersAndOfferRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewBannersAndOfferTable();

  int? get bannerId => getField<int>('banner_id');
  set bannerId(int? value) => setField<int>('banner_id', value);

  DateTime? get bannerCreatedAt => getField<DateTime>('banner_created_at');
  set bannerCreatedAt(DateTime? value) =>
      setField<DateTime>('banner_created_at', value);

  int? get bannerIdEmpresa => getField<int>('banner_id_empresa');
  set bannerIdEmpresa(int? value) => setField<int>('banner_id_empresa', value);

  String? get bannerImagem => getField<String>('banner_imagem');
  set bannerImagem(String? value) => setField<String>('banner_imagem', value);

  String? get bannerNome => getField<String>('banner_nome');
  set bannerNome(String? value) => setField<String>('banner_nome', value);

  String? get bannerLocalizacaoApp =>
      getField<String>('banner_localizacao_app');
  set bannerLocalizacaoApp(String? value) =>
      setField<String>('banner_localizacao_app', value);

  String? get bannerLink => getField<String>('banner_link');
  set bannerLink(String? value) => setField<String>('banner_link', value);

  DateTime? get bannerDataInicio => getField<DateTime>('banner_data_inicio');
  set bannerDataInicio(DateTime? value) =>
      setField<DateTime>('banner_data_inicio', value);

  DateTime? get bannerDataFim => getField<DateTime>('banner_data_fim');
  set bannerDataFim(DateTime? value) =>
      setField<DateTime>('banner_data_fim', value);

  int? get bannerIdCategoria => getField<int>('banner_id_categoria');
  set bannerIdCategoria(int? value) =>
      setField<int>('banner_id_categoria', value);

  int? get bannerIdOferta => getField<int>('banner_id_oferta');
  set bannerIdOferta(int? value) => setField<int>('banner_id_oferta', value);

  int? get bannerIdProduto => getField<int>('banner_id_produto');
  set bannerIdProduto(int? value) => setField<int>('banner_id_produto', value);

  int? get ofertaId => getField<int>('oferta_id');
  set ofertaId(int? value) => setField<int>('oferta_id', value);

  DateTime? get ofertaCreatedAt => getField<DateTime>('oferta_created_at');
  set ofertaCreatedAt(DateTime? value) =>
      setField<DateTime>('oferta_created_at', value);

  String? get ofertaNome => getField<String>('oferta_nome');
  set ofertaNome(String? value) => setField<String>('oferta_nome', value);

  String? get ofertaDescricao => getField<String>('oferta_descricao');
  set ofertaDescricao(String? value) =>
      setField<String>('oferta_descricao', value);

  String? get ofertaRegulamento => getField<String>('oferta_regulamento');
  set ofertaRegulamento(String? value) =>
      setField<String>('oferta_regulamento', value);

  String? get ofertaImagem => getField<String>('oferta_imagem');
  set ofertaImagem(String? value) => setField<String>('oferta_imagem', value);

  DateTime? get ofertaDataInicio => getField<DateTime>('oferta_data_inicio');
  set ofertaDataInicio(DateTime? value) =>
      setField<DateTime>('oferta_data_inicio', value);

  DateTime? get ofertaDataFim => getField<DateTime>('oferta_data_fim');
  set ofertaDataFim(DateTime? value) =>
      setField<DateTime>('oferta_data_fim', value);

  int? get ofertaIdEmpresa => getField<int>('oferta_id_empresa');
  set ofertaIdEmpresa(int? value) => setField<int>('oferta_id_empresa', value);

  String? get ofertaLocal => getField<String>('oferta_local');
  set ofertaLocal(String? value) => setField<String>('oferta_local', value);
}
