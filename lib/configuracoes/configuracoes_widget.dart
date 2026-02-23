import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/biometric_service.dart';
import '/services/secure_storage_service.dart';
import '/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'configuracoes_model.dart';
export 'configuracoes_model.dart';

class ConfiguracoesWidget extends StatefulWidget {
  const ConfiguracoesWidget({super.key});

  static String routeName = 'Configuracoes';
  static String routePath = 'configuracoes';

  @override
  State<ConfiguracoesWidget> createState() => _ConfiguracoesWidgetState();
}

class _ConfiguracoesWidgetState extends State<ConfiguracoesWidget> {
  late ConfiguracoesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Estados dos switches
  bool _notificacoesEntregas = true;
  bool _modoEscuro = false;
  bool _vibracao = true;
  bool _sons = true;

  // Biometria
  final _biometricService = BiometricService();
  final _secureStorage = SecureStorageService();
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  String _biometricType = 'Biometria';

  // Serviço de configurações
  final _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConfiguracoesModel());

    // Carregar configurações salvas
    _loadSettings();

    // Verificar biometria
    _checkBiometricStatus();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  /// Carrega as configurações salvas do banco
  Future<void> _loadSettings() async {
    try {
      final userId = currentUserUid;
      final tenantId = FFAppState().tenantId;

      final settings = await _settingsService.loadSettings(userId, tenantId);

      if (mounted) {
        setState(() {
          _notificacoesEntregas = settings.notificationsOrders;
          _modoEscuro = settings.darkMode;
          _vibracao = settings.vibration;
          _sons = settings.appSounds;
        });
      }
    } catch (e) {
      print('❌ Erro ao carregar configurações: $e');
      // Manter valores padrão em caso de erro
    }
  }

  /// Verifica o status da biometria
  Future<void> _checkBiometricStatus() async {
    final isAvailable = await _biometricService.isBiometricAvailable();
    final isEnabled = await _secureStorage.isBiometricEnabled();
    final biometricType = await _biometricService.getBiometricTypeDescription();

    if (mounted) {
      setState(() {
        _biometricAvailable = isAvailable;
        _biometricEnabled = isEnabled;
        _biometricType = biometricType;
      });
    }
  }

  /// Alterna o status da biometria
  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      // Ativar biometria
      final hasEnrolled = await _biometricService.hasBiometricsEnrolled();

      if (!hasEnrolled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Configure $_biometricType nas configurações do dispositivo primeiro'),
            backgroundColor: FlutterFlowTheme.of(context).warning,
          ),
        );
        return;
      }

      // Perguntar email/senha para salvar (SEM pedir biometria antes)
      await _showCredentialsDialog();
    } else {
      // Desativar biometria
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Desativar $_biometricType?'),
          content:
              Text('Você precisará digitar email e senha para fazer login.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Desativar',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).error,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await _secureStorage.setBiometricEnabled(false);

        setState(() {
          _biometricEnabled = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$_biometricType desativado'),
              backgroundColor: FlutterFlowTheme.of(context).info,
            ),
          );
        }
      }
    }
  }

  /// Mostra diálogo para inserir credenciais
  Future<void> _showCredentialsDialog() async {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Configurar $_biometricType'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Digite suas credenciais para habilitar o login rápido com $_biometricType.',
              style: TextStyle(
                fontSize: 14,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: Icon(Icons.lock_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Ativar',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Preencha email e senha'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
        return;
      }

      // Validar credenciais tentando fazer login
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Text('Validando credenciais...'),
              ],
            ),
            backgroundColor: FlutterFlowTheme.of(context).primary,
            duration: Duration(seconds: 2),
          ),
        );

        final user = await authManager.signInWithEmail(
          context,
          emailController.text,
          passwordController.text,
        );

        if (user == null) {
          // Login falhou - credenciais inválidas
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Email ou senha incorretos'),
                backgroundColor: FlutterFlowTheme.of(context).error,
              ),
            );
          }
          return;
        }

        // Credenciais válidas - salvar
        await _secureStorage.saveCredentials(
          email: emailController.text,
          password: passwordController.text,
        );
        await _secureStorage.setBiometricEnabled(true);

        setState(() {
          _biometricEnabled = true;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '$_biometricType ativado! Use sua biometria no próximo login.'),
              backgroundColor: FlutterFlowTheme.of(context).success,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        print('❌ Erro ao validar credenciais: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao validar credenciais'),
              backgroundColor: FlutterFlowTheme.of(context).error,
            ),
          );
        }
      }
    }

    emailController.dispose();
    passwordController.dispose();
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
            'Configurações',
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
                // Notificações
                _buildSectionHeader(context, 'Notificações'),
                _buildSwitchItem(
                  context,
                  icon: Icons.delivery_dining_outlined,
                  title: 'Notificações de Entregas',
                  subtitle: 'Receba alertas sobre novas entregas e atualizações',
                  value: _notificacoesEntregas,
                  onChanged: (value) async {
                    setState(() {
                      _notificacoesEntregas = value;
                    });
                    await _settingsService.setNotificacoesPedidos(value);
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

                // Aparência
                _buildSectionHeader(context, 'Aparência'),
                _buildSwitchItem(
                  context,
                  icon: Icons.dark_mode_outlined,
                  title: 'Modo Escuro',
                  subtitle: 'Ativar tema escuro',
                  value: _modoEscuro,
                  onChanged: (value) async {
                    setState(() {
                      _modoEscuro = value;
                    });
                    await _settingsService.setModoEscuro(value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Modo escuro ${value ? 'ativado' : 'desativado'}'),
                        backgroundColor: FlutterFlowTheme.of(context).info,
                        duration: Duration(seconds: 2),
                      ),
                    );
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

                // Som e Vibração
                _buildSectionHeader(context, 'Som e Vibração'),
                _buildSwitchItem(
                  context,
                  icon: Icons.volume_up_outlined,
                  title: 'Sons do App',
                  subtitle: 'Reproduzir sons de notificações',
                  value: _sons,
                  onChanged: (value) async {
                    setState(() {
                      _sons = value;
                    });
                    await _settingsService.setSons(value);
                  },
                ),
                _buildSwitchItem(
                  context,
                  icon: Icons.vibration_outlined,
                  title: 'Vibração',
                  subtitle: 'Vibrar ao receber notificações',
                  value: _vibracao,
                  onChanged: (value) async {
                    setState(() {
                      _vibracao = value;
                    });
                    await _settingsService.setVibracao(value);
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

                // Privacidade e Segurança
                _buildSectionHeader(context, 'Privacidade e Segurança'),

                // Login Biométrico (só aparece se disponível)
                if (_biometricAvailable)
                  _buildSwitchItem(
                    context,
                    icon: Icons.fingerprint_rounded,
                    title: 'Login com $_biometricType',
                    subtitle: 'Entre rapidamente usando biometria',
                    value: _biometricEnabled,
                    onChanged: _toggleBiometric,
                  ),

                _buildMenuItem(
                  context,
                  icon: Icons.lock_outline_rounded,
                  title: 'Alterar Senha',
                  subtitle: 'Modificar sua senha de acesso',
                  onTap: () {
                    context.pushNamed('recuperarsenha');
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
                  icon: Icons.description_outlined,
                  title: 'Termos de Uso',
                  subtitle: 'Leia nossos termos de uso',
                  onTap: () {
                    context.pushNamed('termosUso');
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

                // Sobre
                _buildSectionHeader(context, 'Sobre'),
                _buildMenuItem(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: 'Sobre o App',
                  subtitle: 'Versão 1.0.0',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'TaiGostei',
                      applicationVersion: '1.0.0',
                      applicationIcon: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Icon(
                          Icons.shopping_bag_rounded,
                          color: Colors.white,
                          size: 32.0,
                        ),
                      ),
                      children: [
                        Text(
                          'Seu app de delivery favorito!',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ],
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.star_outline_rounded,
                  title: 'Avaliar App',
                  subtitle: 'Deixe sua opinião',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Obrigado pelo interesse!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 8.0),
      child: Text(
        title,
        style: FlutterFlowTheme.of(context).titleSmall.override(
              font: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
              ),
              color: FlutterFlowTheme.of(context).primary,
              letterSpacing: 0.0,
            ),
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      child: Row(
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              icon,
              size: 24.0,
              color: FlutterFlowTheme.of(context).primary,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: FlutterFlowTheme.of(context).primary,
          ),
        ],
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
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
        child: Row(
          children: [
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(
                icon,
                size: 24.0,
                color: FlutterFlowTheme.of(context).primary,
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
