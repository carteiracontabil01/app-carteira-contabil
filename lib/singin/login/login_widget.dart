import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/biometric_service.dart';
import '/services/secure_storage_service.dart';
import '/services/permission_service.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_model.dart';
export 'login_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String routeName = 'login';
  static String routePath = 'login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // Controle de tabs: 0 = Login, 1 = Cadastro, 2 = Reset Senha
  late int _currentTab;

  // Biometria
  final _biometricService = BiometricService();
  final _secureStorage = SecureStorageService();
  final _permissionService = PermissionService();
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  String _biometricType = 'Biometria';

  // Controle de cooldown para reset de senha
  bool _canSendResetEmail = true;
  int _cooldownSeconds = 0;

  @override
  void initState() {
    super.initState();
    // Começa com a tela de login
    _currentTab = 0;
    _model = createModel(context, () => LoginModel());

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    _model.fullNameCreateTextController ??= TextEditingController();
    _model.fullNameCreateFocusNode ??= FocusNode();

    _model.cpfCreateTextController ??= TextEditingController();
    _model.cpfCreateFocusNode ??= FocusNode();

    _model.phoneCreateTextController ??= TextEditingController();
    _model.phoneCreateFocusNode ??= FocusNode();

    _model.emailAddressCreateTextController ??= TextEditingController();
    _model.emailAddressCreateFocusNode ??= FocusNode();

    _model.passwordCreateTextController ??= TextEditingController();
    _model.passwordCreateFocusNode ??= FocusNode();

    _model.passwordConfirmTextController ??= TextEditingController();
    _model.passwordConfirmFocusNode ??= FocusNode();

    _model.emailAddressResetTextController ??= TextEditingController();
    _model.emailAddressResetFocusNode ??= FocusNode();

    // Verificar disponibilidade de biometria
    _checkBiometricAvailability();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  /// Verifica se a biometria está disponível e habilitada
  Future<void> _checkBiometricAvailability() async {
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

  /// Faz login usando biometria
  Future<void> _loginWithBiometric() async {
    try {
      // Verificar se tem credenciais salvas
      final hasCredentials = await _secureStorage.hasCredentials();

      if (!hasCredentials) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Faça login primeiro para habilitar a biometria'),
            backgroundColor: FlutterFlowTheme.of(context).warning,
          ),
        );
        return;
      }

      // Autenticar com biometria
      final authenticated = await _biometricService.authenticate(
        reason: 'Use sua biometria para entrar no app',
      );

      if (!authenticated) {
        return; // Usuário cancelou ou falhou
      }

      // Recuperar credenciais
      final credentials = await _secureStorage.getCredentials();

      if (credentials == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Credenciais não encontradas'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
        return;
      }

      // Fazer login com as credenciais salvas
      GoRouter.of(context).prepareAuthEvent();

      final user = await authManager.signInWithEmail(
        context,
        credentials['email']!,
        credentials['password']!,
      );

      if (user != null) {
        // Login bem-sucedido
        print('✅ Login biométrico bem-sucedido');

        // Configurar FCM Token após login biométrico
        try {
          await actions.setFCMToken();
          print('✅ FCM Token configurado após login biométrico');
        } catch (e) {
          print('⚠️ Erro ao configurar FCM Token: $e');
        }

        if (mounted) {
          context.goNamedAuth('home', context.mounted);
        }
      }
    } catch (e) {
      print('❌ Erro no login biométrico: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer login com biometria'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  /// Inicia cooldown para evitar múltiplas tentativas de reset
  Future<void> _startResetCooldown() async {
    setState(() {
      _canSendResetEmail = false;
      _cooldownSeconds = 60; // 1 minuto
    });

    while (_cooldownSeconds > 0) {
      await Future.delayed(Duration(seconds: 1));
      if (mounted) {
        setState(() => _cooldownSeconds--);
      }
    }

    if (mounted) {
      setState(() => _canSendResetEmail = true);
    }
  }

  /// Pergunta ao usuário se deseja habilitar biometria
  Future<void> _promptEnableBiometric(String email, String password) async {
    final biometricAvailable = await _biometricService.isBiometricAvailable();

    if (!biometricAvailable) return;

    final hasEnrolled = await _biometricService.hasBiometricsEnrolled();
    if (!hasEnrolled) return;

    // Verificar se já está habilitado
    final isAlreadyEnabled = await _secureStorage.isBiometricEnabled();
    if (isAlreadyEnabled) return;

    final biometricType = await _biometricService.getBiometricTypeDescription();

    if (mounted) {
      final shouldEnable = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ativar $biometricType?'),
          content: Text(
            'Deseja usar $biometricType para fazer login mais rapidamente nas próximas vezes?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Agora não'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Ativar',
                style: TextStyle(
                  color: const Color(0xFF15203D), // Azul escuro padrão
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

      if (shouldEnable == true) {
        // Salvar credenciais
        await _secureStorage.saveCredentials(
          email: email,
          password: password,
        );
        await _secureStorage.setBiometricEnabled(true);

        setState(() {
          _biometricEnabled = true;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$biometricType ativado com sucesso!'),
              backgroundColor: FlutterFlowTheme.of(context).success,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 40.0, 24.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: Image.asset(
                        'assets/images/logo-colorida.png',
                        width: 240.0,
                        height: 80.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.0),

                  // Título
                  Text(
                    _currentTab == 0
                        ? 'Bem-vindo!'
                        : _currentTab == 1
                            ? 'Criar conta'
                            : 'Recuperar senha',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                          ),
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    _currentTab == 0
                        ? 'Entre com suas credenciais'
                        : _currentTab == 1
                            ? 'Preencha seus dados para cadastrar'
                            : 'Digite seu e-mail para redefinir a senha',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.nunito(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 32.0),

                  // Tabs (ocultar no modo reset)
                  if (_currentTab != 2)
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).grayscale20,
                        borderRadius:
                            BorderRadius.circular(28.0), // Mais arredondado
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _currentTab = 0),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 14.0),
                                decoration: BoxDecoration(
                                  color: _currentTab == 0
                                      ? const Color(
                                          0xFF15203D) // Azul escuro padrão
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      28.0), // Mais arredondado
                                ),
                                child: Text(
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        color: _currentTab == 0
                                            ? Colors.white
                                            : FlutterFlowTheme.of(context)
                                                .secondaryText,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _currentTab = 1),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 14.0),
                                decoration: BoxDecoration(
                                  color: _currentTab == 1
                                      ? const Color(
                                          0xFF15203D) // Azul escuro padrão
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      28.0), // Mais arredondado
                                ),
                                child: Text(
                                  'Cadastrar',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        color: _currentTab == 1
                                            ? Colors.white
                                            : FlutterFlowTheme.of(context)
                                                .secondaryText,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_currentTab != 2) SizedBox(height: 32.0),

                  // Botão voltar para login (no modo reset)
                  if (_currentTab == 2) ...[
                    SizedBox(height: 16.0),
                    InkWell(
                      onTap: () => setState(() => _currentTab = 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 20.0,
                            color:
                                const Color(0xFF15203D), // Azul escuro padrão
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Voltar para login',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  color: const Color(
                                      0xFF15203D), // Azul escuro padrão
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.0),
                  ],

                  // Formulário
                  Form(
                    key: _formKey,
                    child: _currentTab == 0
                        ? _buildLoginForm()
                        : _currentTab == 1
                            ? _buildSignUpForm()
                            : _buildResetPasswordForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Formulário de Login
  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email
        TextFormField(
          controller: _model.emailAddressTextController,
          focusNode: _model.emailAddressFocusNode,
          autofocus: false,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'E-mail',
            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            hintText: 'Digite seu e-mail',
            hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).grayscale20,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF15203D), // Azul escuro padrão
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding: EdgeInsetsDirectional.all(16.0),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.nunito(),
                letterSpacing: 0.0,
              ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'O e-mail é obrigatório';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Digite um e-mail válido';
            }
            return null;
          },
        ),
        SizedBox(height: 16.0),

        // Senha
        TextFormField(
          controller: _model.passwordTextController,
          focusNode: _model.passwordFocusNode,
          autofocus: false,
          obscureText: !_model.passwordVisibility,
          decoration: InputDecoration(
            labelText: 'Senha',
            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            hintText: 'Digite sua senha',
            hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).grayscale20,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF15203D), // Azul escuro padrão
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding: EdgeInsetsDirectional.all(16.0),
            prefixIcon: Icon(
              Icons.lock_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            suffixIcon: InkWell(
              onTap: () => setState(
                () => _model.passwordVisibility = !_model.passwordVisibility,
              ),
              focusNode: FocusNode(skipTraversal: true),
              child: Icon(
                _model.passwordVisibility
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 20.0,
              ),
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.nunito(),
                letterSpacing: 0.0,
              ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'A senha é obrigatória';
            }
            if (value.length < 6) {
              return 'A senha deve ter no mínimo 6 caracteres';
            }
            return null;
          },
        ),
        SizedBox(height: 8.0),

        // Esqueci a senha
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: InkWell(
            onTap: () {
              setState(() => _currentTab = 2);
            },
            child: Text(
              'Esqueceu a senha?',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                    ),
                    color: const Color(0xFF15203D), // Azul escuro padrão
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ),
        SizedBox(height: 24.0),

        // Botão Entrar
        FFButtonWidget(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // Mostrar loading
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      SizedBox(width: 16.0),
                      Text('Entrando...'),
                    ],
                  ),
                  backgroundColor:
                      const Color(0xFFD5D91B), // Verde/Amarelo padrão
                  duration: Duration(seconds: 2),
                ),
              );

              GoRouter.of(context).prepareAuthEvent();

              final email = _model.emailAddressTextController.text;
              final password = _model.passwordTextController.text;

              final user = await authManager.signInWithEmail(
                context,
                email,
                password,
              );

              if (user == null) {
                return;
              }

              // Configurar FCM Token após login
              try {
                await actions.setFCMToken();
                print('✅ FCM Token configurado após login');
              } catch (e) {
                print('⚠️ Erro ao configurar FCM Token: $e');
              }

              // Perguntar se deseja habilitar biometria (apenas primeira vez)
              await _promptEnableBiometric(email, password);

              if (mounted) {
                context.goNamedAuth('home', context.mounted);
              }
            }
          },
          text: 'Entrar',
          icon: Icon(
            Icons.login_rounded,
            size: 20.0,
          ),
          options: FFButtonOptions(
            width: double.infinity,
            height: 56.0,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 24.0),
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
            color: const Color(0xFFD5D91B), // Verde/Amarelo padrão
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  font: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                  ),
                  color: const Color(0xFF15203D), // Texto escuro no botão verde
                  letterSpacing: 0.0,
                ),
            elevation: 0.0,
            borderRadius: BorderRadius.circular(28.0), // Mais arredondado
          ),
        ),

        // Divisor "OU" e botão de biometria
        if (_biometricAvailable && _biometricEnabled) ...[
          SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: FlutterFlowTheme.of(context).grayscale40,
                  thickness: 1.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'OU',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: FlutterFlowTheme.of(context).grayscale40,
                  thickness: 1.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.0),
          // Botão de Biometria
          OutlinedButton.icon(
            onPressed: _loginWithBiometric,
            icon: Icon(
              Icons.fingerprint_rounded,
              size: 24.0,
            ),
            label: Text(
              'Entrar com $_biometricType',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                    color: const Color(0xFF15203D), // Azul escuro padrão
                    letterSpacing: 0.0,
                  ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF15203D), // Azul escuro padrão
              minimumSize: Size(double.infinity, 56.0),
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24.0),
              side: BorderSide(
                color: const Color(0xFF15203D), // Azul escuro padrão
                width: 2.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0), // Mais arredondado
              ),
            ),
          ),
        ],
      ],
    );
  }

  // Formulário de Cadastro
  Widget _buildSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Nome Completo
        TextFormField(
          controller: _model.fullNameCreateTextController,
          focusNode: _model.fullNameCreateFocusNode,
          autofocus: false,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Nome Completo',
            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            hintText: 'Digite seu nome completo',
            hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).grayscale20,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF15203D), // Azul escuro padrão
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding: EdgeInsetsDirectional.all(16.0),
            prefixIcon: Icon(
              Icons.person_outline,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.nunito(),
                letterSpacing: 0.0,
              ),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Digite seu nome completo';
            }
            if (!value.contains(' ')) {
              return 'Digite nome e sobrenome';
            }
            return null;
          },
        ),
        SizedBox(height: 16.0),

        // CPF
        TextFormField(
          controller: _model.cpfCreateTextController,
          focusNode: _model.cpfCreateFocusNode,
          autofocus: false,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'CPF',
            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            hintText: '000.000.000-00',
            hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).grayscale20,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF15203D), // Azul escuro padrão
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding: EdgeInsetsDirectional.all(16.0),
            prefixIcon: Icon(
              Icons.badge_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.nunito(),
                letterSpacing: 0.0,
              ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Digite seu CPF';
            }
            // Validar CPF (implementar depois)
            final cpfClean = value.replaceAll(RegExp(r'[^0-9]'), '');
            if (cpfClean.length != 11) {
              return 'CPF deve ter 11 dígitos';
            }
            return null;
          },
        ),
        SizedBox(height: 16.0),

        // Telefone
        TextFormField(
          controller: _model.phoneCreateTextController,
          focusNode: _model.phoneCreateFocusNode,
          autofocus: false,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Telefone',
            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            hintText: '(00) 00000-0000',
            hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).grayscale20,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF15203D), // Azul escuro padrão
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding: EdgeInsetsDirectional.all(16.0),
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.nunito(),
                letterSpacing: 0.0,
              ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Digite seu telefone';
            }
            final phoneClean = value.replaceAll(RegExp(r'[^0-9]'), '');
            if (phoneClean.length < 10) {
              return 'Telefone inválido';
            }
            return null;
          },
        ),
        SizedBox(height: 16.0),

        // Email
        TextFormField(
          controller: _model.emailAddressCreateTextController,
          focusNode: _model.emailAddressCreateFocusNode,
          autofocus: false,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'E-mail',
            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            hintText: 'Digite seu e-mail',
            hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).grayscale20,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF15203D), // Azul escuro padrão
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding: EdgeInsetsDirectional.all(16.0),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.nunito(),
                letterSpacing: 0.0,
              ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'O e-mail é obrigatório';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Digite um e-mail válido';
            }
            return null;
          },
        ),
        SizedBox(height: 16.0),

        // Senha
        TextFormField(
          controller: _model.passwordCreateTextController,
          focusNode: _model.passwordCreateFocusNode,
          autofocus: false,
          obscureText: !_model.passwordCreateVisibility,
          decoration: InputDecoration(
            labelText: 'Senha',
            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            hintText: 'Digite sua senha',
            hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).grayscale20,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF15203D), // Azul escuro padrão
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding: EdgeInsetsDirectional.all(16.0),
            prefixIcon: Icon(
              Icons.lock_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            suffixIcon: InkWell(
              onTap: () => setState(
                () => _model.passwordCreateVisibility =
                    !_model.passwordCreateVisibility,
              ),
              focusNode: FocusNode(skipTraversal: true),
              child: Icon(
                _model.passwordCreateVisibility
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 20.0,
              ),
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.nunito(),
                letterSpacing: 0.0,
              ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'A senha é obrigatória';
            }
            if (value.length < 6) {
              return 'A senha deve ter no mínimo 6 caracteres';
            }
            return null;
          },
        ),
        SizedBox(height: 16.0),

        // Confirmar Senha
        TextFormField(
          controller: _model.passwordConfirmTextController,
          focusNode: _model.passwordConfirmFocusNode,
          autofocus: false,
          obscureText: !_model.passwordConfirmVisibility,
          decoration: InputDecoration(
            labelText: 'Confirmar Senha',
            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            hintText: 'Digite sua senha novamente',
            hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).grayscale20,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF15203D), // Azul escuro padrão
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding: EdgeInsetsDirectional.all(16.0),
            prefixIcon: Icon(
              Icons.lock_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            suffixIcon: InkWell(
              onTap: () => setState(
                () => _model.passwordConfirmVisibility =
                    !_model.passwordConfirmVisibility,
              ),
              focusNode: FocusNode(skipTraversal: true),
              child: Icon(
                _model.passwordConfirmVisibility
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 20.0,
              ),
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.nunito(),
                letterSpacing: 0.0,
              ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'A confirmação é obrigatória';
            }
            if (value != _model.passwordCreateTextController.text) {
              return 'As senhas não coincidem';
            }
            return null;
          },
        ),
        SizedBox(height: 24.0),

        // Botão Cadastrar
        FFButtonWidget(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // Mostrar loading
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      SizedBox(width: 16.0),
                      Text('Criando conta...'),
                    ],
                  ),
                  backgroundColor: const Color(0xFFD5D91B), // Amarelo padrão
                  duration: Duration(seconds: 3),
                ),
              );

              GoRouter.of(context).prepareAuthEvent();

              final user = await authManager.createAccountWithEmail(
                context,
                _model.emailAddressCreateTextController.text,
                _model.passwordCreateTextController.text,
              );

              if (user == null) {
                return;
              }

              // Atribuir role de delivery_person automaticamente
              try {
                await Supabase.instance.client.rpc(
                  'assign_delivery_person_role',
                  params: {'p_user_id': user.uid},
                );
                print('✅ Role de usuário atribuído com sucesso');
              } catch (e) {
                print('⚠️ Erro ao atribuir role de usuário: $e');
                // Não bloqueia o cadastro, mas avisa
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Conta criada, mas configure seu perfil manualmente.'),
                      backgroundColor: FlutterFlowTheme.of(context).warning,
                    ),
                  );
                }
              }

              // Salvar dados adicionais na tabela users
              try {
                await Supabase.instance.client.from('users').insert({
                  'id': user.uid,
                  'display_name':
                      _model.fullNameCreateTextController.text.trim(),
                  'document': _model.cpfCreateTextController.text
                      .replaceAll(RegExp(r'[^0-9]'), ''),
                  'phone': _model.phoneCreateTextController.text
                      .replaceAll(RegExp(r'[^0-9]'), ''),
                });
                print('✅ Dados do usuário salvos com sucesso');
              } catch (e) {
                print('⚠️ Erro ao salvar dados do usuário: $e');
              }

              // Solicitar permissões críticas após cadastro
              if (mounted) {
                await _permissionService.requestAllCriticalPermissions(context);
              }

              // Configurar FCM Token após permissões concedidas
              try {
                await actions.setFCMToken();
                print('✅ FCM Token configurado após registro');
              } catch (e) {
                print('⚠️ Erro ao configurar FCM Token após registro: $e');
              }

              if (mounted) {
                context.goNamedAuth('home', context.mounted);
              }
            }
          },
          text: 'Cadastrar',
          icon: Icon(
            Icons.person_add_rounded,
            size: 20.0,
          ),
          options: FFButtonOptions(
            width: double.infinity,
            height: 56.0,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 24.0),
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
            color: const Color(0xFFD5D91B), // Amarelo padrão para cadastro
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  font: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                  ),
                  color:
                      const Color(0xFF15203D), // Texto escuro no botão amarelo
                  letterSpacing: 0.0,
                ),
            elevation: 0.0,
            borderRadius: BorderRadius.circular(28.0), // Mais arredondado
          ),
        ),
      ],
    );
  }

  // Formulário de Reset de Senha
  Widget _buildResetPasswordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email
        TextFormField(
          controller: _model.emailAddressResetTextController,
          focusNode: _model.emailAddressResetFocusNode,
          autofocus: false,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'E-mail',
            labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            hintText: 'Digite seu e-mail cadastrado',
            hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.nunito(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).grayscale20,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF15203D), // Azul escuro padrão
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).error,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(28.0), // Mais arredondado
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding: EdgeInsetsDirectional.all(16.0),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.nunito(),
                letterSpacing: 0.0,
              ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'O e-mail é obrigatório';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Digite um e-mail válido';
            }
            return null;
          },
        ),
        SizedBox(height: 24.0),

        // Botão Enviar
        FFButtonWidget(
          onPressed: !_canSendResetEmail
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // Enviar e-mail de recuperação
                      await authManager.resetPassword(
                        email: _model.emailAddressResetTextController.text,
                        context: context,
                        redirectTo: 'carteira-contabil:///redefinir-senha',
                      );

                      // Mostrar mensagem de sucesso
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'E-mail enviado! Verifique sua caixa de entrada.',
                            ),
                            backgroundColor:
                                FlutterFlowTheme.of(context).success,
                            duration: Duration(seconds: 4),
                          ),
                        );

                        // Voltar para login e iniciar cooldown
                        setState(() => _currentTab = 0);
                        _startResetCooldown();
                      }
                    } on AuthException catch (e) {
                      if (mounted) {
                        String errorMessage =
                            'Erro ao enviar e-mail de recuperação';

                        if (e.message.contains('rate limit')) {
                          errorMessage =
                              'Muitas tentativas. Aguarde alguns minutos e tente novamente.';
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                            duration: Duration(seconds: 4),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Erro ao enviar e-mail de recuperação'),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                            duration: Duration(seconds: 4),
                          ),
                        );
                      }
                    }
                  }
                },
          text: _canSendResetEmail
              ? 'Enviar e-mail de recuperação'
              : 'Aguarde ${_cooldownSeconds}s...',
          icon: Icon(
            Icons.email_outlined,
            size: 20.0,
          ),
          options: FFButtonOptions(
            width: double.infinity,
            height: 56.0,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 24.0),
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
            color: const Color(0xFFD5D91B), // Verde/Amarelo padrão
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  font: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                  ),
                  color: const Color(0xFF15203D), // Texto escuro no botão verde
                  letterSpacing: 0.0,
                ),
            elevation: 0.0,
            borderRadius: BorderRadius.circular(28.0), // Mais arredondado
          ),
        ),
      ],
    );
  }
}
