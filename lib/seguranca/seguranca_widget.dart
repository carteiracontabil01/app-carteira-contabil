import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/widgets/home_surface_tokens.dart';
import '/services/biometric_service.dart';
import '/services/secure_storage_service.dart';
import 'seguranca_model.dart';
import 'widgets/biometric_credentials_dialog.dart';
import 'widgets/security_info_card.dart';
import 'widgets/security_intro_card.dart';
import 'widgets/security_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

export 'seguranca_model.dart';

class SegurancaWidget extends StatefulWidget {
  const SegurancaWidget({super.key});

  static String routeName = 'seguranca';
  static String routePath = 'seguranca';

  @override
  State<SegurancaWidget> createState() => _SegurancaWidgetState();
}

class _SegurancaWidgetState extends State<SegurancaWidget> {
  late SegurancaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _biometricService = BiometricService();
  final _secureStorage = SecureStorageService();

  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  String _biometricType = 'Biometria';
  bool _isTogglingBiometric = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SegurancaModel());
    _loadBiometricState();
  }

  Future<void> _loadBiometricState() async {
    final isAvailable = await _biometricService.isBiometricAvailable();
    final isEnabled = await _secureStorage.isBiometricEnabled();
    final biometricType = await _biometricService.getBiometricTypeDescription();

    if (!mounted) return;
    setState(() {
      _biometricAvailable = isAvailable;
      _biometricEnabled = isEnabled;
      _biometricType = biometricType;
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    if (_isTogglingBiometric) return;

    setState(() => _isTogglingBiometric = true);
    try {
      if (value) {
        final authenticated = await _biometricService.authenticate(
          reason: 'Autentique-se para ativar $_biometricType',
        );
        if (!authenticated) return;

        if (!mounted) return;
        final credentials = await showBiometricCredentialsDialog(
          context,
          currentUserEmail,
        );
        if (credentials == null) return;

        await _secureStorage.saveCredentials(
          email: credentials.email,
          password: credentials.password,
        );
        await _secureStorage.setBiometricEnabled(true);

        if (!mounted) return;
        setState(() => _biometricEnabled = true);
        _showMessage(
          message: '$_biometricType ativado com sucesso!',
          background: FlutterFlowTheme.of(context).success,
        );
      } else {
        await _secureStorage.clearCredentials();
        await _secureStorage.setBiometricEnabled(false);

        if (!mounted) return;
        setState(() => _biometricEnabled = false);
        _showMessage(
          message: '$_biometricType desativado',
          background: FlutterFlowTheme.of(context).secondaryText,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isTogglingBiometric = false);
      }
    }
  }

  void _showMessage({
    required String message,
    required Color background,
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.nunito(),
        ),
        backgroundColor: background,
      ),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String text,
  ) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: theme.primary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

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
            'Segurança',
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: SecurityIntroCard(),
                  ),
                  _buildSectionTitle(context, 'AUTENTICAÇÃO'),
                  if (_biometricAvailable)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: HomeSurfaceTokens.cardDecoration(
                        theme,
                        radius: 20,
                      ),
                      child: SecurityOptionTile(
                        icon: Icons.fingerprint_rounded,
                        title: 'Login Biométrico',
                        subtitle: 'Entre rapidamente usando $_biometricType',
                        switchValue: _biometricEnabled,
                        onSwitchChanged: _isTogglingBiometric ? null : _toggleBiometric,
                      ),
                    ),
                  _buildSectionTitle(context, 'CREDENCIAIS'),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: HomeSurfaceTokens.cardDecoration(
                      theme,
                      radius: 20,
                    ),
                    child: Column(
                      children: [
                        SecurityOptionTile(
                          icon: Icons.lock_outline_rounded,
                          title: 'Alterar Senha',
                          subtitle: 'Modificar sua senha de acesso',
                          showDivider: true,
                          onTap: () => context.pushNamed('alterarSenha'),
                        ),
                        SecurityOptionTile(
                          icon: Icons.email_outlined,
                          title: 'Alterar E-mail',
                          subtitle: 'Modificar seu e-mail de acesso',
                          onTap: () => context.pushNamed('alterarEmail'),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: SecurityInfoCard(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
