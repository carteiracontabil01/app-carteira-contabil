import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/biometric_service.dart';
import '/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'seguranca_model.dart';
export 'seguranca_model.dart';

class SegurancaWidget extends StatefulWidget {
  const SegurancaWidget({super.key});

  static String routeName = 'seguranca';
  static String routePath = 'seguranca';

  @override
  State<SegurancaWidget> createState() => _SegurancaWidgetState();
}

class _SegurancaWidgetState extends State<SegurancaWidget>
    with WidgetsBindingObserver {
  late SegurancaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Biometria
  final _biometricService = BiometricService();
  final _secureStorage = SecureStorageService();
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  String _biometricType = 'Biometria';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SegurancaModel());
    _checkBiometricStatus();

    // Adicionar observer do ciclo de vida do app
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Quando o app volta ao primeiro plano, atualizar dados do usuário
    if (state == AppLifecycleState.resumed) {
      _refreshUserData();
    }
  }

  Future<void> _refreshUserData() async {
    try {
      await currentUser?.refreshUser();
      if (mounted) {
        setState(() {}); // Força rebuild com novos dados
      }
    } catch (e) {
      // Silenciar erros de refresh
    }
  }

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

  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      // Ativar biometria
      final authenticated = await _biometricService.authenticate(
        reason: 'Autentique-se para ativar $_biometricType',
      );

      if (authenticated) {
        // Pedir credenciais para salvar
        final credentials = await _showCredentialsDialog();

        if (credentials != null) {
          await _secureStorage.saveCredentials(
            email: credentials['email']!,
            password: credentials['password']!,
          );
          await _secureStorage.setBiometricEnabled(true);

          setState(() => _biometricEnabled = true);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$_biometricType ativado com sucesso!'),
                backgroundColor: FlutterFlowTheme.of(context).success,
              ),
            );
          }
        }
      }
    } else {
      // Desativar biometria
      await _secureStorage.clearCredentials();
      await _secureStorage.setBiometricEnabled(false);

      setState(() => _biometricEnabled = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$_biometricType desativado'),
            backgroundColor: FlutterFlowTheme.of(context).secondaryText,
          ),
        );
      }
    }
  }

  Future<Map<String, String>?> _showCredentialsDialog() async {
    final emailController = TextEditingController(text: currentUserEmail);
    final passwordController = TextEditingController();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirme suas credenciais'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
              enabled: false,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (passwordController.text.isNotEmpty) {
                Navigator.pop(context, {
                  'email': emailController.text,
                  'password': passwordController.text,
                });
              }
            },
            child: Text(
              'Confirmar',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _model.dispose();
    super.dispose();
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool? value,
    Function(bool)? onChanged,
  }) {
    final bool isSwitch = value != null && onChanged != null;

    return InkWell(
      onTap: isSwitch ? null : onTap,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          border: Border(
            bottom: BorderSide(
              color: FlutterFlowTheme.of(context).grayscale20,
              width: 1.0,
            ),
          ),
        ),
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
                color: FlutterFlowTheme.of(context).primary,
                size: 24.0,
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
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 4.0),
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
            if (isSwitch)
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeTrackColor: FlutterFlowTheme.of(context).primary,
              )
            else
              Icon(
                Icons.chevron_right_rounded,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 24.0,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
            'Segurança',
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
          top: true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cabeçalho informativo
                Container(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 64.0,
                            height: 64.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.security_rounded,
                              size: 32.0,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Proteja sua conta',
                                  style: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        font: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                        ),
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Gerencie a segurança da sua conta',
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
                        ],
                      ),
                    ],
                  ),
                ),

                // Seção de Autenticação
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 16.0),
                  child: Text(
                    'AUTENTICAÇÃO',
                    style: FlutterFlowTheme.of(context).labelSmall.override(
                          font: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 1.0,
                        ),
                  ),
                ),

                // Login Biométrico
                if (_biometricAvailable)
                  _buildMenuItem(
                    context,
                    icon: Icons.fingerprint_rounded,
                    title: 'Login Biométrico',
                    subtitle: 'Entre rapidamente usando $_biometricType',
                    value: _biometricEnabled,
                    onChanged: _toggleBiometric,
                    onTap: () {},
                  ),

                // Seção de Credenciais
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 16.0),
                  child: Text(
                    'CREDENCIAIS',
                    style: FlutterFlowTheme.of(context).labelSmall.override(
                          font: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 1.0,
                        ),
                  ),
                ),

                // Alterar Senha
                _buildMenuItem(
                  context,
                  icon: Icons.lock_outline_rounded,
                  title: 'Alterar Senha',
                  subtitle: 'Modificar sua senha de acesso',
                  onTap: () {
                    context.pushNamed('alterarSenha');
                  },
                ),

                // Alterar Email
                _buildMenuItem(
                  context,
                  icon: Icons.email_outlined,
                  title: 'Alterar E-mail',
                  subtitle: 'Modificar seu e-mail de acesso',
                  onTap: () {
                    context.pushNamed('alterarEmail');
                  },
                ),

                // Informações adicionais
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .info
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).info,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: FlutterFlowTheme.of(context).info,
                          size: 20.0,
                        ),
                        SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dica de Segurança',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'Use uma senha forte com letras, números e caracteres especiais. Ative a autenticação biométrica para maior segurança.',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.nunito(),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
