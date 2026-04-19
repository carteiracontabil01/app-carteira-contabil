import '/app_state.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/widgets/home_surface_tokens.dart';
import 'cnaes_servicos_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

export 'cnaes_servicos_model.dart';

class CnaesServicosWidget extends StatefulWidget {
  const CnaesServicosWidget({super.key});

  static String routeName = 'cnaesServicos';
  static String routePath = 'cnaes-servicos';

  @override
  State<CnaesServicosWidget> createState() => _CnaesServicosWidgetState();
}

class _CnaesServicosWidgetState extends State<CnaesServicosWidget> {
  late CnaesServicosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CnaesServicosModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _extractCnaes(Map<String, dynamic>? profile) {
    final raw = profile?['cnaes'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: theme.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String code,
    required String description,
    required bool principal,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: theme.grayscale20,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: principal
              ? theme.primary.withValues(alpha: 0.25)
              : theme.grayscale30,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (code.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    code,
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: theme.primary,
                    ),
                  ),
                ),
              if (code.isNotEmpty) const SizedBox(width: 8),
              if (principal)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6FFF0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Principal',
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1D8B5E),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: theme.primary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  String _ellipsis(String value, {int max = 220}) {
    final trimmed = value.trim();
    if (trimmed.length <= max) return trimmed;
    return '${trimmed.substring(0, max)}...';
  }

  Widget _buildCnaeTile(BuildContext context, Map<String, dynamic> cnae) {
    final theme = FlutterFlowTheme.of(context);
    final code = (cnae['code'] ?? '---').toString();
    final description = (cnae['description'] ?? 'Sem descrição').toString();
    final isPrimary = cnae['principal'] == true;

    final rawServices = cnae['serviceItemsLc116'];
    final services = rawServices is List
        ? rawServices
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList()
        : <Map<String, dynamic>>[];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: HomeSurfaceTokens.cardDecoration(theme, radius: 14),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          iconColor: theme.primary,
          collapsedIconColor: theme.secondaryText,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      code,
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: theme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isPrimary)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6FFF0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Primário',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1D8B5E),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: theme.primary,
                ),
              ),
            ],
          ),
          children: [
            if (services.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Nenhum serviço selecionado para este CNAE.',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Serviços selecionados',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: theme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...services.map((service) {
                    final codeLc = (service['code_lc116'] ?? '').toString();
                    final desc =
                        (service['description'] ?? 'Serviço sem descrição').toString();
                    final isServicePrimary = service['principal'] == true;
                    return _buildServiceCard(
                      context,
                      code: codeLc,
                      description: _ellipsis(desc),
                      principal: isServicePrimary,
                    );
                  }),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final appState = context.watch<FFAppState>();

    final cnaes = _extractCnaes(appState.companyProfile);
    final primary = cnaes.where((item) => item['principal'] == true).toList();
    final secondary = cnaes.where((item) => item['principal'] != true).toList();
    final noCompany = appState.companyId == null || appState.companyId!.isEmpty;

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
            'CNAEs e Serviços',
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
        body: Container(
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
          child: noCompany
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Selecione uma empresa para visualizar os CNAEs e serviços.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        color: theme.secondaryText,
                      ),
                    ),
                  ),
                )
              : cnaes.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Nenhum CNAE encontrado para esta empresa.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            color: theme.secondaryText,
                          ),
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(0, 14, 0, 24),
                      children: [
                        _buildSectionTitle(
                          context,
                          title: 'CNAE Primário',
                          subtitle: 'Atividade principal da empresa',
                        ),
                        if (primary.isEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                            child: Text(
                              'Nenhum CNAE primário informado.',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: theme.secondaryText,
                              ),
                            ),
                          )
                        else
                          ...primary.map((item) => _buildCnaeTile(context, item)),
                        _buildSectionTitle(
                          context,
                          title: 'CNAEs Secundários',
                          subtitle: 'Atividades complementares',
                        ),
                        if (secondary.isEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                            child: Text(
                              'Nenhum CNAE secundário informado.',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: theme.secondaryText,
                              ),
                            ),
                          )
                        else
                          ...secondary.map((item) => _buildCnaeTile(context, item)),
                      ],
                    ),
        ),
      ),
    );
  }
}
