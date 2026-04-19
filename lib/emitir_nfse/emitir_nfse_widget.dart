import 'dart:async';

import '/app_state.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/widgets/home_surface_tokens.dart';
import '/services/company_profile_service.dart';
import 'emitir_nfse_model.dart';
import 'services/nfse_emission_lookup_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

export 'emitir_nfse_model.dart';

class EmitirNfseWidget extends StatefulWidget {
  const EmitirNfseWidget({super.key});

  static String routeName = 'emitirNfse';
  static String routePath = 'emitir-nfse';

  @override
  State<EmitirNfseWidget> createState() => _EmitirNfseWidgetState();
}

class _EmitirNfseWidgetState extends State<EmitirNfseWidget> {
  late EmitirNfseModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final NfseEmissionLookupService _lookupService = NfseEmissionLookupService();

  bool _isLoading = false;
  bool _isSearchingCustomers = false;
  bool _isSearchingMunicipios = false;

  String _naturezaOperacao = '1';
  String? _selectedCustomerId;
  String? _selectedCnaeId;
  String? _selectedServiceId;

  NfseMunicipioOption? _selectedMunicipio;

  List<Map<String, dynamic>> _baseCustomers = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _remoteCustomers = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _draftCustomers = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _customerMatches = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _cnaes = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _services = <Map<String, dynamic>>[];
  List<NfseMunicipioOption> _municipioMatches = <NfseMunicipioOption>[];
  List<NfseTaxField> _visibleTaxFields = <NfseTaxField>[];
  final Map<String, TextEditingController> _taxValueControllers =
      <String, TextEditingController>{};
  final Map<String, bool> _taxRetentionFlags = <String, bool>{};

  Timer? _customerSearchDebounce;
  Timer? _municipioSearchDebounce;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmitirNfseModel());
    _model.customerSearchController.addListener(_onCustomerSearchChanged);
    _model.municipioSearchController.addListener(_onMunicipioSearchChanged);
    _bootstrapFromProfile();
  }

  @override
  void dispose() {
    _customerSearchDebounce?.cancel();
    _municipioSearchDebounce?.cancel();
    for (final controller in _taxValueControllers.values) {
      controller.dispose();
    }
    _model.customerSearchController.removeListener(_onCustomerSearchChanged);
    _model.municipioSearchController.removeListener(_onMunicipioSearchChanged);
    _model.dispose();
    super.dispose();
  }

  Future<void> _bootstrapFromProfile() async {
    final appState = FFAppState();
    final companyId = appState.companyId;
    final companyUserId = appState.companyUserId;
    if (companyId == null || companyUserId == null) return;

    Map<String, dynamic>? profile = appState.companyProfile;
    if (profile == null || profile['id']?.toString() != companyId) {
      profile = await CompanyProfileService.fetchCompanyProfile(
        companyId: companyId,
        companyUserId: companyUserId,
      );
      if (!mounted) return;
      if (profile != null) {
        appState.setCompanyProfile(profile);
      }
    }

    if (!mounted) return;
    _refreshFromProfile(profile);
  }

  void _refreshFromProfile(Map<String, dynamic>? profile) {
    final cnaes = _lookupService.extractCnaes(profile);
    final customers = _lookupService.extractCompanyCustomers(profile);
    final firstCnaeId = cnaes
        .firstWhere(
          (item) => item['principal'] == true,
          orElse: () => cnaes.isNotEmpty ? cnaes.first : <String, dynamic>{},
        )['id']
        ?.toString();

    _cnaes = cnaes;
    _baseCustomers = customers;
    _selectedCnaeId = firstCnaeId;
    _services = _lookupService.extractServicesFromCnae(
      _findSelectedCnae(),
    );
    _selectedServiceId = _resolveDefaultServiceId(_services);
    _customerMatches =
        _buildCustomerMatches(_model.customerSearchController.text);
    _resolveTaxes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final appState = context.watch<FFAppState>();

    if (_cnaes.isEmpty && appState.companyProfile != null) {
      _refreshFromProfile(appState.companyProfile);
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.grayscale20,
        appBar: AppBar(
          backgroundColor: theme.primary,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.tertiary,
            ),
            onPressed: () => context.safePop(),
          ),
          title: Text(
            'Emissao de NFS-e',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: theme.tertiary,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Form(
          key: _model.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme),
                const SizedBox(height: 14),
                _buildTomadorSection(theme),
                const SizedBox(height: 12),
                _buildNaturezaSection(theme),
                const SizedBox(height: 12),
                _buildCnaeServiceSection(theme),
                const SizedBox(height: 12),
                _buildMunicipioValorSection(theme),
                const SizedBox(height: 12),
                _buildTaxSection(theme),
                const SizedBox(height: 12),
                _buildDescriptionSection(theme),
                const SizedBox(height: 20),
                _buildSubmitButton(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(FlutterFlowTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: HomeSurfaceTokens.cardDecoration(theme, radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pre-emissao da NFS-e',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: theme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Fluxo visual para configurar tomador, servico e impostos dinamicos.',
            style: GoogleFonts.nunito(
              fontSize: 12,
              height: 1.35,
              color: theme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTomadorSection(FlutterFlowTheme theme) {
    final selected = _findCustomerById(_selectedCustomerId);
    final noMatch = _model.customerSearchController.text.trim().length >= 3 &&
        _customerMatches.isEmpty &&
        !_isSearchingCustomers;

    return Container(
      decoration: HomeSurfaceTokens.cardDecoration(theme, radius: 16),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(theme, 'Tomador'),
          const SizedBox(height: 10),
          _buildTextField(
            hint: 'Buscar por razao social, nome fantasia, CPF ou CNPJ',
            controller: _model.customerSearchController,
            focusNode: _model.customerSearchFocusNode,
          ),
          const SizedBox(height: 10),
          if (_isSearchingCustomers)
            const LinearProgressIndicator(minHeight: 2),
          if (_customerMatches.isNotEmpty) ...[
            const SizedBox(height: 10),
            ..._customerMatches.take(6).map((customer) {
              final id = customer['id']?.toString();
              final selectedItem = id != null && id == _selectedCustomerId;
              final title = _customerLabel(customer);
              final doc = _customerDocument(customer);
              return InkWell(
                onTap: () => setState(() => _selectedCustomerId = id),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
                  decoration: BoxDecoration(
                    color: selectedItem
                        ? theme.primary.withValues(alpha: 0.08)
                        : theme.grayscale20,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedItem ? theme.primary : theme.grayscale30,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selectedItem
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        size: 18,
                        color:
                            selectedItem ? theme.primary : theme.secondaryText,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: theme.primaryText,
                              ),
                            ),
                            if (doc.isNotEmpty)
                              Text(
                                doc,
                                style: GoogleFonts.nunito(
                                  fontSize: 11,
                                  color: theme.secondaryText,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
          if (noMatch)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 4),
              child: OutlinedButton.icon(
                onPressed: _openCreateCustomerSheet,
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                label: const Text('Novo tomador nao encontrado'),
              ),
            ),
          if (selected != null) ...[
            const SizedBox(height: 8),
            Text(
              'Selecionado: ${_customerLabel(selected)}',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: theme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNaturezaSection(FlutterFlowTheme theme) {
    return Container(
      decoration: HomeSurfaceTokens.cardDecoration(theme, radius: 16),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(theme, 'Natureza da operacao'),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _naturezaOperacao,
            isExpanded: true,
            decoration: _inputDecoration(theme, hint: 'Selecione a natureza'),
            items: const [
              DropdownMenuItem(
                value: '1',
                child: Text('Tributacao no municipio'),
              ),
              DropdownMenuItem(
                value: '2',
                child: Text('Tributacao fora do municipio'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _naturezaOperacao = value);
              _resolveTaxes();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCnaeServiceSection(FlutterFlowTheme theme) {
    return Container(
      decoration: HomeSurfaceTokens.cardDecoration(theme, radius: 16),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(theme, 'CNAE e servico'),
          const SizedBox(height: 10),
          Text(
            'CNAE',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedCnaeId,
            isExpanded: true,
            decoration: _inputDecoration(theme, hint: 'Selecione o CNAE'),
            items: _cnaes.map((cnae) {
              final label =
                  '${(cnae['code'] ?? '').toString()} - ${(cnae['description'] ?? '').toString()}';
              return DropdownMenuItem(
                value: cnae['id']?.toString(),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            selectedItemBuilder: (context) {
              return _cnaes.map((cnae) {
                final label =
                    '${(cnae['code'] ?? '').toString()} - ${(cnae['description'] ?? '').toString()}';
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList();
            },
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Selecione o CNAE' : null,
            onChanged: (value) {
              if (value == null) return;
              final cnae = _cnaes
                  .where((item) => item['id']?.toString() == value)
                  .firstOrNull;
              setState(() {
                _selectedCnaeId = value;
                _services = _lookupService.extractServicesFromCnae(cnae);
                _selectedServiceId = _resolveDefaultServiceId(_services);
              });
              _resolveTaxes();
            },
          ),
          const SizedBox(height: 10),
          Text(
            'Servico',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedServiceId,
            isExpanded: true,
            decoration: _inputDecoration(theme, hint: 'Selecione o servico'),
            items: _services.map((service) {
              final code = (service['code_lc116'] ?? '').toString();
              final desc = (service['description'] ?? '').toString();
              final label = code.isEmpty ? desc : '$code - $desc';
              return DropdownMenuItem(
                value: service['id']?.toString(),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            selectedItemBuilder: (context) {
              return _services.map((service) {
                final code = (service['code_lc116'] ?? '').toString();
                final desc = (service['description'] ?? '').toString();
                final label = code.isEmpty ? desc : '$code - $desc';
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList();
            },
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Selecione o servico' : null,
            onChanged: (value) {
              setState(() => _selectedServiceId = value);
              _resolveTaxes();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMunicipioValorSection(FlutterFlowTheme theme) {
    return Container(
      decoration: HomeSurfaceTokens.cardDecoration(theme, radius: 16),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(theme, 'Municipio e valor do servico'),
          const SizedBox(height: 10),
          _buildTextField(
            hint: 'Municipio de execucao do servico',
            controller: _model.municipioSearchController,
            focusNode: _model.municipioSearchFocusNode,
          ),
          if (_isSearchingMunicipios)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: LinearProgressIndicator(minHeight: 2),
            ),
          if (_municipioMatches.isNotEmpty) ...[
            const SizedBox(height: 8),
            ..._municipioMatches.take(5).map((item) {
              final selected = _selectedMunicipio?.id == item.id;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedMunicipio = item;
                    _model.municipioSearchController.text = item.label;
                    _municipioMatches = <NfseMunicipioOption>[];
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? theme.primary.withValues(alpha: 0.08)
                        : theme.grayscale20,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected ? theme.primary : theme.grayscale30,
                    ),
                  ),
                  child: Text(
                    item.label,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: theme.primaryText,
                    ),
                  ),
                ),
              );
            }),
          ],
          const SizedBox(height: 8),
          _buildTextField(
            hint: 'Valor do servico (R\$)',
            controller: _model.valorController,
            focusNode: _model.valorFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+[,.]?\d{0,2}')),
            ],
            validator: (value) {
              final normalized = (value ?? '').replaceAll(',', '.').trim();
              final parsed = double.tryParse(normalized);
              if (parsed == null || parsed <= 0) {
                return 'Informe um valor valido';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaxSection(FlutterFlowTheme theme) {
    return Container(
      decoration: HomeSurfaceTokens.cardDecoration(theme, radius: 16),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(theme, 'Impostos'),
          const SizedBox(height: 4),
          Text(
            'Campos exibidos conforme empresa, servico e configuracao municipal.',
            style: GoogleFonts.nunito(
              fontSize: 11,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 10),
          if (_visibleTaxFields.isEmpty)
            Text(
              'Nenhum imposto aplicavel para esta combinacao.',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: theme.secondaryText,
              ),
            )
          else
            ..._visibleTaxFields
                .map((taxField) => _buildTaxFieldCard(theme, taxField)),
        ],
      ),
    );
  }

  Widget _buildTaxFieldCard(FlutterFlowTheme theme, NfseTaxField taxField) {
    final valueController = _taxValueControllers[taxField.field]!;
    final isRetentionEnabled = _taxRetentionFlags[taxField.field] ?? false;
    final isPercentField = taxField.field.toLowerCase().contains('aliquot');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: theme.grayscale20,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.grayscale30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  taxField.label,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: theme.primaryText,
                  ),
                ),
              ),
              if (taxField.required)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.warning.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Obrigatorio',
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: theme.warning,
                    ),
                  ),
                ),
            ],
          ),
          if ((taxField.observation ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              taxField.observation!,
              style: GoogleFonts.nunito(
                fontSize: 11,
                color: theme.secondaryText,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  hint: isPercentField ? '0,00 %' : '0,00',
                  controller: valueController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+[,.]?\d{0,4}')),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Text(
                    'Retido',
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: theme.secondaryText,
                    ),
                  ),
                  Switch(
                    value: isRetentionEnabled,
                    onChanged: (value) {
                      setState(
                          () => _taxRetentionFlags[taxField.field] = value);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(FlutterFlowTheme theme) {
    return Container(
      decoration: HomeSurfaceTokens.cardDecoration(theme, radius: 16),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(theme, 'Descricao da nota'),
          const SizedBox(height: 10),
          _buildTextField(
            hint: 'Descreva o servico prestado',
            controller: _model.descricaoController,
            focusNode: _model.descricaoFocusNode,
            maxLines: 4,
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Informe a descricao'
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(FlutterFlowTheme theme) {
    final isDisabled = _isLoading;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isDisabled ? null : _onPreviewEmission,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isDisabled ? theme.grayscale50 : theme.primary,
              boxShadow: isDisabled
                  ? null
                  : [
                      BoxShadow(
                        color: theme.primary.withValues(alpha: 0.24),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoading)
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.tertiary,
                    ),
                  )
                else
                  Icon(
                    Icons.visibility_rounded,
                    size: 20,
                    color: theme.tertiary,
                  ),
                const SizedBox(width: 8),
                Text(
                  _isLoading ? 'Validando...' : 'Visualizar emissao',
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: theme.tertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(FlutterFlowTheme theme, String text) => Text(
        text,
        style: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: theme.primary,
        ),
      );

  InputDecoration _inputDecoration(
    FlutterFlowTheme theme, {
    required String hint,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.nunito(
        fontSize: 13,
        color: theme.secondaryText.withValues(alpha: 0.7),
      ),
      filled: true,
      fillColor: theme.secondaryBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.grayscale30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.error, width: 1.4),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    FocusNode? focusNode,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: _inputDecoration(theme, hint: hint),
      style: GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  void _onCustomerSearchChanged() {
    _customerSearchDebounce?.cancel();
    final query = _model.customerSearchController.text.trim();
    setState(() {
      _customerMatches = _buildCustomerMatches(query);
    });

    if (query.length < 3) {
      setState(() {
        _isSearchingCustomers = false;
        _remoteCustomers = <Map<String, dynamic>>[];
      });
      return;
    }

    final hasLocalMatch = _customerMatches.isNotEmpty;
    if (hasLocalMatch) return;

    _customerSearchDebounce =
        Timer(const Duration(milliseconds: 320), () async {
      final companyId = FFAppState().companyId;
      if (companyId == null || companyId.isEmpty) return;
      setState(() => _isSearchingCustomers = true);

      try {
        final remote = await _lookupService.searchCompanyCustomers(
          companyId: companyId,
          query: query,
        );
        if (!mounted) return;
        setState(() {
          _remoteCustomers = remote;
          _customerMatches = _buildCustomerMatches(query);
          _isSearchingCustomers = false;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() => _isSearchingCustomers = false);
      }
    });
  }

  void _onMunicipioSearchChanged() {
    _municipioSearchDebounce?.cancel();
    final query = _model.municipioSearchController.text.trim();
    if (query.length < 2) {
      setState(() {
        _municipioMatches = <NfseMunicipioOption>[];
        _isSearchingMunicipios = false;
      });
      return;
    }

    _municipioSearchDebounce =
        Timer(const Duration(milliseconds: 300), () async {
      setState(() => _isSearchingMunicipios = true);
      try {
        final result = await _lookupService.searchMunicipios(query: query);
        if (!mounted) return;
        setState(() {
          _municipioMatches = result;
          _isSearchingMunicipios = false;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() => _isSearchingMunicipios = false);
      }
    });
  }

  List<Map<String, dynamic>> _buildCustomerMatches(String query) {
    final all = <Map<String, dynamic>>[
      ..._baseCustomers,
      ..._remoteCustomers,
      ..._draftCustomers,
    ];
    final byId = <String, Map<String, dynamic>>{};
    for (final item in all) {
      final id = item['id']?.toString() ?? '';
      if (id.isEmpty) continue;
      byId[id] = item;
    }

    final deduped = byId.values.toList();
    if (query.trim().isEmpty) return deduped;
    final q = query.toLowerCase();

    return deduped.where((customer) {
      final chunks = [
        customer['business_name'],
        customer['legal_name'],
        customer['cnpj'],
        customer['cpf'],
      ].map((item) => (item ?? '').toString().toLowerCase());
      return chunks.any((value) => value.contains(q));
    }).toList();
  }

  Map<String, dynamic>? _findSelectedCnae() {
    if (_selectedCnaeId == null) return null;
    return _cnaes
        .where((item) => item['id']?.toString() == _selectedCnaeId)
        .firstOrNull;
  }

  Map<String, dynamic>? _findSelectedService() {
    if (_selectedServiceId == null) return null;
    return _services
        .where((item) => item['id']?.toString() == _selectedServiceId)
        .firstOrNull;
  }

  Map<String, dynamic>? _findCustomerById(String? customerId) {
    if (customerId == null || customerId.isEmpty) return null;
    final all = _buildCustomerMatches('');
    return all
        .where((item) => item['id']?.toString() == customerId)
        .firstOrNull;
  }

  String? _resolveDefaultServiceId(List<Map<String, dynamic>> services) {
    if (services.isEmpty) return null;
    final defaultService = services
        .where(
          (item) =>
              item['service_default'] == true || item['principal'] == true,
        )
        .firstOrNull;
    return (defaultService ?? services.first)['id']?.toString();
  }

  String _customerLabel(Map<String, dynamic> customer) {
    final legalName = (customer['legal_name'] ?? '').toString().trim();
    final businessName = (customer['business_name'] ?? '').toString().trim();
    return legalName.isNotEmpty
        ? legalName
        : businessName.isNotEmpty
            ? businessName
            : 'Tomador sem nome';
  }

  String _customerDocument(Map<String, dynamic> customer) {
    final cnpj = (customer['cnpj'] ?? '').toString().trim();
    final cpf = (customer['cpf'] ?? '').toString().trim();
    if (cnpj.isNotEmpty) return 'CNPJ: $cnpj';
    if (cpf.isNotEmpty) return 'CPF: $cpf';
    return '';
  }

  void _resolveTaxes() {
    final profile = FFAppState().companyProfile;
    final selectedService = _findSelectedService();
    final resolution = _lookupService.resolveTaxFields(
      profile: profile,
      selectedService: selectedService,
      naturezaOperacao: _naturezaOperacao,
    );
    _visibleTaxFields = resolution.fields;
    _syncTaxControllers();
    setState(() {});
  }

  void _syncTaxControllers() {
    final activeKeys = _visibleTaxFields.map((item) => item.field).toSet();

    final removed = _taxValueControllers.keys
        .where((key) => !activeKeys.contains(key))
        .toList();
    for (final key in removed) {
      _taxValueControllers[key]?.dispose();
      _taxValueControllers.remove(key);
      _taxRetentionFlags.remove(key);
    }

    for (final field in _visibleTaxFields) {
      _taxValueControllers.putIfAbsent(
          field.field, () => TextEditingController(text: '0,00'));
      _taxRetentionFlags.putIfAbsent(field.field, () => false);
    }
  }

  Future<void> _openCreateCustomerSheet() async {
    final created = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateCustomerSheet(
        initialQuery: _model.customerSearchController.text.trim(),
      ),
    );

    if (created == null || !mounted) return;
    setState(() {
      _draftCustomers.add(created);
      _selectedCustomerId = created['id']?.toString();
      _customerMatches =
          _buildCustomerMatches(_model.customerSearchController.text);
    });
  }

  Future<void> _onPreviewEmission() async {
    final messenger = ScaffoldMessenger.of(context);
    final formValid = _model.formKey.currentState?.validate() ?? false;
    if (!formValid) return;

    if (_selectedCustomerId == null || _selectedCustomerId!.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Selecione um tomador para continuar.')),
      );
      return;
    }

    if (_selectedMunicipio == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Selecione o municipio de execucao.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Tela pronta: fluxo de emissao configurado (visualizacao apenas).',
          style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _CreateCustomerSheet extends StatefulWidget {
  const _CreateCustomerSheet({required this.initialQuery});

  final String initialQuery;

  @override
  State<_CreateCustomerSheet> createState() => _CreateCustomerSheetState();
}

class _CreateCustomerSheetState extends State<_CreateCustomerSheet> {
  final _formKey = GlobalKey<FormState>();
  final _documentController = TextEditingController();
  final _razaoController = TextEditingController();
  final _fantasiaController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ufController = TextEditingController();

  String _personType = 'juridica';

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery.isNotEmpty) {
      _razaoController.text = widget.initialQuery;
    }
  }

  @override
  void dispose() {
    _documentController.dispose();
    _razaoController.dispose();
    _fantasiaController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cidadeController.dispose();
    _ufController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.92,
      minChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: Form(
              key: _formKey,
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.grayscale40,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Novo tomador (sem integracao)',
                    style: GoogleFonts.nunito(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: theme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fluxo visual para cadastro quando a busca nao encontra o tomador.',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: theme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _personType,
                    decoration: InputDecoration(
                      labelText: 'Tipo de pessoa',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'juridica', child: Text('Pessoa Juridica')),
                      DropdownMenuItem(
                          value: 'fisica', child: Text('Pessoa Fisica')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _personType = value);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _documentController,
                    decoration: InputDecoration(
                      labelText: _personType == 'juridica' ? 'CNPJ' : 'CPF',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Informe o documento'
                            : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _razaoController,
                    decoration: InputDecoration(
                      labelText: 'Razao social / Nome',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Informe o nome do tomador'
                            : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _fantasiaController,
                    decoration: InputDecoration(
                      labelText: 'Nome fantasia',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Telefone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cidadeController,
                          decoration: InputDecoration(
                            labelText: 'Cidade',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 92,
                        child: TextFormField(
                          controller: _ufController,
                          maxLength: 2,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            counterText: '',
                            labelText: 'UF',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.safePop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.primary,
                            side: BorderSide(
                                color: theme.primary.withValues(alpha: 0.5)),
                            textStyle: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.primary,
                            foregroundColor: theme.accent2,
                            textStyle: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            final valid =
                                _formKey.currentState?.validate() ?? false;
                            if (!valid) return;

                            final document = _documentController.text.trim();
                            final fakeId =
                                'new-customer-${DateTime.now().millisecondsSinceEpoch}';
                            Navigator.of(context).pop(<String, dynamic>{
                              'id': fakeId,
                              'legal_name': _razaoController.text.trim(),
                              'business_name': _fantasiaController.text.trim(),
                              'cnpj':
                                  _personType == 'juridica' ? document : null,
                              'cpf': _personType == 'fisica' ? document : null,
                              'business_email': _emailController.text.trim(),
                              'business_phone_number':
                                  _phoneController.text.trim(),
                              'is_draft': true,
                            });
                          },
                          child: const Text('Usar no formulario'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
