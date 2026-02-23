import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'onboarding_model.dart';
export 'onboarding_model.dart';

// White Label & Tenant
import '../config/environment.dart';
import '../services/tenant_service.dart';
import '/singin/login/login_widget.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({super.key});

  static String routeName = 'onboarding';
  static String routePath = 'inicioApp';

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  late OnboardingModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingModel());

    // On page load action - White Label Tenant Detection
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      try {
        print('🚀 Onboarding - Detectando tenant...');
        print('📦 White Label App: ${appConfig.appName}');
        print('🏷️  Tenant Slug: ${appConfig.tenantSlug}');

        // White Label: Usa o slug fixo da configuração
        final tenantId = await TenantService.detectTenantByUrl(
          '',
          tenantSlug: appConfig.tenantSlug,
        );

        if (tenantId != null) {
          // Busca informações completas do tenant
          final tenantInfo = await TenantService.getTenantInfo(tenantId);

          if (tenantInfo != null) {
            // Salva o tenant no estado global
            FFAppState().setTenant(tenantId, tenantInfo);
            final tenantName = tenantInfo['name'] as String? ?? 'Desconhecido';
            print('✅ Tenant carregado: $tenantName');
          } else {
            print('⚠️ Tenant não encontrado - continuando sem tenant');
            // Não bloqueia o app, apenas loga o aviso
          }
        } else {
          print('⚠️ Tenant não encontrado no banco - continuando sem tenant');
          // Não bloqueia o app, apenas loga o aviso
        }

        safeSetState(() {});
      } catch (e) {
        print('⚠️ Erro ao detectar tenant: $e - continuando sem tenant');
        // Não bloqueia o app, apenas loga o erro
        safeSetState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final availableHeight = screenHeight - safeAreaTop - safeAreaBottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              // Tela inicial
              _buildInitialScreen(),

              // Botões sobrepostos na divisão entre azul e branco
              Positioned(
                bottom: availableHeight * 0.3 -
                    28.0, // Centro do botão amarelo na divisão (metade no azul, metade no branco)
                left: 24.0,
                right: 24.0,
                child: _buildInitialButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tela inicial com layout azul
  Widget _buildInitialScreen() {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final availableHeight = screenHeight - safeAreaTop - safeAreaBottom;

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          // Top Section (70%): Fundo azul escuro
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: availableHeight * 0.3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF15203D), // Azul escuro
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF15203D),
                    const Color(0xFF1a2a4f),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Ícone azul sobreposto ao fundo (decorativo) - ocupa toda a tela
                  Positioned.fill(
                    child: Opacity(
                      opacity:
                          0.2, // Opacidade sutil para não competir com o texto
                      child: Image.asset(
                        'assets/images/icone-azul.png',
                        fit: BoxFit
                            .cover, // Cobre toda a área, cortando se necessário
                      ),
                    ),
                  ),
                  // Ícone verde no topo esquerdo
                  Positioned(
                    top: 40.0,
                    left: 24.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        'assets/images/icone-verde.png',
                        width: 48.0,
                        height: 48.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // "ajuda" no topo direito
                  Positioned(
                    top: 40.0,
                    right: 24.0,
                    child: GestureDetector(
                      onTap: () {
                        context.goNamed('ajuda');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ajuda',
                            style: GoogleFonts.nunito(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 4.0),
                          Icon(
                            Icons.help_outline,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Texto alinhado à esquerda
                  Positioned(
                    left: 24.0,
                    bottom:
                        120.0, // Posicionado próximo à divisão com os botões
                    child: Padding(
                      padding: EdgeInsets.only(right: 32.0),
                      child: Text(
                        'Contabilidade\ndo seu negócio\nem qualquer\nhora e lugar.',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.nunito(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Section (30%): Fundo branco
          Positioned(
            top: availableHeight * 0.7,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Botões da tela inicial
  Widget _buildInitialButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Botão "Criar uma conta" (amarelo) - fica na divisa
        SizedBox(
          width: double.infinity,
          height: 56.0,
          child: FFButtonWidget(
            onPressed: () {
              context.goNamed(LoginWidget.routeName);
            },
            text: 'Criar uma conta',
            options: FFButtonOptions(
              height: 56.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              color: const Color(0xFFD5D91B), // Amarelo #d5d91b
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                    ),
                    color: const Color(0xFF15203D), // Texto escuro
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(28.0),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        // Botão "Entrar" (azul escuro) - fica abaixo, totalmente na parte branca
        SizedBox(
          width: double.infinity,
          height: 56.0,
          child: FFButtonWidget(
            onPressed: () {
              context.goNamed(LoginWidget.routeName);
            },
            text: 'Entrar',
            options: FFButtonOptions(
              height: 56.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              color: const Color(0xFF15203D), // Azul escuro
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                    ),
                    color: Colors.white,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(28.0),
            ),
          ),
        ),
      ],
    );
  }
}
