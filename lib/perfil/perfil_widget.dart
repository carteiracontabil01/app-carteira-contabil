import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'perfil_model.dart';
export 'perfil_model.dart';

class PerfilWidget extends StatefulWidget {
  const PerfilWidget({super.key});

  static String routeName = 'perfil';
  static String routePath = 'perfil';

  @override
  State<PerfilWidget> createState() => _PerfilWidgetState();
}

class _PerfilWidgetState extends State<PerfilWidget> {
  late PerfilModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilModel());
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
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: Navigator.of(context).canPop()
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 28,
                  ),
                  onPressed: () => context.safePop(),
                )
              : null,
          title: Text(
            'Perfil',
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
                // Header com informações do usuário
                if (loggedIn)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.all(24.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      border: Border(
                        bottom: BorderSide(
                          color: FlutterFlowTheme.of(context).grayscale20,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Avatar com avaliação
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            FutureBuilder<List<ClientRow>>(
                              future: ClientTable().queryRows(
                                queryFn: (q) => q.eq('id', currentUserUid),
                              ),
                              builder: (context, snapshot) {
                                final imageUrl = snapshot.hasData &&
                                        snapshot.data!.isNotEmpty
                                    ? snapshot.data!.first.imageUrl
                                    : null;

                                return Container(
                                  width: 80.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: imageUrl == null || imageUrl.isEmpty
                                        ? FlutterFlowTheme.of(context)
                                            .primary
                                            .withValues(alpha: 0.1)
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                    image:
                                        imageUrl != null && imageUrl.isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(imageUrl),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                  ),
                                  child: imageUrl == null || imageUrl.isEmpty
                                      ? Icon(
                                          Icons.person_rounded,
                                          size: 40.0,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                        )
                                      : null,
                                );
                              },
                            ),
                            // Badge de avaliação
                            FutureBuilder<List<MotoboyRatingsRow>>(
                              future: MotoboyRatingsTable().queryRows(
                                queryFn: (q) =>
                                    q.eq('delivery_person_id', currentUserUid),
                              ),
                              builder: (context, snapshot) {
                                // Calcular média (0.0 se não houver avaliações)
                                final ratings = snapshot.data ?? [];
                                final avgRating = ratings.isEmpty
                                    ? 0.0
                                    : ratings.fold<double>(
                                          0,
                                          (sum, rating) => sum + rating.rating,
                                        ) /
                                        ratings.length;

                                return Positioned(
                                  bottom: -4,
                                  child: InkWell(
                                    onTap: () {
                                      // Navegar para tela de avaliações
                                      context.pushNamed(
                                        'avaliacoesDriver',
                                        extra: {
                                          'driverId': currentUserUid,
                                          'ratings': ratings,
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsetsDirectional.symmetric(
                                        horizontal: 8.0,
                                        vertical: 4.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .warning,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.star_rounded,
                                            color: Colors.white,
                                            size: 16.0,
                                          ),
                                          SizedBox(width: 4.0),
                                          Text(
                                            avgRating.toStringAsFixed(1),
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.nunito(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          currentUserEmail.isNotEmpty
                              ? currentUserEmail.split('@')[0]
                              : 'Usuário',
                          style:
                              FlutterFlowTheme.of(context).titleLarge.override(
                                    font: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        SizedBox(height: 4.0),
                        if (currentUserEmail.isNotEmpty)
                          Text(
                            currentUserEmail,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.nunito(),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                ),
                          ),
                      ],
                    ),
                  ),

                // Menu de opções
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context,
                        icon: Icons.person_outline_rounded,
                        title: 'Meus Dados',
                        subtitle: 'Informações pessoais',
                        onTap: () {
                          context.pushNamed(MeusDadosWidget.routeName);
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.security_rounded,
                        title: 'Segurança',
                        subtitle: 'Senha, e-mail e autenticação',
                        onTap: () {
                          context.pushNamed('seguranca');
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.home_outlined,
                        title: 'Meu Endereço',
                        subtitle: 'Endereço residencial',
                        onTap: () {
                          context.pushNamed(AddEnderecoWidget.routeName);
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.settings_outlined,
                        title: 'Configurações',
                        subtitle: 'Preferências do app',
                        onTap: () {
                          context.pushNamed(ConfiguracoesWidget.routeName);
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.help_outline_rounded,
                        title: 'Ajuda',
                        subtitle: 'Central de ajuda e suporte',
                        onTap: () {
                          context.pushNamed(AjudaWidget.routeName);
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

                      // Logout
                      if (loggedIn)
                        _buildMenuItem(
                          context,
                          icon: Icons.logout_rounded,
                          title: 'Sair',
                          subtitle: 'Desconectar da conta',
                          titleColor: Colors.red,
                          onTap: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Sair'),
                                content: Text(
                                    'Tem certeza que deseja sair da sua conta?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text(
                                      'Sair',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true) {
                              await authManager.signOut();
                              if (context.mounted) {
                                context.goNamedAuth(
                                    'onboarding', context.mounted);
                              }
                            }
                          },
                        ),

                      // Versão do app
                      Padding(
                        padding: EdgeInsetsDirectional.all(24.0),
                        child: Center(
                          child: Text(
                            'Versão 1.0.0',
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.nunito(),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
    Color? titleColor,
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
                color:
                    FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(
                icon,
                size: 24.0,
                color: titleColor ?? FlutterFlowTheme.of(context).primary,
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
                          color: titleColor ??
                              FlutterFlowTheme.of(context).primaryText,
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
