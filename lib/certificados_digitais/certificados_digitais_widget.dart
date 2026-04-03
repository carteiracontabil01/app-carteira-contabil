import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/company_profile_service.dart';
import 'certificados_digitais_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

export 'certificados_digitais_model.dart';

/// Lista [certificates_access] de [api.vw_company_by_id] (via [FFAppState.companyProfile]).
class CertificadosDigitaisWidget extends StatefulWidget {
  const CertificadosDigitaisWidget({super.key});

  static String routeName = 'certificadosDigitais';
  static String routePath = 'certificados-digitais';

  @override
  State<CertificadosDigitaisWidget> createState() =>
      _CertificadosDigitaisWidgetState();
}

class _CertificadosDigitaisWidgetState extends State<CertificadosDigitaisWidget> {
  late CertificadosDigitaisModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CertificadosDigitaisModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureProfile());
  }

  Future<void> _ensureProfile() async {
    final appState = context.read<FFAppState>();
    final cid = appState.companyId;
    final cuid = appState.companyUserId;
    if (cid == null || cid.isEmpty || cuid == null || cuid.isEmpty) return;
    if (appState.companyProfile != null &&
        appState.companyProfile!['id']?.toString() == cid) {
      return;
    }
    _model.isRefreshing = true;
    if (mounted) setState(() {});
    await CompanyProfileService.refreshIntoAppState(
      companyId: cid,
      companyUserId: cuid,
    );
    if (!mounted) return;
    _model.isRefreshing = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    final appState = context.read<FFAppState>();
    final cid = appState.companyId;
    final cuid = appState.companyUserId;
    if (cid == null || cid.isEmpty || cuid == null || cuid.isEmpty) return;
    _model.isRefreshing = true;
    if (mounted) setState(() {});
    await CompanyProfileService.refreshIntoAppState(
      companyId: cid,
      companyUserId: cuid,
    );
    if (!mounted) return;
    _model.isRefreshing = false;
    setState(() {});
  }

  static List<Map<String, dynamic>> _certificatesFromProfile(
      Map<String, dynamic>? profile) {
    if (profile == null) return [];
    final raw = profile['certificates_access'];
    if (raw == null) return [];
    if (raw is List) {
      return raw
          .map((e) {
            if (e is Map) {
              return Map<String, dynamic>.from(e);
            }
            return <String, dynamic>{};
          })
          .where((m) => m.isNotEmpty)
          .toList();
    }
    return [];
  }

  static String? _fmtDate(dynamic v, DateFormat fmt) {
    if (v == null) return null;
    if (v is DateTime) return fmt.format(v);
    final s = v.toString();
    if (s.isEmpty) return null;
    try {
      return fmt.format(DateTime.parse(s));
    } catch (_) {
      return s;
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final dateFmt = DateFormat('dd/MM/yyyy');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.primaryText,
              size: 22,
            ),
            onPressed: () => context.safePop(),
          ),
          title: Text(
            'Certificados digitais',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
            ),
          ),
          elevation: 0,
        ),
        body: Consumer<FFAppState>(
          builder: (context, appState, _) {
            final certs = _certificatesFromProfile(appState.companyProfile);
            final noCompany = appState.companyId == null ||
                appState.companyId!.isEmpty;

            if (noCompany) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Selecione uma empresa no início para ver os certificados.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      color: theme.secondaryText,
                    ),
                  ),
                ),
              );
            }

            return Stack(
              children: [
                RefreshIndicator(
                  color: theme.primary,
                  onRefresh: _onRefresh,
                  child: certs.isEmpty && !_model.isRefreshing
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.35,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.verified_user_outlined,
                                      size: 56,
                                      color: theme.secondaryText
                                          .withValues(alpha: 0.45),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Nenhum certificado digital encontrado para esta empresa.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(
                                        fontSize: 15,
                                        color: theme.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: certs.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final c = certs[i];
                            final name =
                                (c['name'] ?? 'Certificado').toString();
                            final type = (c['type'] ?? '—').toString();
                            final login =
                                (c['user_login'] ?? '').toString().trim();
                            final active = c['active'] == true ||
                                c['active'] == 'true';
                            final exp = _fmtDate(c['expiration_date'], dateFmt);
                            final eff = _fmtDate(c['effective_date'], dateFmt);
                            final created =
                                _fmtDate(c['created_at'], dateFmt);

                            return Material(
                              color: theme.secondaryBackground,
                              borderRadius: BorderRadius.circular(14),
                              child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: theme.primary
                                                  .withValues(alpha: 0.12),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.badge_outlined,
                                              color: theme.primary,
                                              size: 26,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  name,
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: theme.primaryText,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Tipo: $type',
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 13,
                                                    color: theme.secondaryText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: active
                                                  ? const Color(0xFF2E7D32)
                                                      .withValues(alpha: 0.12)
                                                  : theme.secondaryText
                                                      .withValues(alpha: 0.12),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              active ? 'Ativo' : 'Inativo',
                                              style: GoogleFonts.nunito(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: active
                                                    ? const Color(0xFF2E7D32)
                                                    : theme.secondaryText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (login.isNotEmpty) ...[
                                        const SizedBox(height: 12),
                                        _line(
                                            context, 'Usuário', login, theme),
                                      ],
                                      if (exp != null)
                                        _line(context, 'Validade', exp, theme),
                                      if (eff != null)
                                        _line(
                                            context, 'Vigência', eff, theme),
                                      if (created != null)
                                        _line(
                                            context, 'Cadastro', created, theme),
                                    ],
                                  ),
                                ),
                            );
                          },
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

  Widget _line(
    BuildContext context,
    String label,
    String value,
    FlutterFlowTheme theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: theme.secondaryText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
