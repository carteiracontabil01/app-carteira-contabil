import '/app_state.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/widgets/home_surface_tokens.dart';
import '/services/company_profile_service.dart';
import 'ajuda_model.dart';
import 'widgets/help_menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

export 'ajuda_model.dart';

class AjudaWidget extends StatefulWidget {
  const AjudaWidget({super.key});

  static String routeName = 'ajuda';
  static String routePath = 'ajuda';

  @override
  State<AjudaWidget> createState() => _AjudaWidgetState();
}

class _AjudaWidgetState extends State<AjudaWidget> {
  late AjudaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AjudaModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureProfile());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _ensureProfile() async {
    final appState = context.read<FFAppState>();
    final companyId = appState.companyId;
    final companyUserId = appState.companyUserId;
    final profile = appState.companyProfile;
    final hasAccountingOffice =
        profile?['accounting_offices'] is Map || profile?['accounting_office'] is Map;

    if (companyId == null ||
        companyId.isEmpty ||
        companyUserId == null ||
        companyUserId.isEmpty ||
        hasAccountingOffice) {
      return;
    }

    _isRefreshing = true;
    if (mounted) setState(() {});

    await CompanyProfileService.refreshIntoAppState(
      companyId: companyId,
      companyUserId: companyUserId,
    );

    if (!mounted) return;
    _isRefreshing = false;
    setState(() {});
  }

  Future<void> _openPhone(String phone) async {
    final sanitized = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (sanitized.isEmpty) {
      _showContactUnavailable('Telefone');
      return;
    }

    final phoneUri = Uri(scheme: 'tel', path: sanitized);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      _showContactUnavailable('Telefone');
    }
  }

  Future<void> _openEmail(String email) async {
    final sanitized = email.trim();
    if (sanitized.isEmpty || !sanitized.contains('@')) {
      _showContactUnavailable('E-mail');
      return;
    }

    final emailUri = Uri(
      scheme: 'mailto',
      path: sanitized,
      query: 'subject=Ajuda - Carteira Contábil',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      _showContactUnavailable('E-mail');
    }
  }

  Future<void> _openWhatsApp(String whatsapp) async {
    var digits = whatsapp.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      _showContactUnavailable('WhatsApp');
      return;
    }

    if (!digits.startsWith('55')) {
      digits = '55$digits';
    }

    final whatsappUri = Uri.parse(
      'https://wa.me/$digits?text=Olá,%20preciso%20de%20ajuda',
    );
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      _showContactUnavailable('WhatsApp');
    }
  }

  void _showContactUnavailable(String channel) {
    if (!mounted) return;

    final theme = FlutterFlowTheme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$channel indisponível para esta empresa.',
          style: GoogleFonts.nunito(
            color: theme.tertiary,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: theme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatPhoneForDisplay(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return '';

    // Remove country code (55) when present.
    final normalized =
        digits.length > 11 && digits.startsWith('55') ? digits.substring(2) : digits;

    if (normalized.length == 11) {
      return '(${normalized.substring(0, 2)}) '
          '${normalized.substring(2, 7)}-${normalized.substring(7, 11)}';
    }

    if (normalized.length == 10) {
      return '(${normalized.substring(0, 2)}) '
          '${normalized.substring(2, 6)}-${normalized.substring(6, 10)}';
    }

    return value;
  }

  Widget _buildSection({
    required BuildContext context,
    required List<Widget> children,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: HomeSurfaceTokens.cardDecoration(theme, radius: 20),
      child: Column(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final appState = context.watch<FFAppState>();
    final profile = appState.companyProfile;
    final accountingOfficeRaw =
        profile?['accounting_offices'] ?? profile?['accounting_office'];
    final accountingOffice = accountingOfficeRaw is Map
        ? Map<String, dynamic>.from(accountingOfficeRaw)
        : null;

    final phone = accountingOffice?['contact_phone']?.toString().trim() ?? '';
    final email = accountingOffice?['contact_email']?.toString().trim() ?? '';
    final whatsapp =
        accountingOffice?['contact_whatsapp']?.toString().trim() ?? '';

    final phoneLabel =
        phone.isNotEmpty ? _formatPhoneForDisplay(phone) : 'Não informado';
    final emailLabel = email.isNotEmpty ? email : 'Não informado';
    final whatsappLabel =
        whatsapp.isNotEmpty ? _formatPhoneForDisplay(whatsapp) : 'Não informado';

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
            'Ajuda e Suporte',
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
        body: SafeArea(
          child: Container(
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
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 20),
                  child: Column(
                    children: [
                      _buildSection(
                        context: context,
                        children: [
                          HelpMenuTile(
                            icon: Icons.phone_outlined,
                            title: 'Telefone',
                            subtitle: phoneLabel,
                            onTap: () => _openPhone(phone),
                            showDivider: true,
                          ),
                          HelpMenuTile(
                            icon: Icons.email_outlined,
                            title: 'E-mail',
                            subtitle: emailLabel,
                            onTap: () => _openEmail(email),
                            showDivider: true,
                          ),
                          HelpMenuTile(
                            icon: Icons.chat_bubble_outline_rounded,
                            title: 'WhatsApp',
                            subtitle: whatsappLabel,
                            onTap: () => _openWhatsApp(whatsapp),
                          ),
                        ],
                      ),
                      _buildSection(
                        context: context,
                        children: [
                          HelpMenuTile(
                            icon: Icons.description_outlined,
                            title: 'Termos de Uso',
                            subtitle: 'Leia nossos termos de uso',
                            onTap: () => context.pushNamed('termosUso'),
                            showDivider: true,
                          ),
                          HelpMenuTile(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Política de Privacidade',
                            subtitle: 'Leia nossa política de privacidade',
                            onTap: () =>
                                context.pushNamed('politicaPrivacidade'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_isRefreshing)
                  Container(
                    color: Colors.black12,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
