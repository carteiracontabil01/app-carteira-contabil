import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _carrinhoProduto = prefs
              .getStringList('ff_carrinhoProduto')
              ?.map((x) {
                try {
                  return CarrinhoProdutoStruct.fromSerializableMap(
                      jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _carrinhoProduto;
    });
    _safeInit(() {
      _pageSelect = prefs.getString('ff_pageSelect') ?? _pageSelect;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_addressDelivery')) {
        try {
          final serializedData = prefs.getString('ff_addressDelivery') ?? '{}';
          _addressDelivery = EnderecoTempStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _totalNotificacoes =
          prefs.getInt('ff_totalNotificacoes') ?? _totalNotificacoes;
    });
    _safeInit(() {
      _favorito = prefs
              .getStringList('ff_favorito')
              ?.map((x) {
                try {
                  return ProdutoStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _favorito;
    });
    _safeInit(() {
      _totalCarrinho = prefs.getDouble('ff_totalCarrinho') ?? _totalCarrinho;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_cupomDesc')) {
        try {
          final serializedData = prefs.getString('ff_cupomDesc') ?? '{}';
          _cupomDesc = DtDescontoCupomStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _entrega = prefs.getBool('ff_entrega') ?? _entrega;
    });
    _safeInit(() {
      _viewList = prefs.getBool('ff_viewList') ?? _viewList;
    });
    _safeInit(() {
      _favoritos = prefs.getStringList('ff_favoritos') ?? _favoritos;
    });
    _safeInit(() {
      _idBusiness = prefs.getInt('ff_idBusiness') ?? _idBusiness;
    });
    _safeInit(() {
      _urlbusiness = prefs.getString('ff_urlbusiness') ?? _urlbusiness;
    });
    _safeInit(() {
      _tenantId = prefs.getString('ff_tenantId');
    });
    _safeInit(() {
      _fcmToken = prefs.getString('ff_fcmToken') ?? _fcmToken;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  Color _corSelecionada = Colors.transparent;
  Color get corSelecionada => _corSelecionada;
  set corSelecionada(Color value) {
    _corSelecionada = value;
  }

  List<String> _cardapioGrade = [];
  List<String> get cardapioGrade => _cardapioGrade;
  set cardapioGrade(List<String> value) {
    _cardapioGrade = value;
  }

  void addToCardapioGrade(String value) {
    cardapioGrade.add(value);
  }

  void removeFromCardapioGrade(String value) {
    cardapioGrade.remove(value);
  }

  void removeAtIndexFromCardapioGrade(int index) {
    cardapioGrade.removeAt(index);
  }

  void updateCardapioGradeAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    cardapioGrade[index] = updateFn(_cardapioGrade[index]);
  }

  void insertAtIndexInCardapioGrade(int index, String value) {
    cardapioGrade.insert(index, value);
  }

  int _contador = 0;
  int get contador => _contador;
  set contador(int value) {
    _contador = value;
  }

  int _contadorFinal = 0;
  int get contadorFinal => _contadorFinal;
  set contadorFinal(int value) {
    _contadorFinal = value;
  }

  List<CarrinhoProdutoStruct> _carrinhoProduto = [];
  List<CarrinhoProdutoStruct> get carrinhoProduto => _carrinhoProduto;
  set carrinhoProduto(List<CarrinhoProdutoStruct> value) {
    _carrinhoProduto = value;
    prefs.setStringList(
        'ff_carrinhoProduto', value.map((x) => x.serialize()).toList());
  }

  void addToCarrinhoProduto(CarrinhoProdutoStruct value) {
    carrinhoProduto.add(value);
    prefs.setStringList('ff_carrinhoProduto',
        _carrinhoProduto.map((x) => x.serialize()).toList());
  }

  void removeFromCarrinhoProduto(CarrinhoProdutoStruct value) {
    carrinhoProduto.remove(value);
    prefs.setStringList('ff_carrinhoProduto',
        _carrinhoProduto.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromCarrinhoProduto(int index) {
    carrinhoProduto.removeAt(index);
    prefs.setStringList('ff_carrinhoProduto',
        _carrinhoProduto.map((x) => x.serialize()).toList());
  }

  void updateCarrinhoProdutoAtIndex(
    int index,
    CarrinhoProdutoStruct Function(CarrinhoProdutoStruct) updateFn,
  ) {
    carrinhoProduto[index] = updateFn(_carrinhoProduto[index]);
    prefs.setStringList('ff_carrinhoProduto',
        _carrinhoProduto.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInCarrinhoProduto(int index, CarrinhoProdutoStruct value) {
    carrinhoProduto.insert(index, value);
    prefs.setStringList('ff_carrinhoProduto',
        _carrinhoProduto.map((x) => x.serialize()).toList());
  }

  String _pageSelect = '';
  String get pageSelect => _pageSelect;
  set pageSelect(String value) {
    _pageSelect = value;
    prefs.setString('ff_pageSelect', value);
  }

  EnderecoTempStruct _addressDelivery = EnderecoTempStruct();
  EnderecoTempStruct get addressDelivery => _addressDelivery;
  set addressDelivery(EnderecoTempStruct value) {
    _addressDelivery = value;
    prefs.setString('ff_addressDelivery', value.serialize());
  }

  void updateAddressDeliveryStruct(Function(EnderecoTempStruct) updateFn) {
    updateFn(_addressDelivery);
    prefs.setString('ff_addressDelivery', _addressDelivery.serialize());
  }

  bool _criarConta = false;
  bool get criarConta => _criarConta;
  set criarConta(bool value) {
    _criarConta = value;
  }

  String _dinheiro = '';
  String get dinheiro => _dinheiro;
  set dinheiro(String value) {
    _dinheiro = value;
  }

  String _valorFormatado = '';
  String get valorFormatado => _valorFormatado;
  set valorFormatado(String value) {
    _valorFormatado = value;
  }

  bool _verSaldoHome = false;
  bool get verSaldoHome => _verSaldoHome;
  set verSaldoHome(bool value) {
    _verSaldoHome = value;
  }

  int _totalNotificacoes = 0;
  int get totalNotificacoes => _totalNotificacoes;
  set totalNotificacoes(int value) {
    _totalNotificacoes = value;
    prefs.setInt('ff_totalNotificacoes', value);
  }

  bool _resetSenha = false;
  bool get resetSenha => _resetSenha;
  set resetSenha(bool value) {
    _resetSenha = value;
  }

  String _formLogin = 'login';
  String get formLogin => _formLogin;
  set formLogin(String value) {
    _formLogin = value;
  }

  List<ProdutoStruct> _favorito = [];
  List<ProdutoStruct> get favorito => _favorito;
  set favorito(List<ProdutoStruct> value) {
    _favorito = value;
    prefs.setStringList(
        'ff_favorito', value.map((x) => x.serialize()).toList());
  }

  void addToFavorito(ProdutoStruct value) {
    favorito.add(value);
    prefs.setStringList(
        'ff_favorito', _favorito.map((x) => x.serialize()).toList());
  }

  void removeFromFavorito(ProdutoStruct value) {
    favorito.remove(value);
    prefs.setStringList(
        'ff_favorito', _favorito.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromFavorito(int index) {
    favorito.removeAt(index);
    prefs.setStringList(
        'ff_favorito', _favorito.map((x) => x.serialize()).toList());
  }

  void updateFavoritoAtIndex(
    int index,
    ProdutoStruct Function(ProdutoStruct) updateFn,
  ) {
    favorito[index] = updateFn(_favorito[index]);
    prefs.setStringList(
        'ff_favorito', _favorito.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInFavorito(int index, ProdutoStruct value) {
    favorito.insert(index, value);
    prefs.setStringList(
        'ff_favorito', _favorito.map((x) => x.serialize()).toList());
  }

  double _totalCarrinho = 0.0;
  double get totalCarrinho => _totalCarrinho;
  set totalCarrinho(double value) {
    _totalCarrinho = value;
    prefs.setDouble('ff_totalCarrinho', value);
  }

  double _cupomdesc = 0.0;
  double get cupomdesc => _cupomdesc;
  set cupomdesc(double value) {
    _cupomdesc = value;
  }

  DtDescontoCupomStruct _cupomDesc = DtDescontoCupomStruct();
  DtDescontoCupomStruct get cupomDesc => _cupomDesc;
  set cupomDesc(DtDescontoCupomStruct value) {
    _cupomDesc = value;
    prefs.setString('ff_cupomDesc', value.serialize());
  }

  void updateCupomDescStruct(Function(DtDescontoCupomStruct) updateFn) {
    updateFn(_cupomDesc);
    prefs.setString('ff_cupomDesc', _cupomDesc.serialize());
  }

  bool _entrega = true;
  bool get entrega => _entrega;
  set entrega(bool value) {
    _entrega = value;
    prefs.setBool('ff_entrega', value);
  }

  double _taxaEntrega = 0.0;
  double get taxaEntrega => _taxaEntrega;
  set taxaEntrega(double value) {
    _taxaEntrega = value;
  }

  bool _viewList = false;
  bool get viewList => _viewList;
  set viewList(bool value) {
    _viewList = value;
    prefs.setBool('ff_viewList', value);
  }

  String _gatewaySelecionado = '';
  String get gatewaySelecionado => _gatewaySelecionado;
  set gatewaySelecionado(String value) {
    _gatewaySelecionado = value;
  }

  List<String> _favoritos = [];
  List<String> get favoritos => _favoritos;
  set favoritos(List<String> value) {
    _favoritos = value;
    prefs.setStringList('ff_favoritos', value);
  }

  void addToFavoritos(String value) {
    favoritos.add(value);
    prefs.setStringList('ff_favoritos', _favoritos);
  }

  void removeFromFavoritos(String value) {
    favoritos.remove(value);
    prefs.setStringList('ff_favoritos', _favoritos);
  }

  void removeAtIndexFromFavoritos(int index) {
    favoritos.removeAt(index);
    prefs.setStringList('ff_favoritos', _favoritos);
  }

  void updateFavoritosAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    favoritos[index] = updateFn(_favoritos[index]);
    prefs.setStringList('ff_favoritos', _favoritos);
  }

  void insertAtIndexInFavoritos(int index, String value) {
    favoritos.insert(index, value);
    prefs.setStringList('ff_favoritos', _favoritos);
  }

  String _routeDistance = '';
  String get routeDistance => _routeDistance;
  set routeDistance(String value) {
    _routeDistance = value;
  }

  String _routeDuration = '';
  String get routeDuration => _routeDuration;
  set routeDuration(String value) {
    _routeDuration = value;
  }

  // ============================================
  // 🔔 FIREBASE CLOUD MESSAGING
  // ============================================

  String _fcmToken = '';
  String get fcmToken => _fcmToken;
  set fcmToken(String value) {
    _fcmToken = value;
    prefs.setString('ff_fcmToken', value);
  }

  // ============================================
  // 🏢 TENANT (Sistema Multi-Tenant)
  // ============================================

  /// ID do tenant atual (UUID)
  String? _tenantId;
  String? get tenantId => _tenantId;
  set tenantId(String? value) {
    _tenantId = value;
    try {
      if (value != null) {
        prefs.setString('ff_tenantId', value);
      } else {
        prefs.remove('ff_tenantId');
      }
    } catch (e) {
      print('⚠️ Erro ao salvar tenantId: $e');
    }
  }

  /// Informações completas do tenant
  Map<String, dynamic>? _tenantInfo;
  Map<String, dynamic>? get tenantInfo => _tenantInfo;

  /// Define o tenant atual
  void setTenant(String id, Map<String, dynamic>? info) {
    _tenantId = id;
    _tenantInfo = info;
    try {
      prefs.setString('ff_tenantId', id);
    } catch (e) {
      print('⚠️ Erro ao salvar tenantId: $e');
    }
    notifyListeners();
    print('✅ Tenant definido: ${info?['name'] ?? id}');
  }

  /// Limpa o tenant atual
  void clearTenant() {
    _tenantId = null;
    _tenantInfo = null;
    prefs.remove('ff_tenantId');
    notifyListeners();
    print('🗑️  Tenant removido');
  }

  // ============================================
  // ⚠️ DEPRECATED - Manter por compatibilidade
  // ============================================

  int _idBusiness = 1;
  int get idBusiness => _idBusiness;
  set idBusiness(int value) {
    _idBusiness = value;
    prefs.setInt('ff_idBusiness', value);
  }

  String _urlbusiness = '';
  String get urlbusiness => _urlbusiness;
  set urlbusiness(String value) {
    _urlbusiness = value;
    prefs.setString('ff_urlbusiness', value);
  }

  // ============================================
  // 💰 PREÇOS
  // ============================================

  double _propPrice = 0.0;
  double get propPrice => _propPrice;
  set propPrice(double value) {
    _propPrice = value;
  }

  double _promoPrice = 0.0;
  double get promoPrice => _promoPrice;
  set promoPrice(double value) {
    _promoPrice = value;
  }

  double _costPrice = 0.0;
  double get costPrice => _costPrice;
  set costPrice(double value) {
    _costPrice = value;
  }

  GatewaySelectStruct _gatewaySelect = GatewaySelectStruct();
  GatewaySelectStruct get gatewaySelect => _gatewaySelect;
  set gatewaySelect(GatewaySelectStruct value) {
    _gatewaySelect = value;
  }

  void updateGatewaySelectStruct(Function(GatewaySelectStruct) updateFn) {
    updateFn(_gatewaySelect);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

// TODO: Implementar se necessário no futuro
// Future _safeInitAsync(Function() initializeField) async {
//   try {
//     await initializeField();
//   } catch (_) {}
// }

// TODO: Implementar se necessário no futuro
// Color? _colorFromIntValue(int? val) {
//   if (val == null) {
//     return null;
//   }
//   return Color(val);
// }
