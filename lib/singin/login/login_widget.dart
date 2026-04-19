import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/biometric_service.dart';
import '/services/secure_storage_service.dart';
import '/services/permission_service.dart';
import '/singin/login/widgets/auth_header.dart';
import '/singin/login/widgets/auth_tab_selector.dart';
import '/singin/login/widgets/login_form.dart';
import '/singin/login/widgets/sign_up_form.dart';
import '/singin/login/widgets/reset_password_form.dart';
import '/singin/login/models/sign_up_payload.dart';
import '/singin/login/services/login_flow_service.dart';
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
  static const bool _signUpEnabled = false;

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

      GoRouter.of(context).prepareAuthEvent();

      final result = await LoginFlowService.loginWithEmail(
        context: context,
        email: credentials['email']!,
        password: credentials['password']!,
      );

      if (result.success && mounted) {
        context.go('/');
      }
    } catch (e) {
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
                  AuthHeader(
                    title: _currentTab == 0
                        ? 'Bem-vindo!'
                        : _currentTab == 1
                            ? 'Criar conta'
                            : 'Recuperar senha',
                    subtitle: _currentTab == 0
                        ? 'Entre com suas credenciais'
                        : _currentTab == 1
                            ? 'Preencha seus dados para cadastrar'
                            : 'Digite seu e-mail para redefinir a senha',
                  ),
                  const SizedBox(height: 32.0),

                  // Tabs (ocultar no modo reset)
                  if (_currentTab != 2)
                    AuthTabSelector(
                      currentTab: _currentTab,
                      onTabChanged: (tab) => setState(() => _currentTab = tab),
                    ),
                  if (_currentTab != 2) const SizedBox(height: 32.0),

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

  Future<void> _handleLoginPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).tertiary,
              ),
            ),
            const SizedBox(width: 16.0),
            Text(
              'Entrando...',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).tertiary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        duration: const Duration(seconds: 2),
      ),
    );

    GoRouter.of(context).prepareAuthEvent();

    final email = _model.emailAddressTextController.text;
    final password = _model.passwordTextController.text;

    final result = await LoginFlowService.loginWithEmail(
      context: context,
      email: email,
      password: password,
    );

    if (!result.success) {
      return;
    }

    await _promptEnableBiometric(email, password);

    if (mounted) {
      context.go('/');
    }
  }

  Future<void> _handleSignUpPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(width: 16.0),
            Text('Criando conta...'),
          ],
        ),
        backgroundColor: Color(0xFFD5D91B),
        duration: Duration(seconds: 3),
      ),
    );

    GoRouter.of(context).prepareAuthEvent();

    final signUpResult = await LoginFlowService.signUpWithEmail(
      context: context,
      permissionService: _permissionService,
      payload: SignUpPayload(
        email: _model.emailAddressCreateTextController.text,
        password: _model.passwordCreateTextController.text,
        fullName: _model.fullNameCreateTextController.text,
        cpf: _model.cpfCreateTextController.text,
        phone: _model.phoneCreateTextController.text,
      ),
    );

    if (!signUpResult.success) {
      return;
    }

    if (signUpResult.showProfileWarning && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Conta criada, mas configure seu perfil manualmente.'),
          backgroundColor: FlutterFlowTheme.of(context).warning,
        ),
      );
    }

    if (mounted) {
      context.go('/');
    }
  }

  Future<void> _handleResetPasswordPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await LoginFlowService.sendResetPasswordEmail(
      context: context,
      email: _model.emailAddressResetTextController.text,
      redirectTo: 'carteira-contabil:///redefinir-senha',
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Erro ao enviar e-mail de recuperação'),
        backgroundColor: result.success
            ? FlutterFlowTheme.of(context).success
            : FlutterFlowTheme.of(context).error,
        duration: const Duration(seconds: 4),
      ),
    );

    if (result.success) {
      setState(() => _currentTab = 0);
      _startResetCooldown();
    }
  }

  Widget _buildLoginForm() => LoginForm(
        emailController: _model.emailAddressTextController,
        emailFocusNode: _model.emailAddressFocusNode,
        passwordController: _model.passwordTextController,
        passwordFocusNode: _model.passwordFocusNode,
        passwordVisible: _model.passwordVisibility,
        onTogglePasswordVisibility: () => setState(
          () => _model.passwordVisibility = !_model.passwordVisibility,
        ),
        onForgotPassword: () => setState(() => _currentTab = 2),
        onLoginPressed: _handleLoginPressed,
        showBiometricButton: _biometricAvailable && _biometricEnabled,
        biometricType: _biometricType,
        onBiometricPressed: _loginWithBiometric,
      );

  Widget _buildSignUpForm() => SignUpForm(
        fullNameController: _model.fullNameCreateTextController,
        fullNameFocusNode: _model.fullNameCreateFocusNode,
        cpfController: _model.cpfCreateTextController,
        cpfFocusNode: _model.cpfCreateFocusNode,
        phoneController: _model.phoneCreateTextController,
        phoneFocusNode: _model.phoneCreateFocusNode,
        emailController: _model.emailAddressCreateTextController,
        emailFocusNode: _model.emailAddressCreateFocusNode,
        passwordController: _model.passwordCreateTextController,
        passwordFocusNode: _model.passwordCreateFocusNode,
        passwordVisible: _model.passwordCreateVisibility,
        onTogglePasswordVisibility: () => setState(
          () =>
              _model.passwordCreateVisibility = !_model.passwordCreateVisibility,
        ),
        passwordConfirmController: _model.passwordConfirmTextController,
        passwordConfirmFocusNode: _model.passwordConfirmFocusNode,
        passwordConfirmVisible: _model.passwordConfirmVisibility,
        onTogglePasswordConfirmVisibility: () => setState(
          () => _model.passwordConfirmVisibility =
              !_model.passwordConfirmVisibility,
        ),
        signUpEnabled: _signUpEnabled,
        onSignUpPressed: _handleSignUpPressed,
      );

  Widget _buildResetPasswordForm() => ResetPasswordForm(
        emailController: _model.emailAddressResetTextController,
        emailFocusNode: _model.emailAddressResetFocusNode,
        canSendResetEmail: _canSendResetEmail,
        cooldownSeconds: _cooldownSeconds,
        onSendResetEmail: _handleResetPasswordPressed,
      );
}
