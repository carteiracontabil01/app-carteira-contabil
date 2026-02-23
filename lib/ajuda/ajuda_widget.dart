import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ajuda_model.dart';
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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AjudaModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
            borderRadius: 30.0,
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
            'Ajuda e Suporte',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  font: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tickets
                _buildMenuItem(
                  context,
                  icon: Icons.confirmation_number_outlined,
                  title: 'Meus Tickets',
                  subtitle: 'Acompanhe seus chamados',
                  onTap: () {
                    context.pushNamed('tickets');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.add_box_outlined,
                  title: 'Abrir Novo Ticket',
                  subtitle: 'Relate um problema ou dúvida',
                  onTap: () {
                    context.pushNamed('suporte');
                  },
                ),

                // Divider
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Divider(
                    color: FlutterFlowTheme.of(context).grayscale20,
                  ),
                ),

                // Contato
                _buildMenuItem(
                  context,
                  icon: Icons.phone_outlined,
                  title: 'Telefone',
                  subtitle: '0800 123 4567',
                  onTap: () async {
                    final Uri phoneUri =
                        Uri(scheme: 'tel', path: '08001234567');
                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    }
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.email_outlined,
                  title: 'E-mail',
                  subtitle: 'suporte@carteiracontabil.com.br',
                  onTap: () async {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'suporte@carteiracontabil.com.br',
                      query: 'subject=Ajuda - Carteira Contábil',
                    );
                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(emailUri);
                    }
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'WhatsApp',
                  subtitle: '(00) 90000-0000',
                  onTap: () async {
                    final Uri whatsappUri = Uri.parse(
                        'https://wa.me/5500900000000?text=Olá,%20preciso%20de%20ajuda');
                    if (await canLaunchUrl(whatsappUri)) {
                      await launchUrl(whatsappUri,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                ),

                // Divider
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Divider(
                    color: FlutterFlowTheme.of(context).grayscale20,
                  ),
                ),

                // Links Úteis
                _buildMenuItem(
                  context,
                  icon: Icons.description_outlined,
                  title: 'Termos de Uso',
                  subtitle: 'Leia nossos termos de uso',
                  onTap: () {
                    context.pushNamed('termosUso');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: 'Política de Privacidade',
                  subtitle: 'Leia nossa política de privacidade',
                  onTap: () {
                    context.pushNamed('politicaPrivacidade');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.assignment_return_outlined,
                  title: 'Política de Devolução',
                  subtitle: 'Conheça nossa política de devolução',
                  onTap: () {
                    context.pushNamed('politicaDevolucao');
                  },
                ),

                SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
        child: Row(
          children: [
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).grayscale20,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(
                icon,
                size: 24.0,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          font: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600,
                          ),
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    subtitle,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.nunito(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.0,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}
