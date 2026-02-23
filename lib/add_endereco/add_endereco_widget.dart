import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'add_endereco_model.dart';
export 'add_endereco_model.dart';

class AddEnderecoWidget extends StatefulWidget {
  const AddEnderecoWidget({
    super.key,
    this.edit,
    this.usuario,
    this.endereco,
  });

  final bool? edit;
  final ClientRow? usuario;
  final UserAddressRow? endereco;

  static String routeName = 'addEndereco';
  static String routePath = 'addEndereco';

  @override
  State<AddEnderecoWidget> createState() => _AddEnderecoWidgetState();
}

class _AddEnderecoWidgetState extends State<AddEnderecoWidget> {
  late AddEnderecoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Controllers
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _numberFocusNode = FocusNode();
  final FocusNode _complementFocusNode = FocusNode();
  final FocusNode _titleFocusNode = FocusNode();

  // Session token for Google Places API
  String _sessionToken = const Uuid().v4();

  // Autocomplete suggestions
  List<dynamic> _predictions = [];
  bool _isSearching = false;

  // Selected place data
  String? _selectedAddress;
  String? _street;
  String? _neighborhood;
  String? _city;
  String? _state;
  String? _zipCode;
  double? _lat;
  double? _lng;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddEnderecoModel());

    // Preencher campos se estiver editando
    if (widget.endereco != null) {
      _selectedAddress = widget.endereco!.address;
      _searchController.text = widget.endereco!.address;
      _numberController.text = widget.endereco!.number ?? '';
      _complementController.text = widget.endereco!.complement ?? '';
      _titleController.text = widget.endereco!.title ?? '';

      // Dados ocultos
      _street = widget.endereco!.address;
      _neighborhood = widget.endereco!.district;
      _city = widget.endereco!.city;
      _state = widget.endereco!.state;
      _zipCode = widget.endereco!.zipCode;
      _lat = widget.endereco!.lat;
      _lng = widget.endereco!.lng;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    _searchController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _titleController.dispose();
    _searchFocusNode.dispose();
    _numberFocusNode.dispose();
    _complementFocusNode.dispose();
    _titleFocusNode.dispose();

    super.dispose();
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final response = await Supabase.instance.client.rpc(
        'google_places_autocomplete',
        params: {
          'p_input': query,
          'p_session_token': _sessionToken,
        },
      );

      if (response != null) {
        final predictions = response['predictions'] as List?;
        setState(() {
          _predictions = predictions ?? [];
          _isSearching = false;
        });
      }
    } catch (e) {
      print('❌ Erro ao buscar endereços: $e');
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _selectPlace(String placeId, String description) async {
    // Extrair número do endereço se existir (ex: "Rua ABC, 123" -> "123")
    String? extractedNumber;
    final numberMatch = RegExp(r',\s*(\d+)').firstMatch(description);
    if (numberMatch != null) {
      extractedNumber = numberMatch.group(1);
    }

    setState(() {
      _selectedAddress = description;
      _searchController.text = description;
      _predictions = [];
      _isSearching = true;

      // Preencher número extraído
      if (extractedNumber != null && _numberController.text.isEmpty) {
        _numberController.text = extractedNumber;
      }
    });

    // Remover foco do campo de busca
    _searchFocusNode.unfocus();

    try {
      final response = await Supabase.instance.client.rpc(
        'google_place_details',
        params: {
          'p_place_id': placeId,
          'p_session_token': _sessionToken,
        },
      );

      if (response != null && response['result'] != null) {
        final result = response['result'];
        final addressComponents = result['address_components'] as List?;
        final geometry = result['geometry'];

        String? street;
        String? neighborhood;
        String? city;
        String? state;
        String? zipCode;

        if (addressComponents != null) {
          for (var component in addressComponents) {
            final types = component['types'] as List;
            final longName = component['long_name'] as String?;
            final shortName = component['short_name'] as String?;

            if (types.contains('route')) {
              street = longName;
            } else if (types.contains('sublocality') ||
                types.contains('neighborhood')) {
              neighborhood = longName;
            } else if (types.contains('administrative_area_level_2')) {
              city = longName;
            } else if (types.contains('administrative_area_level_1')) {
              state = shortName;
            } else if (types.contains('postal_code')) {
              zipCode = longName;
            }
          }
        }

        setState(() {
          _street = street ?? '';
          _neighborhood = neighborhood;
          _city = city ?? '';
          _state = state ?? '';
          _zipCode = zipCode ?? '';
          _lat = geometry?['location']?['lat'];
          _lng = geometry?['location']?['lng'];
          _isSearching = false;
        });

        // Gerar novo session token após completar uma sessão
        _sessionToken = const Uuid().v4();

        // Focar no campo apropriado
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_numberController.text.isNotEmpty) {
            // Se número foi preenchido, focar em complemento
            _complementFocusNode.requestFocus();
          } else {
            // Se não, focar em número
            _numberFocusNode.requestFocus();
          }
        });
      }
    } catch (e) {
      print('❌ Erro ao buscar detalhes do endereço: $e');
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar detalhes do endereço'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  Future<void> _saveAddress() async {
    final tenantId = FFAppState().tenantId;

    if (tenantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: Tenant ID não encontrado'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    if (_selectedAddress == null || _selectedAddress!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecione um endereço'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    if (_city == null || _state == null || _zipCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Endereço incompleto. Tente selecionar outro endereço.'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    try {
      // Construir o endereço completo
      String fullAddress = _street ?? _selectedAddress!;
      if (_numberController.text.isNotEmpty) {
        fullAddress = '$fullAddress, ${_numberController.text}';
      }

      if (widget.edit == true && widget.endereco != null) {
        // Atualizar endereço existente
        await UserAddressTable().update(
          data: {
            'address': fullAddress,
            'number': _numberController.text.isNotEmpty
                ? _numberController.text
                : null,
            'complement': _complementController.text.isNotEmpty
                ? _complementController.text
                : null,
            'district': _neighborhood,
            'city': _city,
            'state': _state,
            'zip_code': _zipCode,
            'lat': _lat,
            'lng': _lng,
            'title':
                _titleController.text.isNotEmpty ? _titleController.text : null,
          },
          matchingRows: (rows) => rows.eq('id', widget.endereco!.id),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Endereço atualizado com sucesso!'),
            backgroundColor: FlutterFlowTheme.of(context).success,
          ),
        );
      } else {
        // Inserir novo endereço
        await UserAddressTable().insert({
          'user_id': currentUserUid,
          'tenant_id': tenantId,
          'address': fullAddress,
          'number':
              _numberController.text.isNotEmpty ? _numberController.text : null,
          'complement': _complementController.text.isNotEmpty
              ? _complementController.text
              : null,
          'district': _neighborhood,
          'city': _city,
          'state': _state,
          'zip_code': _zipCode,
          'lat': _lat,
          'lng': _lng,
          'title':
              _titleController.text.isNotEmpty ? _titleController.text : null,
          'is_default': false,
          'is_billing': false,
          'is_active': true,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Endereço adicionado com sucesso!'),
            backgroundColor: FlutterFlowTheme.of(context).success,
          ),
        );
      }

      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar endereço: $e'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            widget.edit == true ? 'Editar Endereço' : 'Novo Endereço',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  font: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(18.0, 24.0, 18.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Campo de busca de endereço
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Buscar endereço',
                                hintText: 'Digite o nome da rua, número...',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.nunito(),
                                      color: Color(0x99575757),
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.nunito(),
                                      color: Color(0x99575757),
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xCCE6E6E9),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                suffixIcon: _isSearching
                                    ? Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: SizedBox(
                                          width: 20.0,
                                          height: 20.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                      )
                                    : _searchController.text.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _searchController.clear();
                                                _predictions = [];
                                                _selectedAddress = null;
                                              });
                                            },
                                          )
                                        : null,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.nunito(),
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                              onChanged: (value) {
                                EasyDebounce.debounce(
                                  'search-places',
                                  Duration(milliseconds: 500),
                                  () => _searchPlaces(value),
                                );
                              },
                            ),

                            // Lista de sugestões
                            if (_predictions.isNotEmpty)
                              Container(
                                margin: EdgeInsets.only(top: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 8.0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _predictions.length,
                                  separatorBuilder: (context, index) => Divider(
                                    height: 1,
                                    color: FlutterFlowTheme.of(context)
                                        .grayscale20,
                                  ),
                                  itemBuilder: (context, index) {
                                    final prediction = _predictions[index];
                                    return InkWell(
                                      onTap: () {
                                        _selectPlace(
                                          prediction['place_id'],
                                          prediction['description'],
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 20.0,
                                            ),
                                            SizedBox(width: 12.0),
                                            Expanded(
                                              child: Text(
                                                prediction['description'] ?? '',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font:
                                                          GoogleFonts.nunito(),
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),

                        SizedBox(height: 24.0),

                        // Campos Número e Complemento (lado a lado)
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _numberController,
                                focusNode: _numberFocusNode,
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Número',
                                  hintText: 'Ex: 123',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.nunito(),
                                        color: Color(0x99575757),
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                      ),
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.nunito(),
                                        color: Color(0x99575757),
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xCCE6E6E9),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.nunito(),
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                    ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: 12.0),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _complementController,
                                focusNode: _complementFocusNode,
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Complemento',
                                  hintText: 'Apto, Bloco...',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.nunito(),
                                        color: Color(0x99575757),
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                      ),
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.nunito(),
                                        color: Color(0x99575757),
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xCCE6E6E9),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.nunito(),
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24.0),

                        // Campo Título/Referência
                        TextFormField(
                          controller: _titleController,
                          focusNode: _titleFocusNode,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Identificação (opcional)',
                            hintText: 'Ex: Casa, Trabalho, Academia...',
                            labelStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.nunito(),
                                  color: Color(0x99575757),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.nunito(),
                                  color: Color(0x99575757),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xCCE6E6E9),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.nunito(),
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                        ),

                        // Informações extraídas (DEBUG - pode ser removido em produção)
                        if (_city != null && _state != null)
                          Padding(
                            padding: EdgeInsets.only(top: 24.0),
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .info
                                  .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 20.0,
                                    color: FlutterFlowTheme.of(context).info,
                                  ),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      '$_city - $_state${_neighborhood != null ? ', $_neighborhood' : ''}${_zipCode != null ? ' • CEP: $_zipCode' : ''}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            font: GoogleFonts.nunito(),
                                            color: FlutterFlowTheme.of(context)
                                                .info,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Botão Salvar
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 20.0),
                child: FFButtonWidget(
                  onPressed: _saveAddress,
                  text: 'Salvar endereço',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 48.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600,
                          ),
                          color: FlutterFlowTheme.of(context).grayscale10,
                          letterSpacing: 0.0,
                        ),
                    elevation: 3.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
