import '/enums/company_access_type_enum.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/company_profile_service.dart';
import 'models/certificate_access_item.dart';
import 'widgets/certificate_card.dart';
import 'widgets/certificate_empty_state.dart';
import 'widgets/certificate_type_tabs.dart';
import 'certificados_digitais_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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

class _CertificadosDigitaisWidgetState
    extends State<CertificadosDigitaisWidget> {
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

  static ({String bucket, String path})? _extractStorageBucketAndPath(
      String rawUrl) {
    final uri = Uri.tryParse(rawUrl);
    if (uri == null) return null;

    // Formato esperado:
    // /storage/v1/object/public/<bucket>/<path>
    final segments = uri.pathSegments;
    final objectIdx = segments.indexOf('object');
    if (objectIdx == -1) return null;
    if (segments.length <= objectIdx + 3) return null;

    final visibility = segments[objectIdx + 1]; // public | sign
    if (visibility != 'public' && visibility != 'sign') return null;

    final bucket = segments[objectIdx + 2];
    final path = segments.skip(objectIdx + 3).join('/');
    if (bucket.isEmpty || path.isEmpty) return null;

    return (bucket: bucket, path: Uri.decodeComponent(path));
  }

  Future<String> _resolveDownloadUrl(String rawUrl) async {
    final parsed = _extractStorageBucketAndPath(rawUrl);
    if (parsed == null) return rawUrl;

    try {
      final result = await Supabase.instance.client.storage
          .from(parsed.bucket)
          .createSignedUrl(parsed.path, 120);
      if (result.isNotEmpty) return result;
    } catch (_) {
      // fallback abaixo
    }
    return rawUrl;
  }

  Future<void> _downloadCertificate(String? url, String fileName) async {
    if (url == null || url.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Este certificado não possui URL de download.',
            style: GoogleFonts.nunito(),
          ),
        ),
      );
      return;
    }
    final resolvedUrl = await _resolveDownloadUrl(url.trim());
    final uri = Uri.tryParse(resolvedUrl);
    if (uri == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'URL de certificado inválida.',
            style: GoogleFonts.nunito(),
          ),
        ),
      );
      return;
    }
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível baixar/abrir o certificado "$fileName".',
            style: GoogleFonts.nunito(),
          ),
        ),
      );
    }
  }

  Widget _buildCertificatesList(
    BuildContext context,
    FlutterFlowTheme theme,
    List<CertificateAccessItem> certificates,
    String emptyMessage,
  ) {
    return RefreshIndicator(
      color: theme.primary,
      onRefresh: _onRefresh,
      child: certificates.isEmpty && !_model.isRefreshing
          ? CertificateEmptyState(message: emptyMessage)
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: certificates.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final certificate = certificates[i];
                return CertificateCard(
                  certificate: certificate,
                  onDownloadPressed: certificate.downloadUrl == null ||
                          certificate.downloadUrl!.trim().isEmpty
                      ? null
                      : () => _downloadCertificate(
                            certificate.downloadUrl,
                            certificate.name,
                          ),
                );
              },
            ),
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
    final dateFmt = DateFormat('dd/MM/yyyy');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.grayscale20,
        appBar: AppBar(
          backgroundColor: theme.primary,
          automaticallyImplyLeading: false,
          toolbarHeight: 68,
          titleSpacing: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.tertiary,
              size: 22,
            ),
            onPressed: () => context.safePop(),
          ),
          title: Text(
            'Certificados digitais',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: theme.tertiary,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Chat',
              onPressed: () => context.pushNamed('chat'),
              icon: Icon(
                Icons.chat_bubble_outline_rounded,
                color: theme.tertiary,
                size: 21,
              ),
            ),
            IconButton(
              onPressed: () => context.pushNamed('notificacoes'),
              icon: Icon(
                Icons.notifications_outlined,
                color: theme.tertiary,
                size: 21,
              ),
            ),
          ],
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
                height: 1, color: theme.tertiary.withValues(alpha: 0.22)),
          ),
        ),
        body: Consumer<FFAppState>(
          builder: (context, appState, _) {
            final certificates = CertificateAccessItem.fromProfile(
                appState.companyProfile, dateFmt);
            final certsPj = certificates
                .where(
                  (certificate) =>
                      certificate.type ==
                      CompanyAccessTypeEnum.legalEntityCertificate,
                )
                .toList();
            final certsPf = certificates
                .where(
                  (certificate) =>
                      certificate.type ==
                      CompanyAccessTypeEnum.individualCertificate,
                )
                .toList();
            final noCompany =
                appState.companyId == null || appState.companyId!.isEmpty;

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
                        CertificatesTypeTabs(
                          pjCount: certsPj.length,
                          pfCount: certsPf.length,
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildCertificatesList(
                                context,
                                theme,
                                certsPj,
                                'Nenhum certificado PJ encontrado para esta empresa.',
                              ),
                              _buildCertificatesList(
                                context,
                                theme,
                                certsPf,
                                'Nenhum certificado PF encontrado para esta empresa.',
                              ),
                            ],
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
