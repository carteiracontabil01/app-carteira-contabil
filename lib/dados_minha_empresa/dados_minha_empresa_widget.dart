import '/enums/company_profile_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/widgets/home_surface_tokens.dart';
import '/services/company_profile_service.dart';
import '/shared/components/brand_enum_chip.dart';
import 'dados_minha_empresa_model.dart';
import 'widgets/company_address_card.dart';
import 'widgets/company_data_field_tile.dart';
import 'widgets/company_info_tab_selector.dart';
import 'widgets/company_not_found_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

export 'dados_minha_empresa_model.dart';

class DadosMinhaEmpresaWidget extends StatefulWidget {
  const DadosMinhaEmpresaWidget({super.key});

  static String routeName = 'dadosMinhaEmpresa';
  static String routePath = 'dados-minha-empresa';

  @override
  State<DadosMinhaEmpresaWidget> createState() => _DadosMinhaEmpresaWidgetState();
}

class _DadosMinhaEmpresaWidgetState extends State<DadosMinhaEmpresaWidget> {
  late DadosMinhaEmpresaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DadosMinhaEmpresaModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureProfile());
  }

  Future<void> _ensureProfile() async {
    final appState = context.read<FFAppState>();
    final companyId = appState.companyId;
    final companyUserId = appState.companyUserId;

    if (companyId == null ||
        companyId.isEmpty ||
        companyUserId == null ||
        companyUserId.isEmpty) {
      return;
    }

    if (appState.companyProfile != null &&
        appState.companyProfile!['id']?.toString() == companyId) {
      return;
    }

    _model.isRefreshing = true;
    if (mounted) setState(() {});
    await CompanyProfileService.refreshIntoAppState(
      companyId: companyId,
      companyUserId: companyUserId,
    );
    if (!mounted) return;
    _model.isRefreshing = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    final appState = context.read<FFAppState>();
    final companyId = appState.companyId;
    final companyUserId = appState.companyUserId;
    if (companyId == null ||
        companyId.isEmpty ||
        companyUserId == null ||
        companyUserId.isEmpty) {
      return;
    }

    _model.isRefreshing = true;
    if (mounted) setState(() {});
    await CompanyProfileService.refreshIntoAppState(
      companyId: companyId,
      companyUserId: companyUserId,
    );
    if (!mounted) return;
    _model.isRefreshing = false;
    setState(() {});
  }

  String _displayValue(dynamic value) {
    if (value == null) return '—';
    final raw = value.toString().trim();
    return raw.isEmpty ? '—' : raw;
  }

  String _mapSegment(String raw) {
    return CompanySegmentEnum.fromValue(raw)?.label ?? raw;
  }

  String _mapCompanySize(String raw) {
    return CompanySizeEnum.fromValue(raw)?.label ?? raw;
  }

  String _mapOperationMode(String raw) {
    return CompanyOperationTypeEnum.fromValue(raw)?.label ?? raw;
  }

  String _mapTaxRegime(String raw) {
    return CompanyTaxRegimeEnum.fromValue(raw)?.label ?? raw;
  }

  String _mapAddressType(String raw) {
    return AddressTypeEnum.fromValue(raw)?.label ?? raw;
  }

  List<String> _mapListLikeValues(
    dynamic value,
    String Function(String raw) mapper,
  ) {
    if (value == null) return const [];
    if (value is List) {
      return value
          .map((item) => mapper(item.toString().trim()))
          .where((item) => item.isNotEmpty && item != '—')
          .toList();
    }

    final raw = value.toString().trim();
    if (raw.isEmpty) return const [];
    if (raw.startsWith('[') && raw.endsWith(']')) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded
              .map((item) => mapper(item.toString().trim()))
              .where((item) => item.isNotEmpty && item != '—')
              .toList();
        }
      } catch (_) {}
    }
    return [mapper(raw)];
  }

  Future<void> _copyValue({
    required String label,
    required String value,
  }) async {
    if (value.trim().isEmpty || value == '—') return;

    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$label copiado.',
          style: GoogleFonts.nunito(),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildEnumTile({
    required BuildContext context,
    required String label,
    required List<String> values,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.grayscale30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          if (values.isEmpty)
            Text(
              '—',
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: theme.primary,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: values
                  .map((item) => BrandEnumChip(label: item))
                  .toList(growable: false),
            ),
        ],
      ),
    );
  }

  Widget _buildGeneralTab(BuildContext context, Map<String, dynamic> profile) {
    final cnpj = _displayValue(profile['cnpj']);
    final businessName = _displayValue(profile['business_name']);
    final legalName = _displayValue(profile['legal_name']);
    final email = _displayValue(profile['business_email']);
    final phone = _displayValue(profile['business_phone_number']);
    final contactName = _displayValue(profile['business_contact_name']);
    final municipalRegistration = _displayValue(profile['municipal_registration']);
    final segmentValues = _mapListLikeValues(profile['business_segment'], _mapSegment);
    final companySizeLabel = _mapCompanySize(_displayValue(profile['company_size']));
    final operationModes =
        _mapListLikeValues(profile['operation_mode'], _mapOperationMode);
    final taxRegimeLabel = _mapTaxRegime(_displayValue(profile['tax_regime']));

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 26),
      children: [
        CompanyDataFieldTile(
          label: 'CNPJ',
          value: cnpj,
          onCopy: () => _copyValue(label: 'CNPJ', value: cnpj),
        ),
        CompanyDataFieldTile(
          label: 'Nome fantasia',
          value: businessName,
          onCopy: () => _copyValue(label: 'Nome fantasia', value: businessName),
        ),
        CompanyDataFieldTile(
          label: 'Razão social',
          value: legalName,
          onCopy: () => _copyValue(label: 'Razão social', value: legalName),
        ),
        CompanyDataFieldTile(
          label: 'E-mail empresarial',
          value: email,
          onCopy: () => _copyValue(label: 'E-mail empresarial', value: email),
        ),
        CompanyDataFieldTile(
          label: 'Telefone de contato',
          value: phone,
          onCopy: () => _copyValue(label: 'Telefone de contato', value: phone),
        ),
        CompanyDataFieldTile(
          label: 'Nome do responsável',
          value: contactName,
        ),
        CompanyDataFieldTile(
          label: 'Inscrição municipal',
          value: municipalRegistration,
          onCopy: () => _copyValue(
            label: 'Inscrição municipal',
            value: municipalRegistration,
          ),
        ),
        _buildEnumTile(
          context: context,
          label: 'Segmento',
          values: segmentValues,
        ),
        _buildEnumTile(
          context: context,
          label: 'Porte da empresa',
          values: companySizeLabel == '—' ? const [] : [companySizeLabel],
        ),
        _buildEnumTile(
          context: context,
          label: 'Forma de atuação',
          values: operationModes,
        ),
        _buildEnumTile(
          context: context,
          label: 'Regime tributário',
          values: taxRegimeLabel == '—' ? const [] : [taxRegimeLabel],
        ),
      ],
    );
  }

  Widget _buildAddressTab(BuildContext context, Map<String, dynamic> profile) {
    final theme = FlutterFlowTheme.of(context);
    final rawAddresses = profile['addresses'];
    final addresses = rawAddresses is List
        ? rawAddresses
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList()
        : <Map<String, dynamic>>[];

    if (addresses.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 70, 24, 24),
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 48,
            color: theme.secondaryText.withValues(alpha: 0.45),
          ),
          const SizedBox(height: 12),
          Text(
            'Nenhum endereço cadastrado para esta empresa.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 15,
              color: theme.secondaryText,
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 26),
      itemCount: addresses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final address = addresses[index];
        final type = _mapAddressType(_displayValue(address['address_type']));
        final street = _displayValue(address['address']);
        final number = _displayValue(address['number']);
        final complement = _displayValue(address['complement']);
        final neighborhood = _displayValue(address['neighborhood']);
        final city = _displayValue(address['city']);
        final state = _displayValue(address['state']);
        final zipCode = _displayValue(address['zip_code']);

        return CompanyAddressCard(
          typeLabel: type,
          street: street,
          number: number,
          complement: complement == '—' ? null : complement,
          neighborhood: neighborhood,
          city: city,
          state: state,
          zipCode: zipCode,
        );
      },
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.grayscale20,
        appBar: AppBar(
          backgroundColor: theme.primary,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          toolbarHeight: 68,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.tertiary,
              size: 22,
            ),
            onPressed: () => context.safePop(),
          ),
          title: Text(
            'Dados da Empresa',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: theme.tertiary,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              height: 1,
              color: theme.tertiary.withValues(alpha: 0.22),
            ),
          ),
        ),
        body: Consumer<FFAppState>(
          builder: (context, appState, _) {
            final profile = appState.companyProfile;
            final noCompany = appState.companyId == null || appState.companyId!.isEmpty;

            if (noCompany) {
              return const CompanyNotFoundState(
                message: 'Selecione uma empresa na Home para visualizar esses dados.',
              );
            }

            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.grayscale10,
                        theme.grayscale20,
                      ],
                    ),
                  ),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          decoration: HomeSurfaceTokens.cardDecoration(
                            theme,
                            radius: 12,
                          ),
                          child: const CompanyInfoTabSelector(),
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            color: theme.primary,
                            onRefresh: _onRefresh,
                            child: TabBarView(
                              children: [
                                _buildGeneralTab(context, profile ?? const {}),
                                _buildAddressTab(context, profile ?? const {}),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_model.isRefreshing)
                  Container(
                    color: Colors.black12,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
